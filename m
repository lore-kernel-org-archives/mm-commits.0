From: akpm@linux-foundation.org
Subject: [merged] proc-tty-switch-usb-serial-to-proc_fops.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:33:55 -0700
Message-ID: <200904011833.n31IXtlt006910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760307AbZDATOQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:14:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc tty: switch usb-serial to ->proc_fops
has been removed from the -mm tree.  Its filename was
     proc-tty-switch-usb-serial-to-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc tty: switch usb-serial to ->proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/usb-serial.c |   58 +++++++++++++-----------------
 1 file changed, 27 insertions(+), 31 deletions(-)

diff -puN drivers/usb/serial/usb-serial.c~proc-tty-switch-usb-serial-to-proc_fops drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~proc-tty-switch-usb-serial-to-proc_fops
+++ a/drivers/usb/serial/usb-serial.c
@@ -26,6 +26,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
@@ -421,57 +422,52 @@ static int serial_break(struct tty_struc
 	return 0;
 }
 
-static int serial_read_proc(char *page, char **start, off_t off, int count,
-							int *eof, void *data)
+static int serial_proc_show(struct seq_file *m, void *v)
 {
 	struct usb_serial *serial;
-	int length = 0;
 	int i;
-	off_t begin = 0;
 	char tmp[40];
 
 	dbg("%s", __func__);
-	length += sprintf(page, "usbserinfo:1.0 driver:2.0\n");
-	for (i = 0; i < SERIAL_TTY_MINORS && length < PAGE_SIZE; ++i) {
+	seq_puts(m, "usbserinfo:1.0 driver:2.0\n");
+	for (i = 0; i < SERIAL_TTY_MINORS; ++i) {
 		serial = usb_serial_get_by_index(i);
 		if (serial == NULL)
 			continue;
 
-		length += sprintf(page+length, "%d:", i);
+		seq_printf(m, "%d:", i);
 		if (serial->type->driver.owner)
-			length += sprintf(page+length, " module:%s",
+			seq_printf(m, " module:%s",
 				module_name(serial->type->driver.owner));
-		length += sprintf(page+length, " name:\"%s\"",
+		seq_printf(m, " name:\"%s\"",
 				serial->type->description);
-		length += sprintf(page+length, " vendor:%04x product:%04x",
+		seq_printf(m, " vendor:%04x product:%04x",
 			le16_to_cpu(serial->dev->descriptor.idVendor),
 			le16_to_cpu(serial->dev->descriptor.idProduct));
-		length += sprintf(page+length, " num_ports:%d",
-							serial->num_ports);
-		length += sprintf(page+length, " port:%d",
-							i - serial->minor + 1);
+		seq_printf(m, " num_ports:%d", serial->num_ports);
+		seq_printf(m, " port:%d", i - serial->minor + 1);
 		usb_make_path(serial->dev, tmp, sizeof(tmp));
-		length += sprintf(page+length, " path:%s", tmp);
+		seq_printf(m, " path:%s", tmp);
 
-		length += sprintf(page+length, "\n");
-		if ((length + begin) > (off + count)) {
-			usb_serial_put(serial);
-			goto done;
-		}
-		if ((length + begin) < off) {
-			begin += length;
-			length = 0;
-		}
+		seq_putc(m, '\n');
 		usb_serial_put(serial);
 	}
-	*eof = 1;
-done:
-	if (off >= (length + begin))
-		return 0;
-	*start = page + (off-begin);
-	return (count < begin+length-off) ? count : begin+length-off;
+	return 0;
 }
 
+static int serial_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, serial_proc_show, NULL);
+}
+
+static const struct file_operations serial_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= serial_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int serial_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -1113,9 +1109,9 @@ static const struct tty_operations seria
 	.unthrottle =		serial_unthrottle,
 	.break_ctl =		serial_break,
 	.chars_in_buffer =	serial_chars_in_buffer,
-	.read_proc =		serial_read_proc,
 	.tiocmget =		serial_tiocmget,
 	.tiocmset =		serial_tiocmset,
+	.proc_fops =		&serial_proc_fops,
 };
 
 struct tty_driver *usb_serial_tty_driver;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
sysctl-dont-take-the-use-count-of-multiple-heads-at-a-time.patch
sysctl-lockdep-support-for-sysctl-reference-counting.patch
simplify-copy_thread.patch
simplify-copy_thread-checkpatch-fixes.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers.patch
sysctl-fix-suid_dumpable-and-lease-break-time-sysctls.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch

