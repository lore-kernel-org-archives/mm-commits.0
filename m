From: akpm@linux-foundation.org
Subject: + page-types-unsigned-cannot-be-less-than-0-in-add_page.patch added to -mm tree
Date: Mon, 12 Oct 2009 15:35:12 -0700
Message-ID: <200910122235.n9CMZC9B022052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933219AbZJLWgp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 18:36:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, fengguang.wu@intel.com, randy.dunlap@oracle.com


The patch titled
     page-types: unsigned cannot be less than 0 in add_page()
has been added to the -mm tree.  Its filename is
     page-types-unsigned-cannot-be-less-than-0-in-add_page.patch

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
Subject: page-types: unsigned cannot be less than 0 in add_page()
From: Roel Kluin <roel.kluin@gmail.com>

If not signed, testing of the read() return value in this function
will not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/vm/page-types.c~page-types-unsigned-cannot-be-less-than-0-in-add_page Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~page-types-unsigned-cannot-be-less-than-0-in-add_page
+++ a/Documentation/vm/page-types.c
@@ -560,7 +560,7 @@ static void walk_pfn(unsigned long voffs
 {
 	uint64_t buf[KPAGEFLAGS_BATCH];
 	unsigned long batch;
-	unsigned long pages;
+	long pages;
 	unsigned long i;
 
 	while (count) {
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
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch

