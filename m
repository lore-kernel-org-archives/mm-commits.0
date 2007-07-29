From: akpm@linux-foundation.org
Subject: + uml-console-should-handle-spurious-irqs.patch added to -mm tree
Date: Sat, 28 Jul 2007 23:56:09 -0700
Message-ID: <200707290656.l6T6u9dA012560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36070 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759823AbXG2G4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:56:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     UML: console should handle spurious IRQS
has been added to the -mm tree.  Its filename is
     uml-console-should-handle-spurious-irqs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: UML: console should handle spurious IRQS
From: Jeff Dike <jdike@addtoit.com>

The previous DEBUG_SHIRQ patch missed one case.  The console doesn't
set its host descriptors non-blocking.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_kern.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN arch/um/drivers/chan_kern.c~uml-console-should-handle-spurious-irqs arch/um/drivers/chan_kern.c
--- a/arch/um/drivers/chan_kern.c~uml-console-should-handle-spurious-irqs
+++ a/arch/um/drivers/chan_kern.c
@@ -157,7 +157,7 @@ static void tty_receive_char(struct tty_
 
 static int open_one_chan(struct chan *chan)
 {
-	int fd;
+	int fd, err;
 
 	if(chan->opened)
 		return 0;
@@ -168,6 +168,13 @@ static int open_one_chan(struct chan *ch
 				     chan->data, &chan->dev);
 	if(fd < 0)
 		return fd;
+
+	err = os_set_fd_block(fd, 0);
+	if (err) {
+		(*chan->ops->close)(fd, chan->data);
+		return err;
+	}
+
 	chan->fd = fd;
 
 	chan->opened = 1;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-console-should-handle-spurious-irqs.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
