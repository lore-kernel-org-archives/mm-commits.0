From: akpm@linux-foundation.org
Subject: - drivers-message-fusion-use-array_size.patch removed from -mm tree
Date: Tue, 25 Nov 2008 11:57:51 -0800
Message-ID: <200811251957.mAPJvpFZ029299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076AbYKYT56 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 14:57:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, Eric.Moore@lsil.com, mm-commits@vger.kernel.org


The patch titled
     drivers/message/fusion: use ARRAY_SIZE
has been removed from the -mm tree.  Its filename was
     drivers-message-fusion-use-array_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/message/fusion: use ARRAY_SIZE
From: Julia Lawall <julia@diku.dk>

ARRAY_SIZE is more concise to use when the size of an array is divided by
the size of its type or the size of its first element.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@i@
@@

#include <linux/kernel.h>

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(E[...]))
+ ARRAY_SIZE(E)

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(T))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~drivers-message-fusion-use-array_size drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~drivers-message-fusion-use-array_size
+++ a/drivers/message/fusion/mptbase.c
@@ -4562,7 +4562,7 @@ WaitForDoorbellReply(MPT_ADAPTER *ioc, i
 			failcnt++;
 		hword = le16_to_cpu(CHIPREG_READ32(&ioc->chip->Doorbell) & 0x0000FFFF);
 		/* don't overflow our IOC hs_reply[] buffer! */
-		if (u16cnt < sizeof(ioc->hs_reply) / sizeof(ioc->hs_reply[0]))
+		if (u16cnt < ARRAY_SIZE(ioc->hs_reply))
 			hs_reply[u16cnt] = hword;
 		CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
 	}
@@ -7173,7 +7173,7 @@ union loginfo_type {
 
 	sas_loginfo.loginfo = log_info;
 	if ((sas_loginfo.dw.bus_type != 3 /*SAS*/) &&
-	    (sas_loginfo.dw.originator < sizeof(originator_str)/sizeof(char*)))
+	    (sas_loginfo.dw.originator < ARRAY_SIZE(originator_str)))
 		return;
 
 	originator_desc = originator_str[sas_loginfo.dw.originator];
@@ -7182,21 +7182,21 @@ union loginfo_type {
 
 		case 0:  /* IOP */
 			if (sas_loginfo.dw.code <
-			    sizeof(iop_code_str)/sizeof(char*))
+			    ARRAY_SIZE(iop_code_str))
 				code_desc = iop_code_str[sas_loginfo.dw.code];
 			break;
 		case 1:  /* PL */
 			if (sas_loginfo.dw.code <
-			    sizeof(pl_code_str)/sizeof(char*))
+			    ARRAY_SIZE(pl_code_str))
 				code_desc = pl_code_str[sas_loginfo.dw.code];
 			break;
 		case 2:  /* IR */
 			if (sas_loginfo.dw.code >=
-			    sizeof(ir_code_str)/sizeof(char*))
+			    ARRAY_SIZE(ir_code_str))
 				break;
 			code_desc = ir_code_str[sas_loginfo.dw.code];
 			if (sas_loginfo.dw.subcode >=
-			    sizeof(raid_sub_code_str)/sizeof(char*))
+			    ARRAY_SIZE(raid_sub_code_str))
 			break;
 			if (sas_loginfo.dw.code == 0)
 				sub_code_desc =
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-char-agp-add-missing-pci_dev_get.patch
arch-arm-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-avr32-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-powerpc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-ia64-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-mtd-maps-nettelc-use-array_size.patch
net-tipc-bcasth-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
drivers-pci-hotplug-add-missing-pci_dev_get.patch
fs-namespacec-drop-code-after-return.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch

