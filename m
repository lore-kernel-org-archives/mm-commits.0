Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBA3CD37B0
	for <mm-commits@archiver.kernel.org>; Mon, 18 Sep 2023 19:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjIRTiw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 15:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjIRTiv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 15:38:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D41101
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 12:38:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637D9C433C8;
        Mon, 18 Sep 2023 19:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695065925;
        bh=3KxgThj+b83y7ml5w8uv8IAo3Oyo16boSJTCfLfsRyI=;
        h=Date:To:From:Subject:From;
        b=QPUPnUbgt/u0bhsCy9cC16l8aKAipPKd2AoHuFh1snF2UDYUXIHA8slnP6lYtbM6F
         0k0dMEoJDFz6xj0bcxRPkSG9hp1/AMt0Jt8pD2YEHHHagXnRrvBhfIDv0imovrKm2t
         53OGEhmR3ltCMZjqHSJB0db9zehMytNgYW1EYWo0=
Date:   Mon, 18 Sep 2023 12:38:44 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hughd@google.com,
        hannes@cmpxchg.org, david@redhat.com, shr@devkernel.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-add-smart-page-scanning-mode.patch added to mm-unstable branch
Message-Id: <20230918193845.637D9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: add "smart" page scanning mode
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-add-smart-page-scanning-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-add-smart-page-scanning-mode.patch

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
From: Stefan Roesch <shr@devkernel.io>
Subject: mm/ksm: add "smart" page scanning mode
Date: Mon, 18 Sep 2023 11:58:13 -0700

Patch series "Smart scanning mode for KSM", v2.

This patch series adds "smart scanning" for KSM.

What is smart scanning?
=======================
KSM evaluates all the candidate pages for each scan.  It does not use
historic information from previous scans.  This has the effect that
candidate pages that couldn't be used for KSM de-duplication continue to
be evaluated for each scan.

The idea of "smart scanning" is to keep historic information.  With the
historic information we can temporarily skip the candidate page for one or
several scans.

Details:
========
"Smart scanning" is to keep two small counters to store if the page has
been used for KSM.  One counter stores how often we already tried to use
the page for KSM and the other counter stores when a page will be used as
a candidate page again.

How often we skip the candidate page depends how often a page failed KSM
de-duplication.  The code skips a maximum of 8 times.  During testing this
has shown to be a good compromise for different workloads.

New sysfs knob:
===============
Smart scanning is not enabled by default.  With
/sys/kernel/mm/ksm/smart_scan smart scanning can be enabled.

Monitoring:
===========
To monitor how effective smart scanning is a new sysfs knob has been
introduced.  /sys/kernel/mm/pages_skipped report how many pages have been
skipped by smart scanning.

Results:
========

- Various workloads have shown a 20% - 25% reduction in page scans
  For the instagram workload for instance, the number of pages scanned has been
  reduced from over 20M pages per scan to less than 15M pages.
- Less pages scans also resulted in an overall higher de-duplication rate as
  some shorter lived pages could be de-duplicated additionally
- Less pages scanned allows to reduce the pages_to_scan parameter
  and this resulted in  a 25% reduction in terms of CPU.
- The improvements have been observed for workloads that enable KSM with
  madvise as well as prctl


This patch (of 4):

This change adds a "smart" page scanning mode for KSM.  So far all the
candidate pages are continuously scanned to find candidates for
de-duplication.  There are a considerably number of pages that cannot be
de-duplicated.  This is costly in terms of CPU.  By using smart scanning
considerable CPU savings can be achieved.

This change takes the history of scanning pages into account and skips the
page scanning of certain pages for a while if de-deduplication for this
page has not been successful in the past.

To do this it introduces two new fields in the ksm_rmap_item structure:
age and skip_age.  age, is the KSM age and skip_age is the age for how
long page scanning of this page is skipped.  The age field is incremented
each time the page is scanned and the page cannot be de-duplicated.

How often a page is skipped is dependent how often de-duplication has been
tried so far and the number of skips is currently limited to 8.  This
value has shown to be effective with different workloads.

The feature is currently disable by default and can be enabled with the
new smart_scan knob.

The feature has shown to be very effective: upt to 25% of the page scans
can be eliminated; the pages_to_scan rate can be reduced by 40 - 50% and a
similar de-duplication rate can be maintained.

Link: https://lkml.kernel.org/r/20230918185816.1518366-1-shr@devkernel.io
Link: https://lkml.kernel.org/r/20230918185816.1518366-2-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |  108 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

--- a/mm/ksm.c~mm-ksm-add-smart-page-scanning-mode
+++ a/mm/ksm.c
@@ -56,6 +56,8 @@
 #define DO_NUMA(x)	do { } while (0)
 #endif
 
