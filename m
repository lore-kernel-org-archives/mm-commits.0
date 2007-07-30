From: akpm@linux-foundation.org
Subject: + hugetlbfs-read-support-fix-2.patch added to -mm tree
Date: Mon, 30 Jul 2007 15:02:29 -0700
Message-ID: <200707302202.l6UM2Tlo032741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51044 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759758AbXG3WCo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 18:02:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     make hugetlbfs_read() static
has been added to the -mm tree.  Its filename is
     hugetlbfs-read-support-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-read-support-fix-2 fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-read-support-fix-2
+++ a/fs/hugetlbfs/inode.c
@@ -217,8 +217,8 @@ hugetlbfs_read_actor(struct page *page, 
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
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
drivers-i2c-i2c-corec-make-code-static.patch
git-hwmon.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
fore200e_param_bs_queue-must-be-__devinit.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
radeon_driver_vblank_do_wait-static.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
