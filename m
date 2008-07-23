From: akpm@linux-foundation.org
Subject: + x86-usb-debug-port-early-console-v2.patch added to -mm tree
Date: Wed, 23 Jul 2008 15:07:08 -0700
Message-ID: <200807232207.m6NM785S014374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753570AbYGWWHl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 18:07:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel@gmail.com, ebiederm@xmission.com, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: usb debug port early console
has been added to the -mm tree.  Its filename is
     x86-usb-debug-port-early-console-v2.patch

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
Subject: x86: usb debug port early console
From: Yinghai Lu <yhlu.kernel@gmail.com>

Based on work from Eric, and add some timeout so don't dead loop when
debug device is not installed

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 
 arch/x86/kernel/early_printk.c      |  642 +++++++++++++++++++++++++-
 drivers/usb/host/ehci.h             |   14 
 3 files changed, 654 insertions(+), 5 deletions(-)

diff -puN Documentation/kernel-parameters.txt~x86-usb-debug-port-early-console-v2 Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~x86-usb-debug-port-early-console-v2
+++ a/Documentation/kernel-parameters.txt
@@ -654,11 +654,12 @@ and is between 256 and 4096 characters. 
 	earlyprintk=	[X86-32,X86-64,SH,BLACKFIN]
 			earlyprintk=vga
 			earlyprintk=serial[,ttySn[,baudrate]]
+			earlyprintk=dbgp
 
 			Append ",keep" to not disable it when the real console
 			takes over.
 
-			Only vga or serial at a time, not both.
+			Only vga or serial or usb debug port at a time.
 
 			Currently only ttyS0 and ttyS1 are supported.
 
diff -puN arch/x86/kernel/early_printk.c~x86-usb-debug-port-early-console-v2 arch/x86/kernel/early_printk.c
--- a/arch/x86/kernel/early_printk.c~x86-usb-debug-port-early-console-v2
+++ a/arch/x86/kernel/early_printk.c
@@ -3,11 +3,20 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/screen_info.h>
+#include <linux/usb/ch9.h>
+#include <linux/pci_regs.h>
+#include <linux/pci_ids.h>
+#include <linux/errno.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/fcntl.h>
 #include <asm/setup.h>
 #include <xen/hvc-console.h>
+#include <asm/pci-direct.h>
+#include <asm/pgtable.h>
+#include <asm/fixmap.h>
+#define EARLY_PRINTK
+#include "../../../drivers/usb/host/ehci.h"
 
 /* Simple VGA output */
 #define VGABASE		(__ISA_IO_base + 0xb8000)
@@ -78,6 +87,7 @@ static int early_serial_base = 0x3f8;  /
 static int early_serial_putc(unsigned char ch)
 {
 	unsigned timeout = 0xffff;
+
 	while ((inb(early_serial_base + LSR) & XMTRDY) == 0 && --timeout)
 		cpu_relax();
 	outb(ch, early_serial_base + TXR);
@@ -151,6 +161,602 @@ static struct console early_serial_conso
 	.index =	-1,
 };
 
+
+static struct ehci_caps __iomem *ehci_caps;
+static struct ehci_regs __iomem *ehci_regs;
+static struct ehci_dbg_port __iomem *ehci_debug;
+static unsigned dbgp_endpoint_out;
+
+#define USB_DEBUG_DEVNUM 127
+
+#define DBGP_DATA_TOGGLE	0x8800
+
+static inline u32 dbgp_pid_update(u32 x, u32 tok)
+{
+	return ((x ^ DBGP_DATA_TOGGLE) & 0xffff00) | (tok & 0xff);
+}
+
+static inline u32 dbgp_len_update(u32 x, u32 len)
+{
+	return (x & ~0x0f) | (len & 0x0f);
+}
+
+/*
+ * USB Packet IDs (PIDs)
+ */
+
+/* token */
+#define USB_PID_OUT		0xe1
+#define USB_PID_IN		0x69
+#define USB_PID_SOF		0xa5
+#define USB_PID_SETUP		0x2d
+/* handshake */
+#define USB_PID_ACK		0xd2
+#define USB_PID_NAK		0x5a
+#define USB_PID_STALL		0x1e
+#define USB_PID_NYET		0x96
+/* data */
+#define USB_PID_DATA0		0xc3
+#define USB_PID_DATA1		0x4b
+#define USB_PID_DATA2		0x87
+#define USB_PID_MDATA		0x0f
+/* Special */
+#define USB_PID_PREAMBLE	0x3c
+#define USB_PID_ERR		0x3c
+#define USB_PID_SPLIT		0x78
+#define USB_PID_PING		0xb4
+#define USB_PID_UNDEF_0		0xf0
+
+#define USB_PID_DATA_TOGGLE	0x88
+#define DBGP_CLAIM (DBGP_OWNER | DBGP_ENABLED | DBGP_INUSE)
+
+#define PCI_CAP_ID_EHCI_DEBUG	0xa
+
+#define HUB_ROOT_RESET_TIME	50	/* times are in msec */
+#define HUB_SHORT_RESET_TIME	10
+#define HUB_LONG_RESET_TIME	200
+#define HUB_RESET_TIMEOUT	500
+
+#define DBGP_MAX_PACKET		8
+
+static int dbgp_wait_until_complete(void)
+{
+	unsigned ctrl;
+	int loop = 0x100000;
+
+	do {
+		ctrl = readl(&ehci_debug->control);
+		/* Stop when the transaction is finished */
+		if (ctrl & DBGP_DONE)
+			break;
+	} while (--loop > 0);
+
+	if (!loop)
+		return -1;
+
+	/* Now that we have observed the completed transaction,
+	 * clear the done bit.
+	 */
+	writel(ctrl | DBGP_DONE, &ehci_debug->control);
+	return (ctrl & DBGP_ERROR) ? -DBGP_ERRCODE(ctrl) : DBGP_LEN(ctrl);
+}
+
+static void dbgp_mdelay(int ms)
+{
+	int i;
+
+	while (ms--) {
+		for (i = 0; i < 1000; i++)
+			outb(0x1, 0x80);
+	}
+}
+
+static void dbgp_breath(void)
+{
+	/* Sleep to give the debug port a chance to breathe */
+}
+
+static int dbgp_wait_until_done(unsigned ctrl)
+{
+	unsigned pids, lpid;
+	int ret;
+	int loop = 3;
+
+retry:
+	writel(ctrl | DBGP_GO, &ehci_debug->control);
+	ret = dbgp_wait_until_complete();
+	pids = readl(&ehci_debug->pids);
+	lpid = DBGP_PID_GET(pids);
+
+	if (ret < 0)
+		return ret;
+
+	/* If the port is getting full or it has dropped data
+	 * start pacing ourselves, not necessary but it's friendly.
+	 */
+	if ((lpid == USB_PID_NAK) || (lpid == USB_PID_NYET))
+		dbgp_breath();
+
+	/* If I get a NACK reissue the transmission */
+	if (lpid == USB_PID_NAK) {
+		if (--loop > 0)
+			goto retry;
+	}
+
+	return ret;
+}
+
+static void dbgp_set_data(const void *buf, int size)
+{
+	const unsigned char *bytes = buf;
+	unsigned lo, hi;
+	int i;
+
+	lo = hi = 0;
+	for (i = 0; i < 4 && i < size; i++)
+		lo |= bytes[i] << (8*i);
+	for (; i < 8 && i < size; i++)
+		hi |= bytes[i] << (8*(i - 4));
+	writel(lo, &ehci_debug->data03);
+	writel(hi, &ehci_debug->data47);
+}
+
+static void dbgp_get_data(void *buf, int size)
+{
+	unsigned char *bytes = buf;
+	unsigned lo, hi;
+	int i;
+
+	lo = readl(&ehci_debug->data03);
+	hi = readl(&ehci_debug->data47);
+	for (i = 0; i < 4 && i < size; i++)
+		bytes[i] = (lo >> (8*i)) & 0xff;
+	for (; i < 8 && i < size; i++)
+		bytes[i] = (hi >> (8*(i - 4))) & 0xff;
+}
+
+static int dbgp_bulk_write(unsigned devnum, unsigned endpoint,
+			 const char *bytes, int size)
+{
+	unsigned pids, addr, ctrl;
+	int ret;
+
+	if (size > DBGP_MAX_PACKET)
+		return -1;
+
+	addr = DBGP_EPADDR(devnum, endpoint);
+
+	pids = readl(&ehci_debug->pids);
+	pids = dbgp_pid_update(pids, USB_PID_OUT);
+
+	ctrl = readl(&ehci_debug->control);
+	ctrl = dbgp_len_update(ctrl, size);
+	ctrl |= DBGP_OUT;
+	ctrl |= DBGP_GO;
+
+	dbgp_set_data(bytes, size);
+	writel(addr, &ehci_debug->address);
+	writel(pids, &ehci_debug->pids);
+
+	ret = dbgp_wait_until_done(ctrl);
+	if (ret < 0)
+		return ret;
+
+	return ret;
+}
+
+static int dbgp_bulk_read(unsigned devnum, unsigned endpoint, void *data,
+				 int size)
+{
+	unsigned pids, addr, ctrl;
+	int ret;
+
+	if (size > DBGP_MAX_PACKET)
+		return -1;
+
+	addr = DBGP_EPADDR(devnum, endpoint);
+
+	pids = readl(&ehci_debug->pids);
+	pids = dbgp_pid_update(pids, USB_PID_IN);
+
+	ctrl = readl(&ehci_debug->control);
+	ctrl = dbgp_len_update(ctrl, size);
+	ctrl &= ~DBGP_OUT;
+	ctrl |= DBGP_GO;
+
+	writel(addr, &ehci_debug->address);
+	writel(pids, &ehci_debug->pids);
+	ret = dbgp_wait_until_done(ctrl);
+	if (ret < 0)
+		return ret;
+	if (size > ret)
+		size = ret;
+	dbgp_get_data(data, size);
+	return ret;
+}
+
+static int dbgp_control_msg(unsigned devnum, int requesttype, int request,
+	int value, int index, void *data, int size)
+{
+	unsigned pids, addr, ctrl;
+	struct usb_ctrlrequest req;
+	int read;
+	int ret;
+
+	read = (requesttype & USB_DIR_IN) != 0;
+	if (size > (read ? DBGP_MAX_PACKET:0))
+		return -1;
+
+	/* Compute the control message */
+	req.bRequestType = requesttype;
+	req.bRequest = request;
+	req.wValue = value;
+	req.wIndex = index;
+	req.wLength = size;
+
+	pids = DBGP_PID_SET(USB_PID_DATA0, USB_PID_SETUP);
+	addr = DBGP_EPADDR(devnum, 0);
+
+	ctrl = readl(&ehci_debug->control);
+	ctrl = dbgp_len_update(ctrl, sizeof(req));
+	ctrl |= DBGP_OUT;
+	ctrl |= DBGP_GO;
+
+	/* Send the setup message */
+	dbgp_set_data(&req, sizeof(req));
+	writel(addr, &ehci_debug->address);
+	writel(pids, &ehci_debug->pids);
+	ret = dbgp_wait_until_done(ctrl);
+	if (ret < 0)
+		return ret;
+
+	/* Read the result */
+	ret = dbgp_bulk_read(devnum, 0, data, size);
+	return ret;
+}
+
+
+/* Find a PCI capability */
+static __u32 __init find_cap(int num, int slot, int func, int cap)
+{
+	u8 pos;
+	int bytes;
+
+	if (!(read_pci_config_16(num, slot, func, PCI_STATUS) &
+		PCI_STATUS_CAP_LIST))
+		return 0;
+	pos = read_pci_config_byte(num, slot, func, PCI_CAPABILITY_LIST);
+	for (bytes = 0; bytes < 48 && pos >= 0x40; bytes++) {
+		u8 id;
+		pos &= ~3;
+		id = read_pci_config_byte(num, slot, func, pos+PCI_CAP_LIST_ID);
+		if (id == 0xff)
+			break;
+		if (id == cap)
+			return pos;
+		pos = read_pci_config_byte(num, slot, func,
+						 pos+PCI_CAP_LIST_NEXT);
+	}
+	return 0;
+}
+
+static __u32 __init find_dbgp(int ehci_num, unsigned *rbus, unsigned *rslot,
+				unsigned *rfunc)
+{
+	unsigned bus, slot, func;
+
+	for (bus = 0; bus < 256; bus++) {
+		for (slot = 0; slot < 32; slot++) {
+			for (func = 0; func < 8; func++) {
+				u32 class;
+				unsigned cap;
+
+				class = read_pci_config(bus, slot, func,
+							 PCI_CLASS_REVISION);
+				if ((class >> 8) != PCI_CLASS_SERIAL_USB_EHCI)
+					continue;
+				cap = find_cap(bus, slot, func,
+						 PCI_CAP_ID_EHCI_DEBUG);
+				if (!cap)
+					continue;
+				if (ehci_num-- != 0)
+					continue;
+				*rbus = bus;
+				*rslot = slot;
+				*rfunc = func;
+				return cap;
+			}
+		}
+	}
+	return 0;
+}
+
+static int ehci_reset_port(int port)
+{
+	unsigned portsc;
+	unsigned delay_time, delay;
+	int loop;
+
+	/* Reset the usb debug port */
+	portsc = readl(&ehci_regs->port_status[port - 1]);
+	portsc &= ~PORT_PE;
+	portsc |= PORT_RESET;
+	writel(portsc, &ehci_regs->port_status[port - 1]);
+
+	delay = HUB_ROOT_RESET_TIME;
+	for (delay_time = 0; delay_time < HUB_RESET_TIMEOUT;
+	     delay_time += delay) {
+		dbgp_mdelay(delay);
+
+		portsc = readl(&ehci_regs->port_status[port - 1]);
+		if (portsc & PORT_RESET) {
+			/* force reset to complete */
+			loop = 2;
+			writel(portsc & ~(PORT_RWC_BITS | PORT_RESET),
+				&ehci_regs->port_status[port - 1]);
+			do {
+				portsc = readl(&ehci_regs->port_status[port-1]);
+			} while ((portsc & PORT_RESET) && (--loop > 0));
+		}
+
+		/* Device went away? */
+		if (!(portsc & PORT_CONNECT))
+			return -ENOTCONN;
+
+		/* bomb out completely if something weird happend */
+		if ((portsc & PORT_CSC))
+			return -EINVAL;
+
+		/* If we've finished resetting, then break out of the loop */
+		if (!(portsc & PORT_RESET) && (portsc & PORT_PE))
+			return 0;
+	}
+	return -EBUSY;
+}
+
+static int ehci_wait_for_port(int port)
+{
+	unsigned status;
+	int ret, reps;
+
+	for (reps = 0; reps < 3; reps++) {
+		dbgp_mdelay(100);
+		status = readl(&ehci_regs->status);
+		if (status & STS_PCD) {
+			ret = ehci_reset_port(port);
+			if (ret == 0)
+				return 0;
+		}
+	}
+	return -ENOTCONN;
+}
+
+
+#define DBGP_DEBUG 0
+#if DBGP_DEBUG
+# define dbgp_printk early_printk
+#else
+static inline void dbgp_printk(const char *fmt, ...) { }
+#endif
+
+static int ehci_setup(void)
+{
+	unsigned cmd, ctrl, status, portsc, hcs_params, debug_port, n_ports;
+	int ret;
+	int loop;
+
+	hcs_params = readl(&ehci_caps->hcs_params);
+	debug_port = HCS_DEBUG_PORT(hcs_params);
+	n_ports    = HCS_N_PORTS(hcs_params);
+
+	dbgp_printk("debug_port: %d\n", debug_port);
+	dbgp_printk("n_ports:    %d\n", n_ports);
+
+	loop = 10;
+	/* Reset the EHCI controller */
+	cmd = readl(&ehci_regs->command);
+	cmd |= CMD_RESET;
+	writel(cmd, &ehci_regs->command);
+	do {
+		cmd = readl(&ehci_regs->command);
+	} while ((cmd & CMD_RESET) && (--loop > 0));
+
+	/* Claim ownership, but do not enable yet */
+	ctrl = readl(&ehci_debug->control);
+	ctrl |= DBGP_OWNER;
+	ctrl &= ~(DBGP_ENABLED | DBGP_INUSE);
+	writel(ctrl, &ehci_debug->control);
+
+	/* Start the ehci running */
+	cmd = readl(&ehci_regs->command);
+	cmd &= ~(CMD_LRESET | CMD_IAAD | CMD_PSE | CMD_ASE | CMD_RESET);
+	cmd |= CMD_RUN;
+	writel(cmd, &ehci_regs->command);
+
+	/* Ensure everything is routed to the EHCI */
+	writel(FLAG_CF, &ehci_regs->configured_flag);
+
+	/* Wait until the controller is no longer halted */
+	loop = 10;
+	do {
+		status = readl(&ehci_regs->status);
+	} while ((status & STS_HALT) && (--loop > 0));
+
+	/* Wait for a device to show up in the debug port */
+	ret = ehci_wait_for_port(debug_port);
+	if (ret < 0) {
+		dbgp_printk("No device found in debug port\n");
+		return -1;
+	}
+
+	/* Enable the debug port */
+	ctrl = readl(&ehci_debug->control);
+	ctrl |= DBGP_CLAIM;
+	writel(ctrl, &ehci_debug->control);
+	ctrl = readl(&ehci_debug->control);
+	if ((ctrl & DBGP_CLAIM) != DBGP_CLAIM) {
+		dbgp_printk("No device in debug port\n");
+		writel(ctrl & ~DBGP_CLAIM, &ehci_debug->control);
+		return -1;
+
+	}
+
+	/* Completely transfer the debug device to the debug controller */
+	portsc = readl(&ehci_regs->port_status[debug_port - 1]);
+	portsc &= ~PORT_PE;
+	writel(portsc, &ehci_regs->port_status[debug_port - 1]);
+
+	return 0;
+}
+
+static int __init early_dbgp_init(char *s)
+{
+	struct usb_debug_descriptor dbgp_desc;
+	void __iomem *ehci_bar;
+	unsigned ctrl, devnum;
+	unsigned bus, slot, func, cap;
+	unsigned debug_port, bar, offset;
+	unsigned bar_val;
+	char *e;
+	int ret;
+	unsigned dbgp_num;
+
+	if (!early_pci_allowed())
+		return -1;
+
+	dbgp_num = 0;
+	if (*s)
+		dbgp_num = strict_strtoul(s, 10, &e);
+	dbgp_printk("dbgp_num: %d\n", dbgp_num);
+	cap = find_dbgp(dbgp_num, &bus, &slot, &func);
+	if (!cap)
+		return -1;
+
+	dbgp_printk("Found EHCI debug port\n");
+
+	debug_port = read_pci_config(bus, slot, func, cap);
+	bar = (debug_port >> 29) & 0x7;
+	bar = (bar * 4) + 0xc;
+	offset = (debug_port >> 16) & 0xfff;
+	dbgp_printk("bar: %02x offset: %03x\n", bar, offset);
+	if (bar != PCI_BASE_ADDRESS_0) {
+		dbgp_printk("only debug ports on bar 1 handled.\n");
+		return -1;
+	}
+
+	bar_val = read_pci_config(bus, slot, func, PCI_BASE_ADDRESS_0);
+	dbgp_printk("bar_val: %02x offset: %03x\n", bar_val, offset);
+	if (bar_val & ~PCI_BASE_ADDRESS_MEM_MASK) {
+		dbgp_printk("only simple 32bit mmio bars supported\n");
+		return -1;
+	}
+
+
+	/* FIXME I don't have the bar size so just guess PAGE_SIZE is more
+	 * than enough.  1K is the biggest I have seen.
+	 */
+	set_fixmap_nocache(FIX_DBGP_BASE, bar_val & PAGE_MASK);
+	ehci_bar = (void __iomem *)__fix_to_virt(FIX_DBGP_BASE);
+	ehci_bar += bar_val & ~PAGE_MASK;
+	dbgp_printk("ehci_bar: %p\n", ehci_bar);
+
+	ehci_caps  = ehci_bar;
+	ehci_regs  = ehci_bar + HC_LENGTH(readl(&ehci_caps->hc_capbase));
+	ehci_debug = ehci_bar + offset;
+
+	ret = ehci_setup();
+	if (ret < 0) {
+		dbgp_printk("ehci_setup failed\n");
+		ehci_debug = 0;
+		return -1;
+	}
+	dbgp_mdelay(100);
+
+	/* Find the debug device and make it device number 127 */
+	for (devnum = 0; devnum <= 127; devnum++) {
+		ret = dbgp_control_msg(devnum,
+			USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_DEVICE,
+			USB_REQ_GET_DESCRIPTOR, (USB_DT_DEBUG << 8), 0,
+			&dbgp_desc, sizeof(dbgp_desc));
+		if (ret > 0)
+			break;
+	}
+	if (devnum > 127) {
+		dbgp_printk("Could not find attached debug device\n");
+		goto err;
+	}
+	if (ret < 0) {
+		dbgp_printk("Attached device is not a debug device\n");
+		goto err;
+	}
+	dbgp_endpoint_out = dbgp_desc.bDebugOutEndpoint;
+
+	/* Move the device to 127 if it isn't already there */
+	if (devnum != USB_DEBUG_DEVNUM) {
+		ret = dbgp_control_msg(devnum,
+			USB_DIR_OUT | USB_TYPE_STANDARD | USB_RECIP_DEVICE,
+			USB_REQ_SET_ADDRESS, USB_DEBUG_DEVNUM, 0, NULL, 0);
+		if (ret < 0) {
+			dbgp_printk("Could not move attached device to %d\n",
+				USB_DEBUG_DEVNUM);
+			goto err;
+		}
+		devnum = USB_DEBUG_DEVNUM;
+	}
+
+	/* Enable the debug interface */
+	ret = dbgp_control_msg(USB_DEBUG_DEVNUM,
+		USB_DIR_OUT | USB_TYPE_STANDARD | USB_RECIP_DEVICE,
+		USB_REQ_SET_FEATURE, USB_DEVICE_DEBUG_MODE, 0, NULL, 0);
+	if (ret < 0) {
+		dbgp_printk(" Could not enable the debug device\n");
+		goto err;
+	}
+
+	/* Perform a small write to get the even/odd data state in sync
+	 */
+	ret = dbgp_bulk_write(USB_DEBUG_DEVNUM, dbgp_endpoint_out, " ", 1);
+	if (ret < 0) {
+		dbgp_printk("dbgp_bulk_write failed: %d\n", ret);
+		goto err;
+	}
+
+
+	return 0;
+err:
+	/* Things didn't work so remove my claim */
+	ctrl = readl(&ehci_debug->control);
+	ctrl &= ~(DBGP_CLAIM | DBGP_OUT);
+	writel(ctrl, &ehci_debug->control);
+	ehci_debug = 0;
+
+	return -1;
+}
+
+static void early_dbgp_write(struct console *con, const char *str, unsigned n)
+{
+	int chunk, ret;
+
+	if (!ehci_debug)
+		return;
+	while (n > 0) {
+		chunk = n;
+		if (chunk > DBGP_MAX_PACKET)
+			chunk = DBGP_MAX_PACKET;
+		ret = dbgp_bulk_write(USB_DEBUG_DEVNUM,
+			dbgp_endpoint_out, str, chunk);
+		str += chunk;
+		n -= chunk;
+	}
+}
+
+static struct console early_dbgp_console = {
+	.name =		"earlydbg",
+	.write =	early_dbgp_write,
+	.flags =	CON_PRINTBUFFER,
+	.index =	-1,
+};
+
 /* Console interface to a host file on AMD's SimNow! */
 
 static int simnow_fd;
