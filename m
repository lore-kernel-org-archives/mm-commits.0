Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C80C5C7EE26
	for <mm-commits@archiver.kernel.org>; Wed,  3 May 2023 00:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjECAWV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 20:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjECAWR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 20:22:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452C330C8
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 17:22:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2EFE629E3
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 00:22:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2EBC433EF;
        Wed,  3 May 2023 00:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683073335;
        bh=8fVPZuKH0LdByMXmhIJZN+PdYtiWSIonByx+PKLGfY8=;
        h=Date:To:From:Subject:From;
        b=MURsbRKgYbsJ/shh7B0gpK+au+E29xGhxdLIj6GwH1HSpfuJrMynI4feDkTt2M3qG
         LOhS2mbBhcV9dNn4ulfQ83MYAyY+9oXWux6887Z3tS3DPefBNiyd52l+MFq7v9rJY9
         ZRgsF8EpuMPgE9PIUsnDs7LHsCoYwgO0tXmTKifU=
Date:   Tue, 02 May 2023 17:22:14 -0700
To:     mm-commits@vger.kernel.org, svens@linux.ibm.com, shuah@kernel.org,
        shr@devkernel.io, riel@surriel.com, mhocko@suse.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, hannes@cmpxchg.org,
        gor@linux.ibm.com, frankja@linux.ibm.com,
        borntraeger@linux.ibm.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-move-disabling-ksm-from-s390-gmap-code-to-ksm-code.patch removed from -mm tree
Message-Id: <20230503002215.2E2EBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/ksm: move disabling KSM from s390/gmap code to KSM code
has been removed from the -mm tree.  Its filename was
     mm-ksm-move-disabling-ksm-from-s390-gmap-code-to-ksm-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/ksm: move disabling KSM from s390/gmap code to KSM code
Date: Sat, 22 Apr 2023 23:01:56 +0200

Let's factor out actual disabling of KSM.  The existing "mm->def_flags &=
~VM_MERGEABLE;" was essentially a NOP and can be dropped, because
def_flags should never include VM_MERGEABLE.  Note that we don't currently
prevent re-enabling KSM.

This should now be faster in case KSM was never enabled, because we only
conditionally iterate all VMAs.  Further, it certainly looks cleaner.

Link: https://lkml.kernel.org/r/20230422210156.33630-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Stefan Roesch <shr@devkernel.io>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/gmap.c |   20 +-------------------
 include/linux/ksm.h |    6 ++++++
 mm/ksm.c            |   11 +++++++++++
 3 files changed, 18 insertions(+), 19 deletions(-)

--- a/arch/s390/mm/gmap.c~mm-ksm-move-disabling-ksm-from-s390-gmap-code-to-ksm-code
+++ a/arch/s390/mm/gmap.c
@@ -2585,30 +2585,12 @@ EXPORT_SYMBOL_GPL(s390_enable_sie);
 
 int gmap_mark_unmergeable(void)
 {
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
-	unsigned long vm_flags;
-	int ret;
-	VMA_ITERATOR(vmi, mm, 0);
-
 	/*
 	 * Make sure to disable KSM (if enabled for the whole process or
 	 * individual VMAs). Note that nothing currently hinders user space
 	 * from re-enabling it.
 	 */
-	clear_bit(MMF_VM_MERGE_ANY, &mm->flags);
-
-	for_each_vma(vmi, vma) {
-		/* Copy vm_flags to avoid partial modifications in ksm_madvise */
-		vm_flags = vma->vm_flags;
-		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
-				  MADV_UNMERGEABLE, &vm_flags);
-		if (ret)
-			return ret;
-		vm_flags_reset(vma, vm_flags);
-	}
-	mm->def_flags &= ~VM_MERGEABLE;
-	return 0;
+	return ksm_disable(current->mm);
 }
 EXPORT_SYMBOL_GPL(gmap_mark_unmergeable);
 
--- a/include/linux/ksm.h~mm-ksm-move-disabling-ksm-from-s390-gmap-code-to-ksm-code
+++ a/include/linux/ksm.h
@@ -22,6 +22,7 @@ int ksm_madvise(struct vm_area_struct *v
 void ksm_add_vma(struct vm_area_struct *vma);
 int ksm_enable_merge_any(struct mm_struct *mm);
 int ksm_disable_merge_any(struct mm_struct *mm);
+int ksm_disable(struct mm_struct *mm);
 
 int __ksm_enter(struct mm_struct *mm);
 void __ksm_exit(struct mm_struct *mm);
@@ -80,6 +81,11 @@ static inline void ksm_add_vma(struct vm
 {
 }
 
+static inline int ksm_disable(struct mm_struct *mm)
+{
+	return 0;
+}
+
 static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	return 0;
--- a/mm/ksm.c~mm-ksm-move-disabling-ksm-from-s390-gmap-code-to-ksm-code
+++ a/mm/ksm.c
@@ -2628,6 +2628,17 @@ int ksm_disable_merge_any(struct mm_stru
 	return 0;
 }
 
+int ksm_disable(struct mm_struct *mm)
+{
+	mmap_assert_write_locked(mm);
+
+	if (!test_bit(MMF_VM_MERGEABLE, &mm->flags))
+		return 0;
+	if (test_bit(MMF_VM_MERGE_ANY, &mm->flags))
+		return ksm_disable_merge_any(mm);
+	return ksm_del_vmas(mm);
+}
+
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, int advice, unsigned long *vm_flags)
 {
_

Patches currently in -mm which might be from david@redhat.com are


