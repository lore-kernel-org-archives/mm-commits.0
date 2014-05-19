From: akpm@linux-foundation.org
Subject: + rwsem-support-optimistic-spinning-fix.patch added to -mm tree
Date: Mon, 19 May 2014 12:49:38 -0700
Message-ID: <537a6052.89oxELbVSayP4tT/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbaESTti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 May 2014 15:49:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davidlohr@hp.com

Subject: + rwsem-support-optimistic-spinning-fix.patch added to -mm tree
To: davidlohr@hp.com
From: akpm@linux-foundation.org
Date: Mon, 19 May 2014 12:49:38 -0700


The patch titled
     Subject: rwsem-support-optimistic-spinning-fix
has been added to the -mm tree.  Its filename is
     rwsem-support-optimistic-spinning-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rwsem-support-optimistic-spinning-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rwsem-support-optimistic-spinning-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: rwsem-support-optimistic-spinning-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rwsem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/rwsem.h~rwsem-support-optimistic-spinning-fix include/linux/rwsem.h
--- a/include/linux/rwsem.h~rwsem-support-optimistic-spinning-fix
+++ a/include/linux/rwsem.h
@@ -64,7 +64,7 @@ static inline int rwsem_is_locked(struct
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) && defined(CONFIG_RWSEM_XCHGADD_ALGORITHM)
 #define __RWSEM_INITIALIZER(name)			\
 	{ RWSEM_UNLOCKED_VALUE,				\
 	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
_

Patches currently in -mm which might be from davidlohr@hp.com are

mmvmacache-add-debug-data.patch
mmvmacache-optimize-overflow-system-wide-flushing.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
mips-call-find_vma-with-the-mmap_sem-held.patch
arc-call-find_vma-with-the-mmap_sem-held.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
drm-exynos-call-find_vma-with-the-mmap_sem-held.patch
mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path.patch
ipc-constify-ipc_ops.patch
ipc-shmc-check-for-ulong-overflows-in-shmat.patch
ipc-shmc-check-for-overflows-of-shm_tot.patch
ipc-shmc-check-for-integer-overflow-during-shmget.patch
ipc-shmc-increase-the-defaults-for-shmall-shmmax.patch
ipcshm-document-new-limits-in-the-uapi-header.patch
ipcshm-document-new-limits-in-the-uapi-header-v2.patch
ipcshm-document-new-limits-in-the-uapi-header-v3.patch
ipcmsg-use-current-state-helpers.patch
ipcmsg-move-some-msgq-ns-code-around.patch
ipcmsg-always-respect-msg_noerror.patch
ipcmsg-document-volatile-r_msg.patch
linux-next.patch
blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch
rwsem-support-optimistic-spinning.patch
rwsem-support-optimistic-spinning-checkpatch-fixes.patch
rwsem-support-optimistic-spinning-fix.patch

