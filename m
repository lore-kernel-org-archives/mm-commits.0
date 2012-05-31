From: akpm@linux-foundation.org
Subject: [merged] fb-add-events-for-early-fb-event-support.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:25 -0700
Message-ID: <20120531191825.712F7A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36898 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933035Ab2EaTS0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:26 -0400
Received: by ggeh3 with SMTP id h3so135741gge.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: inki.dae@samsung.com, FlorianSchandinat@gmx.de, kyungmin.park@samsung.com, lars@metafoo.de, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: fbdev: add events for early fb event support
has been removed from the -mm tree.  Its filename was
     fb-add-events-for-early-fb-event-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Inki Dae <inki.dae@samsung.com>
Subject: fbdev: add events for early fb event support

Add FB_EARLY_EVENT_BLANK and FB_R_EARLY_EVENT_BLANK event mode supports. 
first, fb_notifier_call_chain() is called with FB_EARLY_EVENT_BLANK and
fb_blank() of specific fb driver is called and then
fb_notifier_call_chain() is called with FB_EVENT_BLANK again at
fb_blank().  and if fb_blank() was failed then fb_nitifier_call_chain()
would be called with FB_R_EARLY_EVENT_BLANK to revert the previous
effects.

Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |   21 +++++++++++++++------
 include/linux/fb.h    |    4 ++++
 2 files changed, 19 insertions(+), 6 deletions(-)

diff -puN drivers/video/fbmem.c~fb-add-events-for-early-fb-event-support drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-add-events-for-early-fb-event-support
+++ a/drivers/video/fbmem.c
@@ -1046,20 +1046,29 @@ fb_set_var(struct fb_info *info, struct 
 int
 fb_blank(struct fb_info *info, int blank)
 {	
- 	int ret = -EINVAL;
+	struct fb_event event;
+	int ret = -EINVAL, early_ret;
 
  	if (blank > FB_BLANK_POWERDOWN)
  		blank = FB_BLANK_POWERDOWN;
 
+	event.info = info;
+	event.data = &blank;
+
+	early_ret = fb_notifier_call_chain(FB_EARLY_EVENT_BLANK, &event);
+
 	if (info->fbops->fb_blank)
  		ret = info->fbops->fb_blank(blank, info);
 
- 	if (!ret) {
-		struct fb_event event;
-
-		event.info = info;
-		event.data = &blank;
+	if (!ret)
 		fb_notifier_call_chain(FB_EVENT_BLANK, &event);
+	else {
+		/*
+		 * if fb_blank is failed then revert effects of
+		 * the early blank event.
+		 */
+		if (!early_ret)
+			fb_notifier_call_chain(FB_R_EARLY_EVENT_BLANK, &event);
 	}
 
  	return ret;
diff -puN include/linux/fb.h~fb-add-events-for-early-fb-event-support include/linux/fb.h
--- a/include/linux/fb.h~fb-add-events-for-early-fb-event-support
+++ a/include/linux/fb.h
@@ -554,6 +554,10 @@ struct fb_cursor_user {
 #define FB_EVENT_FB_UNBIND              0x0E
 /*      CONSOLE-SPECIFIC: remap all consoles to new fb - for vga switcheroo */
 #define FB_EVENT_REMAP_ALL_CONSOLE      0x0F
+/*      A hardware display blank early change occured */
+#define FB_EARLY_EVENT_BLANK		0x10
+/*      A hardware display blank revert early change occured */
+#define FB_R_EARLY_EVENT_BLANK		0x11
 
 struct fb_event {
 	struct fb_info *info;
_

Patches currently in -mm which might be from inki.dae@samsung.com are

origin.patch
linux-next.patch

