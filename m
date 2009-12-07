From: akpm@linux-foundation.org
Subject: + keys-ptr_err-return-of-wrong-pointer-in-keyctl_get_security.patch added to -mm tree
Date: Mon, 07 Dec 2009 15:19:01 -0800
Message-ID: <200912072319.nB7NJ14F009738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965138AbZLGXTO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2009 18:19:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, dhowells@redhat.com, jmorris@namei.org


The patch titled
     keys: PTR_ERR return of wrong pointer in keyctl_get_security()
has been added to the -mm tree.  Its filename is
     keys-ptr_err-return-of-wrong-pointer-in-keyctl_get_security.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-return-ptr_err-rather-than-is_err.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
ib-uverbs-ptr_err-return-of-wrong-pointer-in-ib_uverbs_get_context.patch
hidp-ptr_err-return-of-wrong-pointer-in-hidp_setup_hid.patch
imx-bit-confusion.patch
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
r8192u_core-test-for-negative-error-in-rtl8192_rx_isr.patch
wusb-use-sizeof-struct-rather-than-pointer.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
keys-ptr_err-return-of-wrong-pointer-in-keyctl_get_security.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch

