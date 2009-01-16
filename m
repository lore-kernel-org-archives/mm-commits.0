From: akpm@linux-foundation.org
Subject: + filesystem-freeze-allow-sysrq-emergency-sync-to-thaw-frozen-filesystems.patch added to -mm tree
Date: Thu, 15 Jan 2009 16:21:52 -0800
Message-ID: <200901160021.n0G0LqqR015395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbZAPAWL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 19:22:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, t-sato@yk.jp.nec.com


The patch titled
     filesystem-freeze: allow SysRq-emergency-sync to thaw frozen filesystems
has been added to the -mm tree.  Its filename is
     filesystem-freeze-allow-sysrq-emergency-sync-to-thaw-frozen-filesystems.patch

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
Subject: filesystem-freeze: allow SysRq-emergency-sync to thaw frozen filesystems
From: Eric Sandeen <sandeen@redhat.com>

Now that the filesystem freeze operation has been elevated to the VFS, and
is just an ioctl away, some sort of safety net for unintentionally frozen
root filesystems may be in order.

The timeout thaw originally proposed did not get merged, but perhaps
something like this would be useful in emergencies.

This doesn't have to piggyback on the existing emergency sync sysrq, but
it seems like a reasonable, simple addition to me.

I've tested this on a non-root fs with multiple (nested) freezers, as well
as on a system rendered unresponsive due to a frozen root fs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysrq.txt     |    3 ++-
 drivers/char/sysrq.c        |    1 +
 fs/buffer.c                 |   23 +++++++++++++++++++++++
 include/linux/buffer_head.h |    1 +
 4 files changed, 27 insertions(+), 1 deletion(-)

diff -puN Documentation/sysrq.txt~filesystem-freeze-allow-sysrq-emergency-sync-to-thaw-frozen-filesystems Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~filesystem-freeze-allow-sysrq-emergency-sync-to-thaw-frozen-filesystems
+++ a/Documentation/sysrq.txt
@@ -100,7 +100,8 @@ On all -  write a character to /proc/sys
 
 'r'     - Turns off keyboard raw mode and sets it to XLATE.
 
-'s'     - Will attempt to sync all mounted filesystems.
+'s'     - Will attempt to sync all mounted filesystems, and unfreeze
+	  any frozen fileystems.
 
 't'     - Will dump a list of current tasks and their information to your
           console.
diff -puN drivers/char/sysrq.c~filesystem-freeze-allow-sysrq-emergency-sync-to-thaw-frozen-filesystems drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~filesystem-freeze-allow-sysrq-emergency-sync-to-thaw-frozen-filesystems
+++ a/drivers/char/sysrq.c
@@ -151,6 +151,7 @@ static struct sysrq_key_op sysrq_reboot_
 
 static void sysrq_handle_sync(int key, struct tty_struct *tty)
 {
+	emergency_thaw();
 	emergency_sync();
 }
 static struct sysrq_key_op sysrq_sync_op = {
diff -puN fs/buffer.c~filesystem-freeze-allow-sysrq-emergency-sync-to-thaw-frozen-filesystems fs/buffer.c
--- a/fs/buffer.c~filesystem-freeze-allow-sysrq-emergency-sync-to-thaw-frozen-filesystems
+++ a/fs/buffer.c
@@ -258,6 +258,29 @@ struct super_block *freeze_bdev(struct b
 }
 EXPORT_SYMBOL(freeze_bdev);
 
+void do_thaw(unsigned long unused)
+{
+	struct super_block *sb;
+	char b[BDEVNAME_SIZE];
+
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
+			printk(KERN_WARNING "Emergency Thaw on %s\n",
+			       bdevname(sb->s_bdev, b));
+	}
+	printk(KERN_WARNING "Emergency Thaw complete\n");
+}
+
+/**
+ * emergency_thaw -- force thaw every filesystem
+ *
+ * Used for emergency unfreeze of all filesystems via SysRq
+ */
+void emergency_thaw(void)
+{
+	pdflush_operation(do_thaw, 0);
+}
+
 /**
  * thaw_bdev  -- unlock filesystem
  * @bdev:	blockdevice to unlock
diff -puN include/linux/buffer_head.h~filesystem-freeze-allow-sysrq-emergency-sync-to-thaw-frozen-filesystems include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~filesystem-freeze-allow-sysrq-emergency-sync-to-thaw-frozen-filesystems
+++ a/include/linux/buffer_head.h
@@ -171,6 +171,7 @@ void __wait_on_buffer(struct buffer_head
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 int fsync_bdev(struct block_device *);
 struct super_block *freeze_bdev(struct block_device *);
+void emergency_thaw(void);
 int thaw_bdev(struct block_device *, struct super_block *);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
_

Patches currently in -mm which might be from sandeen@redhat.com are

linux-next.patch
filesystem-freeze-allow-sysrq-emergency-sync-to-thaw-frozen-filesystems.patch

