From: akpm@linux-foundation.org
Subject: - basic-braille-screen-reader-support.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:33 -0700
Message-ID: <200805010932.m419WXef030995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757335AbYEAJe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, alan@redhat.com, dtor@mail.ru, jikos@jikos.cz, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Basic braille screen reader support
has been removed from the -mm tree.  Its filename was
     basic-braille-screen-reader-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Basic braille screen reader support
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

This adds a minimalistic braille screen reader support.  This is meant to
be used by blind people e.g.  on boot failures or when / cannot be mounted
etc and thus the userland screen readers can not work.

[akpm@linux-foundation.org: fix exports]
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Jiri Kosina <jikos@jikos.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/braille-console.txt               |   34 +
 Documentation/kernel-parameters.txt             |    5 
 arch/powerpc/kernel/ppc_ksyms.c                 |    3 
 arch/ppc/kernel/ppc_ksyms.c                     |    3 
 drivers/Kconfig                                 |    2 
 drivers/Makefile                                |    1 
 drivers/accessibility/Kconfig                   |   23 
 drivers/accessibility/Makefile                  |    1 
 drivers/accessibility/braille/Makefile          |    1 
 drivers/accessibility/braille/braille_console.c |  397 ++++++++++++++
 drivers/char/consolemap.c                       |    1 
 drivers/char/keyboard.c                         |    2 
 drivers/char/vt.c                               |    1 
 include/linux/console.h                         |    4 
 kernel/printk.c                                 |   90 ++-
 15 files changed, 538 insertions(+), 30 deletions(-)

diff -puN /dev/null Documentation/braille-console.txt
--- /dev/null
+++ a/Documentation/braille-console.txt
@@ -0,0 +1,34 @@
+                       Linux Braille Console
+
+To get early boot messages on a braille device (before userspace screen
+readers can start), you first need to compile the support for the usual serial
+console (see serial-console.txt), and for braille device (in Device Drivers -
+Accessibility).
+
+Then you need to specify a console=brl, option on the kernel command line, the
+format is:
+
+	console=brl,serial_options...
+
+where serial_options... are the same as described in serial-console.txt
+
+So for instance you can use console=brl,ttyS0 if the braille device is connected
+to the first serial port, and console=brl,ttyS0,115200 to override the baud rate
+to 115200, etc.
+
+By default, the braille device will just show the last kernel message (console
+mode).  To review previous messages, press the Insert key to switch to the VT
+review mode.  In review mode, the arrow keys permit to browse in the VT content,
+page up/down keys go at the top/bottom of the screen, and the home key goes back
+to the cursor, hence providing very basic screen reviewing facility.
+
+Sound feedback can be obtained by adding the braille_console.sound=1 kernel
+parameter.
+
+For simplicity, only one braille console can be enabled, other uses of
+console=brl,... will be discarded.  Also note that it does not interfere with
+the console selection mecanism described in serial-console.txt
+
+For now, only the VisioBraille device is supported.
+
+Samuel Thibault <samuel.thibault@ens-lyon.org>
diff -puN Documentation/kernel-parameters.txt~basic-braille-screen-reader-support Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~basic-braille-screen-reader-support
+++ a/Documentation/kernel-parameters.txt
@@ -496,6 +496,11 @@ and is between 256 and 4096 characters. 
 			switching to the matching ttyS device later.  The
 			options are the same as for ttyS, above.
 
+                If the device connected to the port is not a TTY but a braille
+                device, prepend "brl," before the device type, for instance
+			console=brl,ttyS0
+		For now, only VisioBraille is supported.
+
 	earlycon=	[KNL] Output early console device and options.
 		uart[8250],io,<addr>[,options]
 		uart[8250],mmio,<addr>[,options]
diff -puN arch/powerpc/kernel/ppc_ksyms.c~basic-braille-screen-reader-support arch/powerpc/kernel/ppc_ksyms.c
--- a/arch/powerpc/kernel/ppc_ksyms.c~basic-braille-screen-reader-support
+++ a/arch/powerpc/kernel/ppc_ksyms.c
@@ -133,9 +133,6 @@ EXPORT_SYMBOL(adb_try_handler_change);
 EXPORT_SYMBOL(cuda_request);
 EXPORT_SYMBOL(cuda_poll);
 #endif /* CONFIG_ADB_CUDA */
