From: akpm@linux-foundation.org
Subject: [merged] edac-i5000_edac-critical-fix-panic-out-of-bounds.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:27:17 -0800
Message-ID: <201001212127.o0LLRHaf030631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755325Ab0AUV2P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:28:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tom@vincze.org, dougthompson@xmission.com, mchehab@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     edac: i5000_edac critical fix panic out of bounds
has been removed from the -mm tree.  Its filename was
     edac-i5000_edac-critical-fix-panic-out-of-bounds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: i5000_edac critical fix panic out of bounds
From: Tamas Vincze <tom@vincze.org>

EDAC MC0: INTERNAL ERROR: channel-b out of range (4 >= 4)
Kernel panic - not syncing: EDAC MC0: Uncorrected Error  (XEN) Domain 0 crashed: 'noreboot' set - not rebooting.

This happens because FERR_NF_FBD bit 28 is not updated on i5000.  Due to
that, both bits 28 and 29 may be equal to one, returning channel = 3.  As
this value is invalid, EDAC core generates the panic.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14568

Signed-off-by: Tamas Vincze <tom@vincze.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5000_edac.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/edac/i5000_edac.c~edac-i5000_edac-critical-fix-panic-out-of-bounds drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~edac-i5000_edac-critical-fix-panic-out-of-bounds
+++ a/drivers/edac/i5000_edac.c
@@ -577,7 +577,13 @@ static void i5000_process_nonfatal_error
 		debugf0("\tUncorrected bits= 0x%x\n", ue_errors);
 
 		branch = EXTRACT_FBDCHAN_INDX(info->ferr_nf_fbd);
-		channel = branch;
+
+		/*
+		 * According with i5000 datasheet, bit 28 has no significance
+		 * for errors M4Err-M12Err and M17Err-M21Err, on FERR_NF_FBD
+		 */
+		channel = branch & 2;
+
 		bank = NREC_BANK(info->nrecmema);
 		rank = NREC_RANK(info->nrecmema);
 		rdwr = NREC_RDWR(info->nrecmema);
_

Patches currently in -mm which might be from tom@vincze.org are

origin.patch

