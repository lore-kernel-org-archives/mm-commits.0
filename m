From: akpm@linux-foundation.org
Subject: + ibft-fix-the-display-of-a-few-fields-in-the-nic-attribute-structure-in-sysfs.patch added to -mm tree
Date: Sat, 11 Apr 2009 11:44:41 -0700
Message-ID: <200904111844.n3BIifLN018177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754499AbZDKSqb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 11 Apr 2009 14:46:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ashutosh.naik@gmail.com, vishnu@chelsio.com


The patch titled
     ibft: fix the display of a few fields in the NIC attribute structure in sysfs
has been added to the -mm tree.  Its filename is
     ibft-fix-the-display-of-a-few-fields-in-the-nic-attribute-structure-in-sysfs.patch

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
Subject: ibft: fix the display of a few fields in the NIC attribute structure in sysfs
From: Ashutosh Naik <ashutosh.naik@gmail.com>

Fix the display of a few fields in the iBFT NIC attribute structure in
sysfs.

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

ibft-fix-the-display-of-a-few-fields-in-the-nic-attribute-structure-in-sysfs.patch

