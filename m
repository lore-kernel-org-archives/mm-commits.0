From: akpm@linux-foundation.org
Subject: - ibmasm-whitespace-cleanup.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:02:43 -0700
Message-ID: <200707172302.l6HN2hCb011596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52567 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765545AbXGQXQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtor@insightbb.com, dtor@mail.ru, masbock@us.ibm.com, vernux@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     IBMASM: whitespace cleanup
has been removed from the -mm tree.  Its filename was
     ibmasm-whitespace-cleanup.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: IBMASM: whitespace cleanup
=46rom: Dmitry Torokhov <dtor@insightbb.com>

IBMASM: whitespace cleanup

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Vernon Mauery <vernux@us.ibm.com>
Cc: Max Asbock <masbock@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ibmasm/command.c     |   14 +++++++-------
 drivers/misc/ibmasm/dot_command.c |   10 +++++-----
 drivers/misc/ibmasm/dot_command.h |    2 +-
 drivers/misc/ibmasm/event.c       |    8 ++++----
 drivers/misc/ibmasm/heartbeat.c   |    2 +-
 drivers/misc/ibmasm/i2o.h         |   10 +++++-----
 drivers/misc/ibmasm/ibmasm.h      |    6 +++---
 drivers/misc/ibmasm/ibmasmfs.c    |   24 ++++++++++++------------
 drivers/misc/ibmasm/lowlevel.c    |    2 +-
 drivers/misc/ibmasm/lowlevel.h    |   16 ++++++++--------
 drivers/misc/ibmasm/module.c      |   10 +++++-----
 drivers/misc/ibmasm/r_heartbeat.c |   10 +++++-----
 drivers/misc/ibmasm/remote.h      |    8 ++++----
 drivers/misc/ibmasm/uart.c        |    2 +-
 14 files changed, 62 insertions(+), 62 deletions(-)

diff -puN drivers/misc/ibmasm/command.c~ibmasm-whitespace-cleanup drive=
rs/misc/ibmasm/command.c
--- a/drivers/misc/ibmasm/command.c~ibmasm-whitespace-cleanup
+++ a/drivers/misc/ibmasm/command.c
@@ -18,7 +18,7 @@
  *
  * Copyright (C) IBM Corporation, 2004
  *
- * Author: Max Asb=F6ck <amax@us.ibm.com>=20
+ * Author: Max Asb=F6ck <amax@us.ibm.com>
  *
  */
