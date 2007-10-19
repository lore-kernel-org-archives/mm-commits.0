From: akpm@linux-foundation.org
Subject: - console-events-and-accessibility.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:49:19 -0700
Message-ID: <200710192249.l9JMnJoT023955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36310 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756005AbXJSWt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 18:49:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     Console events and accessibility
has been removed from the -mm tree.  Its filename was
     console-events-and-accessibility.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Console events and accessibility
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Some external modules like Speakup need to monitor console output.

This adds a VT notifier that such modules can use to get console output events:
allocation, deallocation, writes, other updates (cursor position, switch, etc.)

[akpm@linux-foundation.org: fix headers_check]
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c        |   45 ++++++++++++++++++++++++++++++++++++-
 include/linux/notifier.h |    6 ++++
 include/linux/vt.h       |   12 +++++++++
 3 files changed, 62 insertions(+), 1 deletion(-)

diff -puN drivers/char/vt.c~console-events-and-accessibility drivers/char/vt.c
--- a/drivers/char/vt.c~console-events-and-accessibility
+++ a/drivers/char/vt.c
@@ -99,6 +99,7 @@
 #include <linux/pm.h>
 #include <linux/font.h>
 #include <linux/bitops.h>
+#include <linux/notifier.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
@@ -223,6 +224,35 @@ enum {
 };
 
 /*
+ * Notifier list for console events.
+ */
+static ATOMIC_NOTIFIER_HEAD(vt_notifier_list);
+
+int register_vt_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&vt_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(register_vt_notifier);
+
+int unregister_vt_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&vt_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(unregister_vt_notifier);
+
+static void notify_write(struct vc_data *vc, unsigned int unicode)
+{
+	struct vt_notifier_param param = { .vc = vc, unicode = unicode };
+	atomic_notifier_call_chain(&vt_notifier_list, VT_WRITE, &param);
+}
+
+static void notify_update(struct vc_data *vc)
+{
+	struct vt_notifier_param param = { .vc = vc };
+	atomic_notifier_call_chain(&vt_notifier_list, VT_UPDATE, &param);
+}
+
+/*
  *	Low-Level Functions
  */
 
@@ -718,6 +748,7 @@ int vc_allocate(unsigned int currcons)	/
 		return -ENXIO;
 	if (!vc_cons[currcons].d) {
 	    struct vc_data *vc;
+	    struct vt_notifier_param param;
 
 	    /* prevent users from taking too much memory */
 	    if (currcons >= MAX_NR_USER_CONSOLES && !capable(CAP_SYS_RESOURCE))
@@ -729,7 +760,7 @@ int vc_allocate(unsigned int currcons)	/
 	    /* although the numbers above are not valid since long ago, the
 	       point is still up-to-date and the comment still has its value
 	       even if only as a historical artifact.  --mj, July 1998 */
-	    vc = kzalloc(sizeof(struct vc_data), GFP_KERNEL);
+	    param.vc = vc = kzalloc(sizeof(struct vc_data), GFP_KERNEL);
 	    if (!vc)
 		return -ENOMEM;
 	    vc_cons[currcons].d = vc;
@@ -746,6 +777,7 @@ int vc_allocate(unsigned int currcons)	/
 	    }
 	    vc->vc_kmalloced = 1;
 	    vc_init(vc, vc->vc_rows, vc->vc_cols, 1);
+	    atomic_notifier_call_chain(&vt_notifier_list, VT_ALLOCATE, &param);
 	}
 	return 0;
 }
@@ -907,6 +939,8 @@ void vc_deallocate(unsigned int currcons
 
 	if (vc_cons_allocated(currcons)) {
 		struct vc_data *vc = vc_cons[currcons].d;
+		struct vt_notifier_param param = { .vc = vc };
+		atomic_notifier_call_chain(&vt_notifier_list, VT_DEALLOCATE, &param);
 		vc->vc_sw->con_deinit(vc);
 		put_pid(vc->vt_pid);
 		module_put(vc->vc_sw->owner);
@@ -1019,6 +1053,7 @@ static void lf(struct vc_data *vc)
 		vc->vc_pos += vc->vc_size_row;
 	}
 	vc->vc_need_wrap = 0;
+	notify_write(vc, '\n');
 }
 
 static void ri(struct vc_data *vc)
