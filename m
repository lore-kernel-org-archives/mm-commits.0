Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C67FC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 17:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245708AbiEJR4x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 13:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244623AbiEJR4w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 13:56:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE3223BF9
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 10:52:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B7D861A09
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 17:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5A2C385A6;
        Tue, 10 May 2022 17:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652205173;
        bh=6PtkQrpMWlaBcG+Kz4V+7+UCYI6zIzjiszb7vXJfMa8=;
        h=Date:To:From:Subject:From;
        b=YxiBdHkD4FC93PiGKWY3rnPpCBWFdHkTg0jCFU0ODTxFpo6OVhrEbqr/AYdpcLCKF
         Ptb2u77dLBwW41OucNKvvfl6YZTR6aOvR0pNjmb8v03YtS+I6bpnDf+x3Y4ry/aoVL
         OplQZdsKT6hKLGjb+88tIJflD/74fmpth2h0TgUY=
Date:   Tue, 10 May 2022 10:52:52 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-start-tracking-vmas-with-maple-tree-fix.patch added to mm-unstable branch
Message-Id: <20220510175253.8A5A2C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mapletree: build fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-start-tracking-vmas-with-maple-tree-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-start-tracking-vmas-with-maple-tree-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mapletree: build fix

Fix the vma_mas_store/vma_mas_remove issues.  Missing prototypes, missing
implementation on nommu.

Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +++
 mm/mmap.c          |    4 ++--
 mm/nommu.c         |   13 +++++++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-start-tracking-vmas-with-maple-tree-fix
+++ a/include/linux/mm.h
@@ -2641,6 +2641,9 @@ extern struct vm_area_struct *copy_vma(s
 	bool *need_rmap_locks);
 extern void exit_mmap(struct mm_struct *);
 
+void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas);
+void vma_mas_remove(struct vm_area_struct *vma, struct ma_state *mas);
+
 static inline int check_data_rlimit(unsigned long rlim,
 				    unsigned long new,
 				    unsigned long start,
--- a/mm/mmap.c~mm-start-tracking-vmas-with-maple-tree-fix
+++ a/mm/mmap.c
@@ -754,7 +754,7 @@ static void __vma_link_file(struct vm_ar
  *
  * Note: the end address is inclusive in the maple tree.
  */
-inline void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas)
+void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas)
 {
 	trace_vma_store(mas->tree, vma);
 	mas_set_range(mas, vma->vm_start, vma->vm_end - 1);
@@ -770,7 +770,7 @@ inline void vma_mas_store(struct vm_area
  * been established and points to the correct location.
  * Note: the end address is inclusive in the maple tree.
  */
-static inline void vma_mas_remove(struct vm_area_struct *vma, struct ma_state *mas)
+void vma_mas_remove(struct vm_area_struct *vma, struct ma_state *mas)
 {
 	trace_vma_mas_szero(mas->tree, vma->vm_start, vma->vm_end - 1);
 	mas->index = vma->vm_start;
--- a/mm/nommu.c~mm-start-tracking-vmas-with-maple-tree-fix
+++ a/mm/nommu.c
@@ -545,6 +545,19 @@ static void put_nommu_region(struct vm_r
 	__put_nommu_region(region);
 }
 
+void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas)
+{
+	mas_set_range(mas, vma->vm_start, vma->vm_end - 1);
+	mas_store_prealloc(mas, vma);
+}
+
+void vma_mas_remove(struct vm_area_struct *vma, struct ma_state *mas)
+{
+	mas->index = vma->vm_start;
+	mas->last = vma->vm_end - 1;
+	mas_store_prealloc(mas, NULL);
+}
+
 /*
  * add a VMA into a process's mm_struct in the appropriate place in the list
  * and tree and add to the address space's page tree also if not an anonymous
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

