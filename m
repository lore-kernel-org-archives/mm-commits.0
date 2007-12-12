From: akpm@linux-foundation.org
Subject: + pci-disable-decoding-during-sizing-of-bars.patch added to -mm tree
Date: Wed, 12 Dec 2007 00:13:00 -0800
Message-ID: <200712120813.lBC8D0V8000441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48690 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754252AbXLLINu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 03:13:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andreas.eckstein@gmx.net, ak@suse.de, dsd@gentoo.org, greg@kroah.com, marco@pianoinflames.de, mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org


The patch titled
     pci: disable decoding during sizing of BARs
has been added to the -mm tree.  Its filename is
     pci-disable-decoding-during-sizing-of-bars.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pci: disable decoding during sizing of BARs
From: Andreas Eckstein <andreas.eckstein@gmx.net>

Stolen from http://bugs.gentoo.org/show_bug.cgi?id=198810

Fixes Marco's boot problem, described thusly:

  I first got acpi failure on boot, pci=nommconf worked first time, than I
  patched with q35.pci.patch from
  http://bugs.gentoo.org/show_bug.cgi?id=198810 and boot worked without
  nommconf.

  (See http://lkml.org/lkml/2007/12/4/336)

Linus sayeth

  It looks ok now that it doesn't do it for host controllers.  I guess we
  could just apply it.

Cc: Daniel Drake <dsd@gentoo.org>
Cc: Marco Gatti <marco@pianoinflames.de>
Cc: Greg KH <greg@kroah.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN drivers/pci/probe.c~pci-disable-decoding-during-sizing-of-bars drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-disable-decoding-during-sizing-of-bars
+++ a/drivers/pci/probe.c
@@ -181,11 +181,26 @@ static inline int is_64bit_memory(u32 ma
 	return 0;
 }
 
+/*
+ * Sizing PCI BARs requires us to disable decoding, otherwise we may run
+ * into conflicts with other devices while trying to size the BAR.  Normally
+ * this isn't a problem, but it happens on some machines normally, and can
+ * happen on others during PCI device hotplug.  Don't disable BARs for host
+ * bridges, though.  Some of them do silly things like disable accesses to
+ * RAM from the CPU
+ */
 static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 {
 	unsigned int pos, reg, next;
 	u32 l, sz;
 	struct resource *res;
+	u16 orig_cmd;
+
+	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_HOST) {
+		pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
+		pci_write_config_word(dev, PCI_COMMAND,
+			orig_cmd & ~(PCI_COMMAND_MEMORY | PCI_COMMAND_IO));
+	}
 
 	for(pos=0; pos<howmany; pos = next) {
 		u64 l64;
@@ -283,6 +298,9 @@ static void pci_read_bases(struct pci_de
 			}
 		}
 	}
+
+	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_HOST)
+		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
 }
 
 void pci_read_bridge_bases(struct pci_bus *child)
_

Patches currently in -mm which might be from andreas.eckstein@gmx.net are

pci-disable-decoding-during-sizing-of-bars.patch
