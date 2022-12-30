Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D88C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 30 Dec 2022 22:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235568AbiL3WCD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235706AbiL3WBq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Dec 2022 17:01:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A16A1D0C2
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 14:01:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8E2F61A04
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 22:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F4EC433EF;
        Fri, 30 Dec 2022 22:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672437701;
        bh=lT+kcPVaq4xYfaIpxSD0fZsCwHR69ROi3qEHDPb3LkI=;
        h=Date:To:From:Subject:From;
        b=lJLyHWJzhh5oZWW4nbETMNT+bi7tht7yOr/W6KCm2XdZT509+4AKryUF3y7qcD0El
         EMi9n1LR5ihgm9wcdeYMiKNI8h4nAaIBlKTp02QebeK9c0m7hTOythsiiHCiGFFLCZ
         X1cKcaZ8587gdRrwSCySJeXfvuI1TvGoUB7UQOv4=
Date:   Fri, 30 Dec 2022 14:01:40 -0800
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        ran.xiaokai@zte.com.cn, jiang.xuexin@zte.com.cn,
        imbrenda@linux.ibm.com, david@redhat.com, xu.xin16@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-count-zero-pages-for-each-process.patch added to mm-unstable branch
Message-Id: <20221230220141.16F4EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: count zero pages for each process
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-count-zero-pages-for-each-process.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-count-zero-pages-for-each-process.patch

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
From: xu xin <xu.xin16@zte.com.cn>
Subject: ksm: count zero pages for each process
Date: Fri, 30 Dec 2022 09:16:29 +0800 (CST)

As the number of ksm zero pages is not included in ksm_merging_pages per
process when enabling use_zero_pages, it's unclear of how many actual
pages are merged by KSM.  To let users accurately estimate their memory
demands when unsharing KSM zero-pages, it's necessary to show KSM zero-
pages per process.

Since unsharing zero pages placed by KSM accurately is achieved, then
tracking empty pages merging and unmerging is not a difficult thing any
longer.

Since we already have /proc/<pid>/ksm_stat, just add the information of
zero_pages_sharing in it.

Link: https://lkml.kernel.org/r/202212300916292181912@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Xuexin Jiang <jiang.xuexin@zte.com.cn>
Cc: Xiaokai Ran <ran.xiaokai@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/proc/base.c~ksm-count-zero-pages-for-each-process
+++ a/fs/proc/base.c
@@ -3207,6 +3207,7 @@ static int proc_pid_ksm_stat(struct seq_
 	mm = get_task_mm(task);
 	if (mm) {
 		seq_printf(m, "ksm_rmap_items %lu\n", mm->ksm_rmap_items);
+		seq_printf(m, "zero_pages_sharing %lu\n", mm->ksm_zero_pages_sharing);
 		mmput(mm);
 	}
 
--- a/include/linux/mm_types.h~ksm-count-zero-pages-for-each-process
+++ a/include/linux/mm_types.h
@@ -776,7 +776,7 @@ struct mm_struct {
 #ifdef CONFIG_KSM
 		/*
 		 * Represent how many pages of this process are involved in KSM
-		 * merging.
+		 * merging (not including ksm_zero_pages_sharing).
 		 */
 		unsigned long ksm_merging_pages;
 		/*
@@ -784,6 +784,11 @@ struct mm_struct {
 		 * including merged and not merged.
 		 */
 		unsigned long ksm_rmap_items;
+		/*
+		 * Represent how many empty pages are merged with kernel zero
+		 * pages when enabling KSM use_zero_pages.
+		 */
+		unsigned long ksm_zero_pages_sharing;
 #endif
 #ifdef CONFIG_LRU_GEN
 		struct {
--- a/mm/ksm.c~ksm-count-zero-pages-for-each-process
+++ a/mm/ksm.c
@@ -794,6 +794,7 @@ static inline void clean_rmap_item_zero_
 {
 	if (rmap_item->address & ZERO_PAGE_FLAG) {
 		ksm_zero_pages_sharing--;
+		rmap_item->mm->ksm_zero_pages_sharing--;
 		rmap_item->address &= PAGE_MASK;
 	}
 }
@@ -2117,6 +2118,7 @@ static int try_to_merge_with_kernel_zero
 			if (!err) {
 				rmap_item->address |= ZERO_PAGE_FLAG;
 				ksm_zero_pages_sharing++;
+				rmap_item->mm->ksm_zero_pages_sharing++;
 			}
 		} else {
 			/* If the vma is out of date, we do not need to continue. */
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ksm-abstract-the-function-try_to_get_old_rmap_item.patch
ksm-support-unsharing-zero-pages-placed-by-ksm.patch
ksm-count-all-zero-pages-placed-by-ksm.patch
ksm-count-zero-pages-for-each-process.patch
ksm-add-zero_pages_sharing-documentation.patch
selftest-add-testing-unsharing-and-counting-ksm-zero-page.patch