-#ifdef CONFIG_VT
-EXPORT_SYMBOL(kd_mksound);
-#endif
 EXPORT_SYMBOL(to_tm);
 
 #ifdef CONFIG_PPC32
diff -puN arch/ppc/kernel/ppc_ksyms.c~basic-braille-screen-reader-support arch/ppc/kernel/ppc_ksyms.c
--- a/arch/ppc/kernel/ppc_ksyms.c~basic-braille-screen-reader-support
+++ a/arch/ppc/kernel/ppc_ksyms.c
@@ -183,9 +183,6 @@ EXPORT_SYMBOL(cuda_poll);
 #if defined(CONFIG_BOOTX_TEXT)
 EXPORT_SYMBOL(btext_update_display);
 #endif
-#ifdef CONFIG_VT
-EXPORT_SYMBOL(kd_mksound);
-#endif
 EXPORT_SYMBOL(to_tm);
 
 EXPORT_SYMBOL(pm_power_off);
diff -puN drivers/Kconfig~basic-braille-screen-reader-support drivers/Kconfig
--- a/drivers/Kconfig~basic-braille-screen-reader-support
+++ a/drivers/Kconfig
@@ -84,6 +84,8 @@ source "drivers/memstick/Kconfig"
 
 source "drivers/leds/Kconfig"
 
+source "drivers/accessibility/Kconfig"
+
 source "drivers/infiniband/Kconfig"
 
 source "drivers/edac/Kconfig"
diff -puN drivers/Makefile~basic-braille-screen-reader-support drivers/Makefile
--- a/drivers/Makefile~basic-braille-screen-reader-support
+++ a/drivers/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_WATCHDOG)		+= watchdog/
 obj-$(CONFIG_PHONE)		+= telephony/
 obj-$(CONFIG_MD)		+= md/
 obj-$(CONFIG_BT)		+= bluetooth/
+obj-$(CONFIG_ACCESSIBILITY)	+= accessibility/
 obj-$(CONFIG_ISDN)		+= isdn/
 obj-$(CONFIG_EDAC)		+= edac/
 obj-$(CONFIG_MCA)		+= mca/
