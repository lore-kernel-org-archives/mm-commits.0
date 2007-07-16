From: akpm@linux-foundation.org
Subject: - kernel-utf-8-handling.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:51 -0700
Message-ID: <200707162055.l6GKtpaE001970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35804 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752351AbXGPVg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:36:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, adaplas@pol.net, bunk@stusta.de, dtor@mail.ru, dwmw2@infradead.org, jengelh@gmx.de, patrakov@ums.usu.ru, mm-commits@vger.kernel.org


The patch titled
     Kernel utf-8 handling
has been removed from the -mm tree.  Its filename was
     kernel-utf-8-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Kernel utf-8 handling
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

This patch fixes dead keys and copy/paste of non-ASCII characters in UTF-8
mode on Linux console.  See more details about the original patch at:
http://chris.heathens.co.nz/linux/utf8.html

Already posted on
	(Oldest) http://lkml.org/lkml/2003/5/31/148
	         http://lkml.org/lkml/2005/12/24/69
	(Recent) http://lkml.org/lkml/2006/8/7/75

[bunk@stusta.de: make drivers/char/selection.c:store_utf8() static]
Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Alexander E. Patrakov <patrakov@ums.usu.ru>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/consolemap.c  |   78 ++++++++++++++++++++++++++++++++---
 drivers/char/keyboard.c    |   26 ++++++++---
 drivers/char/selection.c   |   48 +++++++++++++++++----
 include/linux/consolemap.h |    5 +-
 4 files changed, 134 insertions(+), 23 deletions(-)

diff -puN drivers/char/consolemap.c~kernel-utf-8-handling drivers/char/consolemap.c
--- a/drivers/char/consolemap.c~kernel-utf-8-handling
+++ a/drivers/char/consolemap.c
@@ -177,6 +177,7 @@ struct uni_pagedir {
 	unsigned long	refcount;
 	unsigned long	sum;
 	unsigned char	*inverse_translations[4];
+	u16		*inverse_trans_unicode;
 	int		readonly;
 };
 
@@ -207,6 +208,41 @@ static void set_inverse_transl(struct vc
 	}
 }
 
+static void set_inverse_trans_unicode(struct vc_data *conp,
+				      struct uni_pagedir *p)
+{
+	int i, j, k, glyph;
+	u16 **p1, *p2;
+	u16 *q;
+
+	if (!p) return;
+	q = p->inverse_trans_unicode;
+	if (!q) {
+		q = p->inverse_trans_unicode =
+			kmalloc(MAX_GLYPH * sizeof(u16), GFP_KERNEL);
+		if (!q)
+			return;
+	}
+	memset(q, 0, MAX_GLYPH * sizeof(u16));
+
+	for (i = 0; i < 32; i++) {
+		p1 = p->uni_pgdir[i];
+		if (!p1)
+			continue;
+		for (j = 0; j < 32; j++) {
+			p2 = p1[j];
+			if (!p2)
+				continue;
+			for (k = 0; k < 64; k++) {
+				glyph = p2[k];
+				if (glyph >= 0 && glyph < MAX_GLYPH
+					       && q[glyph] < 32)
+		  			q[glyph] = (i << 11) + (j << 6) + k;
+			}
+		}
+	}
+}
+
 unsigned short *set_translate(int m, struct vc_data *vc)
 {
 	inv_translate[vc->vc_num] = m;
@@ -217,19 +253,29 @@ unsigned short *set_translate(int m, str
  * Inverse translation is impossible for several reasons:
  * 1. The font<->character maps are not 1-1.
  * 2. The text may have been written while a different translation map
- *    was active, or using Unicode.
+ *    was active.
  * Still, it is now possible to a certain extent to cut and paste non-ASCII.
  */
-unsigned char inverse_translate(struct vc_data *conp, int glyph)
+u16 inverse_translate(struct vc_data *conp, int glyph, int use_unicode)
 {
 	struct uni_pagedir *p;
+	int m;
 	if (glyph < 0 || glyph >= MAX_GLYPH)
 		return 0;
-	else if (!(p = (struct uni_pagedir *)*conp->vc_uni_pagedir_loc) ||
-		 !p->inverse_translations[inv_translate[conp->vc_num]])
+	else if (!(p = (struct uni_pagedir *)*conp->vc_uni_pagedir_loc))
 		return glyph;
-	else
-		return p->inverse_translations[inv_translate[conp->vc_num]][glyph];
+	else if (use_unicode) {
+		if (!p->inverse_trans_unicode)
+			return glyph;
+		else
+			return p->inverse_trans_unicode[glyph];
+	} else {
+		m = inv_translate[conp->vc_num];
+		if (!p->inverse_translations[m])
+			return glyph;
+		else
+			return p->inverse_translations[m][glyph];
+	}
 }
 
 static void update_user_maps(void)
@@ -243,6 +289,7 @@ static void update_user_maps(void)
 		p = (struct uni_pagedir *)*vc_cons[i].d->vc_uni_pagedir_loc;
 		if (p && p != q) {
 			set_inverse_transl(vc_cons[i].d, p, USER_MAP);
+			set_inverse_trans_unicode(vc_cons[i].d, p);
 			q = p;
 		}
 	}
@@ -353,6 +400,10 @@ static void con_release_unimap(struct un
 		kfree(p->inverse_translations[i]);
 		p->inverse_translations[i] = NULL;
 	}
+	if (p->inverse_trans_unicode) {
+		kfree(p->inverse_trans_unicode);
+		p->inverse_trans_unicode = NULL;
+	}
 }
 
 void con_free_unimap(struct vc_data *vc)
