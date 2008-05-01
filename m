From: akpm@linux-foundation.org
Subject: + fix-irq-flags-for-iuu_phoenixc.patch added to -mm tree
Date: Thu, 01 May 2008 15:58:24 -0700
Message-ID: <200805012258.m41MwOV6029848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754704AbYEAW6q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 18:58:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, greg@kroah.com, srostedt@redhat.com


The patch titled
     fix irq flags for iuu_phoenix.c
has been added to the -mm tree.  Its filename is
     fix-irq-flags-for-iuu_phoenixc.patch

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
Subject: fix irq flags for iuu_phoenix.c
From: Steven Rostedt <rostedt@goodmis.org>

The file drivers/usb/serial/iuu_phoenix.c uses "int" for flags.  This can
cause hard to find bugs on some architectures.  This patch converts the flags
to use "long" instead.

This bug was discovered by doing an allyesconfig make on the -rt kernel where
checks are done to ensure all flags are of size sizeof(long).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/iuu_phoenix.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/usb/serial/iuu_phoenix.c~fix-irq-flags-for-iuu_phoenixc drivers/usb/serial/iuu_phoenix.c
--- a/drivers/usb/serial/iuu_phoenix.c~fix-irq-flags-for-iuu_phoenixc
+++ a/drivers/usb/serial/iuu_phoenix.c
@@ -643,7 +643,7 @@ static void read_buf_callback(struct urb
 static int iuu_bulk_write(struct usb_serial_port *port)
 {
 	struct iuu_private *priv = usb_get_serial_port_data(port);
-	unsigned int flags;
+	unsigned long flags;
 	int result;
 	int i;
 	char *buf_ptr = port->write_urb->transfer_buffer;
@@ -694,7 +694,7 @@ static void iuu_uart_read_callback(struc
 {
 	struct usb_serial_port *port = urb->context;
 	struct iuu_private *priv = usb_get_serial_port_data(port);
-	unsigned int flags;
+	unsigned long flags;
 	int status;
 	int error = 0;
 	int len = 0;
@@ -759,7 +759,7 @@ static int iuu_uart_write(struct usb_ser
 			  int count)
 {
 	struct iuu_private *priv = usb_get_serial_port_data(port);
-	unsigned int flags;
+	unsigned long flags;
 	dbg("%s - enter", __func__);
 
 	if (count > 256)
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
9p-use-correct-type-for-processor-flags.patch
fix-irq-flags-in-mac80211-code.patch
fix-irq-flags-in-saa7134.patch
fix-irq-flags-in-rtc-ds1511.patch
fix-irq-flags-for-iuu_phoenixc.patch
git-sched.patch

