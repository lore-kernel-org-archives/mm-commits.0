From: akpm@linux-foundation.org
Subject: + vt-notifier-extension-for-accessibility.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:34:22 -0800
Message-ID: <200802230735.m1N7ZBQx018342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752153AbYBWHyE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eklhad@comcast.net, samuel.thibault@ens-lyon.org


The patch titled
     VT notifier extension for accessibility
has been added to the -mm tree.  Its filename is
     vt-notifier-extension-for-accessibility.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: VT notifier extension for accessibility
From: Karl Dahlke <eklhad@comcast.net>

Some accessibility modules need to be able to catch the output on the
console before the VT interpretation, and possibly swallow it.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c        |    7 +++++++
 include/linux/notifier.h |    1 +
 2 files changed, 8 insertions(+)

diff -puN drivers/char/vt.c~vt-notifier-extension-for-accessibility drivers/char/vt.c
--- a/drivers/char/vt.c~vt-notifier-extension-for-accessibility
+++ a/drivers/char/vt.c
@@ -2053,6 +2053,7 @@ static int do_con_write(struct tty_struc
 	unsigned long draw_from = 0, draw_to = 0;
 	struct vc_data *vc;
 	unsigned char vc_attr;
+	struct vt_notifier_param param;
 	uint8_t rescan;
 	uint8_t inverse;
 	uint8_t width;
@@ -2112,6 +2113,8 @@ static int do_con_write(struct tty_struc
 	if (IS_FG(vc))
 		hide_cursor(vc);
 
+	param.vc = vc;
+
 	while (!tty->stopped && count) {
 		int orig = *buf;
 		c = orig;
@@ -2200,6 +2203,10 @@ rescan_last_byte:
 		    tc = vc->vc_translate[vc->vc_toggle_meta ? (c | 0x80) : c];
 		}
 
+		param.c = tc;
+		if (atomic_notifier_call_chain(&vt_notifier_list, VT_PREWRITE, &param) == NOTIFY_STOP)
+			continue;
+
                 /* If the original code was a control character we
                  * only allow a glyph to be displayed if the code is
                  * not normally used (such as for cursor movement) or
diff -puN include/linux/notifier.h~vt-notifier-extension-for-accessibility include/linux/notifier.h
--- a/include/linux/notifier.h~vt-notifier-extension-for-accessibility
+++ a/include/linux/notifier.h
@@ -247,6 +247,7 @@ extern struct blocking_notifier_head reb
 #define VT_DEALLOCATE		0x0002 /* Console will be deallocated */
 #define VT_WRITE		0x0003 /* A char got output */
 #define VT_UPDATE		0x0004 /* A bigger update occurred */
+#define VT_PREWRITE		0x0005 /* A char is about to be written to the console */
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
_

Patches currently in -mm which might be from eklhad@comcast.net are

input-put-ledstate-in-the-keyboard-notifier.patch
vt-notifier-extension-for-accessibility.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
