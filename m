From: akpm@linux-foundation.org
Subject: - usb-remove-unnecessary-type-casting-of-urb-context.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:09:42 -0800
Message-ID: <200803042009.m24K9gii026781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763440AbYCDUJr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:09:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tom.leiming@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     USB: remove unnecessary type casting of urb->context
has been removed from the -mm tree.  Its filename was
     usb-remove-unnecessary-type-casting-of-urb-context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: USB: remove unnecessary type casting of urb->context
From: Ming Lei <tom.leiming@gmail.com>

urb->context code cleanup

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/atm/cxacru.c              |    2 -
 drivers/usb/class/cdc-acm.c           |    2 -
 drivers/usb/misc/auerswald.c          |   12 +++++-----
 drivers/usb/misc/ftdi-elan.c          |    2 -
 drivers/usb/misc/iowarrior.c          |    4 +--
 drivers/usb/misc/legousbtower.c       |    4 +--
 drivers/usb/misc/usblcd.c             |    2 -
 drivers/usb/misc/usbtest.c            |    4 +--
 drivers/usb/serial/belkin_sa.c        |    2 -
 drivers/usb/serial/cyberjack.c        |    6 ++---
 drivers/usb/serial/cypress_m8.c       |    4 +--
 drivers/usb/serial/digi_acceleport.c  |    8 +++---
 drivers/usb/serial/empeg.c            |    2 -
 drivers/usb/serial/ftdi_sio.c         |    4 +--
 drivers/usb/serial/garmin_gps.c       |    6 ++---
 drivers/usb/serial/generic.c          |    4 +--
 drivers/usb/serial/io_edgeport.c      |    8 +++---
 drivers/usb/serial/io_ti.c            |    6 ++---
 drivers/usb/serial/ipaq.c             |    4 +--
 drivers/usb/serial/ir-usb.c           |    4 +--
 drivers/usb/serial/iuu_phoenix.c      |   16 ++++++-------
 drivers/usb/serial/keyspan.c          |   28 ++++++++++++------------
 drivers/usb/serial/keyspan_pda.c      |    4 +--
 drivers/usb/serial/kl5kusb105.c       |    4 +--
 drivers/usb/serial/mct_u232.c         |    2 -
 drivers/usb/serial/mos7840.c          |    8 +++---
 drivers/usb/serial/omninet.c          |    4 +--
 drivers/usb/serial/option.c           |    6 ++---
 drivers/usb/serial/oti6858.c          |    6 ++---
 drivers/usb/serial/pl2303.c           |    6 ++---
 drivers/usb/serial/safe_serial.c      |    2 -
 drivers/usb/serial/sierra.c           |    4 +--
 drivers/usb/serial/ti_usb_3410_5052.c |    6 ++---
 drivers/usb/serial/visor.c            |    6 ++---
 drivers/usb/serial/whiteheat.c        |    6 ++---
 drivers/usb/storage/transport.c       |    2 -
 drivers/usb/usb-skeleton.c            |    2 -
 37 files changed, 101 insertions(+), 101 deletions(-)

diff -puN drivers/usb/atm/cxacru.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/atm/cxacru.c
--- a/drivers/usb/atm/cxacru.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/atm/cxacru.c
@@ -444,7 +444,7 @@ CXACRU_ALL_FILES(INIT);
 /* the following three functions are stolen from drivers/usb/core/message.c */
 static void cxacru_blocking_completion(struct urb *urb)
 {
-	complete((struct completion *)urb->context);
+	complete(urb->context);
 }
 
 static void cxacru_timeout_kill(unsigned long data)
