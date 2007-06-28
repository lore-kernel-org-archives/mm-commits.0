From: akpm@linux-foundation.org
Subject: + 3csoho100-tx-needs-extra_preamble.patch added to -mm tree
Date: Thu, 28 Jun 2007 13:14:43 -0700
Message-ID: <200706282014.l5SKEhTS000703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44937 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760857AbXF1UPA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 16:15:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: klassert@mathematik.tu-chemnitz.de, bugs@niluje.net, jonassa@gmail.com


The patch titled
     3cSOHO100-TX needs EXTRA_PREAMBLE
has been added to the -mm tree.  Its filename is
     3csoho100-tx-needs-extra_preamble.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 3cSOHO100-TX needs EXTRA_PREAMBLE
From: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>

The 3cSOHO100-TX needs a mdio_sync() before mdio_read() to read the MII
transceiver registers properly.  Adding EXTRA_PREAMBLE to drv_flags of the
3cSOHO100-TX will force this.

This problem exists already for years (I checked back to 2.6.8).
Setting duplex for the 3cSOHO100-TX was more or less a random process.
Till 2.6.15 it was more likely that the diver ends up in half
duplex mode, after the code change in 2.6.16 it was more likely
to end up in full duplex mode. I wonder why nobody noticed this earier.

Hopefully addresses

Bug 7454 3c59x (3cSOHO100-TX Hurricane) slow network bug
http://bugzilla.kernel.org/show_bug.cgi?id=7454

and

Bug 3654 3cSOHO100-TX: No MII transceiver present
http://bugzilla.kernel.org/show_bug.cgi?id=3654

Cc: Jonas Sandberg <jonassa@gmail.com>
Cc: Jon Sanchez <bugs@niluje.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c59x.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/3c59x.c~3csoho100-tx-needs-extra_preamble drivers/net/3c59x.c
--- a/drivers/net/3c59x.c~3csoho100-tx-needs-extra_preamble
+++ a/drivers/net/3c59x.c
@@ -324,7 +324,7 @@ static struct vortex_chip_info {
 	{"3c980C Python-T",
 	 PCI_USES_MASTER, IS_CYCLONE|HAS_NWAY|HAS_HWCKSM, 128, },
 	{"3cSOHO100-TX Hurricane",
-	 PCI_USES_MASTER, IS_CYCLONE|HAS_NWAY|HAS_HWCKSM, 128, },
+	 PCI_USES_MASTER, IS_CYCLONE|HAS_NWAY|HAS_HWCKSM|EXTRA_PREAMBLE, 128, },
 	{"3c555 Laptop Hurricane",
 	 PCI_USES_MASTER, IS_CYCLONE|EEPROM_8BIT|HAS_HWCKSM, 128, },
 	{"3c556 Laptop Tornado",
_

Patches currently in -mm which might be from klassert@mathematik.tu-chemnitz.de are

3csoho100-tx-needs-extra_preamble.patch