@@ -511,6 +562,7 @@ int con_set_unimap(struct vc_data *vc, u
 
 	for (i = 0; i <= 3; i++)
 		set_inverse_transl(vc, p, i); /* Update all inverse translations */
+	set_inverse_trans_unicode(vc, p);
   
 	return err;
 }
@@ -561,6 +613,7 @@ int con_set_default_unimap(struct vc_dat
 
 	for (i = 0; i <= 3; i++)
 		set_inverse_transl(vc, p, i);	/* Update all inverse translations */
+	set_inverse_trans_unicode(vc, p);
 	dflt = p;
 	return err;
 }
@@ -617,6 +670,19 @@ void con_protect_unimap(struct vc_data *
 		p->readonly = rdonly;
 }
 
+/* may be called during an interrupt */
+u32 conv_8bit_to_uni(unsigned char c)
+{
+	/*
+	 * Always use USER_MAP. This function is used by the keyboard,
+	 * which shouldn't be affected by G0/G1 switching, etc.
+	 * If the user map still contains default values, i.e. the
+	 * direct-to-font mapping, then assume user is using Latin1.
+	 */
+	unsigned short uni = translations[USER_MAP][c];
+	return uni == (0xf000 | c) ? c : uni;
+}
+
 int
 conv_uni_to_pc(struct vc_data *conp, long ucs) 
 {
diff -puN drivers/char/keyboard.c~kernel-utf-8-handling drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~kernel-utf-8-handling
+++ a/drivers/char/keyboard.c
@@ -24,6 +24,7 @@
  * 21-08-02: Converted to input API, major cleanup. (Vojtech Pavlik)
  */
 
+#include <linux/consolemap.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
@@ -308,10 +309,9 @@ static void applkey(struct vc_data *vc, 
  * Many other routines do put_queue, but I think either
  * they produce ASCII, or they produce some user-assigned
  * string, and in both cases we might assume that it is
- * in utf-8 already. UTF-8 is defined for words of up to 31 bits,
- * but we need only 16 bits here
+ * in utf-8 already.
  */
-static void to_utf8(struct vc_data *vc, ushort c)
+static void to_utf8(struct vc_data *vc, uint c)
 {
 	if (c < 0x80)
 		/*  0******* */
@@ -320,11 +320,21 @@ static void to_utf8(struct vc_data *vc, 
 		/* 110***** 10****** */
 		put_queue(vc, 0xc0 | (c >> 6));
 		put_queue(vc, 0x80 | (c & 0x3f));
-	} else {
+    	} else if (c < 0x10000) {
+	       	if (c >= 0xD800 && c < 0xE000)
+			return;
+		if (c == 0xFFFF)
+			return;
 		/* 1110**** 10****** 10****** */
 		put_queue(vc, 0xe0 | (c >> 12));
 		put_queue(vc, 0x80 | ((c >> 6) & 0x3f));
 		put_queue(vc, 0x80 | (c & 0x3f));
+    	} else if (c < 0x110000) {
+		/* 11110*** 10****** 10****** 10****** */
+		put_queue(vc, 0xf0 | (c >> 18));
+		put_queue(vc, 0x80 | ((c >> 12) & 0x3f));
+		put_queue(vc, 0x80 | ((c >> 6) & 0x3f));
+		put_queue(vc, 0x80 | (c & 0x3f));
 	}
 }
 
@@ -393,7 +403,7 @@ static unsigned int handle_diacr(struct 
 		return d;
 
 	if (kbd->kbdmode == VC_UNICODE)
-		to_utf8(vc, d);
+		to_utf8(vc, conv_8bit_to_uni(d));
 	else if (d < 0x100)
 		put_queue(vc, d);
 
@@ -407,7 +417,7 @@ static void fn_enter(struct vc_data *vc)
 {
 	if (diacr) {
 		if (kbd->kbdmode == VC_UNICODE)
-			to_utf8(vc, diacr);
+			to_utf8(vc, conv_8bit_to_uni(diacr));
 		else if (diacr < 0x100)
 			put_queue(vc, diacr);
 		diacr = 0;
@@ -617,7 +627,7 @@ static void k_unicode(struct vc_data *vc
 		return;
 	}
 	if (kbd->kbdmode == VC_UNICODE)
-		to_utf8(vc, value);
+		to_utf8(vc, conv_8bit_to_uni(value));
 	else if (value < 0x100)
 		put_queue(vc, value);
 }
@@ -775,7 +785,7 @@ static void k_shift(struct vc_data *vc, 
 	/* kludge */
 	if (up_flag && shift_state != old_state && npadch != -1) {
 		if (kbd->kbdmode == VC_UNICODE)
-			to_utf8(vc, npadch & 0xffff);
+			to_utf8(vc, npadch);
 		else
 			put_queue(vc, npadch & 0xff);
 		npadch = -1;
diff -puN drivers/char/selection.c~kernel-utf-8-handling drivers/char/selection.c
--- a/drivers/char/selection.c~kernel-utf-8-handling
+++ a/drivers/char/selection.c
@@ -20,6 +20,7 @@
 
 #include <asm/uaccess.h>
 
+#include <linux/kbd_kern.h>
 #include <linux/vt_kern.h>
 #include <linux/consolemap.h>
 #include <linux/selection.h>
@@ -34,6 +35,7 @@ extern void poke_blanked_console(void);
 /* Variables for selection control. */
 /* Use a dynamic buffer, instead of static (Dec 1994) */
 struct vc_data *sel_cons;		/* must not be deallocated */
+static int use_unicode;
 static volatile int sel_start = -1; 	/* cleared by clear_selection */
 static int sel_end;
 static int sel_buffer_lth;
@@ -54,10 +56,11 @@ static inline void highlight_pointer(con
 	complement_pos(sel_cons, where);
 }
 
-static unsigned char
+static u16
 sel_pos(int n)
 {
-	return inverse_translate(sel_cons, screen_glyph(sel_cons, n));
+	return inverse_translate(sel_cons, screen_glyph(sel_cons, n),
+				use_unicode);
 }
 
 /* remove the current selection highlight, if any,
@@ -86,8 +89,8 @@ static u32 inwordLut[8]={
   0xFF7FFFFF  /* latin-1 accented letters, not division sign */
 };
 
-static inline int inword(const unsigned char c) {
-	return ( inwordLut[c>>5] >> (c & 0x1F) ) & 1;
+static inline int inword(const u16 c) {
+	return c > 0xff || (( inwordLut[c>>5] >> (c & 0x1F) ) & 1);
 }
 
 /* set inwordLut contents. Invoked by ioctl(). */
@@ -108,13 +111,36 @@ static inline unsigned short limit(const
 	return (v > u) ? u : v;
 }
 
+/* stores the char in UTF8 and returns the number of bytes used (1-3) */
+static int store_utf8(u16 c, char *p)
+{
+	if (c < 0x80) {
+		/*  0******* */
+		p[0] = c;
+		return 1;
+	} else if (c < 0x800) {
+		/* 110***** 10****** */
+		p[0] = 0xc0 | (c >> 6);
+		p[1] = 0x80 | (c & 0x3f);
+		return 2;
+    	} else {
+		/* 1110**** 10****** 10****** */
+		p[0] = 0xe0 | (c >> 12);
+		p[1] = 0x80 | ((c >> 6) & 0x3f);
+		p[2] = 0x80 | (c & 0x3f);
+		return 3;
+    	}
+}
+
 /* set the current selection. Invoked by ioctl() or by kernel code. */
 int set_selection(const struct tiocl_selection __user *sel, struct tty_struct *tty)
 {
 	struct vc_data *vc = vc_cons[fg_console].d;
 	int sel_mode, new_sel_start, new_sel_end, spc;
 	char *bp, *obp;
-	int i, ps, pe;
+	int i, ps, pe, multiplier;
+	u16 c;
+	struct kbd_struct *kbd = kbd_table + fg_console;
 
 	poke_blanked_console();
 
@@ -158,6 +184,7 @@ int set_selection(const struct tiocl_sel
 		clear_selection();
 		sel_cons = vc_cons[fg_console].d;
 	}
+	use_unicode = kbd && kbd->kbdmode == VC_UNICODE;
 
 	switch (sel_mode)
 	{
@@ -240,7 +267,8 @@ int set_selection(const struct tiocl_sel
 	sel_end = new_sel_end;
 
 	/* Allocate a new buffer before freeing the old one ... */
-	bp = kmalloc((sel_end-sel_start)/2+1, GFP_KERNEL);
+	multiplier = use_unicode ? 3 : 1;  /* chars can take up to 3 bytes */
+	bp = kmalloc((sel_end-sel_start)/2*multiplier+1, GFP_KERNEL);
 	if (!bp) {
 		printk(KERN_WARNING "selection: kmalloc() failed\n");
 		clear_selection();
@@ -251,8 +279,12 @@ int set_selection(const struct tiocl_sel
 
 	obp = bp;
 	for (i = sel_start; i <= sel_end; i += 2) {
-		*bp = sel_pos(i);
-		if (!isspace(*bp++))
+		c = sel_pos(i);
+		if (use_unicode)
+			bp += store_utf8(c, bp);
+		else
+			*bp++ = c;
+		if (!isspace(c))
 			obp = bp;
 		if (! ((i + 2) % vc->vc_size_row)) {
 			/* strip trailing blanks from line and add newline,
diff -puN include/linux/consolemap.h~kernel-utf-8-handling include/linux/consolemap.h
--- a/include/linux/consolemap.h~kernel-utf-8-handling
+++ a/include/linux/consolemap.h
@@ -8,9 +8,12 @@
 #define IBMPC_MAP 2
 #define USER_MAP 3
 
+#include <linux/types.h>
+
 struct vc_data;
 
-extern unsigned char inverse_translate(struct vc_data *conp, int glyph);
+extern u16 inverse_translate(struct vc_data *conp, int glyph, int use_unicode);
 extern unsigned short *set_translate(int m, struct vc_data *vc);
 extern int conv_uni_to_pc(struct vc_data *conp, long ucs);
+extern u32 conv_8bit_to_uni(unsigned char c);
 void console_map_init(void);
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-acpi.patch
git-kvm.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-isdn-config_isdn.patch
use-menuconfig-objects-isdn-config_isdn_capi.patch
use-menuconfig-objects-isdn-config_capi_avm.patch
use-menuconfig-objects-isdn-config_capi_eicon.patch
use-menuconfig-objects-ii-md.patch
