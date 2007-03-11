From: akpm@linux-foundation.org
Subject: - macintosh-mangle-caps-lock-events-on-adb-keyboards.patch removed from -mm tree
Date: Sat, 10 Mar 2007 23:43:54 -0800
Message-ID: <200703110743.l2B7hsxM007178@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38990 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbXCKHoT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 03:44:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wingo@pobox.com, benh@kernel.crashing.org, dtor_core@ameritech.net, hans@fugal.net, paulus@samba.org, vojtech@suse.cz, mm-commits@vger.kernel.org


The patch titled
     macintosh: mangle caps lock events on adb keyboards
has been removed from the -mm tree.  Its filename was
     macintosh-mangle-caps-lock-events-on-adb-keyboards.patch

This patch was dropped because itbrokethebuildandimtiredofcarryingitandnobodyseemsinterestedinfixingitandyouallsuckanyway

------------------------------------------------------
Subject: macintosh: mangle caps lock events on adb keyboards
From: Andy Wingo <wingo@pobox.com>

Adds a proc entry, /proc/sys/dev/adbhid/mangle_caps_lock_events, to enable
translation of the bogus 0xFF keypresses emitted by the caps lock on ADB
keyboards into normal keyup/keydown events.  This allows the caps lock key
to be remapped to a modifier, e.g.  control.

The behavior is off by default because (1) the caps lock LED toggles on
every keydown, which can be irritating, and (2) because very occasionally
the code sees spurious 0xFF events that sometimes leave the capslock
"stuck".  Tapping the key again fixes the problem.  These are known issues
with the keyboard that also show up under Mac OS Tiger when the capslock is
remapped.

Patch (without sysctl) apparently written originally for 2.4 by Gregorio
Gervas, whose email I can't find.  Ported to 2.6 by Hans Fugal
<hans@fugal.net>, and I added the /proc entry.

Given the tradeoffs when enabling this patch I chose to make the behavior
configurable.  Kinda sucks.  I'd like it upstream so I can go back to using
stock kernels though.

[akpm@osdl.org: sue CTL_UNNUMBERED]
Signed-off-by: Andy Wingo <wingo@pobox.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Dmitry Torokhov <dtor_core@ameritech.net>
Cc: Vojtech Pavlik <vojtech@suse.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/macintosh/adbhid.c |   92 ++++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff -puN drivers/macintosh/adbhid.c~macintosh-mangle-caps-lock-events-on-adb-keyboards drivers/macintosh/adbhid.c
--- a/drivers/macintosh/adbhid.c~macintosh-mangle-caps-lock-events-on-adb-keyboards
+++ a/drivers/macintosh/adbhid.c
@@ -40,6 +40,9 @@
 #include <linux/notifier.h>
 #include <linux/input.h>
 
+#include <linux/proc_fs.h>
+#include <linux/sysctl.h>
+
 #include <linux/adb.h>
 #include <linux/cuda.h>
 #include <linux/pmu.h>
@@ -52,6 +55,51 @@
 
 MODULE_AUTHOR("Franz Sirl <Franz.Sirl-kernel@lauterbach.com>");
 
+static int mangle_caps_lock_events;
+
+#ifdef CONFIG_SYSCTL
+
+/* file(s) in /proc/sys/dev/adbhid */
+ctl_table adbhid_files[] = {
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "mangle_caps_lock_events",
+		.data		= &mangle_caps_lock_events,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{ .ctl_name = 0 }
+};
+
+/* dir in /proc/sys/dev */
+ctl_table adbhid_dir[] = {
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "adbhid",
+		.maxlen		= 0,
+		.mode		= 0555,
+		.child		= adbhid_files,
+	},
+	{ .ctl_name = 0 }
+};
+
+/* /proc/sys/dev itself, in case that is not there yet */
+ctl_table adbhid_root_dir[] = {
+	{
+		.ctl_name	= CTL_DEV,
+		.procname	= "dev",
+		.maxlen		= 0,
+		.mode		= 0555,
+		.child		= adbhid_dir,
+	},
+	{ .ctl_name = 0 }
+};
+
+static struct ctl_table_header *adbhid_sysctl_header;
+
+#endif /* endif CONFIG_SYSCTL */
+
 #define KEYB_KEYREG	0	/* register # for key up/down data */
 #define KEYB_LEDREG	2	/* register # for leds on ADB keyboard */
 #define MOUSE_DATAREG	0	/* reg# for movement/button codes from mouse */
@@ -276,12 +324,50 @@ adbhid_input_keycode(int id, int keycode
 {
 	struct adbhid *ahid = adbhid[id];
 	int up_flag;
+	static int caps_lock_state = 0x0;
+
+	if (mangle_caps_lock_events) {
+		switch (keycode) {
+		case ADB_KEY_CAPSLOCK:
+			/* this is where the led transitions to on */
+			caps_lock_state = 0x3;
+			break;
+		case 0x80 | ADB_KEY_CAPSLOCK:
+			/* this is where the led transitions to off */
+			caps_lock_state = 0x0;
+			break;
+		case 0xff:
+			switch (caps_lock_state) {
+			case 0x3: /* led on, key released */
+				caps_lock_state = 0x2;
+				keycode = 0x80 | ADB_KEY_CAPSLOCK;
+				break;
+			case 0x2: /* led on, key pressed */
+				caps_lock_state = 0x1;
+				keycode = ADB_KEY_CAPSLOCK;
+				break;
+                        /* these last two cases are spurious 0xff events.
+			 * log and ignore them.
+			 */
+			case 0x0: /* led off, key pressed */
+			case 0x1: /* led off, key released */
+				printk(KERN_INFO "Spurious caps lock event "
+						"(scancode 0xff).");
+				break;
+			}
+			break;
+		}
+	}
 
 	up_flag = (keycode & 0x80);
 	keycode &= 0x7f;
 
 	switch (keycode) {
-	case ADB_KEY_CAPSLOCK: /* Generate down/up events for CapsLock everytime. */
+	case ADB_KEY_CAPSLOCK:
+		if (mangle_caps_lock_events)
+			break;
+
+		/* Generate down/up events for CapsLock everytime. */
 		input_report_key(ahid->input, KEY_CAPSLOCK, 1);
 		input_report_key(ahid->input, KEY_CAPSLOCK, 0);
 		input_sync(ahid->input);
@@ -1185,6 +1271,10 @@ static int __init adbhid_init(void)
 		return 0;
 #endif
 
+#ifdef CONFIG_SYSCTL
+	adbhid_sysctl_header = register_sysctl_table(adbhid_root_dir, 1);
+#endif /* CONFIG_SYSCTL */
+
 	led_request.complete = 1;
 
 	adbhid_probe();
_

Patches currently in -mm which might be from wingo@pobox.com are

macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
