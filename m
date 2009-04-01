From: akpm@linux-foundation.org
Subject: [merged] filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:39:41 -0700
Message-ID: <200904011839.n31Idf5B008771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933221AbZDASnV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:43:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, randy.dunlap@oracle.com, t-sato@yk.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     filesystem freeze: allow SysRq emergency thaw to thaw frozen filesystems
has been removed from the -mm tree.  Its filename was
     filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[randy.dunlap@oracle.com: emergency thaw only if CONFIG_BLOCK enabled]
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysrq.txt |    5 +++++
 drivers/char/sysrq.c    |   19 ++++++++++++++++++-
 fs/buffer.c             |   33 +++++++++++++++++++++++++++++++++
 include/linux/fs.h      |    1 +
 4 files changed, 57 insertions(+), 1 deletion(-)

diff -puN Documentation/sysrq.txt~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems
+++ a/Documentation/sysrq.txt
@@ -81,6 +81,8 @@ On all -  write a character to /proc/sys
 
 'i'     - Send a SIGKILL to all processes, except for init.
 
+'j'     - Forcibly "Just thaw it" - filesystems frozen by the FIFREEZE ioctl.
+
 'k'     - Secure Access Key (SAK) Kills all programs on the current virtual
           console. NOTE: See important comments below in SAK section.
 
@@ -160,6 +162,9 @@ t'E'rm and k'I'll are useful if you have
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
@@ -346,6 +346,19 @@ static struct sysrq_key_op sysrq_moom_op
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
 
+#ifdef CONFIG_BLOCK
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
+#endif
+
 static void sysrq_handle_kill(int key, struct tty_struct *tty)
 {
 	send_sig_all(SIGKILL);
@@ -396,9 +409,13 @@ static struct sysrq_key_op *sysrq_key_ta
 	&sysrq_moom_op,			/* f */
 	/* g: May be registered by ppc for kgdb */
 	NULL,				/* g */
-	NULL,				/* h */
+	NULL,				/* h - reserved for help */
 	&sysrq_kill_op,			/* i */
+#ifdef CONFIG_BLOCK
+	&sysrq_thaw_op,			/* j */
+#else
 	NULL,				/* j */
+#endif
 	&sysrq_SAK_op,			/* k */
 #ifdef CONFIG_SMP
 	&sysrq_showallcpus_op,		/* l */
diff -puN fs/buffer.c~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems fs/buffer.c
--- a/fs/buffer.c~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems
+++ a/fs/buffer.c
@@ -547,6 +547,39 @@ repeat:
 	return err;
 }
 
+void do_thaw_all(unsigned long unused)
+{
+	struct super_block *sb;
+	char b[BDEVNAME_SIZE];
+
+	spin_lock(&sb_lock);
+restart:
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		sb->s_count++;
+		spin_unlock(&sb_lock);
+		down_read(&sb->s_umount);
+		while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
+			printk(KERN_WARNING "Emergency Thaw on %s\n",
+			       bdevname(sb->s_bdev, b));
+		up_read(&sb->s_umount);
+		spin_lock(&sb_lock);
+		if (__put_super_and_need_restart(sb))
+			goto restart;
+	}
+	spin_unlock(&sb_lock);
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
  * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
  * @mapping: the mapping which wants those buffers written
diff -puN include/linux/fs.h~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems include/linux/fs.h
--- a/include/linux/fs.h~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems
+++ a/include/linux/fs.h
@@ -1878,6 +1878,7 @@ extern struct block_device *open_by_devn
 extern void invalidate_bdev(struct block_device *);
 extern int sync_blockdev(struct block_device *bdev);
 extern struct super_block *freeze_bdev(struct block_device *);
+extern void emergency_thaw_all(void);
 extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
 extern int fsync_bdev(struct block_device *);
 extern int fsync_super(struct super_block *);
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch

