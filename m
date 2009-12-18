From: akpm@linux-foundation.org
Subject: [merged] keys-ptr_err-return-of-wrong-pointer-in-keyctl_get_security.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:27:15 -0800
Message-ID: <200912182027.nBIKRFTR016617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932855AbZLRU1g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:27:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dhowells@redhat.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     keys: PTR_ERR return of wrong pointer in keyctl_get_security()
has been removed from the -mm tree.  Its filename was
     keys-ptr_err-return-of-wrong-pointer-in-keyctl_get_security.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keys: PTR_ERR return of wrong pointer in keyctl_get_security()
From: Roel Kluin <roel.kluin@gmail.com>

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/keyctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/keys/keyctl.c~keys-ptr_err-return-of-wrong-pointer-in-keyctl_get_security security/keys/keyctl.c
--- a/security/keys/keyctl.c~keys-ptr_err-return-of-wrong-pointer-in-keyctl_get_security
+++ a/security/keys/keyctl.c
@@ -1194,7 +1194,7 @@ long keyctl_get_security(key_serial_t ke
 		 * have the authorisation token handy */
 		instkey = key_get_instantiation_authkey(keyid);
 		if (IS_ERR(instkey))
-			return PTR_ERR(key_ref);
+			return PTR_ERR(instkey);
 		key_put(instkey);
 
 		key_ref = lookup_user_key(keyid, KEY_LOOKUP_PARTIAL, 0);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-85xx-wrong-variable-returned-on-error.patch
hidp-ptr_err-return-of-wrong-pointer-in-hidp_setup_hid.patch
imx-bit-confusion.patch
serial-fix-test-of-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
drbd-fix-test-of-unsigned-in-_drbd_fault_random.patch
r8192u_core-test-for-negative-error-in-rtl8192_rx_isr.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch

