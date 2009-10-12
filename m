From: akpm@linux-foundation.org
Subject: + cryptocop-fix-assertion-in-create_output_descriptors.patch added to -mm tree
Date: Mon, 12 Oct 2009 15:12:41 -0700
Message-ID: <200910122212.n9CMCfcf007535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933447AbZJLWNm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 18:13:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cryptocop: fix assertion in create_output_descriptors()
has been added to the -mm tree.  Its filename is
     cryptocop-fix-assertion-in-create_output_descriptors.patch

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
Subject: cryptocop: fix assertion in create_output_descriptors()
From: Roel Kluin <roel.kluin@gmail.com>

size_t desc_len cannot be less than 0, test before the subtraction.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/cris/arch-v32/drivers/cryptocop.c~cryptocop-fix-assertion-in-create_output_descriptors arch/cris/arch-v32/drivers/cryptocop.c
--- a/arch/cris/arch-v32/drivers/cryptocop.c~cryptocop-fix-assertion-in-create_output_descriptors
+++ a/arch/cris/arch-v32/drivers/cryptocop.c
@@ -628,9 +628,9 @@ static int create_output_descriptors(str
 		cdesc->dma_descr->buf = (char*)virt_to_phys(operation->tfrm_op.indata[*iniov_ix].iov_base + *iniov_offset);
 		cdesc->dma_descr->after = cdesc->dma_descr->buf + dlength;
 
+		assert(desc_len >= dlength);
 		desc_len -= dlength;
 		*iniov_offset += dlength;
-		assert(desc_len >= 0);
 		if (*iniov_offset >= operation->tfrm_op.indata[*iniov_ix].iov_len) {
 			*iniov_offset = 0;
 			++(*iniov_ix);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hfc_usb-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch

