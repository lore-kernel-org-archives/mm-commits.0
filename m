From: akpm@linux-foundation.org
Subject: - send-quota-messages-via-netlink-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 15:21:45 -0700
Message-ID: <200710162221.l9GMLjfY020718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49213 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966125AbXJPWWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 18:22:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     send-quota-messages-via-netlink fix
has been removed from the -mm tree.  Its filename was
     send-quota-messages-via-netlink-fix.patch

This patch was dropped because it was folded into quota-send-messages-via-netlink.patch

------------------------------------------------------
Subject: send-quota-messages-via-netlink fix
From: Jan Kara <jack@suse.cz>

Add documentation of quota netlink interface, fix possible race in handling
of packet numbers, add a comment about GFP_NOFS allocation.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/quota.txt |   59 ++++++++++++++++++++++++++
 fs/dquot.c                          |    8 ++-
 2 files changed, 65 insertions(+), 2 deletions(-)

diff -puN /dev/null Documentation/filesystems/quota.txt
--- /dev/null
+++ a/Documentation/filesystems/quota.txt
@@ -0,0 +1,59 @@
+
+Quota subsystem
+===============
+
+Quota subsystem allows system administrator to set limits on used space and
+number of used inodes (inode is a filesystem structure which is associated
+with each file or directory) for users and/or groups. For both used space and
+number of used inodes there are actually two limits. The first one is called
+softlimit and the second one hardlimit.  An user can never exceed a hardlimit
+for any resource. User is allowed to exceed softlimit but only for limited
+period of time. This period is called "grace period" or "grace time". When
+grace time is over, user is not able to allocate more space/inodes until he
+frees enough of them to get below softlimit.
+
+Quota limits (and amount of grace time) are set independently for each
+filesystem.
+
+For more details about quota design, see the documentation in quota-tools package
+(http://sourceforge.net/projects/linuxquota).
+
+Quota netlink interface
+=======================
+When user exceeds a softlimit, runs out of grace time or reaches hardlimit,
+quota subsystem traditionally printed a message to the controlling terminal of
+the process which caused the excess. This method has the disadvantage that
+when user is using a graphical desktop he usually cannot see the message.
+Thus quota netlink interface has been designed to pass information about
+the above events to userspace. There they can be captured by an application
+and processed accordingly.
+
+The interface uses generic netlink framework (see
+http://lwn.net/Articles/208755/ and http://people.suug.ch/~tgr/libnl/ for more
+details about this layer). The name of the quota generic netlink interface
+is "VFS_DQUOT". Definitions of constants below are in <linux/quota.h>.
+  Currently, the interface supports only one message type QUOTA_NL_C_WARNING.
+This command is used to send a notification about any of the above mentioned
+events. Each message has six attributes. These are (type of the argument is
+in braces):
+        QUOTA_NL_A_QTYPE (u32)
+	  - type of quota beging exceeded (one of USRQUOTA, GRPQUOTA)
+        QUOTA_NL_A_EXCESS_ID (u64)
+	  - UID/GID (depends on quota type) of user / group whose limit
+	    is being exceeded.
+        QUOTA_NL_A_CAUSED_ID (u64)
+	  - UID of a user who caused the event
+        QUOTA_NL_A_WARNING (u32)
+	  - what kind of limit is exceeded:
+		QUOTA_NL_IHARDWARN - inode hardlimit
+		QUOTA_NL_ISOFTLONGWARN - inode softlimit is exceeded longer
+		  than given grace period
+		QUOTA_NL_ISOFTWARN - inode softlimit
+		QUOTA_NL_BHARDWARN - space (block) hardlimit
+		QUOTA_NL_BSOFTLONGWARN - space (block) softlimit is exceeded
+		  longer than given grace period.
+		QUOTA_NL_BSOFTWARN - space (block) softlimit
+        QUOTA_NL_A_DEV_MAJOR (u32)
+	  - major number of a device with the affected filesystem
+        QUOTA_NL_A_DEV_MINOR (u32)
+	  - minor number of a device with the affected filesystem
diff -puN fs/dquot.c~send-quota-messages-via-netlink-fix fs/dquot.c
--- a/fs/dquot.c~send-quota-messages-via-netlink-fix
+++ a/fs/dquot.c
@@ -910,18 +910,22 @@ static struct genl_family quota_genl_fam
 /* Send warning to userspace about user which exceeded quota */
 static void send_warning(const struct dquot *dquot, const char warntype)
 {
-	static unsigned long seq;
+	static atomic_t seq;
 	struct sk_buff *skb;
 	void *msg_head;
 	int ret;
 
+	/* We have to allocate using GFP_NOFS as we are called from a
+	 * filesystem performing write and thus further recursion into
+	 * the fs to free some data could cause deadlocks. */
 	skb = genlmsg_new(QUOTA_NL_MSG_SIZE, GFP_NOFS);
 	if (!skb) {
 		printk(KERN_ERR
 		  "VFS: Not enough memory to send quota warning.\n");
 		return;
 	}
-	msg_head = genlmsg_put(skb, 0, seq++, &quota_genl_family, 0, QUOTA_NL_C_WARNING);
+	msg_head = genlmsg_put(skb, 0, atomic_add_return(1, &seq),
+			&quota_genl_family, 0, QUOTA_NL_C_WARNING);
 	if (!msg_head) {
 		printk(KERN_ERR
 		  "VFS: Cannot store netlink header in quota warning.\n");
_

Patches currently in -mm which might be from jack@suse.cz are

quota-send-messages-via-netlink.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
udf-code-style-fixup-v3.patch
jbd-config_jbd_debug-cannot-create-proc-entry.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
jbd-fix-commit-code-to-properly-abort-journal.patch