@@ -165,6 +771,7 @@ enum {
 static noinline long simnow(long cmd, long a, long b, long c)
 {
 	long ret;
+
 	asm volatile("cpuid" :
 		     "=a" (ret) :
 		     "b" (a), "c" (b), "d" (c), "0" (MAGIC1), "D" (cmd + MAGIC2));
@@ -174,6 +781,7 @@ static noinline long simnow(long cmd, lo
 static void __init simnow_init(char *str)
 {
 	char *fn = "klog";
+
 	if (*str == '=')
 		fn = ++str;
 	/* error ignored */
@@ -208,10 +816,11 @@ asmlinkage void early_printk(const char 
 	va_end(ap);
 }
 
-static int __initdata keep_early;
 
 static int __init setup_early_printk(char *buf)
 {
+	int keep_early;
+
 	if (!buf)
 		return 0;
 
@@ -219,8 +828,7 @@ static int __init setup_early_printk(cha
 		return 0;
 	early_console_initialized = 1;
 
-	if (strstr(buf, "keep"))
-		keep_early = 1;
+	keep_early = (strstr(buf, "keep") != NULL);
 
 	if (!strncmp(buf, "serial", 6)) {
 		early_serial_init(buf + 6);
@@ -238,6 +846,15 @@ static int __init setup_early_printk(cha
 		simnow_init(buf + 6);
 		early_console = &simnow_console;
 		keep_early = 1;
+	} else if (!strncmp(buf, "dbgp", 4)) {
+		if (early_dbgp_init(buf+4) < 0)
+			return 0;
+		early_console = &early_dbgp_console;
+		/*
+		 * usb subsys will reset ehci controller, so don't keep
+		 * that early console
+		 */
+		keep_early = 0;
 #ifdef CONFIG_HVC_XEN
 	} else if (!strncmp(buf, "xen", 3)) {
 		early_console = &xenboot_console;
@@ -251,4 +868,23 @@ static int __init setup_early_printk(cha
 	register_console(early_console);
 	return 0;
 }
+
+void __init enable_debug_console(char *buf)
+{
+#if DBGP_DEBUG
+	struct console *old_early_console = NULL;
+
+	if (early_console_initialized && early_console) {
+		old_early_console = early_console;
+		unregister_console(early_console);
+		early_console_initialized = 0;
+	}
+
+	setup_early_printk(buf);
+
+	if (early_console == old_early_console && old_early_console)
+		register_console(old_early_console);
+#endif
+}
+
 early_param("earlyprintk", setup_early_printk);
diff -puN drivers/usb/host/ehci.h~x86-usb-debug-port-early-console-v2 drivers/usb/host/ehci.h
--- a/drivers/usb/host/ehci.h~x86-usb-debug-port-early-console-v2
+++ a/drivers/usb/host/ehci.h
@@ -62,6 +62,7 @@ struct ehci_stats {
 
 #define	EHCI_MAX_ROOT_PORTS	15		/* see HCS_N_PORTS */
 
+#ifndef EARLY_PRINTK
 struct ehci_hcd {			/* one per controller */
 	/* glue to PCI and HCD framework */
 	struct ehci_caps __iomem *caps;
@@ -207,6 +208,7 @@ timer_action (struct ehci_hcd *ehci, enu
 		mod_timer(&ehci->watchdog, t + jiffies);
 	}
 }
+#endif /* EARLY_PRINTK */
 
 /*-------------------------------------------------------------------------*/
 
@@ -352,6 +354,8 @@ struct ehci_dbg_port {
 
 #define	QTD_NEXT(ehci, dma)	cpu_to_hc32(ehci, (u32)dma)
 
+#ifndef EARLY_PRINTK
+
 /*
  * EHCI Specification 0.95 Section 3.5
  * QTD: describe data transfer components (buffer, direction, ...)
@@ -392,7 +396,7 @@ struct ehci_qtd {
 	struct urb		*urb;			/* qtd's urb */
 	size_t			length;			/* length of buffer */
 } __attribute__ ((aligned (32)));
-
+#endif
 /* mask NakCnt+T in qh->hw_alt_next */
 #define QTD_MASK(ehci)	cpu_to_hc32 (ehci, ~0x1f)
 
@@ -449,6 +453,7 @@ union ehci_shadow {
  * These appear in both the async and (for interrupt) periodic schedules.
  */
 
+#ifndef EARLY_PRINTK
 struct ehci_qh {
 	/* first part defined by EHCI spec */
 	__hc32			hw_next;	/* see EHCI 3.6.1 */
@@ -504,6 +509,7 @@ struct ehci_qh {
 #define NO_FRAME ((unsigned short)~0)			/* pick new start */
 	struct usb_device	*dev;		/* access to TT */
 } __attribute__ ((aligned (32)));
+#endif /* EARLY_PRITNK */
 
 /*-------------------------------------------------------------------------*/
 
@@ -517,6 +523,7 @@ struct ehci_iso_packet {
 	u32			buf1;
 };
 
+#ifndef EARLY_PRINTK
 /* temporary schedule data for packets from iso urbs (both speeds)
  * each packet is one logical usb transaction to the device (not TT),
  * beginning at stream->next_uframe
@@ -651,6 +658,7 @@ struct ehci_sitd {
 	unsigned		frame;
 	unsigned		index;
 } __attribute__ ((aligned (32)));
+#endif
 
 /*-------------------------------------------------------------------------*/
 
@@ -672,6 +680,8 @@ struct ehci_fstn {
 	union ehci_shadow	fstn_next;	/* ptr to periodic q entry */
 } __attribute__ ((aligned (32)));
 
+#ifndef EARLY_PRINTK
+
 /*-------------------------------------------------------------------------*/
 
 #ifdef CONFIG_USB_EHCI_ROOT_HUB_TT
@@ -843,4 +853,6 @@ static inline u32 hc32_to_cpup (const st
 
 /*-------------------------------------------------------------------------*/
 
+#endif /* EARLY_PRINTK */
+
 #endif /* __LINUX_EHCI_HCD_H */
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

origin.patch
linux-next.patch
x86-usb-debug-port-early-console-v2.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
bootmem-free-reserve-helpers.patch
bootmem-free-reserve-helpers-fix.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
bootmem-respect-goal-more-likely.patch
bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes.patch
memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove.patch

