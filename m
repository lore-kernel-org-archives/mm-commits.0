From: akpm@linux-foundation.org
Subject: + ata-ncq-is-broken-on-maxtor-6l250s0.patch added to -mm tree
Date: Sun, 18 Mar 2007 00:25:46 -0800
Message-ID: <200703180825.l2I8PkhJ019277@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59734 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbXCRI0F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 04:26:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rol@as2917.net, alan@redhat.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     ata: NCQ is broken on Maxtor 6L250S0
has been added to the -mm tree.  Its filename is
     ata-ncq-is-broken-on-maxtor-6l250s0.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ata-ncq-is-broken-on-maxtor-6l250s0.patch
