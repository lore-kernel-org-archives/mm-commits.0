Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDF5C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 23:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiLPX7f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 18:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiLPX7c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 18:59:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFE26A764
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 15:59:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09760621C4
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 23:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526BAC433EF;
        Fri, 16 Dec 2022 23:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671235170;
        bh=+9QEpSyM4N0FpXV1g5cdR8cIWFVt8aEG+JbL5rbhmuc=;
        h=Date:To:From:Subject:From;
        b=syTJCbPEHv/oa+hEV8hq8IQjrDhrd7VZp4XQHc0MtLLNKeN1F/GB+Y5pWow3wZyCG
         I/HnaEO0LKQ5f85AMvvg3ADxHd9ptagA5UNzF03V/pU+NZW4RxPsc+EeHNSGuH+ovV
         bT2Sxq4Kb4QfY2rxckQdn45al2TT8jmJi8d3tGDo=
Date:   Fri, 16 Dec 2022 15:59:29 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-implement-damos-filter.patch added to mm-unstable branch
Message-Id: <20221216235930.526BAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: implement damos filter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-implement-damos-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-implement-damos-filter.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: implement damos filter
Date: Mon, 5 Dec 2022 23:08:20 +0000

Patch series "implement DAMOS filtering for anon pages and/or specific
memory cgroups"

DAMOS let users do system operations in a data access pattern oriented
way.  The data access pattern, which is extracted by DAMON, is somewhat
accurate more than what user space could know in many cases.  However, in
some situation, users could know something more than the kernel about the
pattern or some special requirements for some types of memory or
processes.  For example, some users would have slow swap devices and knows
latency-ciritical processes and therefore want to use DAMON-based
proactive reclamation (DAMON_RECLAIM) for only non-anonymous pages of
non-latency-critical processes.

For such restriction, users could exclude the memory regions from the
initial monitoring regions and use non-dynamic monitoring regions update
monitoring operations set including fvaddr and paddr.  They could also
adjust the DAMOS target access pattern.  For dynamically changing memory
layout and access pattern, those would be not enough.

To help the case, add an interface, namely DAMOS filters, which can be
used to avoid the DAMOS actions be applied to specific types of memory, to
DAMON kernel API (damon.h).  At the moment, it supports filtering
anonymous pages and/or specific memory cgroups in or out for each DAMOS
scheme.

This patchset adds the support for all DAMOS actions that 'paddr'
monitoring operations set supports ('pageout', 'lru_prio', and
'lru_deprio'), and the functionality is exposed via DAMON kernel API
(damon.h) the DAMON sysfs interface (/sys/kernel/mm/damon/admins/), and
DAMON_RECLAIM module parameters.

Patches Sequence
----------------

First patch implements DAMOS filter interface to DAMON kernel API.  Second
patch makes the physical address space monitoring operations set to
support the filters from all supporting DAMOS actions.  Third patch adds
anonymous pages filter support to DAMON_RECLAIM, and the fourth patch
documents the DAMON_RECLAIM's new feature.  Fifth to seventh patches
implement DAMON sysfs files for support of the filters, and eighth patch
connects the file to use DAMOS filters feature.  Ninth patch adds simple
self test cases for DAMOS filters of the sysfs interface.  Finally,
following two patches (tenth and eleventh) document the new features and
interfaces.


This patch (of 11):

DAMOS lets users do system operation in a data access pattern oriented
way.  The data access pattern, which is extracted by DAMON, is somewhat
accurate more than what user space could know in many cases.  However, in
some situation, users could know something more than the kernel about the
pattern or some special requirements for some types of memory or
processes.  For example, some users would have slow swap devices and knows
latency-ciritical processes and therefore want to use DAMON-based
proactive reclamation (DAMON_RECLAIM) for only non-anonymous pages of
non-latency-critical processes.

For such restriction, users could exclude the memory regions from the
initial monitoring regions and use non-dynamic monitoring regions update
monitoring operations set including fvaddr and paddr.  They could also
adjust the DAMOS target access pattern.  For dynamically changing memory
layout and access pattern, those would be not enough.

To help the case, add an interface, namely DAMOS filters, which can be
used to avoid the DAMOS actions be applied to specific types of memory, to
DAMON kernel API (damon.h).  At the moment, it supports filtering
anonymous pages and/or specific memory cgroups in or out for each DAMOS
scheme.

Note that this commit adds only the interface to the DAMON kernel API. 
The impelmentation should be made in the monitoring operations sets, and
following commits will add that.

Link: https://lkml.kernel.org/r/20221205230830.144349-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20221205230830.144349-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   51 ++++++++++++++++++++++++++++++++++++++++
 mm/damon/core.c       |   39 ++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-implement-damos-filter
+++ a/include/linux/damon.h
@@ -8,6 +8,7 @@
 #ifndef _DAMON_H_
 #define _DAMON_H_
 
+#include <linux/memcontrol.h>
 #include <linux/mutex.h>
 #include <linux/time64.h>
 #include <linux/types.h>
