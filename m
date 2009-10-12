From: akpm@linux-foundation.org
Subject: + fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch added to -mm tree
Date: Mon, 12 Oct 2009 15:13:25 -0700
Message-ID: <200910122213.n9CMDP1o009090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757103AbZJLWP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 18:15:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, jwoithe@physics.adelaide.edu.au, lenb@kernel.org


The patch titled
     fujitsu-laptop: fix tests of acpi_evaluate_integer() return
has been added to the -mm tree.  Its filename is
     fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch

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
Subject: fujitsu-laptop: fix tests of acpi_evaluate_integer() return
From: Roel Kluin <roel.kluin@gmail.com>

The wrong test was used acpi_status status is unsigned.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/platform/x86/fujitsu-laptop.c~fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return drivers/platform/x86/fujitsu-laptop.c
--- a/drivers/platform/x86/fujitsu-laptop.c~fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return
+++ a/drivers/platform/x86/fujitsu-laptop.c
@@ -376,7 +376,7 @@ static int get_lcd_level(void)
 
 	status =
 	    acpi_evaluate_integer(fujitsu->acpi_handle, "GBLL", NULL, &state);
-	if (status < 0)
+	if (ACPI_FAILURE(status))
 		return status;
 
 	fujitsu->brightness_level = state & 0x0fffffff;
@@ -398,7 +398,7 @@ static int get_max_brightness(void)
 
 	status =
 	    acpi_evaluate_integer(fujitsu->acpi_handle, "RBLL", NULL, &state);
-	if (status < 0)
+	if (ACPI_FAILURE(status))
 		return status;
 
 	fujitsu->max_brightness = state;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
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

