From: akpm@linux-foundation.org
Subject: [merged] ibft-fix-the-display-of-a-few-fields-in-the-nic-attribute-structure-in-sysfs.patch removed from -mm tree
Date: Mon, 04 May 2009 13:13:44 -0700
Message-ID: <200905042013.n44KDiWH022724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667AbZEDUP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 16:15:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ashutosh.naik@gmail.com, vishnu@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     ibft: fix the display of a few fields in the NIC attribute structure in sysfs
has been removed from the -mm tree.  Its filename was
     ibft-fix-the-display-of-a-few-fields-in-the-nic-attribute-structure-in-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibft: fix the display of a few fields in the NIC attribute structure in sysfs
From: Ashutosh Naik <ashutosh.naik@gmail.com>

Fix the display of a few fields in the iBFT NIC attribute structure in
sysfs.

Ensure that, if the DHCP IP address and the subnet mask for the interface
is present in the iBFT NIC structure, the corresponding entries are
created in sysfs tree for the device.  This would hence create the
additional entries in the tree based on the iBFT table and would not
delete any existing entries.

Signed-off-by: Ashutosh Naik <ashutosh.naik@gmail.com>
Cc: Vishnu V <vishnu@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/iscsi_ibft.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/firmware/iscsi_ibft.c~ibft-fix-the-display-of-a-few-fields-in-the-nic-attribute-structure-in-sysfs drivers/firmware/iscsi_ibft.c
--- a/drivers/firmware/iscsi_ibft.c~ibft-fix-the-display-of-a-few-fields-in-the-nic-attribute-structure-in-sysfs
+++ a/drivers/firmware/iscsi_ibft.c
@@ -754,11 +754,11 @@ static int __init ibft_check_nic_for(str
 		rc = 1;
 		break;
 	case ibft_eth_ip_addr:
-		if (!memcmp(nic->dhcp, nulls, sizeof(nic->dhcp)))
+		if (memcmp(nic->ip_addr, nulls, sizeof(nic->ip_addr)))
 			rc = 1;
 		break;
 	case ibft_eth_subnet_mask:
-		if (!memcmp(nic->dhcp, nulls, sizeof(nic->dhcp)))
+		if (nic->subnet_mask_prefix)
 			rc = 1;
 		break;
 	case ibft_eth_origin:
_

Patches currently in -mm which might be from ashutosh.naik@gmail.com are

origin.patch

