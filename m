From: akpm@linux-foundation.org
Subject: + wireless-rt2x00-fix-debugfs_create_s-error-checking.patch added to -mm tree
Date: Thu, 30 Oct 2008 13:08:22 -0700
Message-ID: <200810302008.m9UK8Ncq017405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292AbYJ3UJC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 16:09:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhaolei@cn.fujitsu.com, IvDoorn@gmail.com, linville@tuxdriver.com


The patch titled
     wireless/rt2x00/: fix debugfs_create_*()'s error checking
has been added to the -mm tree.  Its filename is
     wireless-rt2x00-fix-debugfs_create_s-error-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wireless/rt2x00/: fix debugfs_create_*()'s error checking


debugfs_create_*() returns NULL if an error occurs, returns -ENODEV when
debugfs is not enabled in the kernel.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/rt2x00/rt2x00debug.c |   21 +++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/net/wireless/rt2x00/rt2x00debug.c~wireless-rt2x00-fix-debugfs_create_s-error-checking drivers/net/wireless/rt2x00/rt2x00debug.c
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c~wireless-rt2x00-fix-debugfs_create_s-error-checking
+++ a/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -587,29 +587,29 @@ void rt2x00debug_register(struct rt2x00_
 	intf->driver_folder =
 	    debugfs_create_dir(intf->rt2x00dev->ops->name,
 			       rt2x00dev->hw->wiphy->debugfsdir);
-	if (IS_ERR(intf->driver_folder))
+	if (IS_ERR(intf->driver_folder) || !intf->driver_folder)
 		goto exit;
 
 	intf->driver_entry =
 	    rt2x00debug_create_file_driver("driver", intf, &intf->driver_blob);
-	if (IS_ERR(intf->driver_entry))
+	if (IS_ERR(intf->driver_entry) || !intf->driver_entry)
 		goto exit;
 
 	intf->chipset_entry =
 	    rt2x00debug_create_file_chipset("chipset",
 					    intf, &intf->chipset_blob);
-	if (IS_ERR(intf->chipset_entry))
+	if (IS_ERR(intf->chipset_entry) || !intf->chipset_entry)
 		goto exit;
 
 	intf->dev_flags = debugfs_create_file("dev_flags", S_IRUSR,
 					      intf->driver_folder, intf,
 					      &rt2x00debug_fop_dev_flags);
-	if (IS_ERR(intf->dev_flags))
+	if (IS_ERR(intf->dev_flags) || !intf->dev_flags)
 		goto exit;
 
 	intf->register_folder =
 	    debugfs_create_dir("register", intf->driver_folder);
-	if (IS_ERR(intf->register_folder))
+	if (IS_ERR(intf->register_folder) || !intf->register_folder)
 		goto exit;
 
 #define RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(__intf, __name)	\
@@ -619,7 +619,8 @@ void rt2x00debug_register(struct rt2x00_
 			       S_IRUSR | S_IWUSR,		\
 			       (__intf)->register_folder,	\
 			       &(__intf)->offset_##__name);	\
-	if (IS_ERR((__intf)->__name##_off_entry))		\
+	if (IS_ERR((__intf)->__name##_off_entry)		\
+			|| !(__intf)->__name##_off_entry)	\
 		goto exit;					\
 								\
 	(__intf)->__name##_val_entry =				\
@@ -627,7 +628,8 @@ void rt2x00debug_register(struct rt2x00_
 				S_IRUSR | S_IWUSR,		\
 				(__intf)->register_folder,	\
 				(__intf), &rt2x00debug_fop_##__name);\
-	if (IS_ERR((__intf)->__name##_val_entry))		\
+	if (IS_ERR((__intf)->__name##_val_entry)		\
+			|| !(__intf)->__name##_val_entry)	\
 		goto exit;					\
 })
 
@@ -640,13 +642,14 @@ void rt2x00debug_register(struct rt2x00_
 
 	intf->queue_folder =
 	    debugfs_create_dir("queue", intf->driver_folder);
-	if (IS_ERR(intf->queue_folder))
+	if (IS_ERR(intf->queue_folder) || !intf->queue_folder)
 		goto exit;
 
 	intf->queue_frame_dump_entry =
 	    debugfs_create_file("dump", S_IRUSR, intf->queue_folder,
 				intf, &rt2x00debug_fop_queue_dump);
-	if (IS_ERR(intf->queue_frame_dump_entry))
+	if (IS_ERR(intf->queue_frame_dump_entry)
+		|| !intf->queue_frame_dump_entry)
 		goto exit;
 
 	skb_queue_head_init(&intf->frame_dump_skbqueue);
_

Patches currently in -mm which might be from zhaolei@cn.fujitsu.com are

origin.patch
linux-next.patch
wireless-iwlwifi-fix-debugfs_create_bools-error-checking.patch
wireless-rt2x00-fix-debugfs_create_s-error-checking.patch

