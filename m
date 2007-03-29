From: akpm@linux-foundation.org
Subject: - ata-ncq-is-broken-on-maxtor-6l250s0.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:42:59 -0700
Message-ID: <200703290742.l2T7gx1w030348@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46214 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965104AbXC2Hn1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:43:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rol@as2917.net, alan@redhat.com, edmudama@gmail.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ata: NCQ is broken on Maxtor 6L250S0
has been removed from the -mm tree.  Its filename was
     ata-ncq-is-broken-on-maxtor-6l250s0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ata: NCQ is broken on Maxtor 6L250S0
From: "Paul Rolland" <rol@as2917.net>

With this applied, my machine has stopped all those painful messages.
dmesg now says :

root@riri:/Kernels# dmesg | grep LBA
ata1.00: 490234752 sectors, multi 0: LBA48 NCQ (not used)
ata2.00: 640 sectors, multi 1: LBA 
ata3.00: 490234752 sectors, multi 0: LBA48 NCQ (not used)

Signed-off-by: Paul Rolland <rol@as2917.net>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/ata/libata-core.c~ata-ncq-is-broken-on-maxtor-6l250s0 drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~ata-ncq-is-broken-on-maxtor-6l250s0
+++ a/drivers/ata/libata-core.c
@@ -3483,6 +3483,8 @@ static const struct ata_blacklist_entry 
         { "WDC WD740ADFD-00",   NULL,		ATA_HORKAGE_NONCQ },
 	/* http://thread.gmane.org/gmane.linux.ide/14907 */
 	{ "FUJITSU MHT2060BH",	NULL,		ATA_HORKAGE_NONCQ },
+	/* NCQ is broken */
+	{ "Maxtor 6L250S0",     "BANC1G10",     ATA_HORKAGE_NONCQ },
 
 	/* Devices with NCQ limits */
 
_

Patches currently in -mm which might be from rol@as2917.net are

origin.patch