diff -puN /dev/null drivers/accessibility/Kconfig
--- /dev/null
+++ a/drivers/accessibility/Kconfig
@@ -0,0 +1,23 @@
+menuconfig ACCESSIBILITY
+	bool "Accessibility support"
+	---help---
+	  Enable a submenu where accessibility items may be enabled.
+
+	  If unsure, say N.
+
+if ACCESSIBILITY
+config A11Y_BRAILLE_CONSOLE
+	bool "Console on braille device"
+	depends on VT
+	depends on SERIAL_CORE_CONSOLE
+	---help---
+	  Enables console output on a braille device connected to a 8250
+	  serial port. For now only the VisioBraille device is supported.
+
+	  To actually enable it, you need to pass option
+	  console=brl,ttyS0
+	  to the kernel. Options are the same as for serial console.
+
+	  If unsure, say N.
+
+endif # ACCESSIBILITY
diff -puN /dev/null drivers/accessibility/Makefile
--- /dev/null
+++ a/drivers/accessibility/Makefile
@@ -0,0 +1 @@
+obj-y				+= braille/
diff -puN /dev/null drivers/accessibility/braille/Makefile
--- /dev/null
+++ a/drivers/accessibility/braille/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_A11Y_BRAILLE_CONSOLE)		+= braille_console.o
diff -puN /dev/null drivers/accessibility/braille/braille_console.c
--- /dev/null
+++ a/drivers/accessibility/braille/braille_console.c
@@ -0,0 +1,397 @@
+/*
+ * Minimalistic braille device kernel support.
+ *
+ * By default, shows console messages on the braille device.
+ * Pressing Insert switches to VC browsing.
+ *
+ *  Copyright (C) Samuel Thibault <samuel.thibault@ens-lyon.org>
+ *
+ * This program is free software ; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation ; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY ; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with the program ; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/autoconf.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/console.h>
+#include <linux/notifier.h>
+
+#include <linux/selection.h>
+#include <linux/vt_kern.h>
+#include <linux/consolemap.h>
+
+#include <linux/keyboard.h>
+#include <linux/kbd_kern.h>
+#include <linux/input.h>
+
+MODULE_AUTHOR("samuel.thibault@ens-lyon.org");
+MODULE_DESCRIPTION("braille device");
+MODULE_LICENSE("GPL");
+
+/*
+ * Braille device support part.
+ */
+
+/* Emit various sounds */
+static int sound;
+module_param(sound, bool, 0);
+MODULE_PARM_DESC(sound, "emit sounds");
+
+static void beep(unsigned int freq)
+{
+	if (sound)
+		kd_mksound(freq, HZ/10);
+}
+
+/* mini console */
+#define WIDTH 40
+#define BRAILLE_KEY KEY_INSERT
+static u16 console_buf[WIDTH];
+static int console_cursor;
+
+/* mini view of VC */
+static int vc_x, vc_y, lastvc_x, lastvc_y;
+
+/* show console ? (or show VC) */
+static int console_show = 1;
+/* pending newline ? */
+static int console_newline = 1;
+static int lastVC = -1;
+
+static struct console *braille_co;
+
+/* Very VisioBraille-specific */
+static void braille_write(u16 *buf)
+{
+	static u16 lastwrite[WIDTH];
+	unsigned char data[1 + 1 + 2*WIDTH + 2 + 1], csum = 0, *c;
+	u16 out;
+	int i;
+
+	if (!braille_co)
+		return;
+
+	if (!memcmp(lastwrite, buf, WIDTH * sizeof(*buf)))
+		return;
+	memcpy(lastwrite, buf, WIDTH * sizeof(*buf));
+
+#define SOH 1
+#define STX 2
+#define ETX 2
+#define EOT 4
+#define ENQ 5
+	data[0] = STX;
+	data[1] = '>';
+	csum ^= '>';
+	c = &data[2];
+	for (i = 0; i < WIDTH; i++) {
+		out = buf[i];
+		if (out >= 0x100)
+			out = '?';
+		else if (out == 0x00)
+			out = ' ';
+		csum ^= out;
+		if (out <= 0x05) {
+			*c++ = SOH;
+			out |= 0x40;
+		}
+		*c++ = out;
+	}
+
+	if (csum <= 0x05) {
+		*c++ = SOH;
+		csum |= 0x40;
+	}
+	*c++ = csum;
+	*c++ = ETX;
+
+	braille_co->write(braille_co, data, c - data);
+}
+
+/* Follow the VC cursor*/
+static void vc_follow_cursor(struct vc_data *vc)
+{
+	vc_x = vc->vc_x - (vc->vc_x % WIDTH);
+	vc_y = vc->vc_y;
+	lastvc_x = vc->vc_x;
+	lastvc_y = vc->vc_y;
+}
+
+/* Maybe the VC cursor moved, if so follow it */
+static void vc_maybe_cursor_moved(struct vc_data *vc)
+{
+	if (vc->vc_x != lastvc_x || vc->vc_y != lastvc_y)
+		vc_follow_cursor(vc);
+}
+
+/* Show portion of VC at vc_x, vc_y */
+static void vc_refresh(struct vc_data *vc)
+{
+	u16 buf[WIDTH];
+	int i;
+
+	for (i = 0; i < WIDTH; i++) {
+		u16 glyph = screen_glyph(vc,
+				2 * (vc_x + i) + vc_y * vc->vc_size_row);
+		buf[i] = inverse_translate(vc, glyph, 1);
+	}
+	braille_write(buf);
+}
+
+/*
+ * Link to keyboard
+ */
+
+static int keyboard_notifier_call(struct notifier_block *blk,
+				  unsigned long code, void *_param)
+{
+	struct keyboard_notifier_param *param = _param;
+	struct vc_data *vc = param->vc;
+	int ret = NOTIFY_OK;
+
+	if (!param->down)
+		return ret;
+
+	switch (code) {
+	case KBD_KEYCODE:
+		if (console_show) {
+			if (param->value == BRAILLE_KEY) {
+				console_show = 0;
+				beep(880);
+				vc_maybe_cursor_moved(vc);
+				vc_refresh(vc);
+				ret = NOTIFY_STOP;
+			}
+		} else {
+			ret = NOTIFY_STOP;
+			switch (param->value) {
+			case KEY_INSERT:
+				beep(440);
+				console_show = 1;
+				lastVC = -1;
+				braille_write(console_buf);
+				break;
+			case KEY_LEFT:
+				if (vc_x > 0) {
+					vc_x -= WIDTH;
+					if (vc_x < 0)
+						vc_x = 0;
+				} else if (vc_y >= 1) {
+					beep(880);
+					vc_y--;
+					vc_x = vc->vc_cols-WIDTH;
+				} else
+					beep(220);
+				break;
+			case KEY_RIGHT:
+				if (vc_x + WIDTH < vc->vc_cols) {
+					vc_x += WIDTH;
+				} else if (vc_y + 1 < vc->vc_rows) {
+					beep(880);
+					vc_y++;
+					vc_x = 0;
+				} else
+					beep(220);
+				break;
+			case KEY_DOWN:
+				if (vc_y + 1 < vc->vc_rows)
+					vc_y++;
+				else
+					beep(220);
+				break;
+			case KEY_UP:
+				if (vc_y >= 1)
+					vc_y--;
+				else
+					beep(220);
+				break;
+			case KEY_HOME:
+				vc_follow_cursor(vc);
+				break;
+			case KEY_PAGEUP:
+				vc_x = 0;
+				vc_y = 0;
+				break;
+			case KEY_PAGEDOWN:
+				vc_x = 0;
+				vc_y = vc->vc_rows-1;
+				break;
+			default:
+				ret = NOTIFY_OK;
+				break;
+			}
+			if (ret == NOTIFY_STOP)
+				vc_refresh(vc);
+		}
+		break;
+	case KBD_POST_KEYSYM:
+	{
+		unsigned char type = KTYP(param->value) - 0xf0;
+		if (type == KT_SPEC) {
+			unsigned char val = KVAL(param->value);
+			int on_off = -1;
+
+			switch (val) {
+			case KVAL(K_CAPS):
+				on_off = vc_kbd_led(kbd_table + fg_console,
+						VC_CAPSLOCK);
+				break;
+			case KVAL(K_NUM):
+				on_off = vc_kbd_led(kbd_table + fg_console,
+						VC_NUMLOCK);
+				break;
+			case KVAL(K_HOLD):
+				on_off = vc_kbd_led(kbd_table + fg_console,
+						VC_SCROLLOCK);
+				break;
+			}
+			if (on_off == 1)
+				beep(880);
+			else if (on_off == 0)
+				beep(440);
+		}
+	}
+	case KBD_UNBOUND_KEYCODE:
+	case KBD_UNICODE:
+	case KBD_KEYSYM:
+		/* Unused */
+		break;
+	}
+	return ret;
+}
+
+static struct notifier_block keyboard_notifier_block = {
+	.notifier_call = keyboard_notifier_call,
+};
+
+static int vt_notifier_call(struct notifier_block *blk,
+			    unsigned long code, void *_param)
+{
+	struct vt_notifier_param *param = _param;
+	struct vc_data *vc = param->vc;
+	switch (code) {
+	case VT_ALLOCATE:
+		break;
+	case VT_DEALLOCATE:
+		break;
+	case VT_WRITE:
+	{
+		unsigned char c = param->c;
+		if (vc->vc_num != fg_console)
+			break;
+		switch (c) {
+		case '\b':
+		case 127:
+			if (console_cursor > 0) {
+				console_cursor--;
+				console_buf[console_cursor] = ' ';
+			}
+			break;
+		case '\n':
+		case '\v':
+		case '\f':
+		case '\r':
+			console_newline = 1;
+			break;
+		case '\t':
+			c = ' ';
+			/* Fallthrough */
+		default:
+			if (c < 32)
+				/* Ignore other control sequences */
+				break;
+			if (console_newline) {
+				memset(console_buf, 0, sizeof(console_buf));
+				console_cursor = 0;
+				console_newline = 0;
+			}
+			if (console_cursor == WIDTH)
+				memmove(console_buf, &console_buf[1],
+					(WIDTH-1) * sizeof(*console_buf));
+			else
+				console_cursor++;
+			console_buf[console_cursor-1] = c;
+			break;
+		}
+		if (console_show)
+			braille_write(console_buf);
+		else {
+			vc_maybe_cursor_moved(vc);
+			vc_refresh(vc);
+		}
+		break;
+	}
+	case VT_UPDATE:
+		/* Maybe a VT switch, flush */
+		if (console_show) {
+			if (vc->vc_num != lastVC) {
+				lastVC = vc->vc_num;
+				memset(console_buf, 0, sizeof(console_buf));
+				console_cursor = 0;
+				braille_write(console_buf);
+			}
+		} else {
+			vc_maybe_cursor_moved(vc);
+			vc_refresh(vc);
+		}
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block vt_notifier_block = {
+	.notifier_call = vt_notifier_call,
+};
+
+/*
+ * Called from printk.c when console=brl is given
+ */
+
+int braille_register_console(struct console *console, int index,
+		char *console_options, char *braille_options)
+{
+	int ret;
+	if (!console_options)
+		/* Only support VisioBraille for now */
+		console_options = "57600o8";
+	if (braille_co)
+		return -ENODEV;
+	if (console->setup) {
+		ret = console->setup(console, console_options);
+		if (ret != 0)
+			return ret;
+	}
+	console->flags |= CON_ENABLED;
+	console->index = index;
+	braille_co = console;
+	return 0;
+}
+
+int braille_unregister_console(struct console *console)
+{
+	if (braille_co != console)
+		return -EINVAL;
+	braille_co = NULL;
+	return 0;
+}
+
+static int __init braille_init(void)
+{
+	register_keyboard_notifier(&keyboard_notifier_block);
+	register_vt_notifier(&vt_notifier_block);
+	return 0;
+}
+
+console_initcall(braille_init);
diff -puN drivers/char/consolemap.c~basic-braille-screen-reader-support drivers/char/consolemap.c
--- a/drivers/char/consolemap.c~basic-braille-screen-reader-support
+++ a/drivers/char/consolemap.c
@@ -277,6 +277,7 @@ u16 inverse_translate(struct vc_data *co
 			return p->inverse_translations[m][glyph];
 	}
 }
+EXPORT_SYMBOL_GPL(inverse_translate);
 
 static void update_user_maps(void)
 {
diff -puN drivers/char/keyboard.c~basic-braille-screen-reader-support drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~basic-braille-screen-reader-support
+++ a/drivers/char/keyboard.c
@@ -110,6 +110,7 @@ const int max_vals[] = {
 const int NR_TYPES = ARRAY_SIZE(max_vals);
 
 struct kbd_struct kbd_table[MAX_NR_CONSOLES];
+EXPORT_SYMBOL_GPL(kbd_table);
 static struct kbd_struct *kbd = kbd_table;
 
 struct vt_spawn_console vt_spawn_con = {
@@ -260,6 +261,7 @@ void kd_mksound(unsigned int hz, unsigne
 	} else
 		kd_nosound(0);
 }
+EXPORT_SYMBOL(kd_mksound);
 
 /*
  * Setting the keyboard rate.
diff -puN drivers/char/vt.c~basic-braille-screen-reader-support drivers/char/vt.c
--- a/drivers/char/vt.c~basic-braille-screen-reader-support
+++ a/drivers/char/vt.c
@@ -4004,6 +4004,7 @@ u16 screen_glyph(struct vc_data *vc, int
 		c |= 0x100;
 	return c;
 }
+EXPORT_SYMBOL_GPL(screen_glyph);
 
 /* used by vcs - note the word offset */
 unsigned short *screen_pos(struct vc_data *vc, int w_offset, int viewed)
diff -puN include/linux/console.h~basic-braille-screen-reader-support include/linux/console.h
--- a/include/linux/console.h~basic-braille-screen-reader-support
+++ a/include/linux/console.h
@@ -91,6 +91,7 @@ void give_up_console(const struct consw 
 #define CON_ENABLED	(4)
 #define CON_BOOT	(8)
 #define CON_ANYTIME	(16) /* Safe to call when cpu is offline */
+#define CON_BRL		(32) /* Used for a braille device */
 
 struct console {
 	char	name[16];
@@ -121,6 +122,9 @@ extern struct tty_driver *console_device
 extern void console_stop(struct console *);
 extern void console_start(struct console *);
 extern int is_console_locked(void);
+extern int braille_register_console(struct console *, int index,
+		char *console_options, char *braille_options);
+extern int braille_unregister_console(struct console *);
 
 extern int console_suspend_enabled;
 
diff -puN kernel/printk.c~basic-braille-screen-reader-support kernel/printk.c
--- a/kernel/printk.c~basic-braille-screen-reader-support
+++ a/kernel/printk.c
@@ -111,6 +111,9 @@ struct console_cmdline
 	char	name[8];			/* Name of the driver	    */
 	int	index;				/* Minor dev. to use	    */
 	char	*options;			/* Options for the driver   */
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+	char	*brl_options;			/* Options for braille driver */
+#endif
 };
 
 #define MAX_CMDLINECONSOLES 8
@@ -808,15 +811,60 @@ static void call_console_drivers(unsigne
 
 #endif
 
+static int __add_preferred_console(char *name, int idx, char *options,
+				   char *brl_options)
+{
+	struct console_cmdline *c;
+	int i;
+
+	/*
+	 *	See if this tty is not yet registered, and
+	 *	if we have a slot free.
+	 */
+	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
+		if (strcmp(console_cmdline[i].name, name) == 0 &&
+			  console_cmdline[i].index == idx) {
+				if (!brl_options)
+					selected_console = i;
+				return 0;
+		}
+	if (i == MAX_CMDLINECONSOLES)
+		return -E2BIG;
+	if (!brl_options)
+		selected_console = i;
+	c = &console_cmdline[i];
+	strlcpy(c->name, name, sizeof(c->name));
+	c->options = options;
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+	c->brl_options = brl_options;
+#endif
+	c->index = idx;
+	return 0;
+}
 /*
  * Set up a list of consoles.  Called from init/main.c
  */
 static int __init console_setup(char *str)
 {
 	char buf[sizeof(console_cmdline[0].name) + 4]; /* 4 for index */
-	char *s, *options;
+	char *s, *options, *brl_options = NULL;
 	int idx;
 
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+	if (!memcmp(str, "brl,", 4)) {
+		brl_options = "";
+		str += 4;
+	} else if (!memcmp(str, "brl=", 4)) {
+		brl_options = str + 4;
+		str = strchr(brl_options, ',');
+		if (!str) {
+			printk(KERN_ERR "need port name after brl=\n");
+			return 1;
+		}
+		*(str++) = 0;
+	}
+#endif
+
 	/*
 	 * Decode str into name, index, options.
 	 */
@@ -841,7 +889,7 @@ static int __init console_setup(char *st
 	idx = simple_strtoul(s, NULL, 10);
 	*s = 0;
 
-	add_preferred_console(buf, idx, options);
+	__add_preferred_console(buf, idx, options, brl_options);
 	return 1;
 }
 __setup("console=", console_setup);
@@ -861,28 +909,7 @@ __setup("console=", console_setup);
  */
 int add_preferred_console(char *name, int idx, char *options)
 {
-	struct console_cmdline *c;
-	int i;
-
-	/*
-	 *	See if this tty is not yet registered, and
-	 *	if we have a slot free.
-	 */
-	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
-		if (strcmp(console_cmdline[i].name, name) == 0 &&
-			  console_cmdline[i].index == idx) {
-				selected_console = i;
-				return 0;
-		}
-	if (i == MAX_CMDLINECONSOLES)
-		return -E2BIG;
-	selected_console = i;
-	c = &console_cmdline[i];
-	memcpy(c->name, name, sizeof(c->name));
-	c->name[sizeof(c->name) - 1] = 0;
-	c->options = options;
-	c->index = idx;
-	return 0;
+	return __add_preferred_console(name, idx, options, NULL);
 }
 
 int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options)
@@ -1163,6 +1190,16 @@ void register_console(struct console *co
 			continue;
 		if (console->index < 0)
 			console->index = console_cmdline[i].index;
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+		if (console_cmdline[i].brl_options) {
+			console->flags |= CON_BRL;
+			braille_register_console(console,
+					console_cmdline[i].index,
+					console_cmdline[i].options,
+					console_cmdline[i].brl_options);
+			return;
+		}
+#endif
 		if (console->setup &&
 		    console->setup(console, console_cmdline[i].options) != 0)
 			break;
@@ -1221,6 +1258,11 @@ int unregister_console(struct console *c
         struct console *a, *b;
 	int res = 1;
 
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+	if (console->flags & CON_BRL)
+		return braille_unregister_console(console);
+#endif
+
 	acquire_console_sem();
 	if (console_drivers == console) {
 		console_drivers=console->next;
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

origin.patch

