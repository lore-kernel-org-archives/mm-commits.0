From: akpm@linux-foundation.org
Subject: + rapidio-tsi721-fix-unused-variable-compiler-warning.patch added to -mm tree
Date: Mon, 20 Aug 2012 14:29:01 -0700
Message-ID: <20120820212902.67CD6100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-iy0-f202.google.com ([209.85.210.202]:34705 "EHLO
	mail-iy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab2HTV3D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 17:29:03 -0400
Received: by ialo24 with SMTP id o24so930431ial.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 14:29:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, mporter@kernel.crashing.org, stable@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: fix unused variable compiler warning
has been added to the -mm tree.  Its filename is
     rapidio-tsi721-fix-unused-variable-compiler-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: fix unused variable compiler warning

Fix unused variable compiler warning when built with CONFIG_RAPIDIO_DEBUG
option off.

This patch is applicable to kernel versions starting from v3.2

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-fix-unused-variable-compiler-warning drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-fix-unused-variable-compiler-warning
+++ a/drivers/rapidio/devices/tsi721.c
@@ -2219,7 +2219,7 @@ static int __devinit tsi721_probe(struct
 				  const struct pci_device_id *id)
 {
 	struct tsi721_device *priv;
-	int i, cap;
+	int cap;
 	int err;
 	u32 regval;
 
@@ -2239,12 +2239,15 @@ static int __devinit tsi721_probe(struct
 	priv->pdev = pdev;
 
 #ifdef DEBUG
+	{
+	int i;
 	for (i = 0; i <= PCI_STD_RESOURCE_END; i++) {
 		dev_dbg(&pdev->dev, "res[%d] @ 0x%llx (0x%lx, 0x%lx)\n",
 			i, (unsigned long long)pci_resource_start(pdev, i),
 			(unsigned long)pci_resource_len(pdev, i),
 			pci_resource_flags(pdev, i));
 	}
+	}
 #endif
 	/*
 	 * Verify BAR configuration
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-tsi721-fix-inbound-doorbell-interrupt-handling.patch
rapidio-tsi721-fix-unused-variable-compiler-warning.patch

