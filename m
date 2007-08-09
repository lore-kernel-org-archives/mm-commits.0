From: akpm@linux-foundation.org
Subject: + unicode-diacritics-support.patch added to -mm tree
Date: Thu, 09 Aug 2007 12:46:48 -0700
Message-ID: <200708091946.l79JkmbN016261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50363 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbXHITrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 15:47:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org, adaplas@pol.net, dwmw2@infradead.org, jengelh@gmx.de


The patch titled
     unicode diacritics support
has been added to the -mm tree.  Its filename is
     unicode-diacritics-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: unicode diacritics support
=46rom: Samuel Thibault <samuel.thibault@ens-lyon.org>

There have been issues with non-latin1 diacritics and unicode.
http://bugzilla.kernel.org/show_bug.cgi?id=3D7746

Git 759448f459234bfcf34b82471f0dba77a9aca498 `Kernel utf-8 handling'
partly resolved it by adding conversion between diacritics and
unicode. The patch below goes further by just turning diacritics into
unicode, hence providing better future support. The kbd support can be
fetched from
http://bugzilla.kernel.org/attachment.cgi?id=3D12313

This was tested in all of latin1, latin9, latin2 and unicode with frenc=
h
and czech dead keys.



Turn the kernel accent_table into unicode, and extend ioctls KDGKBDIACR
and KDSKBDIACR into their equivalents KDGKBDIACRUC and KDSKBDIACR.

New function int conv_uni_to_8bit(u32 uni) for converting unicode into =
8bit
_input_.  No, we don't want to store the translation, as it is potentia=
lly
sparse and large.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Jan Engelhardt <jengelh@gmx.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acorn/char/defkeymap-l7200.c |    2=20
 drivers/char/consolemap.c            |   22 ++++++--
 drivers/char/defkeymap.c_shipped     |    2=20
 drivers/char/keyboard.c              |   35 +++++++++----
 drivers/char/vt_ioctl.c              |   46 ++++++++++++++++-
 drivers/s390/char/defkeymap.c        |    2=20
 drivers/s390/char/keyboard.c         |   66 ++++++++++++++++++++-----
 drivers/s390/char/keyboard.h         |    4 -
 drivers/tc/lk201-map.c_shipped       |    2=20
 include/linux/consolemap.h           |    1=20
 include/linux/kbd_diacr.h            |    2=20
 include/linux/kd.h                   |   10 +++
 12 files changed, 158 insertions(+), 36 deletions(-)

diff -puN drivers/acorn/char/defkeymap-l7200.c~unicode-diacritics-suppo=
rt drivers/acorn/char/defkeymap-l7200.c
--- a/drivers/acorn/char/defkeymap-l7200.c~unicode-diacritics-support
+++ a/drivers/acorn/char/defkeymap-l7200.c
@@ -346,7 +346,7 @@ char *func_table[MAX_NR_FUNC] =3D {
 	0,
 };
=20
-struct kbdiacr accent_table[MAX_DIACR] =3D {
+struct kbdiacruc accent_table[MAX_DIACR] =3D {
 	{'`', 'A', '\300'},	{'`', 'a', '\340'},
 	{'\'', 'A', '\301'},	{'\'', 'a', '\341'},
 	{'^', 'A', '\302'},	{'^', 'a', '\342'},
diff -puN drivers/char/consolemap.c~unicode-diacritics-support drivers/=
char/consolemap.c
--- a/drivers/char/consolemap.c~unicode-diacritics-support
+++ a/drivers/char/consolemap.c
@@ -669,19 +669,29 @@ void con_protect_unimap(struct vc_data *
 		p->readonly =3D rdonly;
 }
=20
+/*
+ * Always use USER_MAP. These functions are used by the keyboard,
+ * which shouldn't be affected by G0/G1 switching, etc.
+ * If the user map still contains default values, i.e. the
+ * direct-to-font mapping, then assume user is using Latin1.
+ */
 /* may be called during an interrupt */
 u32 conv_8bit_to_uni(unsigned char c)
 {
-	/*
-	 * Always use USER_MAP. This function is used by the keyboard,
-	 * which shouldn't be affected by G0/G1 switching, etc.
-	 * If the user map still contains default values, i.e. the
-	 * direct-to-font mapping, then assume user is using Latin1.
-	 */
 	unsigned short uni =3D translations[USER_MAP][c];
 	return uni =3D=3D (0xf000 | c) ? c : uni;
 }
=20
+int conv_uni_to_8bit(u32 uni)
+{
+	int c;
+	for (c =3D 0; c < 0x100; c++)
+		if (translations[USER_MAP][c] =3D=3D uni ||
+		   (translations[USER_MAP][c] =3D=3D (c | 0xf000) && uni =3D=3D c))
+			return c;
+	return -1;
+}
+
 int
 conv_uni_to_pc(struct vc_data *conp, long ucs)=20
 {
diff -puN drivers/char/defkeymap.c_shipped~unicode-diacritics-support d=
rivers/char/defkeymap.c_shipped
--- a/drivers/char/defkeymap.c_shipped~unicode-diacritics-support
+++ a/drivers/char/defkeymap.c_shipped
@@ -222,7 +222,7 @@ char *func_table[MAX_NR_FUNC] =3D {
 	NULL,
 };
=20
-struct kbdiacr accent_table[MAX_DIACR] =3D {
+struct kbdiacruc accent_table[MAX_DIACR] =3D {
 	{'`', 'A', '\300'},	{'`', 'a', '\340'},
 	{'\'', 'A', '\301'},	{'\'', 'a', '\341'},
 	{'^', 'A', '\302'},	{'^', 'a', '\342'},
diff -puN drivers/char/keyboard.c~unicode-diacritics-support drivers/ch=
ar/keyboard.c
--- a/drivers/char/keyboard.c~unicode-diacritics-support
+++ a/drivers/char/keyboard.c
@@ -41,6 +41,7 @@
 #include <linux/sysrq.h>
 #include <linux/input.h>
 #include <linux/reboot.h>
+#include <linux/consolemap.h>
=20
 extern void ctrl_alt_del(void);
=20
@@ -403,9 +404,12 @@ static unsigned int handle_diacr(struct=20
 		return d;
=20
 	if (kbd->kbdmode =3D=3D VC_UNICODE)
-		to_utf8(vc, conv_8bit_to_uni(d));
-	else if (d < 0x100)
-		put_queue(vc, d);
+		to_utf8(vc, d);
+	else {
+		int c =3D conv_uni_to_8bit(d);
+		if (c !=3D -1)
+			put_queue(vc, c);
+	}
=20
 	return ch;
 }
@@ -417,9 +421,12 @@ static void fn_enter(struct vc_data *vc)
 {
 	if (diacr) {
 		if (kbd->kbdmode =3D=3D VC_UNICODE)
-			to_utf8(vc, conv_8bit_to_uni(diacr));
-		else if (diacr < 0x100)
-			put_queue(vc, diacr);
+			to_utf8(vc, diacr);
+		else {
+			int c =3D conv_uni_to_8bit(diacr);
+			if (c !=3D -1)
+				put_queue(vc, c);
+		}
 		diacr =3D 0;
 	}
 	put_queue(vc, 13);
@@ -627,9 +634,12 @@ static void k_unicode(struct vc_data *vc
 		return;
 	}
 	if (kbd->kbdmode =3D=3D VC_UNICODE)
-		to_utf8(vc, conv_8bit_to_uni(value));
-	else if (value < 0x100)
-		put_queue(vc, value);
+		to_utf8(vc, value);
+	else {
+		int c =3D conv_uni_to_8bit(value);
+		if (c !=3D -1)
+			put_queue(vc, c);
+	}
 }
=20
 /*
@@ -646,7 +656,12 @@ static void k_deadunicode(struct vc_data
=20
 static void k_self(struct vc_data *vc, unsigned char value, char up_fl=
ag)
 {
-	k_unicode(vc, value, up_flag);
+	unsigned int uni;
+	if (kbd->kbdmode =3D=3D VC_UNICODE)
+		uni =3D value;
+	else
+		uni =3D conv_8bit_to_uni(value);
+	k_unicode(vc, uni, up_flag);
 }
=20
 static void k_dead2(struct vc_data *vc, unsigned char value, char up_f=
lag)
diff -puN drivers/char/vt_ioctl.c~unicode-diacritics-support drivers/ch=
ar/vt_ioctl.c
--- a/drivers/char/vt_ioctl.c~unicode-diacritics-support
+++ a/drivers/char/vt_ioctl.c
@@ -23,6 +23,7 @@
 #include <linux/major.h>
 #include <linux/fs.h>
 #include <linux/console.h>
+#include <linux/consolemap.h>
 #include <linux/signal.h>
 #include <linux/timex.h>
=20
@@ -582,10 +583,27 @@ int vt_ioctl(struct tty_struct *tty, str
 	case KDGKBDIACR:
 	{
 		struct kbdiacrs __user *a =3D up;
+		struct kbdiacr diacr;
+		int i;
=20
 		if (put_user(accent_table_size, &a->kb_cnt))
 			return -EFAULT;
-		if (copy_to_user(a->kbdiacr, accent_table, accent_table_size*sizeof(=
struct kbdiacr)))
+		for (i =3D 0; i < accent_table_size; i++) {
+			diacr.diacr =3D conv_uni_to_8bit(accent_table[i].diacr);
+			diacr.base =3D conv_uni_to_8bit(accent_table[i].base);
+			diacr.result =3D conv_uni_to_8bit(accent_table[i].result);
+			if (copy_to_user(a->kbdiacr + i, &diacr, sizeof(struct kbdiacr)))
+				return -EFAULT;
+		}
+		return 0;
+	}
+	case KDGKBDIACRUC:
+	{
+		struct kbdiacrsuc __user *a =3D up;
+
+		if (put_user(accent_table_size, &a->kb_cnt))
+			return -EFAULT;
+		if (copy_to_user(a->kbdiacruc, accent_table, accent_table_size*sizeo=
f(struct kbdiacruc)))
 			return -EFAULT;
 		return 0;
 	}
@@ -593,6 +611,30 @@ int vt_ioctl(struct tty_struct *tty, str
 	case KDSKBDIACR:
 	{
 		struct kbdiacrs __user *a =3D up;
+		struct kbdiacr diacr;
+		unsigned int ct;
+		int i;
+
+		if (!perm)
+			return -EPERM;
+		if (get_user(ct,&a->kb_cnt))
+			return -EFAULT;
+		if (ct >=3D MAX_DIACR)
+			return -EINVAL;
+		accent_table_size =3D ct;
+		for (i =3D 0; i < ct; i++) {
+			if (copy_from_user(&diacr, a->kbdiacr + i, sizeof(struct kbdiacr)))
+				return -EFAULT;
+			accent_table[i].diacr =3D conv_8bit_to_uni(diacr.diacr);
+			accent_table[i].base =3D conv_8bit_to_uni(diacr.base);
+			accent_table[i].result =3D conv_8bit_to_uni(diacr.result);
+		}
+		return 0;
+	}
+
+	case KDSKBDIACRUC:
+	{
+		struct kbdiacrsuc __user *a =3D up;
 		unsigned int ct;
=20
 		if (!perm)
@@ -602,7 +644,7 @@ int vt_ioctl(struct tty_struct *tty, str
 		if (ct >=3D MAX_DIACR)
 			return -EINVAL;
 		accent_table_size =3D ct;
-		if (copy_from_user(accent_table, a->kbdiacr, ct*sizeof(struct kbdiac=
r)))
+		if (copy_from_user(accent_table, a->kbdiacruc, ct*sizeof(struct kbdi=
acruc)))
 			return -EFAULT;
 		return 0;
 	}
diff -puN drivers/s390/char/defkeymap.c~unicode-diacritics-support driv=
ers/s390/char/defkeymap.c
--- a/drivers/s390/char/defkeymap.c~unicode-diacritics-support
+++ a/drivers/s390/char/defkeymap.c
@@ -150,7 +150,7 @@ char *func_table[MAX_NR_FUNC] =3D {
 	NULL,
 };
=20
-struct kbdiacr accent_table[MAX_DIACR] =3D {
+struct kbdiacruc accent_table[MAX_DIACR] =3D {
 	{'^', 'c', '\003'},	{'^', 'd', '\004'},
 	{'^', 'z', '\032'},	{'^', '\012', '\000'},
 };
diff -puN drivers/s390/char/keyboard.c~unicode-diacritics-support drive=
rs/s390/char/keyboard.c
--- a/drivers/s390/char/keyboard.c~unicode-diacritics-support
+++ a/drivers/s390/char/keyboard.c
@@ -11,6 +11,7 @@
 #include <linux/sched.h>
 #include <linux/sysrq.h>
=20
+#include <linux/consolemap.h>
 #include <linux/kbd_kern.h>
 #include <linux/kbd_diacr.h>
 #include <asm/uaccess.h>
@@ -82,11 +83,11 @@ kbd_alloc(void) {
 	if (!kbd->fn_handler)
 		goto out_func;
 	kbd->accent_table =3D
-		kmalloc(sizeof(struct kbdiacr)*MAX_DIACR, GFP_KERNEL);
+		kmalloc(sizeof(struct kbdiacruc)*MAX_DIACR, GFP_KERNEL);
 	if (!kbd->accent_table)
 		goto out_fn_handler;
 	memcpy(kbd->accent_table, accent_table,
-	       sizeof(struct kbdiacr)*MAX_DIACR);
+	       sizeof(struct kbdiacruc)*MAX_DIACR);
 	kbd->accent_table_size =3D accent_table_size;
 	return kbd;
=20
@@ -183,8 +184,8 @@ kbd_ebcasc(struct kbd_data *kbd, unsigne
  * Otherwise, conclude that DIACR was not combining after all,
  * queue it and return CH.
  */
-static unsigned char
-handle_diacr(struct kbd_data *kbd, unsigned char ch)
+static unsigned int
+handle_diacr(struct kbd_data *kbd, unsigned int ch)
 {
 	int i, d;
=20
@@ -460,7 +461,6 @@ int
 kbd_ioctl(struct kbd_data *kbd, struct file *file,
 	  unsigned int cmd, unsigned long arg)
 {
-	struct kbdiacrs __user *a;
 	void __user *argp;
 	int ct, perm;
=20
@@ -481,17 +481,40 @@ kbd_ioctl(struct kbd_data *kbd, struct f
 	case KDSKBSENT:
 		return do_kdgkb_ioctl(kbd, argp, cmd, perm);
 	case KDGKBDIACR:
-		a =3D argp;
+	{
+		struct kbdiacrs __user *a =3D argp;
+		struct kbdiacr diacr;
+		int i;
=20
 		if (put_user(kbd->accent_table_size, &a->kb_cnt))
 			return -EFAULT;
+		for (i =3D 0; i < kbd->accent_table_size; i++) {
+			diacr.diacr =3D conv_uni_to_8bit(kbd->accent_table[i].diacr);
+			diacr.base =3D conv_uni_to_8bit(kbd->accent_table[i].base);
+			diacr.result =3D conv_uni_to_8bit(kbd->accent_table[i].result);
+			if (copy_to_user(a->kbdiacr + i, &diacr, sizeof(struct kbdiacr)))
+			return -EFAULT;
+		}
+		return 0;
+	}
+	case KDGKBDIACRUC:
+	{
+		struct kbdiacrsuc __user *a =3D argp;
+
 		ct =3D kbd->accent_table_size;
-		if (copy_to_user(a->kbdiacr, kbd->accent_table,
-				 ct * sizeof(struct kbdiacr)))
+		if (put_user(ct, &a->kb_cnt))
+			return -EFAULT;
+		if (copy_to_user(a->kbdiacruc, kbd->accent_table,
+				 ct * sizeof(struct kbdiacruc)))
 			return -EFAULT;
 		return 0;
+	}
 	case KDSKBDIACR:
-		a =3D argp;
+	{
+		struct kbdiacrs __user *a =3D argp;
+		struct kbdiacr diacr;
+		int i;
+
 		if (!perm)
 			return -EPERM;
 		if (get_user(ct, &a->kb_cnt))
@@ -499,10 +522,31 @@ kbd_ioctl(struct kbd_data *kbd, struct f
 		if (ct >=3D MAX_DIACR)
 			return -EINVAL;
 		kbd->accent_table_size =3D ct;
-		if (copy_from_user(kbd->accent_table, a->kbdiacr,
-				   ct * sizeof(struct kbdiacr)))
+		for (i =3D 0; i < ct; i++) {
+			if (copy_from_user(&diacr, a->kbdiacr + i, sizeof(struct kbdiacr)))
+				return -EFAULT;
+			kbd->accent_table[i].diacr =3D conv_8bit_to_uni(diacr.diacr);
+			kbd->accent_table[i].base =3D conv_8bit_to_uni(diacr.base);
+			kbd->accent_table[i].result =3D conv_8bit_to_uni(diacr.result);
+		}
+		return 0;
+	}
+	case KDSKBDIACRUC:
+	{
+		struct kbdiacrsuc __user *a =3D argp;
+
+		if (!perm)
+			return -EPERM;
+		if (get_user(ct, &a->kb_cnt))
+			return -EFAULT;
+		if (ct >=3D MAX_DIACR)
+			return -EINVAL;
+		kbd->accent_table_size =3D ct;
+		if (copy_from_user(kbd->accent_table, a->kbdiacruc,
+				   ct * sizeof(struct kbdiacruc)))
 			return -EFAULT;
 		return 0;
+	}
 	default:
 		return -ENOIOCTLCMD;
 	}
diff -puN drivers/s390/char/keyboard.h~unicode-diacritics-support drive=
rs/s390/char/keyboard.h
--- a/drivers/s390/char/keyboard.h~unicode-diacritics-support
+++ a/drivers/s390/char/keyboard.h
@@ -25,9 +25,9 @@ struct kbd_data {
 	unsigned short **key_maps;
 	char **func_table;
 	fn_handler_fn **fn_handler;
-	struct kbdiacr *accent_table;
+	struct kbdiacruc *accent_table;
 	unsigned int accent_table_size;
-	unsigned char diacr;
+	unsigned int diacr;
 	unsigned short sysrq;
 };
=20
diff -puN drivers/tc/lk201-map.c_shipped~unicode-diacritics-support dri=
vers/tc/lk201-map.c_shipped
--- a/drivers/tc/lk201-map.c_shipped~unicode-diacritics-support
+++ a/drivers/tc/lk201-map.c_shipped
@@ -225,7 +225,7 @@ char *func_table[MAX_NR_FUNC] =3D {
 	0,
 };
=20
-struct kbdiacr accent_table[MAX_DIACR] =3D {
+struct kbdiacruc accent_table[MAX_DIACR] =3D {
 	{'`', 'A', '=C0'},	{'`', 'a', '=E0'},
 	{'\'', 'A', '=C1'},	{'\'', 'a', '=E1'},
 	{'^', 'A', '=C2'},	{'^', 'a', '=E2'},
diff -puN include/linux/consolemap.h~unicode-diacritics-support include=
/linux/consolemap.h
--- a/include/linux/consolemap.h~unicode-diacritics-support
+++ a/include/linux/consolemap.h
@@ -16,4 +16,5 @@ extern u16 inverse_translate(struct vc_d
 extern unsigned short *set_translate(int m, struct vc_data *vc);
 extern int conv_uni_to_pc(struct vc_data *conp, long ucs);
 extern u32 conv_8bit_to_uni(unsigned char c);
+extern int conv_uni_to_8bit(u32 uni);
 void console_map_init(void);
diff -puN include/linux/kbd_diacr.h~unicode-diacritics-support include/=
linux/kbd_diacr.h
--- a/include/linux/kbd_diacr.h~unicode-diacritics-support
+++ a/include/linux/kbd_diacr.h
@@ -2,7 +2,7 @@
 #define _DIACR_H
 #include <linux/kd.h>
=20
-extern struct kbdiacr accent_table[];
+extern struct kbdiacruc accent_table[];
 extern unsigned int accent_table_size;
=20
 #endif /* _DIACR_H */
diff -puN include/linux/kd.h~unicode-diacritics-support include/linux/k=
d.h
--- a/include/linux/kd.h~unicode-diacritics-support
+++ a/include/linux/kd.h
@@ -125,6 +125,16 @@ struct kbdiacrs {
 #define KDGKBDIACR      0x4B4A  /* read kernel accent table */
 #define KDSKBDIACR      0x4B4B  /* write kernel accent table */
=20
+struct kbdiacruc {
+        __u32 diacr, base, result;
+};
+struct kbdiacrsuc {
+        unsigned int kb_cnt;    /* number of entries in following arra=
y */
+	struct kbdiacruc kbdiacruc[256];    /* MAX_DIACR from keyboard.h */
+};
+#define KDGKBDIACRUC    0x4BFA  /* read kernel accent table - UCS */
+#define KDSKBDIACRUC    0x4BFB  /* write kernel accent table - UCS */
+
 struct kbkeycode {
 	unsigned int scancode, keycode;
 };
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.o=
rg are

unicode-diacritics-support.patch
