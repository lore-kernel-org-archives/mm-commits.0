From: akpm@linux-foundation.org
Subject: - pcmcia-annotate-cb_alloc-with-__ref.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:39 -0700
Message-ID: <200805021942.m42JgdF9011209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932211AbYEBTmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     pcmcia: annotate cb_alloc with __ref
has been removed from the -mm tree.  Its filename was
     pcmcia-annotate-cb_alloc-with-__ref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia: annotate cb_alloc with __ref
From: Sam Ravnborg <sam@ravnborg.org>

cb_alloc() uses a function (pci_scan_slot) that will be annotated __devinit.

Annotate cb_alloc() with __ref to tell modpost to ignore this reference.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/cardbus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pcmcia/cardbus.c~pcmcia-annotate-cb_alloc-with-__ref drivers/pcmcia/cardbus.c
--- a/drivers/pcmcia/cardbus.c~pcmcia-annotate-cb_alloc-with-__ref
+++ a/drivers/pcmcia/cardbus.c
@@ -209,7 +209,7 @@ static void cardbus_assign_irqs(struct p
 	}
 }
 
-int cb_alloc(struct pcmcia_socket * s)
+int __ref cb_alloc(struct pcmcia_socket * s)
 {
 	struct pci_bus *bus = s->cb_dev->subordinate;
 	struct pci_dev *dev;
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
git-pci-current.patch
git-sh.patch
git-scsi-misc.patch
git-watchdog.patch
documentation-build-source-files-in-documentation-sub-dir.patch

