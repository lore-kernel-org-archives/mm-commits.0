From: akpm@linux-foundation.org
Subject: [merged] fs-overlayfs-superc-needs-pagemaph.patch removed from
 -mm tree
Date: Thu, 21 Jan 2016 15:28:35 -0800
Message-ID: <56a169a3.0jF0/RTGZkF11gXA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbcAUX2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:28:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, miklos@szeredi.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/overlayfs/super.c needs pagemap.h
has been removed from the -mm tree.  Its filename was
     fs-overlayfs-superc-needs-pagemaph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/overlayfs/super.c needs pagemap.h

i386 allmodconfig:

In file included from fs/overlayfs/super.c:10:0:
fs/overlayfs/super.c: In function 'ovl_fill_super':
include/linux/fs.h:898:36: error: 'PAGE_CACHE_SIZE' undeclared (first use in this function)
 #define MAX_LFS_FILESIZE (((loff_t)PAGE_CACHE_SIZE << (BITS_PER_LONG-1))-1) 
                                    ^
fs/overlayfs/super.c:939:19: note: in expansion of macro 'MAX_LFS_FILESIZE'
  sb->s_maxbytes = MAX_LFS_FILESIZE;
                   ^
include/linux/fs.h:898:36: note: each undeclared identifier is reported only once for each function it appears in
 #define MAX_LFS_FILESIZE (((loff_t)PAGE_CACHE_SIZE << (BITS_PER_LONG-1))-1) 
                                    ^
fs/overlayfs/super.c:939:19: note: in expansion of macro 'MAX_LFS_FILESIZE'
  sb->s_maxbytes = MAX_LFS_FILESIZE;
                   ^

Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/overlayfs/super.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/overlayfs/super.c~fs-overlayfs-superc-needs-pagemaph fs/overlayfs/super.c
--- a/fs/overlayfs/super.c~fs-overlayfs-superc-needs-pagemaph
+++ a/fs/overlayfs/super.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/parser.h>
 #include <linux/module.h>
+#include <linux/pagemap.h>
 #include <linux/sched.h>
 #include <linux/statfs.h>
 #include <linux/seq_file.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-fix-kernel-crash-in-khugepaged-thread-fix.patch
numa-fix-proc-pid-numa_maps-on-s390-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