+typedef u8 rmap_age_t;
+
 /**
  * DOC: Overview
  *
@@ -193,6 +195,8 @@ struct ksm_stable_node {
  * @node: rb node of this rmap_item in the unstable tree
  * @head: pointer to stable_node heading this list in the stable tree
  * @hlist: link into hlist of rmap_items hanging off that stable_node
+ * @age: number of scan iterations since creation
+ * @skip_age: skip rmap item until age reaches skip_age
  */
 struct ksm_rmap_item {
 	struct ksm_rmap_item *rmap_list;
@@ -212,6 +216,8 @@ struct ksm_rmap_item {
 			struct hlist_node hlist;
 		};
 	};
+	rmap_age_t age;
+	rmap_age_t skip_age;
 };
 
 #define SEQNR_MASK	0x0ff	/* low bits of unstable tree seqnr */
@@ -281,6 +287,9 @@ static unsigned int zero_checksum __read
 /* Whether to merge empty (zeroed) pages with actual zero pages */
 static bool ksm_use_zero_pages __read_mostly;
 
+/* Skip pages that couldn't be de-duplicated previously  */
+static bool ksm_smart_scan;
+
 /* The number of zero pages which is placed by KSM */
 unsigned long ksm_zero_pages;
 
@@ -2305,6 +2314,78 @@ static struct ksm_rmap_item *get_next_rm
 	return rmap_item;
 }
 
+/*
+ * Calculate skip age for the ksm page age. The age determines how often
+ * de-duplicating has already been tried unsuccessfully. If the age is
+ * smaller, the scanning of this page is skipped for less scans.
+ *
+ * @age: rmap_item age of page
+ */
+static unsigned int skip_age(rmap_age_t age)
+{
+	if (age <= 3)
+		return 1;
+	if (age <= 5)
+		return 2;
+	if (age <= 8)
+		return 4;
+
+	return 8;
+}
+
+/*
+ * Determines if a page should be skipped for the current scan.
+ *
+ * @page: page to check
+ * @rmap_item: associated rmap_item of page
+ */
+static bool should_skip_rmap_item(struct page *page,
+				  struct ksm_rmap_item *rmap_item)
+{
+	rmap_age_t age;
+
+	if (!ksm_smart_scan)
+		return false;
+
+	/*
+	 * Never skip pages that are already KSM; pages cmp_and_merge_page()
+	 * will essentially ignore them, but we still have to process them
+	 * properly.
+	 */
+	if (PageKsm(page))
+		return false;
+
+	/*
+	 * Smaller ages are not skipped, they need to get a chance to go
+	 * through the different phases of the KSM merging.
+	 */
+	age = rmap_item->age;
+	rmap_item->age = (rmap_item->age + 1) & 0xFF;
+
+	if (age < 3)
+		return false;
+
+	/*
+	 * Page has been skipped and reached its target age to re-enable
+	 * scanning the page.
+	 */
+	if (rmap_item->skip_age == age) {
+		rmap_item->skip_age = 0;
+		return false;
+	}
+
+	/*
+	 * Skip the page and calculate skip_age on when to re-enable scanning
+	 * for this page.
+	 */
+	if (rmap_item->skip_age == 0) {
+		rmap_item->skip_age = (age + skip_age(age)) & 0xFF;
+		remove_rmap_item_from_tree(rmap_item);
+	}
+
+	return true;
+}
+
 static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 {
 	struct mm_struct *mm;
@@ -2409,6 +2490,10 @@ next_mm:
 				if (rmap_item) {
 					ksm_scan.rmap_list =
 							&rmap_item->rmap_list;
+
+					if (should_skip_rmap_item(*page, rmap_item))
+						goto next_page;
+
 					ksm_scan.address += PAGE_SIZE;
 				} else
 					put_page(*page);
@@ -3449,6 +3534,28 @@ static ssize_t full_scans_show(struct ko
 }
 KSM_ATTR_RO(full_scans);
 
+static ssize_t smart_scan_show(struct kobject *kobj,
+			       struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%u\n", ksm_smart_scan);
+}
+
+static ssize_t smart_scan_store(struct kobject *kobj,
+				struct kobj_attribute *attr,
+				const char *buf, size_t count)
+{
+	int err;
+	bool value;
+
+	err = kstrtobool(buf, &value);
+	if (err)
+		return -EINVAL;
+
+	ksm_smart_scan = value;
+	return count;
+}
+KSM_ATTR(smart_scan);
+
 static struct attribute *ksm_attrs[] = {
 	&sleep_millisecs_attr.attr,
 	&pages_to_scan_attr.attr,
@@ -3469,6 +3576,7 @@ static struct attribute *ksm_attrs[] = {
 	&stable_node_chains_prune_millisecs_attr.attr,
 	&use_zero_pages_attr.attr,
 	&general_profit_attr.attr,
+	&smart_scan_attr.attr,
 	NULL,
 };
 
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-ksm-add-smart-page-scanning-mode.patch
mm-ksm-add-pages_skipped-metric.patch
mm-ksm-document-smart-scan-mode.patch
mm-ksm-document-pages_skipped-sysfs-knob.patch

