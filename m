From: akpm@linux-foundation.org
Subject: + rapidio-add-new-idt-srio-switches.patch added to -mm tree
Date: Fri, 10 Dec 2010 15:24:34 -0800
Message-ID: <201012102324.oBANOYBF009043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531Ab0LJXZD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Dec 2010 18:25:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: add new idt sRIO switches
has been added to the -mm tree.  Its filename is
     rapidio-add-new-idt-srio-switches.patch

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
Subject: rapidio: add new idt sRIO switches
From: Alexandre Bounine <alexandre.bounine@idt.com>

Add new sRIO switch device IDs and enable a basic support for them.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/switches/idt_gen2.c |    2 ++
 include/linux/rio_ids.h             |    2 ++
 2 files changed, 4 insertions(+)

diff -puN drivers/rapidio/switches/idt_gen2.c~rapidio-add-new-idt-srio-switches drivers/rapidio/switches/idt_gen2.c
--- a/drivers/rapidio/switches/idt_gen2.c~rapidio-add-new-idt-srio-switches
+++ a/drivers/rapidio/switches/idt_gen2.c
@@ -416,3 +416,5 @@ static int idtg2_switch_init(struct rio_
 
 DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTCPS1848, idtg2_switch_init);
 DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTCPS1616, idtg2_switch_init);
+DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTVPS1616, idtg2_switch_init);
+DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTSPS1616, idtg2_switch_init);
diff -puN include/linux/rio_ids.h~rapidio-add-new-idt-srio-switches include/linux/rio_ids.h
--- a/include/linux/rio_ids.h~rapidio-add-new-idt-srio-switches
+++ a/include/linux/rio_ids.h
@@ -36,5 +36,7 @@
 #define RIO_DID_IDTCPS10Q		0x035e
 #define RIO_DID_IDTCPS1848		0x0374
 #define RIO_DID_IDTCPS1616		0x0379
+#define RIO_DID_IDTVPS1616		0x0377
+#define RIO_DID_IDTSPS1616		0x0378
 
 #endif				/* LINUX_RIO_IDS_H */
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-use-common-destid-storage-for-endpoints-and-switches.patch
rapidio-integrate-rio_switch-into-rio_dev.patch
rapidio-add-definitions-of-component-tag-fields.patch
rapidio-add-device-object-linking-into-discovery.patch
rapidio-use-component-tag-for-unified-switch-identification.patch
rapidio-add-new-sysfs-attributes.patch
rapidio-add-new-idt-srio-switches.patch

