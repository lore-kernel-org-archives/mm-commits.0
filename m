Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76ECAC77B7E
	for <mm-commits@archiver.kernel.org>; Mon, 24 Apr 2023 22:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbjDXWeo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Apr 2023 18:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbjDXWef (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Apr 2023 18:34:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A6593E8
        for <mm-commits@vger.kernel.org>; Mon, 24 Apr 2023 15:34:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E17F629CC
        for <mm-commits@vger.kernel.org>; Mon, 24 Apr 2023 22:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5036C433EF;
        Mon, 24 Apr 2023 22:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682375668;
        bh=SMmB6SIcAyc05u/zYD0nLJ6dIwrSowQOtahflns8dwk=;
        h=Date:To:From:Subject:From;
        b=PpEQQJKxclex8EURruPKX3MZFh5ZheRS2S243mMwxMT75H763fiD6mTDtNdmQPiSo
         o6jkl8PFhi26GptOFbdaDkP+Gw1/uomxuo3IunZTadklZ7dFXcFGbnZtV5z2NDeFL1
         diTGxwe3qFOzC70pbGdxjvEsAqNX+SbpfDtrpelI=
Date:   Mon, 24 Apr 2023 15:34:28 -0700
To:     mm-commits@vger.kernel.org, svens@linux.ibm.com, shuah@kernel.org,
        shr@devkernel.io, riel@surriel.com, mhocko@suse.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, hannes@cmpxchg.org,
        gor@linux.ibm.com, frankja@linux.ibm.com,
        borntraeger@linux.ibm.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-move-disabling-ksm-from-s390-gmap-code-to-ksm-code.patch added to mm-unstable branch
Message-Id: <20230424223428.A5036C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: move disabling KSM from s390/gmap code to KSM code
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-move-disabling-ksm-from-s390-gmap-code-to-ksm-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-move-disabling-ksm-from-s390-gmap-code-to-ksm-code.patch

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

mm-ksm-unmerge-and-clear-vm_mergeable-when-setting-pr_set_memory_merge=0.patch
selftests-ksm-ksm_functional_tests-add-prctl-unmerge-test.patch
mm-ksm-move-disabling-ksm-from-s390-gmap-code-to-ksm-code.patch

