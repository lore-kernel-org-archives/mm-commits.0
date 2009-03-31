From: akpm@linux-foundation.org
Subject: [folded] filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99.patch removed from -mm tree
Date: Tue, 31 Mar 2009 15:03:25 -0700
Message-ID: <200903312203.n2VM3PG7016452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758772AbZCaWGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 18:06:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, randy.dunlap@oracle.com, t-sato@yk.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Allow SysRq emergency thaw to thaw frozen filesystems (v99)
has been removed from the -mm tree.  Its filename was
     filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99.patch

This patch was dropped because it was folded into filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Allow SysRq emergency thaw to thaw frozen filesystems (v99)
From: Eric Sandeen <sandeen@redhat.com>

(this version fixes a couple small issues raised by Randy Dunlap)
(and adds sb_lock locking I forgot, as akpm pointed out)
(and includes Randy's CONFIG_BLOCK fix)
(and does proper locking, finally)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysrq.txt |    2 +-
 fs/buffer.c             |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff -puN Documentation/sysrq.txt~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99 Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99
+++ a/Documentation/sysrq.txt
@@ -81,7 +81,7 @@ On all -  write a character to /proc/sys
 
 'i'     - Send a SIGKILL to all processes, except for init.
 
-'j'	- Forcibly "Just thaw it" - filesystems frozen by the FIFREEZE ioctl.
+'j'     - Forcibly "Just thaw it" - filesystems frozen by the FIFREEZE ioctl.
 
 'k'     - Secure Access Key (SAK) Kills all programs on the current virtual
           console. NOTE: See important comments below in SAK section.
diff -puN fs/buffer.c~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99 fs/buffer.c
--- a/fs/buffer.c~filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99
+++ a/fs/buffer.c
@@ -552,11 +552,21 @@ void do_thaw_all(unsigned long unused)
 	struct super_block *sb;
 	char b[BDEVNAME_SIZE];
 
+	spin_lock(&sb_lock);
+restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
+		sb->s_count++;
+		spin_unlock(&sb_lock);
+		down_read(&sb->s_umount);
 		while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
 			printk(KERN_WARNING "Emergency Thaw on %s\n",
 			       bdevname(sb->s_bdev, b));
+		up_read(&sb->s_umount);
+		spin_lock(&sb_lock);
+		if (__put_super_and_need_restart(sb))
+			goto restart;
 	}
+	spin_unlock(&sb_lock);
 	printk(KERN_WARNING "Emergency Thaw complete\n");
 }
 
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99.patch
linux-next.patch