=20
@@ -72,7 +72,7 @@ struct command *ibmasm_new_command(struc
 static void free_command(struct kobject *kobj)
 {
 	struct command *cmd =3D to_command(kobj);
-=20
+
 	list_del(&cmd->queue_node);
 	atomic_dec(&command_count);
 	dbg("command count: %d\n", atomic_read(&command_count));
@@ -113,14 +113,14 @@ static inline void do_exec_command(struc
 		exec_next_command(sp);
 	}
 }
-=09
+
 /**
  * exec_command
  * send a command to a service processor
  * Commands are executed sequentially. One command (sp->current_comman=
d)
  * is sent to the service processor. Once the interrupt handler gets a
  * message of type command_response, the message is copied into
- * the current commands buffer,=20
+ * the current commands buffer,
  */
 void ibmasm_exec_command(struct service_processor *sp, struct command =
*cmd)
 {
@@ -160,7 +160,7 @@ static void exec_next_command(struct ser
 	}
 }
=20
-/**=20
+/**
  * Sleep until a command has failed or a response has been received
  * and the command status been updated by the interrupt handler.
  * (see receive_response).
@@ -182,8 +182,8 @@ void ibmasm_receive_command_response(str
 {
 	struct command *cmd =3D sp->current_command;
=20
-	if (!sp->current_command)=20
-		return;=20
+	if (!sp->current_command)
+		return;
=20
 	memcpy_fromio(cmd->buffer, response, min(size, cmd->buffer_size));
 	cmd->status =3D IBMASM_CMD_COMPLETE;
diff -puN drivers/misc/ibmasm/dot_command.c~ibmasm-whitespace-cleanup d=
rivers/misc/ibmasm/dot_command.c
--- a/drivers/misc/ibmasm/dot_command.c~ibmasm-whitespace-cleanup
+++ a/drivers/misc/ibmasm/dot_command.c
@@ -17,7 +17,7 @@
  *
  * Copyright (C) IBM Corporation, 2004
  *
- * Author: Max Asb=F6ck <amax@us.ibm.com>=20
+ * Author: Max Asb=F6ck <amax@us.ibm.com>
  *
  */
=20
@@ -44,11 +44,11 @@ void ibmasm_receive_message(struct servi
 		size =3D message_size;
=20
 	switch (header->type) {
-	case sp_event:=20
+	case sp_event:
 		ibmasm_receive_event(sp, message, size);
 		break;
 	case sp_command_response:
-		ibmasm_receive_command_response(sp, message, size);=20
+		ibmasm_receive_command_response(sp, message, size);
 		break;
 	case sp_heartbeat:
 		ibmasm_receive_heartbeat(sp, message, size);
@@ -95,7 +95,7 @@ int ibmasm_send_driver_vpd(struct servic
 	strcat(vpd_data, IBMASM_DRIVER_VPD);
 	vpd_data[10] =3D 0;
 	vpd_data[15] =3D 0;
-=09
+
 	ibmasm_exec_command(sp, command);
 	ibmasm_wait_for_response(command, IBMASM_CMD_TIMEOUT_NORMAL);
=20
@@ -118,7 +118,7 @@ struct os_state_command {
  * During driver init this function is called with os state "up".
  * This causes the service processor to start sending heartbeats the
  * driver.
- * During driver exit the function is called with os state "down",=20
+ * During driver exit the function is called with os state "down",
  * causing the service processor to stop the heartbeats.
  */
 int ibmasm_send_os_state(struct service_processor *sp, int os_state)
diff -puN drivers/misc/ibmasm/dot_command.h~ibmasm-whitespace-cleanup d=
rivers/misc/ibmasm/dot_command.h
--- a/drivers/misc/ibmasm/dot_command.h~ibmasm-whitespace-cleanup
+++ a/drivers/misc/ibmasm/dot_command.h
@@ -17,7 +17,7 @@
  *
  * Copyright (C) IBM Corporation, 2004
  *
- * Author: Max Asb=F6ck <amax@us.ibm.com>=20
+ * Author: Max Asb=F6ck <amax@us.ibm.com>
  *
  */
=20
diff -puN drivers/misc/ibmasm/event.c~ibmasm-whitespace-cleanup drivers=
/misc/ibmasm/event.c
--- a/drivers/misc/ibmasm/event.c~ibmasm-whitespace-cleanup
+++ a/drivers/misc/ibmasm/event.c
@@ -18,7 +18,7 @@
  *
  * Copyright (C) IBM Corporation, 2004
  *
- * Author: Max Asb=F6ck <amax@us.ibm.com>=20
+ * Author: Max Asb=F6ck <amax@us.ibm.com>
  *
  */
=20
@@ -51,7 +51,7 @@ static void wake_up_event_readers(struct
  * event readers.
  * There is no reader marker in the buffer, therefore readers are
  * responsible for keeping up with the writer, or they will loose even=
ts.
- */=20
+ */
 void ibmasm_receive_event(struct service_processor *sp, void *data, un=
signed int data_size)
 {
 	struct event_buffer *buffer =3D sp->event_buffer;
@@ -77,13 +77,13 @@ void ibmasm_receive_event(struct service
=20
 static inline int event_available(struct event_buffer *b, struct event=
_reader *r)
 {
-	return 	(r->next_serial_number < b->next_serial_number);
+	return (r->next_serial_number < b->next_serial_number);
 }
=20
 /**
  * get_next_event
  * Called by event readers (initiated from user space through the file
- * system).=20
+ * system).
  * Sleeps until a new event is available.
  */
 int ibmasm_get_next_event(struct service_processor *sp, struct event_r=
eader *reader)
diff -puN drivers/misc/ibmasm/heartbeat.c~ibmasm-whitespace-cleanup dri=
vers/misc/ibmasm/heartbeat.c
--- a/drivers/misc/ibmasm/heartbeat.c~ibmasm-whitespace-cleanup
+++ a/drivers/misc/ibmasm/heartbeat.c
@@ -18,7 +18,7 @@
  *
  * Copyright (C) IBM Corporation, 2004
  *
- * Author: Max Asb=F6ck <amax@us.ibm.com>=20
+ * Author: Max Asb=F6ck <amax@us.ibm.com>
  *
  */
=20
diff -puN drivers/misc/ibmasm/i2o.h~ibmasm-whitespace-cleanup drivers/m=
isc/ibmasm/i2o.h
--- a/drivers/misc/ibmasm/i2o.h~ibmasm-whitespace-cleanup
+++ a/drivers/misc/ibmasm/i2o.h
@@ -17,7 +17,7 @@
  *
  * Copyright (C) IBM Corporation, 2004
  *
- * Author: Max Asb=F6ck <amax@us.ibm.com>=20
+ * Author: Max Asb=F6ck <amax@us.ibm.com>
  *
  */
=20
@@ -26,9 +26,9 @@ struct i2o_header {
 	u8	version;
 	u8	message_flags;
 	u16	message_size;
-	u8	target;          =20
+	u8	target;
 	u8	initiator_and_target;
-	u8	initiator;       =20
+	u8	initiator;
 	u8	function;
 	u32	initiator_context;
 };
@@ -64,12 +64,12 @@ static inline unsigned short outgoing_me
 	size =3D sizeof(struct i2o_header) + data_size;
=20
 	i2o_size =3D size / sizeof(u32);
-=09
+
 	if (size % sizeof(u32))
 	       i2o_size++;
=20
 	return i2o_size;
-}=09
+}
=20
 static inline u32 incoming_data_size(struct i2o_message *i2o_message)
 {
diff -puN drivers/misc/ibmasm/ibmasm.h~ibmasm-whitespace-cleanup driver=
s/misc/ibmasm/ibmasm.h
--- a/drivers/misc/ibmasm/ibmasm.h~ibmasm-whitespace-cleanup
+++ a/drivers/misc/ibmasm/ibmasm.h
@@ -18,7 +18,7 @@
  *
  * Copyright (C) IBM Corporation, 2004
  *
- * Author: Max Asb=F6ck <amax@us.ibm.com>=20
+ * Author: Max Asb=F6ck <amax@us.ibm.com>
  *
  */
=20
@@ -58,8 +58,8 @@ static inline char *get_timestamp(char *
 	return buf;
 }
=20
-#define IBMASM_CMD_PENDING	0=09
-#define IBMASM_CMD_COMPLETE	1=09
+#define IBMASM_CMD_PENDING	0
+#define IBMASM_CMD_COMPLETE	1
 #define IBMASM_CMD_FAILED	2
=20
 #define IBMASM_CMD_TIMEOUT_NORMAL	45
diff -puN drivers/misc/ibmasm/ibmasmfs.c~ibmasm-whitespace-cleanup driv=
ers/misc/ibmasm/ibmasmfs.c
--- a/drivers/misc/ibmasm/ibmasmfs.c~ibmasm-whitespace-cleanup
+++ a/drivers/misc/ibmasm/ibmasmfs.c
@@ -17,12 +17,12 @@
  *
  * Copyright (C) IBM Corporation, 2004
  *
- * Author: Max Asb=F6ck <amax@us.ibm.com>=20
+ * Author: Max Asb=F6ck <amax@us.ibm.com>
  *
  */
=20
 /*
- * Parts of this code are based on an article by Jonathan Corbet=20
+ * Parts of this code are based on an article by Jonathan Corbet
  * that appeared in Linux Weekly News.
  */
=20
@@ -55,22 +55,22 @@
  * For each service processor the following files are created:
  *
  * command: execute dot commands
- * 	write: execute a dot command on the service processor
- * 	read: return the result of a previously executed dot command
+ *	write: execute a dot command on the service processor
+ *	read: return the result of a previously executed dot command
  *
  * events: listen for service processor events
- * 	read: sleep (interruptible) until an event occurs
+ *	read: sleep (interruptible) until an event occurs
  *      write: wakeup sleeping event listener
  *
  * reverse_heartbeat: send a heartbeat to the service processor
- * 	read: sleep (interruptible) until the reverse heartbeat fails
+ *	read: sleep (interruptible) until the reverse heartbeat fails
  *      write: wakeup sleeping heartbeat listener
  *
  * remote_video/width
  * remote_video/height
  * remote_video/width: control remote display settings
- * 	write: set value
- * 	read: read value
+ *	write: set value
+ *	read: read value
  */
=20
 #include <linux/fs.h>
@@ -155,7 +155,7 @@ static struct inode *ibmasmfs_make_inode
=20
 static struct dentry *ibmasmfs_create_file (struct super_block *sb,
 			struct dentry *parent,
-		       	const char *name,
+			const char *name,
 			const struct file_operations *fops,
 			void *data,
 			int mode)
@@ -261,7 +261,7 @@ static int command_file_close(struct ino
 	struct ibmasmfs_command_data *command_data =3D file->private_data;
=20
 	if (command_data->command)
-		command_put(command_data->command);=09
+		command_put(command_data->command);
=20
 	kfree(command_data);
 	return 0;
@@ -348,7 +348,7 @@ static ssize_t command_file_write(struct
 static int event_file_open(struct inode *inode, struct file *file)
 {
 	struct ibmasmfs_event_data *event_data;
-	struct service_processor *sp;=20
+	struct service_processor *sp;
=20
 	if (!inode->i_private)
 		return -ENODEV;
@@ -573,7 +573,7 @@ static ssize_t remote_settings_file_writ
 		kfree(buff);
 		return -EFAULT;
 	}
-=09
+
 	value =3D simple_strtoul(buff, NULL, 10);
 	writel(value, address);
 	kfree(buff);
diff -puN drivers/misc/ibmasm/lowlevel.c~ibmasm-whitespace-cleanup driv=
ers/misc/ibmasm/lowlevel.c
--- a/drivers/misc/ibmasm/lowlevel.c~ibmasm-whitespace-cleanup
+++ a/drivers/misc/ibmasm/lowlevel.c
@@ -17,7 +17,7 @@
  *
  * Copyright (C) IBM Corporation, 2004
  *
- * Author: Max Asb=F6ck <amax@us.ibm.com>=20
+ * Author: Max Asb=F6ck <amax@us.ibm.com>
  *
  */
=20
diff -puN drivers/misc/ibmasm/lowlevel.h~ibmasm-whitespace-cleanup driv=
ers/misc/ibmasm/lowlevel.h
--- a/drivers/misc/ibmasm/lowlevel.h~ibmasm-whitespace-cleanup
+++ a/drivers/misc/ibmasm/lowlevel.h
@@ -17,7 +17,7 @@
  *
  * Copyright (C) IBM Corporation, 2004
  *
- * Author: Max Asb=F6ck <amax@us.ibm.com>=20
+ * Author: Max Asb=F6ck <amax@us.ibm.com>
  *
  */
=20
@@ -48,9 +48,9 @@
 #define INTR_CONTROL_REGISTER  0x13A4
=20
 #define SCOUT_COM_A_BASE         0x0000
-#define SCOUT_COM_B_BASE         0x0100  =20
-#define SCOUT_COM_C_BASE         0x0200  =20
-#define SCOUT_COM_D_BASE         0x0300  =20
+#define SCOUT_COM_B_BASE         0x0100
+#define SCOUT_COM_C_BASE         0x0200
+#define SCOUT_COM_D_BASE         0x0300
=20
 static inline int sp_interrupt_pending(void __iomem *base_address)
 {
@@ -86,12 +86,12 @@ static inline void disable_sp_interrupts
=20
 static inline void enable_uart_interrupts(void __iomem *base_address)
 {
-	ibmasm_enable_interrupts(base_address, UART_INTR_MASK);=20
+	ibmasm_enable_interrupts(base_address, UART_INTR_MASK);
 }
=20
 static inline void disable_uart_interrupts(void __iomem *base_address)
 {
-	ibmasm_disable_interrupts(base_address, UART_INTR_MASK);=20
+	ibmasm_disable_interrupts(base_address, UART_INTR_MASK);
 }
=20
 #define valid_mfa(mfa)	( (mfa) !=3D NO_MFAS_AVAILABLE )
@@ -111,7 +111,7 @@ static inline u32 get_mfa_outbound(void=20
=20
 static inline void set_mfa_outbound(void __iomem *base_address, u32 mf=
a)
 {
-   	writel(mfa, base_address + OUTBOUND_QUEUE_PORT);
+	writel(mfa, base_address + OUTBOUND_QUEUE_PORT);
 }
=20
 static inline u32 get_mfa_inbound(void __iomem *base_address)
@@ -126,7 +126,7 @@ static inline u32 get_mfa_inbound(void _
=20
 static inline void set_mfa_inbound(void __iomem *base_address, u32 mfa=
)
 {
-   	writel(mfa, base_address + INBOUND_QUEUE_PORT);
+	writel(mfa, base_address + INBOUND_QUEUE_PORT);
 }
=20
 static inline struct i2o_message *get_i2o_message(void __iomem *base_a=
ddress, u32 mfa)
diff -puN drivers/misc/ibmasm/module.c~ibmasm-whitespace-cleanup driver=
s/misc/ibmasm/module.c
--- a/drivers/misc/ibmasm/module.c~ibmasm-whitespace-cleanup
+++ a/drivers/misc/ibmasm/module.c
@@ -18,9 +18,9 @@
  *
  * Copyright (C) IBM Corporation, 2004
  *
- * Author: Max Asb=F6ck <amax@us.ibm.com>=20
+ * Author: Max Asb=F6ck <amax@us.ibm.com>
  *
- * This driver is based on code originally written by Pete Reynolds=20
+ * This driver is based on code originally written by Pete Reynolds
  * and others.
  *
  */
@@ -30,13 +30,13 @@
  *
  * 1) When loaded it sends a message to the service processor,
  * indicating that an OS is * running. This causes the service process=
or
- * to send periodic heartbeats to the OS.=20
+ * to send periodic heartbeats to the OS.
  *
  * 2) Answers the periodic heartbeats sent by the service processor.
  * Failure to do so would result in system reboot.
  *
  * 3) Acts as a pass through for dot commands sent from user applicati=
ons.
- * The interface for this is the ibmasmfs file system.=20
+ * The interface for this is the ibmasmfs file system.
  *
  * 4) Allows user applications to register for event notification. Eve=
nts
  * are sent to the driver through interrupts. They can be read from us=
er
@@ -105,7 +105,7 @@ static int __devinit ibmasm_init_one(str
 	}
=20
 	sp->irq =3D pdev->irq;
-	sp->base_address =3D ioremap(pci_resource_start(pdev, 0),=20
+	sp->base_address =3D ioremap(pci_resource_start(pdev, 0),
 					pci_resource_len(pdev, 0));
 	if (sp->base_address =3D=3D 0) {
 		dev_err(sp->dev, "Failed to ioremap pci memory\n");
diff -puN drivers/misc/ibmasm/r_heartbeat.c~ibmasm-whitespace-cleanup d=
rivers/misc/ibmasm/r_heartbeat.c
--- a/drivers/misc/ibmasm/r_heartbeat.c~ibmasm-whitespace-cleanup
+++ a/drivers/misc/ibmasm/r_heartbeat.c
@@ -16,7 +16,7 @@
  *
  * Copyright (C) IBM Corporation, 2004
  *
- * Author: Max Asb=F6ck <amax@us.ibm.com>=20
+ * Author: Max Asb=F6ck <amax@us.ibm.com>
  *
  */
=20
@@ -36,10 +36,10 @@ static struct {
 	unsigned char			command[3];
 } rhb_dot_cmd =3D {
 	.header =3D {
-		.type =3D 	sp_read,
+		.type =3D		sp_read,
 		.command_size =3D 3,
 		.data_size =3D	0,
-		.status =3D 	0
+		.status =3D	0
 	},
 	.command =3D { 4, 3, 6 }
 };
@@ -76,9 +76,9 @@ int ibmasm_start_reverse_heartbeat(struc
 		if (cmd->status !=3D IBMASM_CMD_COMPLETE)
 			times_failed++;
=20
-		wait_event_interruptible_timeout(rhb->wait,=20
+		wait_event_interruptible_timeout(rhb->wait,
 			rhb->stopped,
-			REVERSE_HEARTBEAT_TIMEOUT * HZ); =09
+			REVERSE_HEARTBEAT_TIMEOUT * HZ);
=20
 		if (signal_pending(current) || rhb->stopped) {
 			result =3D -EINTR;
diff -puN drivers/misc/ibmasm/remote.h~ibmasm-whitespace-cleanup driver=
s/misc/ibmasm/remote.h
--- a/drivers/misc/ibmasm/remote.h~ibmasm-whitespace-cleanup
+++ a/drivers/misc/ibmasm/remote.h
@@ -18,7 +18,7 @@
  *
  * Copyright (C) IBM Corporation, 2004
  *
- * Author: Max Asb=F6ck <amax@us.ibm.com>=20
+ * Author: Max Asb=F6ck <amax@us.ibm.com>
  *
  * Orignally written by Pete Reynolds
  */
@@ -73,7 +73,7 @@ struct keyboard_input {
=20
=20
=20
-struct remote_input {=20
+struct remote_input {
 	union {
 		struct mouse_input	mouse;
 		struct keyboard_input	keyboard;
@@ -85,7 +85,7 @@ struct remote_input {=20
 	unsigned char	pad3;
 };
=20
-#define mouse_addr(sp) 		(sp->base_address + CONDOR_MOUSE_DATA)
+#define mouse_addr(sp)		(sp->base_address + CONDOR_MOUSE_DATA)
 #define display_width(sp)	(mouse_addr(sp) + CONDOR_INPUT_DISPLAY_RESX)
 #define display_height(sp)	(mouse_addr(sp) + CONDOR_INPUT_DISPLAY_RESY=
)
 #define display_depth(sp)	(mouse_addr(sp) + CONDOR_INPUT_DISPLAY_BITS)
@@ -93,7 +93,7 @@ struct remote_input {=20
 #define vnc_status(sp)		(mouse_addr(sp) + CONDOR_OUTPUT_VNC_STATUS)
 #define isr_control(sp)		(mouse_addr(sp) + CONDOR_MOUSE_ISR_CONTROL)
=20
-#define mouse_interrupt_pending(sp) 	readl(mouse_addr(sp) + CONDOR_MOU=
SE_ISR_STATUS)
+#define mouse_interrupt_pending(sp)	readl(mouse_addr(sp) + CONDOR_MOUS=
E_ISR_STATUS)
 #define clear_mouse_interrupt(sp)	writel(0, mouse_addr(sp) + CONDOR_MO=
USE_ISR_STATUS)
 #define enable_mouse_interrupts(sp)	writel(1, mouse_addr(sp) + CONDOR_=
MOUSE_ISR_CONTROL)
 #define disable_mouse_interrupts(sp)	writel(0, mouse_addr(sp) + CONDOR=
_MOUSE_ISR_CONTROL)
diff -puN drivers/misc/ibmasm/uart.c~ibmasm-whitespace-cleanup drivers/=
misc/ibmasm/uart.c
--- a/drivers/misc/ibmasm/uart.c~ibmasm-whitespace-cleanup
+++ a/drivers/misc/ibmasm/uart.c
@@ -18,7 +18,7 @@
  *
  * Copyright (C) IBM Corporation, 2004
  *
- * Author: Max Asb=F6ck <amax@us.ibm.com>=20
+ * Author: Max Asb=F6ck <amax@us.ibm.com>
  *
  */
=20
_

Patches currently in -mm which might be from dtor@insightbb.com are

origin.patch
git-dvb.patch
git-input.patch
hdaps-switch-to-using-input-polldev.patch
applesmc-switch-to-using-input-polldev.patch
ams-switch-to-using-input-polldev.patch
