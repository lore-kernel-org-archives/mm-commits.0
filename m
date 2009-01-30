From: akpm@linux-foundation.org
Subject: + filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch added to -mm tree
Date: Fri, 30 Jan 2009 13:40:08 -0800
Message-ID: <200901302140.n0ULe9J7014227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755188AbZA3Vk5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 16:40:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, t-sato@yk.jp.nec.com


The patch titled
     filesystem freeze: allow SysRq emergency thaw to thaw frozen filesystems
has been added to the -mm tree.  Its filename is
     filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch

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
Subject: filesystem freeze: allow SysRq emergency thaw to thaw frozen filesystems
From: Eric Sandeen <sandeen@redhat.com>

Now that the filesystem freeze operation has been elevated to the VFS, and
is just an ioctl away, some sort of safety net for unintentionally frozen
root filesystems may be in order.

The timeout thaw originally proposed did not get merged, but perhaps
something like this would be useful in emergencies.

For example, freeze /path/to/mountpoint may freeze your root filesystem if
you forgot that you had that unmounted.

I chose 'j' as the last remaining character other than 'h' which is sort
of reserved for help (because help is generated on any unknown character).

I've tested this on a non-root fs with multiple (nested) freezers, as well
as on a system rendered unresponsive due to a frozen root fs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysrq.txt     |    5 +++++
 drivers/char/sysrq.c        |   15 +++++++++++++--
 fs/buffer.c                 |   23 +++++++++++++++++++++++
 include/linux/buffer_head.h |    1 +
 4 files changed, 42 insertions(+), 2 deletions(-)

diff -puN Documentation/sysrq.txt~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems
+++ a/Documentation/sysrq.txt
@@ -81,6 +81,8 @@ On all -  write a character to /proc/sys
 
 'i'     - Send a SIGKILL to all processes, except for init.
 
+'j'	- Forcibly "Just thaw it" - filesystems frozen by the FIFREEZE ioctl.
+
 'k'     - Secure Access Key (SAK) Kills all programs on the current virtual
           console. NOTE: See important comments below in SAK section.
 
@@ -162,6 +164,9 @@ t'E'rm and k'I'll are useful if you have
 are unable to kill any other way, especially if it's spawning other
 processes.
 
+"'J'ust thaw it" is useful if your system becomes unresponsive due to a frozen
+(probably root) filesystem via the FIFREEZE ioctl.
+
 *  Sometimes SysRq seems to get 'stuck' after using it, what can I do?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 That happens to me, also. I've found that tapping shift, alt, and control
diff -puN drivers/char/sysrq.c~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems
+++ a/drivers/char/sysrq.c
@@ -346,6 +346,17 @@ static struct sysrq_key_op sysrq_moom_op
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
 
+static void sysrq_handle_thaw(int key, struct tty_struct *tty)
+{
+	emergency_thaw_all();
+}
+static struct sysrq_key_op sysrq_thaw_op = {
+	.handler	= sysrq_handle_thaw,
+	.help_msg	= "thaw-filesystems(J)",
+	.action_msg	= "Emergency Thaw of all frozen filesystems",
+	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
+};
+
 static void sysrq_handle_kill(int key, struct tty_struct *tty)
 {
 	send_sig_all(SIGKILL);
@@ -396,9 +407,9 @@ static struct sysrq_key_op *sysrq_key_ta
 	&sysrq_moom_op,			/* f */
 	/* g: May be registered by ppc for kgdb */
 	NULL,				/* g */
-	NULL,				/* h */
+	NULL,				/* h - reserved for help */
 	&sysrq_kill_op,			/* i */
-	NULL,				/* j */
+	&sysrq_thaw_op,			/* j */
 	&sysrq_SAK_op,			/* k */
 #ifdef CONFIG_SMP
 	&sysrq_showallcpus_op,		/* l */
diff -puN fs/buffer.c~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems fs/buffer.c
--- a/fs/buffer.c~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems
+++ a/fs/buffer.c
@@ -258,6 +258,29 @@ struct super_block *freeze_bdev(struct b
 }
 EXPORT_SYMBOL(freeze_bdev);
 
+void do_thaw_all(unsigned long unused)
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
+ * emergency_thaw_all -- forcibly thaw every frozen filesystem
+ *
+ * Used for emergency unfreeze of all filesystems via SysRq
+ */
+void emergency_thaw_all(void)
+{
+	pdflush_operation(do_thaw_all, 0);
+}
+
 /**
  * thaw_bdev  -- unlock filesystem
  * @bdev:	blockdevice to unlock
diff -puN include/linux/buffer_head.h~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems
+++ a/include/linux/buffer_head.h
@@ -171,6 +171,7 @@ void __wait_on_buffer(struct buffer_head
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 int fsync_bdev(struct block_device *);
 struct super_block *freeze_bdev(struct block_device *);
+void emergency_thaw_all(void);
 int thaw_bdev(struct block_device *, struct super_block *);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
_

Patches currently in -mm which might be from sandeen@redhat.com are

linux-next.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch

