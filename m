From: akpm@linux-foundation.org
Subject: + pcmcia-axnet_cs-make-functions-static.patch added to -mm tree
Date: Tue, 18 Dec 2007 15:52:46 -0800
Message-ID: <200712182352.lBINqkQ9028296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42186 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216AbXLRXx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 18:53:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se, alan@redhat.com


The patch titled
     pcmcia/axnet_cs: make functions static
has been added to the -mm tree.  Its filename is
     pcmcia-axnet_cs-make-functions-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pcmcia/axnet_cs: make functions static
From: Richard Knutsson <ricknu-0@student.ltu.se>

Fixing:
  CHECK   drivers/net/pcmcia/axnet_cs.c
drivers/net/pcmcia/axnet_cs.c:994:5: warning: symbol 'ax_close' was not declared. Should it be static?
drivers/net/pcmcia/axnet_cs.c:1017:6: warning: symbol 'ei_tx_timeout' was not declared. Should it be static?

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/pcmcia/axnet_cs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/pcmcia/axnet_cs.c~pcmcia-axnet_cs-make-functions-static drivers/net/pcmcia/axnet_cs.c
--- a/drivers/net/pcmcia/axnet_cs.c~pcmcia-axnet_cs-make-functions-static
+++ a/drivers/net/pcmcia/axnet_cs.c
@@ -991,7 +991,7 @@ static int ax_open(struct net_device *de
  *
  * Opposite of ax_open(). Only used when "ifconfig <devname> down" is done.
  */
-int ax_close(struct net_device *dev)
+static int ax_close(struct net_device *dev)
 {
 	unsigned long flags;
 
@@ -1014,7 +1014,7 @@ int ax_close(struct net_device *dev)
  * completed (or failed) - i.e. never posted a Tx related interrupt.
  */
 
-void ei_tx_timeout(struct net_device *dev)
+static void ei_tx_timeout(struct net_device *dev)
 {
 	long e8390_base = dev->base_addr;
 	struct ei_device *ei_local = (struct ei_device *) netdev_priv(dev);
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

origin.patch
kernel-compliment-va_copy-with-va_end.patch
git-dvb.patch
pcmcia-3c574_cs-fix-dubious-bitfield-warning.patch
pcmcia-3c574_cs-fix-shadow-variable-warning.patch
pcmcia-axnet_cs-make-functions-static.patch
pcmcia-axnet_cs-make-use-of-max-instead-of-handcrafted-one.patch
pcmcia-fmvj18x_cs-fix-shadow-variable-warning.patch
pcmcia-pcnet_cs-fix-shadow-variable-warning.patch
mm-mmap-remove-sparse-warning-null-as-0.patch
dio-array_size-cleanup-update.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
reiserfs-complement-va_start-with-va_end.patch
kernel-paramsc-remove-sparse-warning-different-signedness.patch
