From: akpm@linux-foundation.org
Subject: + mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch added to -mm tree
Date: Mon, 30 Jun 2008 15:39:53 -0700
Message-ID: <200806302239.m5UMdrYk029343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762241AbYF3Wm2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 18:42:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, dhowells@redhat.com


The patch titled
     mn10300: move sg_dma_{address,len}() to asm/scatterlist.h
has been added to the -mm tree.  Its filename is
     mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: move sg_dma_{address,len}() to asm/scatterlist.h
From: Adrian Bunk <bunk@kernel.org>

mn10300 was the only architecture where sg_dma_{address,len}() were not
in asm/scatterlist.h, and it's not a big surprise that this caused a
compile error somewhere:

/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/media/video/videobuf-dma-sg.c: In function `videobuf_dma_map':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/media/video/videobuf-dma-sg.c:238: error: implicit declaration of function 'sg_dma_address'

Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mn10300/pci.h         |    9 ---------
 include/asm-mn10300/scatterlist.h |    9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/asm-mn10300/pci.h~mn10300-move-sg_dma_addresslen-to-asm-scatterlisth include/asm-mn10300/pci.h
--- a/include/asm-mn10300/pci.h~mn10300-move-sg_dma_addresslen-to-asm-scatterlisth
+++ a/include/asm-mn10300/pci.h
@@ -74,15 +74,6 @@ struct pci_dev;
 /* This is always fine. */
 #define pci_dac_dma_supported(pci_dev, mask)	(0)
 
-/*
- * These macros should be used after a pci_map_sg call has been done
- * to get bus addresses of each of the SG entries and their lengths.
- * You should only work with the number of sg entries pci_map_sg
- * returns.
- */
-#define sg_dma_address(sg)	((sg)->dma_address)
-#define sg_dma_len(sg)		((sg)->length)
-
 /* Return the index of the PCI controller for device. */
 static inline int pci_controller_num(struct pci_dev *dev)
 {
diff -puN include/asm-mn10300/scatterlist.h~mn10300-move-sg_dma_addresslen-to-asm-scatterlisth include/asm-mn10300/scatterlist.h
--- a/include/asm-mn10300/scatterlist.h~mn10300-move-sg_dma_addresslen-to-asm-scatterlisth
+++ a/include/asm-mn10300/scatterlist.h
@@ -43,4 +43,13 @@ struct scatterlist {
 
 #define ISA_DMA_THRESHOLD (0x00ffffff)
 
+/*
+ * These macros should be used after a pci_map_sg call has been done
+ * to get bus addresses of each of the SG entries and their lengths.
+ * You should only work with the number of sg entries pci_map_sg
+ * returns.
+ */
+#define sg_dma_address(sg)	((sg)->dma_address)
+#define sg_dma_len(sg)		((sg)->length)
+
 #endif /* _ASM_SCATTERLIST_H */
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
firmware-fix-the-request_firmware-dummy.patch
remove-drivers-acorn-char-defkeymap-l7200c.patch
drm-make-drm_minors_cleanup-static.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
scsi-make-struct-scsi_hosttarget_type-static.patch
git-xtensa.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
mm-page_allocc-cleanups.patch
mm-make-register_page_bootmem_info_section-static.patch
remove-include-asm-h8300-keyboardh.patch
alpha-remove-the-unused-alpha_core_agp-option.patch
remove-include-linux-pm_legacyh.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
include-linux-kernelh-userspace-header-cleanup.patch
remove-the-oss-trident-driver.patch
config_sound_wm97xx-remove-stale-makefile-line.patch
serial-8250_gscc-add-module_license.patch
video-sis-remove-compat-code.patch
drivers-video-amifbc-cleanups.patch
minix-remove-no_truncate-code.patch
jbd-unexport-journal_update_superblock.patch
coda-remove-coda_fs_old_api.patch
fat-dirc-switch-to-struct-__fat_fs_dirent.patch
remove-the-in-kernel-struct-dirent64.patch
remove-unused-include-linux-direnths.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
remove-is_tty.patch
pty-remove-unused-unix98_pty_count-options.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
make-macfb_setup-static.patch
reiser4.patch

