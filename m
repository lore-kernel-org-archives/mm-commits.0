Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A254CD37B0
	for <mm-commits@archiver.kernel.org>; Mon, 18 Sep 2023 19:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjIRTiz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 15:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjIRTix (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 15:38:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF098101
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 12:38:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47876C433CA;
        Mon, 18 Sep 2023 19:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695065927;
        bh=0b70+sW9jSB4CyFPVh8N4p+3rio7pBdGIGRkBoLr9fM=;
        h=Date:To:From:Subject:From;
        b=MhDx2E//cqmPoXccPNlft/924vxLZxPgfCL8hxhFF0CNjxVzU25LWPMX7eJPgF+Lj
         8s+vrmHqQSCMeHvrrQWPk5iXtjPhlw6UnV8KBPg/4IUDZhTsrEnelOU1E5Vqyq517G
         JbMkTlHC8x5hngFVgYlLpsl8rwy43ar4ZJrXcY8A=
Date:   Mon, 18 Sep 2023 12:38:46 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hughd@google.com,
        hannes@cmpxchg.org, david@redhat.com, shr@devkernel.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-add-pages_skipped-metric.patch added to mm-unstable branch
Message-Id: <20230918193847.47876C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: add pages_skipped metric
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-add-pages_skipped-metric.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-add-pages_skipped-metric.patch

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
Subject: mm/ksm: add pages_skipped metric
Date: Mon, 18 Sep 2023 11:58:14 -0700

This change adds the "pages skipped" metric.  To be able to evaluate how
successful smart page scanning is, the pages skipped metric can be
compared to the pages scanned metric.

The pages skipped metric is a cumulative counter.  The counter is stored
under /sys/kernel/mm/ksm/pages_skipped.

Link: https://lkml.kernel.org/r/20230918185816.1518366-3-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/ksm.c~mm-ksm-add-pages_skipped-metric
+++ a/mm/ksm.c
@@ -293,6 +293,9 @@ static bool ksm_smart_scan;
 /* The number of zero pages which is placed by KSM */
 unsigned long ksm_zero_pages;
 
+/* The number of pages that have been skipped due to "smart scanning" */
+static unsigned long ksm_pages_skipped;
+
 #ifdef CONFIG_NUMA
 /* Zeroed when merging across nodes is not allowed */
 static unsigned int ksm_merge_across_nodes = 1;
@@ -2378,6 +2381,7 @@ static bool should_skip_rmap_item(struct
 	 * Skip the page and calculate skip_age on when to re-enable scanning
 	 * for this page.
 	 */
+	++ksm_pages_skipped;
 	if (rmap_item->skip_age == 0) {
 		rmap_item->skip_age = (age + skip_age(age)) & 0xFF;
 		remove_rmap_item_from_tree(rmap_item);
@@ -3468,6 +3472,13 @@ static ssize_t pages_volatile_show(struc
 }
 KSM_ATTR_RO(pages_volatile);
 
+static ssize_t pages_skipped_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lu\n", ksm_pages_skipped);
+}
+KSM_ATTR_RO(pages_skipped);
+
 static ssize_t ksm_zero_pages_show(struct kobject *kobj,
 				struct kobj_attribute *attr, char *buf)
 {
@@ -3565,6 +3576,7 @@ static struct attribute *ksm_attrs[] = {
 	&pages_sharing_attr.attr,
 	&pages_unshared_attr.attr,
 	&pages_volatile_attr.attr,
+	&pages_skipped_attr.attr,
 	&ksm_zero_pages_attr.attr,
 	&full_scans_attr.attr,
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-ksm-add-smart-page-scanning-mode.patch
mm-ksm-add-pages_skipped-metric.patch
mm-ksm-document-smart-scan-mode.patch
mm-ksm-document-pages_skipped-sysfs-knob.patch

