From: akpm@linux-foundation.org
Subject: + jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch added to -mm tree
Date: Mon, 11 Jan 2010 14:28:03 -0800
Message-ID: <201001112228.o0BMS3oY032130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab0AKW3A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 17:29:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dwmw2@infradead.org, rdiezmail-kernelbugzilla@yahoo.de


The patch titled
     jffs2: avoid using C++ keyword `new' in userspace-visible header
has been added to the -mm tree.  Its filename is
     jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch

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
Subject: jffs2: avoid using C++ keyword `new' in userspace-visible header
From: Andrew Morton <akpm@linux-foundation.org>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14995

Reported-by: R. Diez <rdiezmail-kernelbugzilla@yahoo.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/fs.c         |   10 +++++-----
 fs/jffs2/nodelist.h   |    8 ++++----
 include/linux/jffs2.h |    4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/jffs2/fs.c~jffs2-avoid-using-c-keyword-new-in-userspace-visible-header fs/jffs2/fs.c
--- a/fs/jffs2/fs.c~jffs2-avoid-using-c-keyword-new-in-userspace-visible-header
+++ a/fs/jffs2/fs.c
@@ -313,8 +313,8 @@ struct inode *jffs2_iget(struct super_bl
 	case S_IFBLK:
 	case S_IFCHR:
 		/* Read the device numbers from the media */
-		if (f->metadata->size != sizeof(jdev.old) &&
-		    f->metadata->size != sizeof(jdev.new)) {
+		if (f->metadata->size != sizeof(jdev.old_id) &&
+		    f->metadata->size != sizeof(jdev.new_id)) {
 			printk(KERN_NOTICE "Device node has strange size %d\n", f->metadata->size);
 			goto error_io;
 		}
@@ -325,10 +325,10 @@ struct inode *jffs2_iget(struct super_bl
 			printk(KERN_NOTICE "Read device numbers for inode %lu failed\n", (unsigned long)inode->i_ino);
 			goto error;
 		}
-		if (f->metadata->size == sizeof(jdev.old))
-			rdev = old_decode_dev(je16_to_cpu(jdev.old));
+		if (f->metadata->size == sizeof(jdev.old_id))
+			rdev = old_decode_dev(je16_to_cpu(jdev.old_id));
 		else
-			rdev = new_decode_dev(je32_to_cpu(jdev.new));
+			rdev = new_decode_dev(je32_to_cpu(jdev.new_id));
 
 	case S_IFSOCK:
 	case S_IFIFO:
diff -puN fs/jffs2/nodelist.h~jffs2-avoid-using-c-keyword-new-in-userspace-visible-header fs/jffs2/nodelist.h
--- a/fs/jffs2/nodelist.h~jffs2-avoid-using-c-keyword-new-in-userspace-visible-header
+++ a/fs/jffs2/nodelist.h
@@ -312,11 +312,11 @@ static inline int jffs2_blocks_use_vmall
 static inline int jffs2_encode_dev(union jffs2_device_node *jdev, dev_t rdev)
 {
 	if (old_valid_dev(rdev)) {
-		jdev->old = cpu_to_je16(old_encode_dev(rdev));
-		return sizeof(jdev->old);
+		jdev->old_id = cpu_to_je16(old_encode_dev(rdev));
+		return sizeof(jdev->old_id);
 	} else {
-		jdev->new = cpu_to_je32(new_encode_dev(rdev));
-		return sizeof(jdev->new);
+		jdev->new_id = cpu_to_je32(new_encode_dev(rdev));
+		return sizeof(jdev->new_id);
 	}
 }
 
diff -puN include/linux/jffs2.h~jffs2-avoid-using-c-keyword-new-in-userspace-visible-header include/linux/jffs2.h
--- a/include/linux/jffs2.h~jffs2-avoid-using-c-keyword-new-in-userspace-visible-header
+++ a/include/linux/jffs2.h
@@ -215,8 +215,8 @@ union jffs2_node_union
 
 /* Data payload for device nodes. */
 union jffs2_device_node {
-	jint16_t old;
-	jint32_t new;
+	jint16_t old_id;
+	jint32_t new_id;
 };
 
 #endif /* __LINUX_JFFS2_H__ */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

