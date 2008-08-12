From: akpm@linux-foundation.org
Subject: - usb-hso-minor-fixes-due-to-code-review.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:33:43 -0700
Message-ID: <200808122033.m7CKXhLI011815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750781AbYHLUeR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:34:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     USB: HSO: minor fixes due to code review
has been removed from the -mm tree.  Its filename was
     usb-hso-minor-fixes-due-to-code-review.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: USB: HSO: minor fixes due to code review
From: Greg Kroah-Hartman <gregkh@suse.de>

Fix up problems in hso.c driver as pointed out by Andrew.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/hso.c |   43 ++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff -puN drivers/net/usb/hso.c~usb-hso-minor-fixes-due-to-code-review drivers/net/usb/hso.c
--- a/drivers/net/usb/hso.c~usb-hso-minor-fixes-due-to-code-review
+++ a/drivers/net/usb/hso.c
@@ -102,8 +102,12 @@
 
 #define MAX_RX_URBS			2
 
-#define get_serial_by_tty(x)	\
-	(x ? (struct hso_serial *)x->driver_data : NULL)
+static inline struct hso_serial *get_serial_by_tty(struct tty_struct *tty)
+{
+	if (tty)
+		return tty->driver_data;
+	return NULL;
+}
 
 /*****************************************************************************/
 /* Debugging functions                                                       */
@@ -294,24 +298,25 @@ static int hso_get_activity(struct hso_d
 
 /* #define DEBUG */
 
-#define dev2net(x) (x->port_data.dev_net)
-#define dev2ser(x) (x->port_data.dev_serial)
+static inline struct hso_net *dev2net(struct hso_device *hso_dev)
+{
+	return hso_dev->port_data.dev_net;
+}
+
+static inline struct hso_serial *dev2ser(struct hso_device *hso_dev)
+{
+	return hso_dev->port_data.dev_serial;
+}
 
 /* Debugging functions */
 #ifdef DEBUG
 static void dbg_dump(int line_count, const char *func_name, unsigned char *buf,
 		     unsigned int len)
 {
-	u8 i = 0;
-
-	printk(KERN_DEBUG "[%d:%s]: len %d", line_count, func_name, len);
+	static char name[255];
 
-	for (i = 0; i < len; i++) {
-		if (!(i % 16))
-			printk("\n    0x%03x:  ", i);
-		printk("%02x ", (unsigned char)buf[i]);
-	}
-	printk("\n");
+	sprintf(name, "hso[%d:%s]", line_count, func_name);
+	print_hex_dump_bytes(name, DUMP_PREFIX_NONE, buf, len);
 }
 
 #define DUMP(buf_, len_)	\
@@ -528,13 +533,12 @@ static struct hso_serial *get_serial_by_
 
 static struct hso_serial *get_serial_by_index(unsigned index)
 {
-	struct hso_serial *serial;
+	struct hso_serial *serial = NULL;
 	unsigned long flags;
 
-	if (!serial_table[index])
-		return NULL;
 	spin_lock_irqsave(&serial_table_lock, flags);
-	serial = dev2ser(serial_table[index]);
+	if (serial_table[index])
+		serial = dev2ser(serial_table[index]);
 	spin_unlock_irqrestore(&serial_table_lock, flags);
 
 	return serial;
@@ -561,6 +565,7 @@ static int get_free_serial_index(void)
 static void set_serial_by_index(unsigned index, struct hso_serial *serial)
 {
 	unsigned long flags;
+
 	spin_lock_irqsave(&serial_table_lock, flags);
 	if (serial)
 		serial_table[index] = serial->parent;
@@ -569,7 +574,7 @@ static void set_serial_by_index(unsigned
 	spin_unlock_irqrestore(&serial_table_lock, flags);
 }
 
-/* log a meaningfull explanation of an USB status */
+/* log a meaningful explanation of an USB status */
 static void log_usb_status(int status, const char *function)
 {
 	char *explanation;
@@ -2654,7 +2659,7 @@ static void hso_free_interface(struct us
 			hso_stop_net_device(network_table[i]);
 			cancel_work_sync(&network_table[i]->async_put_intf);
 			cancel_work_sync(&network_table[i]->async_get_intf);
-			if(rfk)
+			if (rfk)
 				rfkill_unregister(rfk);
 			hso_free_net_device(network_table[i]);
 		}
_

Patches currently in -mm which might be from gregkh@suse.de are

origin.patch
linux-next.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch

