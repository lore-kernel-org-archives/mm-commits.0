From: akpm@linux-foundation.org
Subject: + kobil_sct-rework-driver.patch added to -mm tree
Date: Thu, 23 Aug 2007 15:09:39 -0700
Message-ID: <200708232209.l7NM9dbY029306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38646 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760132AbXHWWKW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 18:10:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com


The patch titled
     kobil_sct: rework driver
has been added to the -mm tree.  Its filename is
     kobil_sct-rework-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kobil_sct: rework driver
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

No hardware but this driver is currently totally broken so we can't make it
much worse.  Remove all tbe broken invalid termios handling and replace it
with a proper set_termios method.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/kobil_sct.c |  144 +++++++++++--------------------
 1 files changed, 55 insertions(+), 89 deletions(-)

diff -puN drivers/usb/serial/kobil_sct.c~kobil_sct-rework-driver drivers/usb/serial/kobil_sct.c
--- a/drivers/usb/serial/kobil_sct.c~kobil_sct-rework-driver
+++ a/drivers/usb/serial/kobil_sct.c
@@ -82,6 +82,7 @@ static int  kobil_tiocmset(struct usb_se
 			   unsigned int set, unsigned int clear);
 static void kobil_read_int_callback( struct urb *urb );
 static void kobil_write_callback( struct urb *purb );
+static void kobil_set_termios(struct usb_serial_port *port, struct ktermios *old);
 
 
 static struct usb_device_id id_table [] = {
@@ -119,6 +120,7 @@ static struct usb_serial_driver kobil_de
 	.attach =		kobil_startup,
 	.shutdown =		kobil_shutdown,
 	.ioctl =		kobil_ioctl,
+	.set_termios =		kobil_set_termios,
 	.tiocmget =		kobil_tiocmget,
 	.tiocmset =		kobil_tiocmset,
 	.open =			kobil_open,
@@ -137,7 +139,6 @@ struct kobil_private {
 	int cur_pos; // index of the next char to send in buf
 	__u16 device_type;
 	int line_state;
-	struct ktermios internal_termios;
 };
 
 
@@ -216,7 +217,7 @@ static void kobil_shutdown (struct usb_s
 
 static int kobil_open (struct usb_serial_port *port, struct file *filp)
 {
-	int i, result = 0;
+	int result = 0;
 	struct kobil_private *priv;
 	unsigned char *transfer_buffer;
 	int transfer_buffer_length = 8;
@@ -242,16 +243,6 @@ static int kobil_open (struct usb_serial
 	port->tty->termios->c_iflag = IGNBRK | IGNPAR | IXOFF;
 	port->tty->termios->c_oflag &= ~ONLCR; // do NOT translate CR to CR-NL (0x0A -> 0x0A 0x0D)
 	
-	// set up internal termios structure 
-	priv->internal_termios.c_iflag = port->tty->termios->c_iflag;
-	priv->internal_termios.c_oflag = port->tty->termios->c_oflag;
-	priv->internal_termios.c_cflag = port->tty->termios->c_cflag;
-	priv->internal_termios.c_lflag = port->tty->termios->c_lflag;
-
-	for (i=0; i<NCCS; i++) {
-		priv->internal_termios.c_cc[i] = port->tty->termios->c_cc[i];
-	}
-	
 	// allocate memory for transfer buffer
 	transfer_buffer = kzalloc(transfer_buffer_length, GFP_KERNEL);
 	if (! transfer_buffer) {
@@ -607,102 +598,79 @@ static int  kobil_tiocmset(struct usb_se
 	return (result < 0) ? result : 0;
 }
 
-
-static int  kobil_ioctl(struct usb_serial_port *port, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static void kobil_set_termios(struct usb_serial_port *port, struct ktermios *old)
 {
 	struct kobil_private * priv;
 	int result;
 	unsigned short urb_val = 0;
-	unsigned char *transfer_buffer;
-	int transfer_buffer_length = 8;
-	char *settings;
-	void __user *user_arg = (void __user *)arg;
+	int c_cflag = port->tty->termios->c_cflag;
+	speed_t speed;
+	void * settings;
 
 	priv = usb_get_serial_port_data(port);
-	if ((priv->device_type == KOBIL_USBTWIN_PRODUCT_ID) || (priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID)) {
+	if (priv->device_type == KOBIL_USBTWIN_PRODUCT_ID || priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID)
 		// This device doesn't support ioctl calls
-		return 0;
-	}
-
-	switch (cmd) {
-	case TCGETS:   // 0x5401
-		if (!access_ok(VERIFY_WRITE, user_arg, sizeof(struct ktermios))) {
-			dbg("%s - port %d Error in access_ok", __FUNCTION__, port->number);
-			return -EFAULT;
-		}
-		if (kernel_termios_to_user_termios((struct ktermios __user *)arg,
-						   &priv->internal_termios))
-			return -EFAULT;
-		return 0;
-
-	case TCSETS:   // 0x5402
-		if (!(port->tty->termios)) {
-			dbg("%s - port %d Error: port->tty->termios is NULL", __FUNCTION__, port->number);
-			return -ENOTTY;
-		}
-		if (!access_ok(VERIFY_READ, user_arg, sizeof(struct ktermios))) {
-			dbg("%s - port %d Error in access_ok", __FUNCTION__, port->number);
-			return -EFAULT;
-		}
-		if (user_termios_to_kernel_termios(&priv->internal_termios,
-						   (struct ktermios __user *)arg))
-			return -EFAULT;
-		
-		settings = kzalloc(50, GFP_KERNEL);
-		if (! settings) {
-			return -ENOBUFS;
-		}
+		return;
 
-		switch (priv->internal_termios.c_cflag & CBAUD) {
-		case B1200:
+	switch (speed = tty_get_baud_rate(port->tty)) {
+		case 1200:
 			urb_val = SUSBCR_SBR_1200;
-			strcat(settings, "1200 ");
 			break;
-		case B9600:
+		case 9600:
 		default:
 			urb_val = SUSBCR_SBR_9600;
-			strcat(settings, "9600 ");
 			break;
-		}
+	}
+	urb_val |= (c_cflag & CSTOPB) ? SUSBCR_SPASB_2StopBits : SUSBCR_SPASB_1StopBit;
+
+	settings = kzalloc(50, GFP_KERNEL);
+	if (! settings)
+		return;
 
-		urb_val |= (priv->internal_termios.c_cflag & CSTOPB) ? SUSBCR_SPASB_2StopBits : SUSBCR_SPASB_1StopBit;
-		strcat(settings, (priv->internal_termios.c_cflag & CSTOPB) ? "2 StopBits " : "1 StopBit ");
+	sprintf(settings, "%d ", speed);
 
-		if (priv->internal_termios.c_cflag & PARENB) {
-			if  (priv->internal_termios.c_cflag & PARODD) {
-				urb_val |= SUSBCR_SPASB_OddParity;
-				strcat(settings, "Odd Parity");
-			} else {
-				urb_val |= SUSBCR_SPASB_EvenParity;
-				strcat(settings, "Even Parity");
-			}
+	if (c_cflag & PARENB) {
+		if  (c_cflag & PARODD) {
+			urb_val |= SUSBCR_SPASB_OddParity;
+			strcat(settings, "Odd Parity");
 		} else {
-			urb_val |= SUSBCR_SPASB_NoParity;
-			strcat(settings, "No Parity");
+			urb_val |= SUSBCR_SPASB_EvenParity;
+			strcat(settings, "Even Parity");
 		}
-		dbg("%s - port %d setting port to: %s", __FUNCTION__, port->number, settings );
+	} else {
+		urb_val |= SUSBCR_SPASB_NoParity;
+		strcat(settings, "No Parity");
+	}
 
-		result = usb_control_msg( port->serial->dev, 
-					  usb_rcvctrlpipe(port->serial->dev, 0 ), 
-					  SUSBCRequest_SetBaudRateParityAndStopBits,
-					  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
-					  urb_val,
-					  0,
-					  settings,
-					  0,
-					  KOBIL_TIMEOUT
-			);
+	result = usb_control_msg( port->serial->dev,
+				  usb_rcvctrlpipe(port->serial->dev, 0 ),
+				  SUSBCRequest_SetBaudRateParityAndStopBits,
+				  USB_TYPE_VENDOR | USB_RECIP_ENDPOINT | USB_DIR_OUT,
+				  urb_val,
+				  0,
+				  settings,
+				  0,
+				  KOBIL_TIMEOUT
+		);
+	kfree(settings);
+}
 
-		dbg("%s - port %d Send set_baudrate URB returns: %i", __FUNCTION__, port->number, result);
-		kfree(settings);
+static int kobil_ioctl(struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg)
+{
+	struct kobil_private * priv = usb_get_serial_port_data(port);
+	unsigned char *transfer_buffer;
+	int transfer_buffer_length = 8;
+	int result;
+
+	if (priv->device_type == KOBIL_USBTWIN_PRODUCT_ID || priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID)
+		// This device doesn't support ioctl calls
 		return 0;
 
+	switch (cmd) {
 	case TCFLSH:   // 0x540B
 		transfer_buffer = kmalloc(transfer_buffer_length, GFP_KERNEL);
-		if (! transfer_buffer) {
+		if (! transfer_buffer)
 		 	return -ENOBUFS;
-		}
 
 		result = usb_control_msg( port->serial->dev, 
 		 			  usb_rcvctrlpipe(port->serial->dev, 0 ), 
@@ -716,15 +684,13 @@ static int  kobil_ioctl(struct usb_seria
 			);
 		
 		dbg("%s - port %d Send reset_all_queues (FLUSH) URB returns: %i", __FUNCTION__, port->number, result);
-
 		kfree(transfer_buffer);
-		return ((result < 0) ? -EFAULT : 0);
-
+		return (result < 0) ? -EFAULT : 0;
+	default:
+		return -ENOIOCTLCMD;
 	}
-	return -ENOIOCTLCMD;
 }
 
-
 static int __init kobil_init (void)
 {
 	int retval;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
serial-add-support-for-ite-887x-chips.patch
serial_txx9-fix-modem-control-line-handling.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
fix-null-pointer-dereference-in-__vm_enough_memory.patch
m68k-enable-arbitary-speed-tty-support.patch
introduce-config_check_signature-was-re-uninline.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-switch-most-of-the-remaining-sff-drivers-to.patch
pata_sis-add-the-fsc-amilo-and-friends.patch
pata_via-add-armia-w730-k8-and-other-rebadgings.patch
pata_marvell-add-more-identifiers.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
git-scsi-misc.patch
fix-gregkh-usb-usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
kobil_sct-rework-driver.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
pata_it821x-fix-regression-corruptor.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
