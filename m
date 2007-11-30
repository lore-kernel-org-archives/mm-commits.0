From: akpm@linux-foundation.org
Subject: - mn10300-fix-mtd-jedec-probe-so-that-the-asb2303-bootprom-can-be-detected.patch removed from -mm tree
Date: Fri, 30 Nov 2007 13:36:59 -0800
Message-ID: <200711302137.lAULax7V025625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45129 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430AbXK3Vhs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 16:37:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mn10300: fix MTD JEDEC probe so that the ASB2303 bootprom can be detected
has been removed from the -mm tree.  Its filename was
     mn10300-fix-mtd-jedec-probe-so-that-the-asb2303-bootprom-can-be-detected.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: mn10300: fix MTD JEDEC probe so that the ASB2303 bootprom can be detected
From: David Howells <dhowells@redhat.com>

Fix MTD JEDEC probe so that the ASB2303 bootprom can be accessed.  This is
presumably required because the bootprom is normally write-protected and so
the normal flash probes don't work as they require the ability to write to the
flash to send it commands.

In the condition of the excluded if-statement, uaddr is 1.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/jedec_probe.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/mtd/chips/jedec_probe.c~mn10300-fix-mtd-jedec-probe-so-that-the-asb2303-bootprom-can-be-detected drivers/mtd/chips/jedec_probe.c
--- a/drivers/mtd/chips/jedec_probe.c~mn10300-fix-mtd-jedec-probe-so-that-the-asb2303-bootprom-can-be-detected
+++ a/drivers/mtd/chips/jedec_probe.c
@@ -1883,11 +1883,18 @@ static inline __u8 finfo_uaddr(const str
 
 	uaddr = finfo->uaddr[uaddr_idx];
 
+	/* the MN10300 ASB2303 board doesn't detect its bootprom if this test
+	 * is allowed to take place, presumably because the flash is
+	 * write-protected and so cannot be commanded for the purposes of
+	 * probing
+	 */
+#ifndef CONFIG_MN10300_UNIT_ASB2303
 	if (uaddr != MTD_UADDR_NOT_SUPPORTED ) {
 		/* ASSERT("The unlock addresses for non-8-bit mode
 		   are bollocks. We don't really need an array."); */
 		uaddr = finfo->uaddr[0];
 	}
+#endif
 
  uaddr_done:
 	return uaddr;
_

Patches currently in -mm which might be from dhowells@redhat.com are

git-mtd.patch
frv-fix-the-extern-declaration-of-kallsyms_num_syms.patch
frv-arrange-things-such-that-bra-can-reach-from-the-trap.patch
af_rxrpc-configure-crypto-correctly-for-af_rxrpc.patch
frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
frv-remove-dead-config-symbol-from-frv-code.patch
nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
unexport-asm-pageh.patch
add-cmpxchg_local-to-frv.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
tty-let-architectures-override-the-user-kernel-macros.patch
aout-move-stack_top-to-asm-processorh.patch
aout-mark-arches-that-support-aout-format.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
mn10300-add-platform-mtd-support-for-the-asb2303-board.patch
mn10300-fix-mtd-jedec-probe-so-that-the-asb2303-bootprom-can-be-detected.patch
mutex-subsystem-synchro-test-module.patch
