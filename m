From: akpm@linux-foundation.org
Subject: - fbcon-cursor-blink-control.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:45 -0700
Message-ID: <200707172306.l6HN6jDN012047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52557 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764879AbXGQXPL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbcon: cursor blink control
has been removed from the -mm tree.  Its filename was
     fbcon-cursor-blink-control.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbcon: cursor blink control
From: "Antonino A. Daplas" <adaplas@gmail.com>

Add sysfs attribute to enable or disable cursor blinking.  This will also
disable cursor blinking if the VT layer's softcursor is active.  These changes
are required to enable some machines to enter low-power states properly.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   74 +++++++++++++++++++++++++++++++-
 1 file changed, 73 insertions(+), 1 deletion(-)

diff -puN drivers/video/console/fbcon.c~fbcon-cursor-blink-control drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-cursor-blink-control
+++ a/drivers/video/console/fbcon.c
@@ -152,6 +152,7 @@ static int fbcon_set_origin(struct vc_da
 #define DEFAULT_CURSOR_BLINK_RATE	(20)
 
 static int vbl_cursor_cnt;
+static int fbcon_cursor_noblink;
 
 #define divides(a, b)	((!(a) || (b)%(a)) ? 0 : 1)
 
@@ -441,7 +442,8 @@ static void fbcon_add_cursor_timer(struc
 	struct fbcon_ops *ops = info->fbcon_par;
 
 	if ((!info->queue.func || info->queue.func == fb_flashcursor) &&
-	    !(ops->flags & FBCON_FLAGS_CURSOR_TIMER)) {
+	    !(ops->flags & FBCON_FLAGS_CURSOR_TIMER) &&
+	    !fbcon_cursor_noblink) {
 		if (!info->queue.func)
 			INIT_WORK(&info->queue, fb_flashcursor);
 
@@ -1349,6 +1351,11 @@ static void fbcon_cursor(struct vc_data 
 	if (fbcon_is_inactive(vc, info) || vc->vc_deccm != 1)
 		return;
 
+	if (vc->vc_cursor_type & 0x10)
+		fbcon_del_cursor_timer(info);
+	else
+		fbcon_add_cursor_timer(info);
+
 	ops->cursor_flash = (mode == CM_ERASE) ? 0 : 1;
 	if (mode & CM_SOFTBACK) {
 		mode &= ~CM_SOFTBACK;
@@ -3308,9 +3315,74 @@ err:
 	return snprintf(buf, PAGE_SIZE, "%d\n", rotate);
 }
 
+static ssize_t show_cursor_blink(struct class_device *class_device, char *buf)
+{
+	struct fb_info *info;
+	struct fbcon_ops *ops;
+	int idx, blink = -1;
+
+	if (fbcon_has_exited)
+		return 0;
+
+	acquire_console_sem();
+	idx = con2fb_map[fg_console];
+
+	if (idx == -1 || registered_fb[idx] == NULL)
+		goto err;
+
+	info = registered_fb[idx];
+	ops = info->fbcon_par;
+
+	if (!ops)
+		goto err;
+
+	blink = (ops->flags & FBCON_FLAGS_CURSOR_TIMER) ? 1 : 0;
+err:
+	release_console_sem();
+	return snprintf(buf, PAGE_SIZE, "%d\n", blink);
+}
+
+static ssize_t store_cursor_blink(struct class_device *clas_device,
+				  const char *buf, size_t count)
+{
+	struct fb_info *info;
+	int blink, idx;
+	char **last = NULL;
+
+	if (fbcon_has_exited)
+		return count;
+
+	acquire_console_sem();
+	idx = con2fb_map[fg_console];
+
+	if (idx == -1 || registered_fb[idx] == NULL)
+		goto err;
+
+	info = registered_fb[idx];
+
+	if (!info->fbcon_par)
+		goto err;
+
+	blink = simple_strtoul(buf, last, 0);
+
+	if (blink) {
+		fbcon_cursor_noblink = 0;
+		fbcon_add_cursor_timer(info);
+	} else {
+		fbcon_cursor_noblink = 1;
+		fbcon_del_cursor_timer(info);
+	}
+
+err:
+	release_console_sem();
+	return count;
+}
+
 static struct class_device_attribute class_device_attrs[] = {
 	__ATTR(rotate, S_IRUGO|S_IWUSR, show_rotate, store_rotate),
 	__ATTR(rotate_all, S_IWUSR, NULL, store_rotate_all),
+	__ATTR(cursor_blink, S_IRUGO|S_IWUSR, show_cursor_blink,
+	       store_cursor_blink),
 };
 
 static int fbcon_init_class_device(void)
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
