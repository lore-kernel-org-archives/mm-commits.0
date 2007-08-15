From: akpm@linux-foundation.org
Subject: + m68k-mac-make-mac_hid_mouse_emulate_buttons-declaration-visible.patch added to -mm tree
Date: Wed, 15 Aug 2007 14:18:28 -0700
Message-ID: <200708152118.l7FLISQN015494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52042 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758139AbXHOVUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 17:20:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org


The patch titled
     m68k/mac: Make mac_hid_mouse_emulate_buttons() declaration visible
has been added to the -mm tree.  Its filename is
     m68k-mac-make-mac_hid_mouse_emulate_buttons-declaration-visible.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68k/mac: Make mac_hid_mouse_emulate_buttons() declaration visible
From: Geert Uytterhoeven <geert@linux-m68k.org>

m68k/mac: Make mac_hid_mouse_emulate_buttons() declaration visible

drivers/char/keyboard.c: In function 'kbd_keycode':
drivers/char/keyboard.c:1142: error: implicit declaration of function 'mac_hid_mouse_emulate_buttons'

The forward declaration of mac_hid_mouse_emulate_buttons() is not visible on
m68k because it's hidden in the middle of a big #ifdef block.

Move it to <linux/kbd_kern.h>, correct the type of the second parameter, and
include <linux/kbd_kern.h> where needed.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/keyboard.c     |    4 ----
 drivers/macintosh/mac_hid.c |    1 +
 include/linux/kbd_kern.h    |    3 +++
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/keyboard.c~m68k-mac-make-mac_hid_mouse_emulate_buttons-declaration-visible drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~m68k-mac-make-mac_hid_mouse_emulate_buttons-declaration-visible
+++ a/drivers/char/keyboard.c
@@ -1022,10 +1022,6 @@ static const unsigned short x86_keycodes
 	308,310,313,314,315,317,318,319,320,357,322,323,324,325,276,330,
 	332,340,365,342,343,344,345,346,356,270,341,368,369,370,371,372 };
 
-#ifdef CONFIG_MAC_EMUMOUSEBTN
-extern int mac_hid_mouse_emulate_buttons(int, int, int);
-#endif /* CONFIG_MAC_EMUMOUSEBTN */
-
 #ifdef CONFIG_SPARC
 static int sparc_l1_a_state = 0;
 extern void sun_do_break(void);
diff -puN drivers/macintosh/mac_hid.c~m68k-mac-make-mac_hid_mouse_emulate_buttons-declaration-visible drivers/macintosh/mac_hid.c
--- a/drivers/macintosh/mac_hid.c~m68k-mac-make-mac_hid_mouse_emulate_buttons-declaration-visible
+++ a/drivers/macintosh/mac_hid.c
@@ -13,6 +13,7 @@
 #include <linux/sysctl.h>
 #include <linux/input.h>
 #include <linux/module.h>
+#include <linux/kbd_kern.h>
 
 
 static struct input_dev *emumousebtn;
diff -puN include/linux/kbd_kern.h~m68k-mac-make-mac_hid_mouse_emulate_buttons-declaration-visible include/linux/kbd_kern.h
--- a/include/linux/kbd_kern.h~m68k-mac-make-mac_hid_mouse_emulate_buttons-declaration-visible
+++ a/include/linux/kbd_kern.h
@@ -161,4 +161,7 @@ static inline void con_schedule_flip(str
 	schedule_delayed_work(&t->buf.work, 0);
 }
 
+/* mac_hid.c */
+extern int mac_hid_mouse_emulate_buttons(int, unsigned int, int);
+
 #endif
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68k-asm-pageh-needs-linux-compilerh.patch
m68k-kill-superfluous-extern.patch
m68k-remove-unnecessary-m68k_memoffset-export-and-init.patch
remove-dead-code-in-via-pmu68k.patch
m68k-use-_ac-instead-of-ifdef-__assembly__.patch
m68k-enable-arbitary-speed-tty-support.patch
m68k-dont-include-rodata-into-text-segment.patch
m68k-fix-a-few-hickups-in-drivers-scsi-kconfig.patch
zorro-make-sysfs-config-attribute-read-only.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons-declaration-visible.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
