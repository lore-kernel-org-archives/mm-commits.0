From: akpm@linux-foundation.org
Subject: - pci-disable-decoding-during-sizing-of-bars.patch removed from -mm tree
Date: Sat, 16 Feb 2008 14:05:38 -0800
Message-ID: <200802162205.m1GM5cMC011601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39645 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbYBPWNz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 16 Feb 2008 17:13:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@debian.org, ak@suse.de, andreas.eckstein@gmx.net, dsd@gentoo.org, greg@kroah.com, marco@pianoinflames.de, mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org, mm-co


The patch titled
     pci: disable decoding during sizing of BARs
has been removed from the -mm tree.  Its filename was
     pci-disable-decoding-during-sizing-of-bars.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: disable decoding during sizing of BARs

Cc: Matthew Wilcox <willy@debian.org>

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
Cc: Andreas Eckstein <andreas.eckstein@gmx.net>

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
@@ -284,6 +299,9 @@ static void pci_read_bases(struct pci_de
 			}
 		}
 	}
+
+	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_HOST)
+		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
 }
 
 void pci_read_bridge_bases(struct pci_bus *child)
_

Patches currently in -mm which might be from willy@debian.org are

parisc-new-termios-definitions.patch
pci-disable-decoding-during-sizing-of-bars.patch