@@ -1039,6 +1074,7 @@ static inline void cr(struct vc_data *vc
 {
 	vc->vc_pos -= vc->vc_x << 1;
 	vc->vc_need_wrap = vc->vc_x = 0;
+	notify_write(vc, '\r');
 }
 
 static inline void bs(struct vc_data *vc)
@@ -1047,6 +1083,7 @@ static inline void bs(struct vc_data *vc
 		vc->vc_pos -= 2;
 		vc->vc_x--;
 		vc->vc_need_wrap = 0;
+		notify_write(vc, '\b');
 	}
 }
 
@@ -1593,6 +1630,7 @@ static void do_con_trol(struct tty_struc
 				break;
 		}
 		vc->vc_pos += (vc->vc_x << 1);
+		notify_write(vc, '\t');
 		return;
 	case 10: case 11: case 12:
 		lf(vc);
@@ -2252,6 +2290,7 @@ rescan_last_byte:
 				tc = conv_uni_to_pc(vc, ' '); /* A space is printed in the second column */
 				if (tc < 0) tc = ' ';
 			}
+			notify_write(vc, c);
 
 			if (inverse) {
 				FLUSH
@@ -2274,6 +2313,7 @@ rescan_last_byte:
 	release_console_sem();
 
 out:
+	notify_update(vc);
 	return n;
 #undef FLUSH
 }
@@ -2317,6 +2357,7 @@ static void console_callback(struct work
 		do_blank_screen(0);
 		blank_timer_expired = 0;
 	}
+	notify_update(vc_cons[fg_console].d);
 
 	release_console_sem();
 }
@@ -2418,6 +2459,7 @@ static void vt_console_print(struct cons
 				continue;
 		}
 		scr_writew((vc->vc_attr << 8) + c, (unsigned short *)vc->vc_pos);
+		notify_write(vc, c);
 		cnt++;
 		if (myx == vc->vc_cols - 1) {
 			vc->vc_need_wrap = 1;
@@ -2436,6 +2478,7 @@ static void vt_console_print(struct cons
 		}
 	}
 	set_cursor(vc);
+	notify_update(vc);
 
 quit:
 	clear_bit(0, &printing);
diff -puN include/linux/notifier.h~console-events-and-accessibility include/linux/notifier.h
--- a/include/linux/notifier.h~console-events-and-accessibility
+++ a/include/linux/notifier.h
@@ -242,5 +242,11 @@ static inline int notifier_to_errno(int 
 
 extern struct blocking_notifier_head reboot_notifier_list;
 
+/* Virtual Terminal events. */
+#define VT_ALLOCATE		0x0001 /* Console got allocated */
+#define VT_DEALLOCATE		0x0002 /* Console will be deallocated */
+#define VT_WRITE		0x0003 /* A char got output */
+#define VT_UPDATE		0x0004 /* A bigger update occurred */
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
diff -puN include/linux/vt.h~console-events-and-accessibility include/linux/vt.h
--- a/include/linux/vt.h~console-events-and-accessibility
+++ a/include/linux/vt.h
@@ -1,6 +1,18 @@
 #ifndef _LINUX_VT_H
 #define _LINUX_VT_H
 
+#ifdef __KERNEL__
+struct notifier_block;
+
+struct vt_notifier_param {
+	struct vc_data *vc;	/* VC on which the update happened */
+	unsigned int c;		/* Printed char */
+};
+
+extern int register_vt_notifier(struct notifier_block *nb);
+extern int unregister_vt_notifier(struct notifier_block *nb);
+#endif
+
 /*
  * These constants are also useful for user-level apps (e.g., VC
  * resizing).
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

origin.patch
