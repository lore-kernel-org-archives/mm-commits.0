From: akpm@linux-foundation.org
Subject: + hisax_fcpcipnp-move-request_irq-later-in-probe.patch added to -mm tree
Date: Sun, 02 Mar 2008 23:28:05 -0800
Message-ID: <200803030728.m237S5pJ004569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756045AbYCCH2w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 02:28:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyle@mcmartin.ca, kkeil@suse.de, kmcmartin@redhat.com


The patch titled
     hisax_fcpcipnp: move request_irq later in probe
has been added to the -mm tree.  Its filename is
     hisax_fcpcipnp-move-request_irq-later-in-probe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hisax_fcpcipnp: move request_irq later in probe
From: Kyle McMartin <kyle@mcmartin.ca>

After a quick glance at the code, we're getting the DEBUG_SHIRQ spurious
interrupt before we have the adapter template filled in.  Real interrupts
appear to be turned on by fcpci*_init(), so move request_irq until just before
that.

Signed-off-by: Kyle McMartin <kmcmartin@redhat.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/hisax_fcpcipnp.c |   34 +++++++++++++-------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN drivers/isdn/hisax/hisax_fcpcipnp.c~hisax_fcpcipnp-move-request_irq-later-in-probe drivers/isdn/hisax/hisax_fcpcipnp.c
--- a/drivers/isdn/hisax/hisax_fcpcipnp.c~hisax_fcpcipnp-move-request_irq-later-in-probe
+++ a/drivers/isdn/hisax/hisax_fcpcipnp.c
@@ -725,23 +725,6 @@ static int __devinit fcpcipnp_setup(stru
 
 	switch (adapter->type) {
 	case AVM_FRITZ_PCIV2:
-		retval = request_irq(adapter->irq, fcpci2_irq, IRQF_SHARED,
-				     "fcpcipnp", adapter);
-		break;
-	case AVM_FRITZ_PCI:
-		retval = request_irq(adapter->irq, fcpci_irq, IRQF_SHARED,
-				     "fcpcipnp", adapter);
-		break;
-	case AVM_FRITZ_PNP:
-		retval = request_irq(adapter->irq, fcpci_irq, 0,
-				     "fcpcipnp", adapter);
-		break;
-	}
-	if (retval)
-		goto err_region;
-
-	switch (adapter->type) {
-	case AVM_FRITZ_PCIV2:
 	case AVM_FRITZ_PCI:
 		val = inl(adapter->io);
 		break;
@@ -796,6 +779,23 @@ static int __devinit fcpcipnp_setup(stru
 
 	switch (adapter->type) {
 	case AVM_FRITZ_PCIV2:
+		retval = request_irq(adapter->irq, fcpci2_irq, IRQF_SHARED,
+				     "fcpcipnp", adapter);
+		break;
+	case AVM_FRITZ_PCI:
+		retval = request_irq(adapter->irq, fcpci_irq, IRQF_SHARED,
+				     "fcpcipnp", adapter);
+		break;
+	case AVM_FRITZ_PNP:
+		retval = request_irq(adapter->irq, fcpci_irq, 0,
+				     "fcpcipnp", adapter);
+		break;
+	}
+	if (retval)
+		goto err_region;
+
+	switch (adapter->type) {
+	case AVM_FRITZ_PCIV2:
 		fcpci2_init(adapter);
 		isacsx_setup(&adapter->isac);
 		break;
_

Patches currently in -mm which might be from kyle@mcmartin.ca are

git-drm.patch
parisc-new-termios-definitions.patch
hisax_fcpcipnp-move-request_irq-later-in-probe.patch
taint-kernel-after-warn_oncondition.patch
asm-futexh-should-include-linux-uaccessh.patch

