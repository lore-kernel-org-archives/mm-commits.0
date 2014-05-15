From: akpm@linux-foundation.org
Subject: + ipcshm-document-new-limits-in-the-uapi-header-v3.patch added to -mm tree
Date: Thu, 15 May 2014 16:06:07 -0700
Message-ID: <5375485f.nhpe5guAU0xLRIql%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaEOXGI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 19:06:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, manfred@colorfullife.com, davidlohr@hp.com

Subject: + ipcshm-document-new-limits-in-the-uapi-header-v3.patch added to -mm tree
To: davidlohr@hp.com,manfred@colorfullife.com,mtk.manpages@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 16:06:07 -0700


The patch titled
     Subject: ipcshm-document-new-limits-in-the-uapi-header-v3
has been added to the -mm tree.  Its filename is
     ipcshm-document-new-limits-in-the-uapi-header-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcshm-document-new-limits-in-the-uapi-header-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcshm-document-new-limits-in-the-uapi-header-v3.patch

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
Subject: ipcshm-document-new-limits-in-the-uapi-header-v3

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/shm.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/uapi/linux/shm.h~ipcshm-document-new-limits-in-the-uapi-header-v3 include/uapi/linux/shm.h
--- a/include/uapi/linux/shm.h~ipcshm-document-new-limits-in-the-uapi-header-v3
+++ a/include/uapi/linux/shm.h
@@ -8,13 +8,13 @@
 #endif
 
 /*
- * SHMMNI, SHMMAX and SHMALL are the default upper limits which can be
- * modified by sysctl. Both SHMMAX and SHMALL have their default values
- * to the maximum limit which is as large as it can be without helping
- * userspace overflow the values. There is really nothing the kernel
- * can do to avoid this any further. It is therefore not advised to
- * make them any larger. These limits are suitable for both 32 and
- * 64-bit systems.
+ * SHMMNI, SHMMAX and SHMALL are default upper limits which can be
+ * modified by sysctl. The SHMMAX and SHMALL values have been chosen to
+ * be as large possible without facilitating scenarios where userspace
+ * causes overflows when adjusting the limits via operations of the form
+ * "retrieve current limit; add X; update limit". It is therefore not
+ * advised to make SHMMAX and SHMALL any larger. These limits are
+ * suitable for both 32 and 64-bit systems.
  */
 #define SHMMIN 1			 /* min shared seg size (bytes) */
 #define SHMMNI 4096			 /* max num of segs system wide */
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