@@ -216,6 +217,39 @@ struct damos_stat {
 };
 
 /**
+ * enum damos_filter_type - Type of memory for &struct damos_filter
+ * @DAMOS_FILTER_TYPE_ANON:	Anonymous pages.
+ * @DAMOS_FILTER_TYPE_MEMCG:	Specific memcg's pages.
+ * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
+ */
+enum damos_filter_type {
+	DAMOS_FILTER_TYPE_ANON,
+	DAMOS_FILTER_TYPE_MEMCG,
+	NR_DAMOS_FILTER_TYPES,
+};
+
+/**
+ * struct damos_filter - DAMOS action target memory filter.
+ * @type:	Type of the page.
+ * @matching:	If the matching page should filtered out or in.
+ * @memcg_id:	Memcg id of the question if @type is DAMOS_FILTER_MEMCG.
+ * @list:	List head for siblings.
+ *
+ * Before applying the &damos->action to a memory region, DAMOS checks if each
+ * page of the region matches to this and avoid applying the action if so.
+ * Note that the check support is up to &struct damon_operations
+ * implementation.
+ */
+struct damos_filter {
+	enum damos_filter_type type;
+	bool matching;
+	union {
+		unsigned short memcg_id;
+	};
+	struct list_head list;
+};
+
+/**
  * struct damos_access_pattern - Target access pattern of the given scheme.
  * @min_sz_region:	Minimum size of target regions.
  * @max_sz_region:	Maximum size of target regions.
@@ -239,6 +273,7 @@ struct damos_access_pattern {
  * @action:		&damo_action to be applied to the target regions.
  * @quota:		Control the aggressiveness of this scheme.
  * @wmarks:		Watermarks for automated (in)activation of this scheme.
+ * @filters:		Additional set of &struct damos_filter for &action.
  * @stat:		Statistics of this scheme.
  * @list:		List head for siblings.
  *
@@ -254,6 +289,10 @@ struct damos_access_pattern {
  * If all schemes that registered to a &struct damon_ctx are inactive, DAMON
  * stops monitoring and just repeatedly checks the watermarks.
  *
+ * Before applying the &action to a memory region, &struct damon_operations
+ * implementation could check pages of the region and skip &action to respect
+ * &filters
+ *
  * After applying the &action to each region, &stat_count and &stat_sz is
  * updated to reflect the number of regions and total size of regions that the
  * &action is applied.
@@ -263,6 +302,7 @@ struct damos {
 	enum damos_action action;
 	struct damos_quota quota;
 	struct damos_watermarks wmarks;
+	struct list_head filters;
 	struct damos_stat stat;
 	struct list_head list;
 };
@@ -516,6 +556,12 @@ static inline unsigned long damon_sz_reg
 #define damon_for_each_scheme_safe(s, next, ctx) \
 	list_for_each_entry_safe(s, next, &(ctx)->schemes, list)
 
+#define damos_for_each_filter(f, scheme) \
+	list_for_each_entry(f, &(scheme)->filters, list)
+
+#define damos_for_each_filter_safe(f, next, scheme) \
+	list_for_each_entry_safe(f, next, &(scheme)->filters, list)
+
 #ifdef CONFIG_DAMON
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
@@ -536,6 +582,11 @@ void damon_destroy_region(struct damon_r
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges);
 
+struct damos_filter *damos_new_filter(enum damos_filter_type type,
+		bool matching);
+void damos_add_filter(struct damos *s, struct damos_filter *f);
+void damos_destroy_filter(struct damos_filter *f);
+
 struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 			enum damos_action action, struct damos_quota *quota,
 			struct damos_watermarks *wmarks);
--- a/mm/damon/core.c~mm-damon-core-implement-damos-filter
+++ a/mm/damon/core.c
@@ -263,6 +263,40 @@ int damon_set_regions(struct damon_targe
 	return 0;
 }
 
+struct damos_filter *damos_new_filter(enum damos_filter_type type,
+		bool matching)
+{
+	struct damos_filter *filter;
+
+	filter = kmalloc(sizeof(*filter), GFP_KERNEL);
+	if (!filter)
+		return NULL;
+	filter->type = type;
+	filter->matching = matching;
+	return filter;
+}
+
+void damos_add_filter(struct damos *s, struct damos_filter *f)
+{
+	list_add_tail(&f->list, &s->filters);
+}
+
+static void damos_del_filter(struct damos_filter *f)
+{
+	list_del(&f->list);
+}
+
+static void damos_free_filter(struct damos_filter *f)
+{
+	kfree(f);
+}
+
+void damos_destroy_filter(struct damos_filter *f)
+{
+	damos_del_filter(f);
+	damos_free_filter(f);
+}
+
 /* initialize private fields of damos_quota and return the pointer */
 static struct damos_quota *damos_quota_init_priv(struct damos_quota *quota)
 {
@@ -287,6 +321,7 @@ struct damos *damon_new_scheme(struct da
 		return NULL;
 	scheme->pattern = *pattern;
 	scheme->action = action;
+	INIT_LIST_HEAD(&scheme->filters);
 	scheme->stat = (struct damos_stat){};
 	INIT_LIST_HEAD(&scheme->list);
 
@@ -315,6 +350,10 @@ static void damon_free_scheme(struct dam
 
 void damon_destroy_scheme(struct damos *s)
 {
+	struct damos_filter *f, *next;
+
+	damos_for_each_filter_safe(f, next, s)
+		damos_destroy_filter(f);
 	damon_del_scheme(s);
 	damon_free_scheme(s);
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-implement-damos-filter.patch
mm-damon-paddr-support-damos-filters.patch
mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch
docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch
mm-damon-sysfs-schemes-implement-filters-directory.patch
mm-damon-sysfs-schemes-implement-filter-directory.patch
mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch
mm-damon-sysfs-schemes-implement-scheme-filters.patch
selftests-damon-sysfs-test-filters-directory.patch
docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch
docs-abi-damon-document-scheme-filters-files.patch

