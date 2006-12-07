From: akpm@osdl.org
Subject: - add-return-value-checking-of-get_user-in.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:06:30 -0800
Message-ID: <200612072306.kB7N6UcS030270@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52688 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163922AbWLGXGt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:06:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoichi_yuasa@tripeaks.co.jp, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     add return value checking of get_user() in set_vesa_blanking()
has been removed from the -mm tree.  Its filename was
     add-return-value-checking-of-get_user-in.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add return value checking of get_user() in set_vesa_blanking()
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

[akpm@osdl.org: bugfix]
Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/vt.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN drivers/char/vt.c~add-return-value-checking-of-get_user-in drivers/char/vt.c
--- a/drivers/char/vt.c~add-return-value-checking-of-get_user-in
+++ a/drivers/char/vt.c
@@ -152,7 +152,7 @@ static void gotoxy(struct vc_data *vc, i
 static void save_cur(struct vc_data *vc);
 static void reset_terminal(struct vc_data *vc, int do_clear);
 static void con_flush_chars(struct tty_struct *tty);
-static void set_vesa_blanking(char __user *p);
+static int set_vesa_blanking(char __user *p);
 static void set_cursor(struct vc_data *vc);
 static void hide_cursor(struct vc_data *vc);
 static void console_callback(struct work_struct *ignored);
@@ -2369,7 +2369,7 @@ int tioclinux(struct tty_struct *tty, un
 			ret = __put_user(data, p);
 			break;
 		case TIOCL_SETVESABLANK:
-			set_vesa_blanking(p);
+			ret = set_vesa_blanking(p);
 			break;
 		case TIOCL_GETKMSGREDIRECT:
 			data = kmsg_redirect;
@@ -3313,11 +3313,15 @@ postcore_initcall(vtconsole_class_init);
  *	Screen blanking
  */
 
-static void set_vesa_blanking(char __user *p)
+static int set_vesa_blanking(char __user *p)
 {
-    unsigned int mode;
-    get_user(mode, p + 1);
-    vesa_blank_mode = (mode < 4) ? mode : 0;
+	unsigned int mode;
+
+	if (get_user(mode, p + 1))
+		return -EFAULT;
+
+	vesa_blank_mode = (mode < 4) ? mode : 0;
+	return 0;
 }
 
 void do_blank_screen(int entering_gfx)
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

origin.patch
git-mtd.patch
generic-ioremap_page_range-mips-conversion.patch

