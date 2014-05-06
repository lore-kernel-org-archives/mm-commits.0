From: akpm@linux-foundation.org
Subject: + ipcshm-document-new-limits-in-the-uapi-header.patch added to
 -mm tree
Date: Tue, 06 May 2014 13:09:44 -0700
Message-ID: <53694188.+HL36UMArZWwFgwm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaEFUJp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2014 16:09:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, manfred@colorfullife.com, davidlohr@hp.com

Subject: + ipcshm-document-new-limits-in-the-uapi-header.patch added to -mm tree
To: davidlohr@hp.com,manfred@colorfullife.com,mtk.manpages@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 06 May 2014 13:09:44 -0700


The patch titled
     Subject: ipc,shm: document new limits in the uapi header
has been added to the -mm tree.  Its filename is
     ipcshm-document-new-limits-in-the-uapi-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcshm-document-new-limits-in-the-uapi-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcshm-document-new-limits-in-the-uapi-header.patch

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
Subject: ipc,shm: document new limits in the uapi header

This is useful in the future and allows users to better understand the
reasoning behind the changes.

Also use UL as we're dealing with it anyways.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/shm.h |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN include/uapi/linux/shm.h~ipcshm-document-new-limits-in-the-uapi-header include/uapi/linux/shm.h
--- a/include/uapi/linux/shm.h~ipcshm-document-new-limits-in-the-uapi-header
+++ a/include/uapi/linux/shm.h
@@ -8,17 +8,19 @@
 #endif
 
 /*
- * SHMMAX, SHMMNI and SHMALL are upper limits are defaults which can
- * be modified by sysctl.
+ * SHMMNI, SHMMAX and SHMALL are the default upper limits which can be
+ * modified by sysctl. Both SHMMAX and SHMALL have their default values
+ * to the maximum limit which is as large as it can be without helping
+ * userspace overflow the values. There is really nothing the kernel
+ * can do to avoid this any variables. It is therefore not advised to
+ * make them any larger. This is suitable for both 32 and 64-bit systems.
  */
-
 #define SHMMIN 1			 /* min shared seg size (bytes) */
 #define SHMMNI 4096			 /* max num of segs system wide */
-#define SHMMAX (ULONG_MAX - (1L<<24))	 /* max shared seg size (bytes) */
-#define SHMALL (ULONG_MAX - (1L<<24))	 /* max shm system wide (pages) */
+#define SHMMAX (ULONG_MAX - (1UL << 24)) /* max shared seg size (bytes) */
+#define SHMALL (ULONG_MAX - (1UL << 24)) /* max shm system wide (pages) */
 #define SHMSEG SHMMNI			 /* max shared segs per process */
 
-
 /* Obsolete, used only for backwards compatibility and libc5 compiles */
 struct shmid_ds {
 	struct ipc_perm		shm_perm;	/* operation perms */
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
ipc-constify-ipc_ops.patch
ipc-shmc-check-for-ulong-overflows-in-shmat.patch
ipc-shmc-check-for-overflows-of-shm_tot.patch
ipc-shmc-check-for-integer-overflow-during-shmget.patch
ipc-shmc-increase-the-defaults-for-shmall-shmmax.patch
ipcshm-document-new-limits-in-the-uapi-header.patch
linux-next.patch
blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch

