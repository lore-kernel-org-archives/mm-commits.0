From: akpm@linux-foundation.org
Subject: - emulex-fc-hba-driver-fix-overflow-of-statically-allocated-array.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:13:36 -0700
Message-ID: <200708201913.l7KJDaIP018455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48374 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758796AbXHTTVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, James.Bottomley@steeleye.com, james.smart@Emulex.Com, mm-commits@vger.kernel.org


The patch titled
     Emulex FC HBA driver: fix overflow of statically allocated array
has been removed from the -mm tree.  Its filename was
     emulex-fc-hba-driver-fix-overflow-of-statically-allocated-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Emulex FC HBA driver: fix overflow of statically allocated array
From: Jesper Juhl <jesper.juhl@gmail.com>

The Coverity checker noticed that we may overrun a statically allocated
array in drivers/scsi/lpfc/lpfc_sli.c::lpfc_sli_hbqbuf_find().

The case is this; In 'struct lpfc_hba' we have

	#define LPFC_MAX_HBQS  4
	...
	struct lpfc_hba {
		...
		struct hbq_s hbqs[LPFC_MAX_HBQS];
		...
	};

But then in lpfc_sli_hbqbuf_find() we have this code

	hbqno = tag >> 16;
	if (hbqno > LPFC_MAX_HBQS)
		return NULL;

if 'hbqno' ends up as exactely 4, then we won't return, and then this

	list_for_each_entry(d_buf, &phba->hbqs[hbqno].hbq_buffer_list, list) {

will cause an overflow of the statically allocated array at index 4,
since the valid indices are only 0-3.

I propose this patch, that simply changes the 'hbqno > LPFC_MAX_HBQS'
into 'hbqno >= LPFC_MAX_HBQS' as a possible fix.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: James Smart <james.smart@emulex.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_sli.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/lpfc/lpfc_sli.c~emulex-fc-hba-driver-fix-overflow-of-statically-allocated-array drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c~emulex-fc-hba-driver-fix-overflow-of-statically-allocated-array
+++ a/drivers/scsi/lpfc/lpfc_sli.c
@@ -675,7 +675,7 @@ lpfc_sli_hbqbuf_find(struct lpfc_hba *ph
 	uint32_t hbqno;
 
 	hbqno = tag >> 16;
-	if (hbqno > LPFC_MAX_HBQS)
+	if (hbqno >= LPFC_MAX_HBQS)
 		return NULL;
 
 	list_for_each_entry(d_buf, &phba->hbqs[hbqno].hbq_buffer_list, list) {
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-powerpc.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-dvb.patch
git-gfs2-nmw.patch
clean-up-duplicate-includes-in-drivers-input.patch
scripts-ver_linux-correct-printing-of-binutils-version.patch
improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring.patch
avoid-possible-null-pointer-deref-in-3c359-driver.patch
git-backlight.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
git-scsi-misc.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
git-watchdog.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
clean-up-duplicate-includes-in-drivers-spi.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
