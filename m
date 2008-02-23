From: akpm@linux-foundation.org
Subject: - gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:21:42 -0800
Message-ID: <200802232021.m1NKLgG6013362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760148AbYBWUVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:21:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab: slabinfo: fall back from /sys/kernel/slab to /sys/slab
has been removed from the -mm tree.  Its filename was
     gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab: slabinfo: fall back from /sys/kernel/slab to /sys/slab
From: Christoph Lameter <clameter@sgi.com>

I keep running upstream and mm kernels and the location of the slab
directory is different since upstream still uses /sys/slab.  This patch
makes slabinfo check /sys/slab if /sys/kernel/slab is not there.  Makes
slabinfo work on any kernel.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slabinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/vm/slabinfo.c~gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab Documentation/vm/slabinfo.c
--- a/Documentation/vm/slabinfo.c~gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab
+++ a/Documentation/vm/slabinfo.c
@@ -1123,7 +1123,7 @@ void read_slab_dir(void)
 	char *t;
 	int count;
 
-	if (chdir("/sys/kernel/slab"))
+	if (chdir("/sys/kernel/slab") && chdir("/sys/slab"))
 		fatal("SYSFS support for SLUB not active\n");
 
 	dir = opendir(".");
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
define-functions-for-page-cache-handling.patch
nommu-is_vmalloc_addr-wont-compile-if-mmu.patch
cpuset-trivial-documentation-fix-s-n_memory-n_high_memory.patch
use-page_cache_xxx-in-fs-splicec.patch
git-unionfs.patch
use-page_cache_xxx-for-fs-xfs.patch
git-slub.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
remove-set_migrateflags.patch
use-page_cache_xxx-functions-in-mm-filemapc.patch
use-page_cache_xxx-in-mm-page-writebackc.patch
use-page_cache_xxx-in-mm-truncatec.patch
use-page_cache_xxx-in-mm-rmapc.patch
use-page_cache_xxx-in-mm-filemap_xipc.patch
use-page_cache_xxx-in-mm-migratec.patch
use-page_cache_xxx-in-fs-libfsc.patch
use-page_cache_xxx-in-fs-sync.patch
use-page_cache_xxx-in-fs-bufferc.patch
use-page_cache_xxx-in-mm-mpagec.patch
use-page_cache_xxx-in-mm-fadvisec.patch
use-page_cache_xxx-in-ext2.patch
use-page_cache_xxx-in-fs-ext3.patch
use-page_cache_xxx-in-fs-reiserfs.patch
use-page_cache_xxx-in-fs-ext4.patch
generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3.patch
x86_64-fold-pda-into-per-cpu-area-v3.patch
x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
