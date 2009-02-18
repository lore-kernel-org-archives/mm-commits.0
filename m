From: akpm@linux-foundation.org
Subject: + filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99.patch added to -mm tree
Date: Wed, 18 Feb 2009 15:12:33 -0800
Message-ID: <200902182312.n1INCXnP015984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725AbZBRXM4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 18:12:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, randy.dunlap@oracle.com, t-sato@yk.jp.nec.com


The patch titled
     Allow SysRq emergency thaw to thaw frozen filesystems (v99)
has been added to the -mm tree.  Its filename is
     filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99.patch

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
@@ -263,11 +263,21 @@ void do_thaw_all(unsigned long unused)
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
linux-next.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99.patch

