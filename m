Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5FAC7618E
	for <mm-commits@archiver.kernel.org>; Mon, 24 Apr 2023 22:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbjDXWen (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Apr 2023 18:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232987AbjDXWea (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Apr 2023 18:34:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980CF8A4E
        for <mm-commits@vger.kernel.org>; Mon, 24 Apr 2023 15:34:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DD32629C8
        for <mm-commits@vger.kernel.org>; Mon, 24 Apr 2023 22:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A452C433D2;
        Mon, 24 Apr 2023 22:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682375664;
        bh=y2lAl+zmBAIflDwar4RlOlc13Fz09eB8aDeSu/ZTecU=;
        h=Date:To:From:Subject:From;
        b=yb1xh0keXZmFs1qQdvv9Zjwg5lrsnzblbdQm8VotGQj9T4oKqumipaPcyOxV3ejZf
         QviqEt5e2DR4PQr6PYL4WPvga/ykNFz8tAAxMMO5FAveLQdGcyTD3iuWA3ljg/bcuC
         C7A4d8Sso5Xpjgum3yevOGGKDutJcALIGK5vymSs=
Date:   Mon, 24 Apr 2023 15:34:23 -0700
To:     mm-commits@vger.kernel.org, svens@linux.ibm.com, shuah@kernel.org,
        shr@devkernel.io, riel@surriel.com, mhocko@suse.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, hannes@cmpxchg.org,
        gor@linux.ibm.com, frankja@linux.ibm.com,
        borntraeger@linux.ibm.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-unmerge-and-clear-vm_mergeable-when-setting-pr_set_memory_merge=0.patch added to mm-unstable branch
Message-Id: <20230424223424.6A452C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: unmerge and clear VM_MERGEABLE when setting PR_SET_MEMORY_MERGE=0
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-unmerge-and-clear-vm_mergeable-when-setting-pr_set_memory_merge=0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-unmerge-and-clear-vm_mergeable-when-setting-pr_set_memory_merge=0.patch

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
Subject: mm/ksm: unmerge and clear VM_MERGEABLE when setting PR_SET_MEMORY_MERGE=0
Date: Sat, 22 Apr 2023 22:54:18 +0200

Patch series "mm/ksm: improve PR_SET_MEMORY_MERGE=0 handling and cleanup
disabling KSM", v2.

(1) Make PR_SET_MEMORY_MERGE=0 unmerge pages like setting MADV_UNMERGEABLE
does, (2) add a selftest for it and (3) factor out disabling of KSM from
s390/gmap code.


This patch (of 3):

Let's unmerge any KSM pages when setting PR_SET_MEMORY_MERGE=0, and clear
the VM_MERGEABLE flag from all VMAs -- just like KSM would.  Of course,
only do that if we previously set PR_SET_MEMORY_MERGE=1.

Link: https://lkml.kernel.org/r/20230422205420.30372-1-david@redhat.com
Link: https://lkml.kernel.org/r/20230422205420.30372-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Stefan Roesch <shr@devkernel.io>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |    1 
 kernel/sys.c        |   12 ++------
 mm/ksm.c            |   59 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 9 deletions(-)

--- a/include/linux/ksm.h~mm-ksm-unmerge-and-clear-vm_mergeable-when-setting-pr_set_memory_merge=0
+++ a/include/linux/ksm.h
@@ -21,6 +21,7 @@ int ksm_madvise(struct vm_area_struct *v
 
 void ksm_add_vma(struct vm_area_struct *vma);
 int ksm_enable_merge_any(struct mm_struct *mm);
+int ksm_disable_merge_any(struct mm_struct *mm);
 
 int __ksm_enter(struct mm_struct *mm);
 void __ksm_exit(struct mm_struct *mm);
--- a/kernel/sys.c~mm-ksm-unmerge-and-clear-vm_mergeable-when-setting-pr_set_memory_merge=0
+++ a/kernel/sys.c
@@ -2695,16 +2695,10 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 		if (mmap_write_lock_killable(me->mm))
 			return -EINTR;
 
-		if (arg2) {
+		if (arg2)
 			error = ksm_enable_merge_any(me->mm);
-		} else {
-			/*
-			 * TODO: we might want disable KSM on all VMAs and
-			 * trigger unsharing to completely disable KSM.
-			 */
-			clear_bit(MMF_VM_MERGE_ANY, &me->mm->flags);
-			error = 0;
-		}
+		else
+			error = ksm_disable_merge_any(me->mm);
 		mmap_write_unlock(me->mm);
 		break;
 	case PR_GET_MEMORY_MERGE:
--- a/mm/ksm.c~mm-ksm-unmerge-and-clear-vm_mergeable-when-setting-pr_set_memory_merge=0
+++ a/mm/ksm.c
@@ -2520,6 +2520,22 @@ static void __ksm_add_vma(struct vm_area
 		vm_flags_set(vma, VM_MERGEABLE);
 }
 
+static int __ksm_del_vma(struct vm_area_struct *vma)
+{
+	int err;
+
+	if (!(vma->vm_flags & VM_MERGEABLE))
+		return 0;
+
+	if (vma->anon_vma) {
+		err = unmerge_ksm_pages(vma, vma->vm_start, vma->vm_end);
+		if (err)
+			return err;
+	}
+
+	vm_flags_clear(vma, VM_MERGEABLE);
+	return 0;
+}
 /**
  * ksm_add_vma - Mark vma as mergeable if compatible
  *
@@ -2542,6 +2558,20 @@ static void ksm_add_vmas(struct mm_struc
 		__ksm_add_vma(vma);
 }
 
+static int ksm_del_vmas(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma;
+	int err;
+
+	VMA_ITERATOR(vmi, mm, 0);
+	for_each_vma(vmi, vma) {
+		err = __ksm_del_vma(vma);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 /**
  * ksm_enable_merge_any - Add mm to mm ksm list and enable merging on all
  *                        compatible VMA's
@@ -2569,6 +2599,35 @@ int ksm_enable_merge_any(struct mm_struc
 	return 0;
 }
 
+/**
+ * ksm_disable_merge_any - Disable merging on all compatible VMA's of the mm,
+ *			   previously enabled via ksm_enable_merge_any().
+ *
+ * Disabling merging implies unmerging any merged pages, like setting
+ * MADV_UNMERGEABLE would. If unmerging fails, the whole operation fails and
+ * merging on all compatible VMA's remains enabled.
+ *
+ * @mm: Pointer to mm
+ *
+ * Returns 0 on success, otherwise error code
+ */
+int ksm_disable_merge_any(struct mm_struct *mm)
+{
+	int err;
+
+	if (!test_bit(MMF_VM_MERGE_ANY, &mm->flags))
+		return 0;
+
+	err = ksm_del_vmas(mm);
+	if (err) {
+		ksm_add_vmas(mm);
+		return err;
+	}
+
+	clear_bit(MMF_VM_MERGE_ANY, &mm->flags);
+	return 0;
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

