Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3171AE7F147
	for <mm-commits@archiver.kernel.org>; Tue, 26 Sep 2023 23:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbjIZX34 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Sep 2023 19:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbjIZX14 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2023 19:27:56 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AA61F9D4
        for <mm-commits@vger.kernel.org>; Tue, 26 Sep 2023 15:32:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA47C433BC;
        Tue, 26 Sep 2023 21:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695762805;
        bh=v+82WXYLafTQcPTJ1j2IZ+OMkmzJ6aFWxwRjh2AKpWs=;
        h=Date:To:From:Subject:From;
        b=w8uM+Hs7uYiFgpaGw2s+sNGO3s078qozOId5R5CdbWW5I6CUv2oXMVwInc+2YU99H
         vN3JfGQB6/Q7F9qJRSuBDF4ImEiRca1z/PA4pXCjazQAJWEZDj5ed4Sr4ChswGpUm8
         wnZSHKN3o+aDndvOjcjl0gr7YpIFR4AeGMbhOA1w=
Date:   Tue, 26 Sep 2023 14:13:24 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org,
        david@redhat.com, shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-add-pages_skipped-metric.patch added to mm-unstable branch
Message-Id: <20230926211325.5AA47C433BC@smtp.kernel.org>
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
Date: Mon, 25 Sep 2023 21:09:37 -0700

This change adds the "pages skipped" metric.  To be able to evaluate how
successful smart page scanning is, the pages skipped metric can be
compared to the pages scanned metric.

The pages skipped metric is a cumulative counter.  The counter is stored
under /sys/kernel/mm/ksm/pages_skipped.

Link: https://lkml.kernel.org/r/20230926040939.516161-3-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Reviewed-by: David Hildenbrand <david@redhat.com>
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
@@ -2376,6 +2379,7 @@ static bool should_skip_rmap_item(struct
 	}
 
 	/* Skip this page */
+	ksm_pages_skipped++;
 	rmap_item->remaining_skips--;
 	remove_rmap_item_from_tree(rmap_item);
 	return true;
@@ -3463,6 +3467,13 @@ static ssize_t pages_volatile_show(struc
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
@@ -3560,6 +3571,7 @@ static struct attribute *ksm_attrs[] = {
 	&pages_sharing_attr.attr,
 	&pages_unshared_attr.attr,
 	&pages_volatile_attr.attr,
+	&pages_skipped_attr.attr,
 	&ksm_zero_pages_attr.attr,
 	&full_scans_attr.attr,
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-ksm-support-fork-exec-for-prctl.patch
mm-ksm-test-case-for-prctl-fork-exec-workflow.patch
mm-ksm-add-smart-page-scanning-mode.patch
mm-ksm-add-pages_skipped-metric.patch
mm-ksm-document-smart-scan-mode.patch
mm-ksm-document-pages_skipped-sysfs-knob.patch

