Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEACAC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6AFC60F26
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbhKKCvo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:51:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234456AbhKKCvm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:51:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6CF56103C;
        Thu, 11 Nov 2021 02:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598934;
        bh=L10wXR2y1fjK3UsnDglxO83sa7cOYUIgEAxZWhKJFrk=;
        h=Date:From:To:Subject:From;
        b=NFK2CrgHDBNk3T4rVibMREKtupLwVqtY28pJtbPmW1c5kWwcmcMa1GXTvohAb2ufc
         PfKxvNOozHOncxWu+4ZMuTNRsseovQZXa6wK3cADdljUDwyElFLY8ecgOjgm3nlZYd
         64tVHMfc9n52o19KzfFrzAUlMlKLykp6hw/t1YAA=
Date:   Wed, 10 Nov 2021 18:48:53 -0800
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        david@redhat.com, dwmw@amazon.com, elver@google.com,
        foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  [merged]
 mm-damon-core-account-age-of-target-regions.patch removed from -mm tree
Message-ID: <20211111024853.wLuccbzHh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: account age of target regions
has been removed from the -mm tree.  Its filename was
     mm-damon-core-account-age-of-target-regions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: account age of target regions

Patch series "Implement Data Access Monitoring-based Memory Operation Schemes".

Introduction
============

DAMON[1] can be used as a primitive for data access aware memory
management optimizations.  For that, users who want such optimizations
should run DAMON, read the monitoring results, analyze it, plan a new
memory management scheme, and apply the new scheme by themselves.  Such
efforts will be inevitable for some complicated optimizations.

However, in many other cases, the users would simply want the system to
apply a memory management action to a memory region of a specific size
having a specific access frequency for a specific time.  For example,
"page out a memory region larger than 100 MiB keeping only rare accesses
more than 2 minutes", or "Do not use THP for a memory region larger than 2
MiB rarely accessed for more than 1 seconds".

To make the works easier and non-redundant, this patchset implements a new
feature of DAMON, which is called Data Access Monitoring-based Operation
Schemes (DAMOS).  Using the feature, users can describe the normal schemes
in a simple way and ask DAMON to execute those on its own.

[1] https://damonitor.github.io

Evaluations
===========

DAMOS is accurate and useful for memory management optimizations.  An
experimental DAMON-based operation scheme for THP, 'ethp', removes 76.15%
of THP memory overheads while preserving 51.25% of THP speedup.  Another
experimental DAMON-based 'proactive reclamation' implementation, 'prcl',
reduces 93.38% of residential sets and 23.63% of system memory footprint
while incurring only 1.22% runtime overhead in the best case
(parsec3/freqmine).

NOTE that the experimental THP optimization and proactive reclamation are
not for production but only for proof of concepts.

Please refer to the showcase web site's evaluation document[1] for
detailed evaluation setup and results.

[1] https://damonitor.github.io/doc/html/v34/vm/damon/eval.html

Long-term Support Trees
-----------------------

For people who want to test DAMON but using LTS kernels, there are another
couple of trees based on two latest LTS kernels respectively and containing the
'damon/master' backports.

- For v5.4.y: https://git.kernel.org/sj/h/damon/for-v5.4.y
- For v5.10.y: https://git.kernel.org/sj/h/damon/for-v5.10.y

Sequence Of Patches
===================

The 1st patch accounts age of each region.  The 2nd patch implements the
core of the DAMON-based operation schemes feature.  The 3rd patch makes
the default monitoring primitives for virtual address spaces to support
the schemes.  From this point, the kernel space users can use DAMOS.  The
4th patch exports the feature to the user space via the debugfs interface.
The 5th patch implements schemes statistics feature for easier tuning of
the schemes and runtime access pattern analysis, and the 6th patch adds
selftests for these changes.  Finally, the 7th patch documents this new
feature.


This patch (of 7):

DAMON can be used for data access pattern aware memory management
optimizations.  For that, users should run DAMON, read the monitoring
results, analyze it, plan a new memory management scheme, and apply the
new scheme by themselves.  It would not be too hard, but still require
some level of effort.  For complicated cases, this effort is inevitable.

That said, in many cases, users would simply want to apply an actions to a
memory region of a specific size having a specific access frequency for a
specific time.  For example, "page out a memory region larger than 100 MiB
but having a low access frequency more than 10 minutes", or "Use THP for a
memory region larger than 2 MiB having a high access frequency for more
than 2 seconds".

For such optimizations, users will need to first account the age of each
region themselves.  To reduce such efforts, this commit implements a
simple age account of each region in DAMON.  For each aggregation step,
DAMON compares the access frequency with that from last aggregation and
reset the age of the region if the change is significant.  Else, the age
is incremented.  Also, in case of the merge of regions, the region
size-weighted average of the ages is set as the age of merged new region.

Link: https://lkml.kernel.org/r/20211001125604.29660-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20211001125604.29660-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Marco Elver <elver@google.com>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Greg Thelen <gthelen@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: David Rienjes <rientjes@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   10 ++++++++++
 mm/damon/core.c       |   13 +++++++++++++
 2 files changed, 23 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-account-age-of-target-regions
+++ a/include/linux/damon.h
@@ -31,12 +31,22 @@ struct damon_addr_range {
  * @sampling_addr:	Address of the sample for the next access check.
  * @nr_accesses:	Access frequency of this region.
  * @list:		List head for siblings.
+ * @age:		Age of this region.
+ *
+ * @age is initially zero, increased for each aggregation interval, and reset
+ * to zero again if the access frequency is significantly changed.  If two
+ * regions are merged into a new region, both @nr_accesses and @age of the new
+ * region are set as region size-weighted average of those of the two regions.
  */
 struct damon_region {
 	struct damon_addr_range ar;
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
 	struct list_head list;
+
+	unsigned int age;
+/* private: Internal value for age calculation. */
+	unsigned int last_nr_accesses;
 };
 
 /**
--- a/mm/damon/core.c~mm-damon-core-account-age-of-target-regions
+++ a/mm/damon/core.c
@@ -45,6 +45,9 @@ struct damon_region *damon_new_region(un
 	region->nr_accesses = 0;
 	INIT_LIST_HEAD(&region->list);
 
+	region->age = 0;
+	region->last_nr_accesses = 0;
+
 	return region;
 }
 
@@ -444,6 +447,7 @@ static void kdamond_reset_aggregated(str
 
 		damon_for_each_region(r, t) {
 			trace_damon_aggregated(t, r, damon_nr_regions(t));
+			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
 		}
 	}
@@ -461,6 +465,7 @@ static void damon_merge_two_regions(stru
 
 	l->nr_accesses = (l->nr_accesses * sz_l + r->nr_accesses * sz_r) /
 			(sz_l + sz_r);
+	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
 	damon_destroy_region(r, t);
 }
@@ -480,6 +485,11 @@ static void damon_merge_regions_of(struc
 	struct damon_region *r, *prev = NULL, *next;
 
 	damon_for_each_region_safe(r, next, t) {
+		if (diff_of(r->nr_accesses, r->last_nr_accesses) > thres)
+			r->age = 0;
+		else
+			r->age++;
+
 		if (prev && prev->ar.end == r->ar.start &&
 		    diff_of(prev->nr_accesses, r->nr_accesses) <= thres &&
 		    sz_damon_region(prev) + sz_damon_region(r) <= sz_limit)
@@ -527,6 +537,9 @@ static void damon_split_region_at(struct
 
 	r->ar.end = new->ar.start;
 
+	new->age = r->age;
+	new->last_nr_accesses = r->last_nr_accesses;
+
 	damon_insert_region(new, r, damon_next_region(r), t);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are


