From: akpm@linux-foundation.org
Subject: [folded-merged] rwsem-support-optimistic-spinning-fix.patch
 removed from -mm tree
Date: Tue, 03 Jun 2014 15:52:53 -0700
Message-ID: <538e51c5.nIFiWBrKCyz68Qe4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54265 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbaFCWwy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2014 18:52:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, davidlohr@hp.com

Subject: [folded-merged] rwsem-support-optimistic-spinning-fix.patch removed from -mm tree
To: davidlohr@hp.com,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de,tim.c.chen@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 03 Jun 2014 15:52:53 -0700


The patch titled
     Subject: rwsem-support-optimistic-spinning-fix
has been removed from the -mm tree.  Its filename was
     rwsem-support-optimistic-spinning-fix.patch

This patch was dropped because it was folded into rwsem-support-optimistic-spinning.patch

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: rwsem-support-optimistic-spinning-fix

Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
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

origin.patch
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
mm-process_vm_access-move-config-option-into-init-kconfig.patch
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
ipcmsg-document-volatile-r_msg.patch
ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt.patch
linux-next.patch
blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch
rwsem-support-optimistic-spinning.patch

