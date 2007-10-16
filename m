From: akpm@linux-foundation.org
Subject: - hugetlbfs-read-support-fix-2.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:37:40 -0700
Message-ID: <200710160437.l9G4be1F009121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49434 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754206AbXJPEhv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:37:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     make hugetlbfs_read() static
has been removed from the -mm tree.  Its filename was
     hugetlbfs-read-support-fix-2.patch

This patch was dropped because it was folded into hugetlbfs-read-support.patch

------------------------------------------------------
Subject: make hugetlbfs_read() static
From: Adrian Bunk <bunk@stusta.de>

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc6-mm1:
>...
> +hugetlbfs-read-support.patch
>...
>  More MM things
>...

hugetlbfs_read() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-read-support-fix-2 fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-read-support-fix-2
+++ a/fs/hugetlbfs/inode.c
@@ -222,8 +222,8 @@ hugetlbfs_read_actor(struct page *page, 
  * data. Its *very* similar to do_generic_mapping_read(), we can't use that
  * since it has PAGE_CACHE_SIZE assumptions.
  */
-ssize_t
-hugetlbfs_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos)
+static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
+			      size_t len, loff_t *ppos)
 {
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
slow-down-printk-during-boot.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
hugetlbfs-read-support.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-mempolicyc-cleanups.patch
mm-mempolicyc-cleanups-fix.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
unicode-diacritics-support-s390-fix.patch
script-to-check-for-undefined-kconfig-symbols.patch
drivers-block-ccissc-fix-check-after-use.patch
dontdiff-update-based-on-gitignore-updates.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