diff -puN drivers/usb/class/cdc-acm.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/class/cdc-acm.c
--- a/drivers/usb/class/cdc-acm.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/class/cdc-acm.c
@@ -450,7 +450,7 @@ urbs:
 /* data interface wrote those outgoing bytes */
 static void acm_write_bulk(struct urb *urb)
 {
-	struct acm *acm = (struct acm *)urb->context;
+	struct acm *acm = urb->context;
 
 	dbg("Entering acm_write_bulk with status %d", urb->status);
 
diff -puN drivers/usb/misc/auerswald.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/misc/auerswald.c
--- a/drivers/usb/misc/auerswald.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/misc/auerswald.c
@@ -284,7 +284,7 @@ static void auerchain_complete (struct u
         int result;
 
         /* get pointer to element and to chain */
-        pauerchainelement_t acep = (pauerchainelement_t) urb->context;
+        pauerchainelement_t acep =  urb->context;
         pauerchain_t         acp = acep->chain;
 
         /* restore original entries in urb */
@@ -594,7 +594,7 @@ ac_fail:/* free the elements */
 /* completion handler for synchronous chained URBs */
 static void auerchain_blocking_completion (struct urb *urb)
 {
-	pauerchain_chs_t pchs = (pauerchain_chs_t)urb->context;
+	pauerchain_chs_t pchs = urb->context;
 	pchs->done = 1;
 	wmb();
 	wake_up (&pchs->wqh);
@@ -847,7 +847,7 @@ static int auerswald_status_retry (int s
 /* Completion of asynchronous write block */
 static void auerchar_ctrlwrite_complete (struct urb * urb)
 {
-	pauerbuf_t bp = (pauerbuf_t) urb->context;
+	pauerbuf_t bp =  urb->context;
 	pauerswald_t cp = ((pauerswald_t)((char *)(bp->list)-(unsigned long)(&((pauerswald_t)0)->bufctl)));
 	dbg ("auerchar_ctrlwrite_complete called");
 
@@ -860,7 +860,7 @@ static void auerchar_ctrlwrite_complete 
 /* Completion handler for dummy retry packet */
 static void auerswald_ctrlread_wretcomplete (struct urb * urb)
 {
-        pauerbuf_t bp = (pauerbuf_t) urb->context;
+        pauerbuf_t bp =  urb->context;
         pauerswald_t cp;
 	int ret;
 	int status = urb->status;
@@ -904,7 +904,7 @@ static void auerswald_ctrlread_complete 
         unsigned int  serviceid;
         pauerswald_t  cp;
         pauerscon_t   scp;
-        pauerbuf_t    bp  = (pauerbuf_t) urb->context;
+        pauerbuf_t    bp  =  urb->context;
 	int status = urb->status;
 	int ret;
 
@@ -981,7 +981,7 @@ static void auerswald_int_complete (stru
         int ret;
 	int status = urb->status;
         pauerbuf_t   bp = NULL;
-        pauerswald_t cp = (pauerswald_t) urb->context;
+        pauerswald_t cp =  urb->context;
 
         dbg ("%s called", __FUNCTION__);
 
diff -puN drivers/usb/misc/ftdi-elan.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/misc/ftdi-elan.c
--- a/drivers/usb/misc/ftdi-elan.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/misc/ftdi-elan.c
@@ -746,7 +746,7 @@ static ssize_t ftdi_elan_read(struct fil
 
 static void ftdi_elan_write_bulk_callback(struct urb *urb)
 {
-        struct usb_ftdi *ftdi = (struct usb_ftdi *)urb->context;
+        struct usb_ftdi *ftdi = urb->context;
 	int status = urb->status;
 
 	if (status && !(status == -ENOENT || status == -ECONNRESET ||
diff -puN drivers/usb/misc/iowarrior.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/misc/iowarrior.c
--- a/drivers/usb/misc/iowarrior.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/misc/iowarrior.c
@@ -154,7 +154,7 @@ MODULE_DEVICE_TABLE(usb, iowarrior_ids);
  */
 static void iowarrior_callback(struct urb *urb)
 {
-	struct iowarrior *dev = (struct iowarrior *)urb->context;
+	struct iowarrior *dev = urb->context;
 	int intr_idx;
 	int read_idx;
 	int aux_idx;
@@ -230,7 +230,7 @@ static void iowarrior_write_callback(str
 	struct iowarrior *dev;
 	int status = urb->status;
 
-	dev = (struct iowarrior *)urb->context;
+	dev = urb->context;
 	/* sync/async unlink faults aren't errors */
 	if (status &&
 	    !(status == -ENOENT ||
diff -puN drivers/usb/misc/legousbtower.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/misc/legousbtower.c
--- a/drivers/usb/misc/legousbtower.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/misc/legousbtower.c
@@ -753,7 +753,7 @@ exit:
  */
 static void tower_interrupt_in_callback (struct urb *urb)
 {
-	struct lego_usb_tower *dev = (struct lego_usb_tower *)urb->context;
+	struct lego_usb_tower *dev = urb->context;
 	int status = urb->status;
 	int retval;
 
@@ -810,7 +810,7 @@ exit:
  */
 static void tower_interrupt_out_callback (struct urb *urb)
 {
-	struct lego_usb_tower *dev = (struct lego_usb_tower *)urb->context;
+	struct lego_usb_tower *dev = urb->context;
 	int status = urb->status;
 
 	dbg(4, "%s: enter, status %d", __FUNCTION__, status);
diff -puN drivers/usb/misc/usblcd.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/misc/usblcd.c
--- a/drivers/usb/misc/usblcd.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/misc/usblcd.c
@@ -185,7 +185,7 @@ static void lcd_write_bulk_callback(stru
 	struct usb_lcd *dev;
 	int status = urb->status;
 
-	dev = (struct usb_lcd *)urb->context;
+	dev = urb->context;
 
 	/* sync/async unlink faults aren't errors */
 	if (status &&
diff -puN drivers/usb/misc/usbtest.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/misc/usbtest.c
--- a/drivers/usb/misc/usbtest.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/misc/usbtest.c
@@ -201,7 +201,7 @@ found:
 
 static void simple_callback (struct urb *urb)
 {
-	complete ((struct completion *) urb->context);
+	complete (urb->context);
 }
 
 static struct urb *simple_alloc_urb (
@@ -1045,7 +1045,7 @@ static void unlink1_callback (struct urb
 		status = usb_submit_urb (urb, GFP_ATOMIC);
 	if (status) {
 		urb->status = status;
-		complete ((struct completion *) urb->context);
+		complete (urb->context);
 	}
 }
 
diff -puN drivers/usb/serial/belkin_sa.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/belkin_sa.c
--- a/drivers/usb/serial/belkin_sa.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/belkin_sa.c
@@ -251,7 +251,7 @@ static void belkin_sa_close (struct usb_
 
 static void belkin_sa_read_int_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct belkin_sa_private *priv;
 	unsigned char *data = urb->transfer_buffer;
 	int retval;
diff -puN drivers/usb/serial/cyberjack.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/cyberjack.c
--- a/drivers/usb/serial/cyberjack.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/cyberjack.c
@@ -302,7 +302,7 @@ static int cyberjack_write_room( struct 
 
 static void cyberjack_read_int_callback( struct urb *urb )
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct cyberjack_private *priv = usb_get_serial_port_data(port);
 	unsigned char *data = urb->transfer_buffer;
 	int status = urb->status;
@@ -359,7 +359,7 @@ resubmit:
 
 static void cyberjack_read_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct cyberjack_private *priv = usb_get_serial_port_data(port);
 	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
@@ -411,7 +411,7 @@ static void cyberjack_read_bulk_callback
 
 static void cyberjack_write_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct cyberjack_private *priv = usb_get_serial_port_data(port);
 	int status = urb->status;
 
diff -puN drivers/usb/serial/cypress_m8.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/cypress_m8.c
--- a/drivers/usb/serial/cypress_m8.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/cypress_m8.c
@@ -1332,7 +1332,7 @@ static void cypress_unthrottle (struct u
 
 static void cypress_read_int_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
@@ -1484,7 +1484,7 @@ continue_read:
 
 static void cypress_write_int_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	int result;
 	int status = urb->status;
diff -puN drivers/usb/serial/digi_acceleport.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/digi_acceleport.c
--- a/drivers/usb/serial/digi_acceleport.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/digi_acceleport.c
@@ -1233,7 +1233,7 @@ static int digi_write(struct usb_serial_
 static void digi_write_bulk_callback(struct urb *urb)
 {
 
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct usb_serial *serial;
 	struct digi_port *priv;
 	struct digi_serial *serial_priv;
@@ -1611,7 +1611,7 @@ static void digi_shutdown(struct usb_ser
 
 static void digi_read_bulk_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct digi_port *priv;
 	struct digi_serial *serial_priv;
 	int ret;
@@ -1670,7 +1670,7 @@ static void digi_read_bulk_callback(stru
 static int digi_read_inb_callback(struct urb *urb)
 {
 
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct tty_struct *tty = port->tty;
 	struct digi_port *priv = usb_get_serial_port_data(port);
 	int opcode = ((unsigned char *)urb->transfer_buffer)[0];
@@ -1760,7 +1760,7 @@ static int digi_read_inb_callback(struct
 static int digi_read_oob_callback(struct urb *urb)
 {
 
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct usb_serial *serial = port->serial;
 	struct digi_port *priv = usb_get_serial_port_data(port);
 	int opcode, line, status, val;
diff -puN drivers/usb/serial/empeg.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/empeg.c
--- a/drivers/usb/serial/empeg.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/empeg.c
@@ -343,7 +343,7 @@ static void empeg_write_bulk_callback (s
 
 static void empeg_read_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	int result;
diff -puN drivers/usb/serial/ftdi_sio.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -1354,7 +1354,7 @@ error_no_buffer:
 static void ftdi_write_bulk_callback (struct urb *urb)
 {
 	unsigned long flags;
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct ftdi_private *priv;
 	int data_offset;       /* will be 1 for the SIO and 0 otherwise */
 	unsigned long countback;
@@ -1437,7 +1437,7 @@ static int ftdi_chars_in_buffer (struct 
 
 static void ftdi_read_bulk_callback (struct urb *urb)
 { /* ftdi_read_bulk_callback */
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct tty_struct *tty;
 	struct ftdi_private *priv;
 	unsigned long countread;
diff -puN drivers/usb/serial/garmin_gps.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/garmin_gps.c
--- a/drivers/usb/serial/garmin_gps.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/garmin_gps.c
@@ -1046,7 +1046,7 @@ static void garmin_close (struct usb_ser
 static void garmin_write_bulk_callback (struct urb *urb)
 {
 	unsigned long flags;
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int status = urb->status;
 
 	if (port) {
@@ -1286,7 +1286,7 @@ static void garmin_read_process(struct g
 static void garmin_read_bulk_callback (struct urb *urb)
 {
 	unsigned long flags;
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct usb_serial *serial =  port->serial;
 	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
 	unsigned char *data = urb->transfer_buffer;
@@ -1344,7 +1344,7 @@ static void garmin_read_int_callback (st
 {
 	unsigned long flags;
 	int retval;
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct usb_serial *serial = port->serial;
 	struct garmin_data * garmin_data_p = usb_get_serial_port_data(port);
 	unsigned char *data = urb->transfer_buffer;
diff -puN drivers/usb/serial/generic.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/generic.c
--- a/drivers/usb/serial/generic.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/generic.c
@@ -332,7 +332,7 @@ static void flush_and_resubmit_read_urb 
 
 void usb_serial_generic_read_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	int status = urb->status;
 	unsigned long flags;
@@ -358,7 +358,7 @@ EXPORT_SYMBOL_GPL(usb_serial_generic_rea
 
 void usb_serial_generic_write_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int status = urb->status;
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
diff -puN drivers/usb/serial/io_edgeport.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/io_edgeport.c
--- a/drivers/usb/serial/io_edgeport.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/io_edgeport.c
@@ -589,7 +589,7 @@ static int get_epic_descriptor(struct ed
  *****************************************************************************/
 static void edge_interrupt_callback (struct urb *urb)
 {
-	struct edgeport_serial	*edge_serial = (struct edgeport_serial *)urb->context;
+	struct edgeport_serial	*edge_serial = urb->context;
 	struct edgeport_port *edge_port;
 	struct usb_serial_port *port;
 	unsigned char *data = urb->transfer_buffer;
@@ -689,7 +689,7 @@ exit:
  *****************************************************************************/
 static void edge_bulk_in_callback (struct urb *urb)
 {
-	struct edgeport_serial	*edge_serial = (struct edgeport_serial *)urb->context;
+	struct edgeport_serial	*edge_serial = urb->context;
 	unsigned char		*data = urb->transfer_buffer;
 	int			retval;
 	__u16			raw_data_length;
@@ -749,7 +749,7 @@ static void edge_bulk_in_callback (struc
  *****************************************************************************/
 static void edge_bulk_out_data_callback (struct urb *urb)
 {
-	struct edgeport_port *edge_port = (struct edgeport_port *)urb->context;
+	struct edgeport_port *edge_port = urb->context;
 	struct tty_struct *tty;
 	int status = urb->status;
 
@@ -782,7 +782,7 @@ static void edge_bulk_out_data_callback 
  *****************************************************************************/
 static void edge_bulk_out_cmd_callback (struct urb *urb)
 {
-	struct edgeport_port *edge_port = (struct edgeport_port *)urb->context;
+	struct edgeport_port *edge_port = urb->context;
 	struct tty_struct *tty;
 	int status = urb->status;
 
diff -puN drivers/usb/serial/io_ti.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/io_ti.c
--- a/drivers/usb/serial/io_ti.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/io_ti.c
@@ -1711,7 +1711,7 @@ static void handle_new_lsr (struct edgep
 
 static void edge_interrupt_callback (struct urb *urb)
 {
-	struct edgeport_serial *edge_serial = (struct edgeport_serial *)urb->context;
+	struct edgeport_serial *edge_serial = urb->context;
 	struct usb_serial_port *port;
 	struct edgeport_port *edge_port;
 	unsigned char *data = urb->transfer_buffer;
@@ -1804,7 +1804,7 @@ exit:
 
 static void edge_bulk_in_callback (struct urb *urb)
 {
-	struct edgeport_port *edge_port = (struct edgeport_port *)urb->context;
+	struct edgeport_port *edge_port = urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	struct tty_struct *tty;
 	int retval = 0;
@@ -1898,7 +1898,7 @@ static void edge_tty_recv(struct device 
 
 static void edge_bulk_out_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	int status = urb->status;
 
diff -puN drivers/usb/serial/ipaq.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/ipaq.c
--- a/drivers/usb/serial/ipaq.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/ipaq.c
@@ -732,7 +732,7 @@ static void ipaq_close(struct usb_serial
 
 static void ipaq_read_bulk_callback(struct urb *urb)
 {
-	struct usb_serial_port	*port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port	*port = urb->context;
 	struct tty_struct	*tty;
 	unsigned char		*data = urb->transfer_buffer;
 	int			result;
@@ -872,7 +872,7 @@ static void ipaq_write_gather(struct usb
 
 static void ipaq_write_bulk_callback(struct urb *urb)
 {
-	struct usb_serial_port	*port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port	*port = urb->context;
 	struct ipaq_private	*priv = usb_get_serial_port_data(port);
 	unsigned long		flags;
 	int			result;
diff -puN drivers/usb/serial/ir-usb.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/ir-usb.c
--- a/drivers/usb/serial/ir-usb.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/ir-usb.c
@@ -396,7 +396,7 @@ static int ir_write (struct usb_serial_p
 
 static void ir_write_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int status = urb->status;
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
@@ -420,7 +420,7 @@ static void ir_write_bulk_callback (stru
 
 static void ir_read_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	int result;
diff -puN drivers/usb/serial/iuu_phoenix.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/iuu_phoenix.c
--- a/drivers/usb/serial/iuu_phoenix.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/iuu_phoenix.c
@@ -186,7 +186,7 @@ static int iuu_tiocmget(struct usb_seria
 
 static void iuu_rxcmd(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int result;
 	dbg("%s - enter", __FUNCTION__);
 
@@ -240,7 +240,7 @@ static int iuu_reset(struct usb_serial_p
  */
 static void iuu_update_status_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct iuu_private *priv = usb_get_serial_port_data(port);
 	u8 *st;
 	dbg("%s - enter", __FUNCTION__);
@@ -270,7 +270,7 @@ static void iuu_update_status_callback(s
 
 static void iuu_status_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int result;
 	dbg("%s - enter", __FUNCTION__);
 
@@ -392,7 +392,7 @@ static void iuu_rgbf_fill_buffer(u8 *buf
 
 static void iuu_led_activity_on(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int result;
 	char *buf_ptr = port->write_urb->transfer_buffer;
 	*buf_ptr++ = IUU_SET_LED;
@@ -413,7 +413,7 @@ static void iuu_led_activity_on(struct u
 
 static void iuu_led_activity_off(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int result;
 	char *buf_ptr = port->write_urb->transfer_buffer;
 	if (xmas == 1) {
@@ -616,7 +616,7 @@ static int iuu_uart_flush(struct usb_ser
 
 static void read_buf_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	struct tty_struct *tty;
 	dbg("%s - urb->status = %d", __FUNCTION__, urb->status);
@@ -692,7 +692,7 @@ static int iuu_read_buf(struct usb_seria
 
 static void iuu_uart_read_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct iuu_private *priv = usb_get_serial_port_data(port);
 	unsigned int flags;
 	int status;
@@ -781,7 +781,7 @@ static int iuu_uart_write(struct usb_ser
 
 static void read_rxcmd_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int result;
 	dbg("%s - enter", __FUNCTION__);
 
diff -puN drivers/usb/serial/keyspan.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/keyspan.c
--- a/drivers/usb/serial/keyspan.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/keyspan.c
@@ -445,7 +445,7 @@ static void	usa26_indat_callback(struct 
 		return;
 	}
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 	tty = port->tty;
 	if (tty && urb->actual_length) {
 		/* 0x80 bit is error flag */
@@ -490,7 +490,7 @@ static void	usa2x_outdat_callback(struct
 	struct usb_serial_port *port;
 	struct keyspan_port_private *p_priv;
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 	p_priv = usb_get_serial_port_data(port);
 	dbg ("%s - urb %d", __FUNCTION__, urb == p_priv->out_urbs[1]); 
 
@@ -509,7 +509,7 @@ static void	usa26_outcont_callback(struc
 	struct usb_serial_port *port;
 	struct keyspan_port_private *p_priv;
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 	p_priv = usb_get_serial_port_data(port);
 
 	if (p_priv->resend_cont) {
@@ -528,7 +528,7 @@ static void	usa26_instat_callback(struct
 	int old_dcd_state, err;
 	int status = urb->status;
 
-	serial = (struct usb_serial *) urb->context;
+	serial =  urb->context;
 
 	if (status) {
 		dbg("%s - nonzero status: %x", __FUNCTION__, status);
@@ -599,7 +599,7 @@ static void usa28_indat_callback(struct 
 
 	dbg ("%s", __FUNCTION__);
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 	p_priv = usb_get_serial_port_data(port);
 	data = urb->transfer_buffer;
 
@@ -613,7 +613,7 @@ static void usa28_indat_callback(struct 
 			return;
 		}
 
-		port = (struct usb_serial_port *) urb->context;
+		port =  urb->context;
 		p_priv = usb_get_serial_port_data(port);
 		data = urb->transfer_buffer;
 
@@ -647,7 +647,7 @@ static void	usa28_outcont_callback(struc
 	struct usb_serial_port *port;
 	struct keyspan_port_private *p_priv;
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 	p_priv = usb_get_serial_port_data(port);
 
 	if (p_priv->resend_cont) {
@@ -667,7 +667,7 @@ static void	usa28_instat_callback(struct
 	int old_dcd_state;
 	int status = urb->status;
 
-	serial = (struct usb_serial *) urb->context;
+	serial =  urb->context;
 
 	if (status) {
 		dbg("%s - nonzero status: %x", __FUNCTION__, status);
@@ -733,7 +733,7 @@ static void	usa49_glocont_callback(struc
 
 	dbg ("%s", __FUNCTION__);
 
-	serial = (struct usb_serial *) urb->context;
+	serial =  urb->context;
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		p_priv = usb_get_serial_port_data(port);
@@ -761,7 +761,7 @@ static void	usa49_instat_callback(struct
 
 	dbg ("%s", __FUNCTION__);
 
-	serial = (struct usb_serial *) urb->context;
+	serial =  urb->context;
 
 	if (status) {
 		dbg("%s - nonzero status: %x", __FUNCTION__, status);
@@ -836,7 +836,7 @@ static void	usa49_indat_callback(struct 
 		return;
 	}
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 	tty = port->tty;
 	if (tty && urb->actual_length) {
 		/* 0x80 bit is error flag */
@@ -973,7 +973,7 @@ static void usa90_indat_callback(struct 
 		return;
 	}
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 	p_priv = usb_get_serial_port_data(port);
 
 	tty = port->tty;
@@ -1037,7 +1037,7 @@ static void	usa90_instat_callback(struct
 	int old_dcd_state, err;
 	int status = urb->status;
 
-	serial = (struct usb_serial *) urb->context;
+	serial =  urb->context;
 
 	if (status) {
 		dbg("%s - nonzero status: %x", __FUNCTION__, status);
@@ -1084,7 +1084,7 @@ static void	usa90_outcont_callback(struc
 	struct usb_serial_port *port;
 	struct keyspan_port_private *p_priv;
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 	p_priv = usb_get_serial_port_data(port);
 
 	if (p_priv->resend_cont) {
diff -puN drivers/usb/serial/keyspan_pda.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/keyspan_pda.c
--- a/drivers/usb/serial/keyspan_pda.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/keyspan_pda.c
@@ -214,7 +214,7 @@ static void keyspan_pda_request_unthrott
 
 static void keyspan_pda_rx_interrupt (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
        	struct tty_struct *tty = port->tty;
 	unsigned char *data = urb->transfer_buffer;
 	int i;
@@ -608,7 +608,7 @@ exit:
 
 static void keyspan_pda_write_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct keyspan_pda_private *priv;
 
 	port->write_urb_busy = 0;
diff -puN drivers/usb/serial/kl5kusb105.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/kl5kusb105.c
--- a/drivers/usb/serial/kl5kusb105.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/kl5kusb105.c
@@ -570,7 +570,7 @@ exit:
 
 static void klsi_105_write_bulk_callback ( struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int status = urb->status;
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
@@ -631,7 +631,7 @@ static int klsi_105_write_room (struct u
 
 static void klsi_105_read_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct klsi_105_private *priv = usb_get_serial_port_data(port);
 	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
diff -puN drivers/usb/serial/mct_u232.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/mct_u232.c
--- a/drivers/usb/serial/mct_u232.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/mct_u232.c
@@ -517,7 +517,7 @@ static void mct_u232_close (struct usb_s
 
 static void mct_u232_read_int_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
 	struct usb_serial *serial = port->serial;
 	struct tty_struct *tty;
diff -puN drivers/usb/serial/mos7840.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/mos7840.c
--- a/drivers/usb/serial/mos7840.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/mos7840.c
@@ -436,7 +436,7 @@ static void mos7840_control_callback(str
 	int result = 0;
 	int status = urb->status;
 
-	mos7840_port = (struct moschip_port *)urb->context;
+	mos7840_port = urb->context;
 
 	switch (status) {
 	case 0:
@@ -541,7 +541,7 @@ static void mos7840_interrupt_callback(s
 	length = urb->actual_length;
 	data = urb->transfer_buffer;
 
-	serial = (struct usb_serial *)urb->context;
+	serial = urb->context;
 
 	/* Moschip get 5 bytes
 	 * Byte 1 IIR Port 1 (port.number is 0)
@@ -672,7 +672,7 @@ static void mos7840_bulk_in_callback(str
 		return;
 	}
 
-	mos7840_port = (struct moschip_port *)urb->context;
+	mos7840_port = urb->context;
 	if (!mos7840_port) {
 		dbg("%s", "NULL mos7840_port pointer \n");
 		return;
@@ -739,7 +739,7 @@ static void mos7840_bulk_out_data_callba
 	int status = urb->status;
 	int i;
 
-	mos7840_port = (struct moschip_port *)urb->context;
+	mos7840_port = urb->context;
 	spin_lock(&mos7840_port->pool_lock);
 	for (i = 0; i < NUM_URBS; i++) {
 		if (urb == mos7840_port->write_urb_pool[i]) {
diff -puN drivers/usb/serial/omninet.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/omninet.c
--- a/drivers/usb/serial/omninet.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/omninet.c
@@ -197,7 +197,7 @@ static void omninet_close (struct usb_se
 
 static void omninet_read_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port 	*port 	= (struct usb_serial_port *)urb->context;
+	struct usb_serial_port 	*port 	= urb->context;
 	unsigned char 		*data 	= urb->transfer_buffer;
 	struct omninet_header 	*header = (struct omninet_header *) &data[0];
 	int status = urb->status;
@@ -311,7 +311,7 @@ static int omninet_write_room (struct us
 static void omninet_write_bulk_callback (struct urb *urb)
 {
 /*	struct omninet_header	*header = (struct omninet_header  *) urb->transfer_buffer; */
-	struct usb_serial_port 	*port   = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port 	*port   =  urb->context;
 	int status = urb->status;
 
 	dbg("%s - port %0x\n", __FUNCTION__, port->number);
diff -puN drivers/usb/serial/option.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/option.c
@@ -443,7 +443,7 @@ static void option_indat_callback(struct
 	dbg("%s: %p", __FUNCTION__, urb);
 
 	endpoint = usb_pipeendpoint(urb->pipe);
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 
 	if (status) {
 		dbg("%s: nonzero status: %d on endpoint %02x.",
@@ -477,7 +477,7 @@ static void option_outdat_callback(struc
 
 	dbg("%s", __FUNCTION__);
 
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 
 	usb_serial_port_softint(port);
 
@@ -495,7 +495,7 @@ static void option_instat_callback(struc
 {
 	int err;
 	int status = urb->status;
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	struct option_port_private *portdata = usb_get_serial_port_data(port);
 	struct usb_serial *serial = port->serial;
 
diff -puN drivers/usb/serial/oti6858.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/oti6858.c
--- a/drivers/usb/serial/oti6858.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/oti6858.c
@@ -878,7 +878,7 @@ static void oti6858_shutdown(struct usb_
 
 static void oti6858_read_int_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	struct oti6858_private *priv = usb_get_serial_port_data(port);
 	int transient = 0, can_recv = 0, resubmit = 1;
 	int status = urb->status;
@@ -992,7 +992,7 @@ static void oti6858_read_int_callback(st
 
 static void oti6858_read_bulk_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	struct oti6858_private *priv = usb_get_serial_port_data(port);
 	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
@@ -1045,7 +1045,7 @@ static void oti6858_read_bulk_callback(s
 
 static void oti6858_write_bulk_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	struct oti6858_private *priv = usb_get_serial_port_data(port);
 	int status = urb->status;
 	int result;
diff -puN drivers/usb/serial/pl2303.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/pl2303.c
--- a/drivers/usb/serial/pl2303.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/pl2303.c
@@ -942,7 +942,7 @@ static void pl2303_update_line_status(st
 
 static void pl2303_read_int_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	unsigned int actual_length = urb->actual_length;
 	int status = urb->status;
@@ -982,7 +982,7 @@ exit:
 
 static void pl2303_read_bulk_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
@@ -1065,7 +1065,7 @@ static void pl2303_read_bulk_callback(st
 
 static void pl2303_write_bulk_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	int result;
 	int status = urb->status;
diff -puN drivers/usb/serial/safe_serial.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/safe_serial.c
--- a/drivers/usb/serial/safe_serial.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/safe_serial.c
@@ -195,7 +195,7 @@ static __u16 __inline__ fcs_compute10 (u
 
 static void safe_read_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	unsigned char length = urb->actual_length;
 	int i;
diff -puN drivers/usb/serial/sierra.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/sierra.c
--- a/drivers/usb/serial/sierra.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/sierra.c
@@ -416,7 +416,7 @@ static void sierra_indat_callback(struct
 	dbg("%s: %p", __FUNCTION__, urb);
 
 	endpoint = usb_pipeendpoint(urb->pipe);
-	port = (struct usb_serial_port *) urb->context;
+	port =  urb->context;
 
 	if (status) {
 		dbg("%s: nonzero status: %d on endpoint %02x.",
@@ -446,7 +446,7 @@ static void sierra_instat_callback(struc
 {
 	int err;
 	int status = urb->status;
-	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct usb_serial_port *port =  urb->context;
 	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
 	struct usb_serial *serial = port->serial;
 
diff -puN drivers/usb/serial/ti_usb_3410_5052.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/ti_usb_3410_5052.c
--- a/drivers/usb/serial/ti_usb_3410_5052.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1105,7 +1105,7 @@ static void ti_break(struct usb_serial_p
 
 static void ti_interrupt_callback(struct urb *urb)
 {
-	struct ti_device *tdev = (struct ti_device *)urb->context;
+	struct ti_device *tdev = urb->context;
 	struct usb_serial_port *port;
 	struct usb_serial *serial = tdev->td_serial;
 	struct ti_port *tport;
@@ -1188,7 +1188,7 @@ exit:
 
 static void ti_bulk_in_callback(struct urb *urb)
 {
-	struct ti_port *tport = (struct ti_port *)urb->context;
+	struct ti_port *tport = urb->context;
 	struct usb_serial_port *port = tport->tp_port;
 	struct device *dev = &urb->dev->dev;
 	int status = urb->status;
@@ -1254,7 +1254,7 @@ exit:
 
 static void ti_bulk_out_callback(struct urb *urb)
 {
-	struct ti_port *tport = (struct ti_port *)urb->context;
+	struct ti_port *tport = urb->context;
 	struct usb_serial_port *port = tport->tp_port;
 	struct device *dev = &urb->dev->dev;
 	int status = urb->status;
diff -puN drivers/usb/serial/visor.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/visor.c
--- a/drivers/usb/serial/visor.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/visor.c
@@ -485,7 +485,7 @@ static int visor_chars_in_buffer (struct
 
 static void visor_write_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct visor_private *priv = usb_get_serial_port_data(port);
 	int status = urb->status;
 	unsigned long flags;
@@ -509,7 +509,7 @@ static void visor_write_bulk_callback (s
 
 static void visor_read_bulk_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct visor_private *priv = usb_get_serial_port_data(port);
 	unsigned char *data = urb->transfer_buffer;
 	int status = urb->status;
@@ -560,7 +560,7 @@ static void visor_read_bulk_callback (st
 
 static void visor_read_int_callback (struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	int status = urb->status;
 	int result;
 
diff -puN drivers/usb/serial/whiteheat.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/serial/whiteheat.c
--- a/drivers/usb/serial/whiteheat.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/serial/whiteheat.c
@@ -971,7 +971,7 @@ static void command_port_write_callback(
 
 static void command_port_read_callback(struct urb *urb)
 {
-	struct usb_serial_port *command_port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *command_port = urb->context;
 	struct whiteheat_command_private *command_info;
 	int status = urb->status;
 	unsigned char *data = urb->transfer_buffer;
@@ -1021,7 +1021,7 @@ static void command_port_read_callback(s
 
 static void whiteheat_read_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct whiteheat_urb_wrap *wrap;
 	unsigned char *data = urb->transfer_buffer;
 	struct whiteheat_private *info = usb_get_serial_port_data(port);
@@ -1065,7 +1065,7 @@ static void whiteheat_read_callback(stru
 
 static void whiteheat_write_callback(struct urb *urb)
 {
-	struct usb_serial_port *port = (struct usb_serial_port *)urb->context;
+	struct usb_serial_port *port = urb->context;
 	struct whiteheat_private *info = usb_get_serial_port_data(port);
 	struct whiteheat_urb_wrap *wrap;
 	int status = urb->status;
diff -puN drivers/usb/storage/transport.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/storage/transport.c
--- a/drivers/usb/storage/transport.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/storage/transport.c
@@ -110,7 +110,7 @@
  */
 static void usb_stor_blocking_completion(struct urb *urb)
 {
-	struct completion *urb_done_ptr = (struct completion *)urb->context;
+	struct completion *urb_done_ptr = urb->context;
 
 	complete(urb_done_ptr);
 }
diff -puN drivers/usb/usb-skeleton.c~usb-remove-unnecessary-type-casting-of-urb-context drivers/usb/usb-skeleton.c
--- a/drivers/usb/usb-skeleton.c~usb-remove-unnecessary-type-casting-of-urb-context
+++ a/drivers/usb/usb-skeleton.c
@@ -212,7 +212,7 @@ static void skel_write_bulk_callback(str
 {
 	struct usb_skel *dev;
 
-	dev = (struct usb_skel *)urb->context;
+	dev = urb->context;
 
 	/* sync/async unlink faults aren't errors */
 	if (urb->status) {
_

Patches currently in -mm which might be from tom.leiming@gmail.com are


