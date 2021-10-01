Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E04C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FF9161A8E
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhJAXfh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Oct 2021 19:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230368AbhJAXfh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 1 Oct 2021 19:35:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6F05619E7;
        Fri,  1 Oct 2021 23:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633131232;
        bh=hSkrBuB2NppJcZxcPG0Szurj/j7CDVoJaOj4rIWgkFM=;
        h=Date:From:To:Subject:From;
        b=LI8ee3TK/pn1gFKEyOTKuYxXQiTHvLfjQ3S7LDrNH0qqWE2IJiCqnV+I5bsaG3gNA
         7BBS9wL1xywTzJmYOzxHXW+v36VF0Q9FmLob6z2k5YtD0x2A5p7Dv/IWRqmvI4px+4
         MXfQ5OCSavqc9ZCSsSowwdzFOCgk7ld0KPTLwZfI=
Date:   Fri, 01 Oct 2021 16:33:51 -0700
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        david@redhat.com, dwmw@amazon.com, elver@google.com,
        foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  + mm-damon-schemes-implement-statistics-feature.patch
 added to -mm tree
Message-ID: <20211001233351.PZR0HkfzA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/schemes: implement statistics feature
has been added to the -mm tree.  Its filename is
     mm-damon-schemes-implement-statistics-feature.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-schemes-implement-statistics-feature.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-schemes-implement-statistics-feature.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/schemes: implement statistics feature

To tune the DAMON-based operation schemes, knowing how many and how large
regions are affected by each of the schemes will be helful.  Those stats
could be used for not only the tuning, but also monitoring of the working
set size and the number of regions, if the scheme does not change the
program behavior too much.

For the reason, this commit implements the statistics for the schemes. 
The total number and size of the regions that each scheme is applied are
exported to users via '->stat_count' and '->stat_sz' of 'struct damos'. 
Admins can also check the number by reading 'schemes' debugfs file.  The
last two integers now represents the stats.  To allow collecting the stats
without changing the program behavior, this commit also adds new scheme
action, 'DAMOS_STAT'.  Note that 'DAMOS_STAT' is not only making no memory
operation actions, but also does not reset the age of regions.

Link: https://lkml.kernel.org/r/20211001125604.29660-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rienjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   10 +++++++++-
 mm/damon/core.c       |    7 ++++++-
 mm/damon/dbgfs.c      |    5 +++--
 mm/damon/vaddr.c      |    2 ++
 4 files changed, 20 insertions(+), 4 deletions(-)

--- a/include/linux/damon.h~mm-damon-schemes-implement-statistics-feature
+++ a/include/linux/damon.h
@@ -78,6 +78,7 @@ struct damon_target {
  * @DAMOS_PAGEOUT:	Call ``madvise()`` for the region with MADV_PAGEOUT.
  * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
  * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
+ * @DAMOS_STAT:		Do nothing but count the stat.
  */
 enum damos_action {
 	DAMOS_WILLNEED,
@@ -85,6 +86,7 @@ enum damos_action {
 	DAMOS_PAGEOUT,
 	DAMOS_HUGEPAGE,
 	DAMOS_NOHUGEPAGE,
+	DAMOS_STAT,		/* Do nothing but only record the stat */
 };
 
 /**
@@ -96,9 +98,13 @@ enum damos_action {
  * @min_age_region:	Minimum age of target regions.
  * @max_age_region:	Maximum age of target regions.
  * @action:		&damo_action to be applied to the target regions.
+ * @stat_count:		Total number of regions that this scheme is applied.
+ * @stat_sz:		Total size of regions that this scheme is applied.
  * @list:		List head for siblings.
  *
- * Note that both the minimums and the maximums are inclusive.
+ * For each aggregation interval, DAMON applies @action to monitoring target
+ * regions fit in the condition and updates the statistics.  Note that both
+ * the minimums and the maximums are inclusive.
  */
 struct damos {
 	unsigned long min_sz_region;
@@ -108,6 +114,8 @@ struct damos {
 	unsigned int min_age_region;
 	unsigned int max_age_region;
 	enum damos_action action;
+	unsigned long stat_count;
+	unsigned long stat_sz;
 	struct list_head list;
 };
 
--- a/mm/damon/core.c~mm-damon-schemes-implement-statistics-feature
+++ a/mm/damon/core.c
@@ -103,6 +103,8 @@ struct damos *damon_new_scheme(
 	scheme->min_age_region = min_age_region;
 	scheme->max_age_region = max_age_region;
 	scheme->action = action;
+	scheme->stat_count = 0;
+	scheme->stat_sz = 0;
 	INIT_LIST_HEAD(&scheme->list);
 
 	return scheme;
@@ -544,9 +546,12 @@ static void damon_do_apply_schemes(struc
 			continue;
 		if (r->age < s->min_age_region || s->max_age_region < r->age)
 			continue;
+		s->stat_count++;
+		s->stat_sz += sz;
 		if (c->primitive.apply_scheme)
 			c->primitive.apply_scheme(c, t, r, s);
-		r->age = 0;
+		if (s->action != DAMOS_STAT)
+			r->age = 0;
 	}
 }
 
--- a/mm/damon/dbgfs.c~mm-damon-schemes-implement-statistics-feature
+++ a/mm/damon/dbgfs.c
@@ -106,11 +106,11 @@ static ssize_t sprint_schemes(struct dam
 
 	damon_for_each_scheme(s, c) {
 		rc = scnprintf(&buf[written], len - written,
-				"%lu %lu %u %u %u %u %d\n",
+				"%lu %lu %u %u %u %u %d %lu %lu\n",
 				s->min_sz_region, s->max_sz_region,
 				s->min_nr_accesses, s->max_nr_accesses,
 				s->min_age_region, s->max_age_region,
-				s->action);
+				s->action, s->stat_count, s->stat_sz);
 		if (!rc)
 			return -ENOMEM;
 
@@ -159,6 +159,7 @@ static bool damos_action_valid(int actio
 	case DAMOS_PAGEOUT:
 	case DAMOS_HUGEPAGE:
 	case DAMOS_NOHUGEPAGE:
+	case DAMOS_STAT:
 		return true;
 	default:
 		return false;
--- a/mm/damon/vaddr.c~mm-damon-schemes-implement-statistics-feature
+++ a/mm/damon/vaddr.c
@@ -705,6 +705,8 @@ int damon_va_apply_scheme(struct damon_c
 	case DAMOS_NOHUGEPAGE:
 		madv_action = MADV_NOHUGEPAGE;
 		break;
+	case DAMOS_STAT:
+		return 0;
 	default:
 		pr_warn("Wrong action %d\n", scheme->action);
 		return -EINVAL;
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-update-seongjaes-email-address.patch
mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch
mm-damon-core-account-age-of-target-regions.patch
mm-damon-core-implement-damon-based-operation-schemes-damos.patch
mm-damon-vaddr-support-damon-based-operation-schemes.patch
mm-damon-dbgfs-support-damon-based-operation-schemes.patch
mm-damon-schemes-implement-statistics-feature.patch
selftests-damon-add-schemes-debugfs-tests.patch
docs-admin-guide-mm-damon-document-damon-based-operation-schemes.patch

