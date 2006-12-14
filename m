From: akpm@osdl.org
Subject: + edac-fix-in-e752x-mc-driver.patch added to -mm tree
Date: Thu, 14 Dec 2006 12:53:08 -0800
Message-ID: <200612142053.kBEKr8J7024154@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56956 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908AbWLNUxW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 15:53:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikechan@google.com, alan@redhat.com, norsk5@xmission.com


The patch titled
     EDAC: Fix in e752x mc driver
has been added to the -mm tree.  Its filename is
     edac-fix-in-e752x-mc-driver.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: EDAC: Fix in e752x mc driver
From: Mike Chan <mikechan@google.com>

This fix/change returns the offset into the page for the ce/ue error, instead
of just 0.  The e752x dram controller reads 34:6 of the linear address with
the error.

Signed-off-by: Mike Chan <mikechan@google.com>
Signed-off-by: doug thompson <norsk5@xmission.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/edac/e752x_edac.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff -puN drivers/edac/e752x_edac.c~edac-fix-in-e752x-mc-driver drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~edac-fix-in-e752x-mc-driver
+++ a/drivers/edac/e752x_edac.c
@@ -285,8 +285,9 @@ static void do_process_ce(struct mem_ctl
 	if (!pvt->map_type)
 		row = 7 - row;
 
-	edac_mc_handle_ce(mci, page, 0, sec1_syndrome, row, channel,
-		"e752x CE");
+	/* e752x mc reads 34:6 of the DRAM linear address */
+	edac_mc_handle_ce(mci, page, offset_in_page(sec1_add << 4),
+			sec1_syndrome, row, channel, "e752x CE");
 }
 
 static inline void process_ce(struct mem_ctl_info *mci, u16 error_one,
@@ -319,8 +320,10 @@ static void do_process_ue(struct mem_ctl
 			((block_page >> 1) & 3) :
 			edac_mc_find_csrow_by_page(mci, block_page);
 
-		edac_mc_handle_ue(mci, block_page, 0, row,
-			"e752x UE from Read");
+		/* e752x mc reads 34:6 of the DRAM linear address */
+		edac_mc_handle_ue(mci, block_page,
+					offset_in_page(error_2b << 4),
+					row, "e752x UE from Read");
 	}
 	if (error_one & 0x0404) {
 		error_2b = scrb_add;
@@ -333,8 +336,10 @@ static void do_process_ue(struct mem_ctl
 			((block_page >> 1) & 3) :
 			edac_mc_find_csrow_by_page(mci, block_page);
 
-		edac_mc_handle_ue(mci, block_page, 0, row,
-				"e752x UE from Scruber");
+		/* e752x mc reads 34:6 of the DRAM linear address */
+		edac_mc_handle_ue(mci, block_page,
+					offset_in_page(error_2b << 4),
+					row, "e752x UE from Scruber");
 	}
 }
 
_

Patches currently in -mm which might be from mikechan@google.com are

edac-fix-in-e752x-mc-driver.patch

