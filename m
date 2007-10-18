From: akpm@linux-foundation.org
Subject: - quota-send-messages-via-netlink.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:59:36 -0700
Message-ID: <200710180659.l9I6xafc030997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755834AbXJRHAE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:00:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     quota: send messages via netlink
has been removed from the -mm tree.  Its filename was
     quota-send-messages-via-netlink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: quota: send messages via netlink
From: Jan Kara <jack@suse.cz>

Implement sending of quota messages via netlink interface.  The advantage
is that in userspace we can better decide what to do with the message - for
example display a dialogue in your X session or just write the message to
the console.  As a bonus, we can get rid of problems with console locking
deep inside filesystem code once we remove the old printing mechanism.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/quota.txt |   59 ++++++++++
 fs/Kconfig                          |   18 +++
 fs/dquot.c                          |  144 ++++++++++++++++++++------
 include/linux/quota.h               |   31 +++++
 4 files changed, 222 insertions(+), 30 deletions(-)

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
+in parentheses):
+        QUOTA_NL_A_QTYPE (u32)
+	  - type of quota being exceeded (one of USRQUOTA, GRPQUOTA)
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
diff -puN fs/Kconfig~quota-send-messages-via-netlink fs/Kconfig
--- a/fs/Kconfig~quota-send-messages-via-netlink
+++ a/fs/Kconfig
@@ -534,6 +534,24 @@ config QUOTA
 	  with the quota tools. Probably the quota support is only useful for
 	  multi user systems. If unsure, say N.
 
+config QUOTA_NETLINK_INTERFACE
+	bool "Report quota messages through netlink interface"
+	depends on QUOTA && NET
+	help
+	  If you say Y here, quota warnings (about exceeding softlimit, reaching
+	  hardlimit, etc.) will be reported through netlink interface. If unsure,
+	  say Y.
+
+config PRINT_QUOTA_WARNING
+	bool "Print quota warnings to console (OBSOLETE)"
+	depends on QUOTA
+	default y
+	help
+	  If you say Y here, quota warnings (about exceeding softlimit, reaching
+	  hardlimit, etc.) will be printed to the process' controlling terminal.
+	  Note that this behavior is currently deprecated and may go away in
+	  future. Please use notification via netlink socket instead.
+
 config QFMT_V1
 	tristate "Old quota format support"
 	depends on QUOTA
diff -puN fs/dquot.c~quota-send-messages-via-netlink fs/dquot.c
--- a/fs/dquot.c~quota-send-messages-via-netlink
+++ a/fs/dquot.c
@@ -79,6 +79,10 @@
 #include <linux/capability.h>
 #include <linux/quotaops.h>
 #include <linux/writeback.h> /* for inode_lock, oddly enough.. */
+#ifdef CONFIG_QUOTA_NETLINK_INTERFACE
+#include <net/netlink.h>
+#include <net/genetlink.h>
+#endif
 
 #include <asm/uaccess.h>
 
@@ -823,6 +827,7 @@ static inline void dquot_decr_space(stru
 	clear_bit(DQ_BLKS_B, &dquot->dq_flags);
 }
 
+#ifdef CONFIG_PRINT_QUOTA_WARNING
 static int flag_print_warnings = 1;
 
 static inline int need_print_warning(struct dquot *dquot)
@@ -839,22 +844,15 @@ static inline int need_print_warning(str
 	return 0;
 }
 
-/* Values of warnings */
-#define NOWARN 0
-#define IHARDWARN 1
-#define ISOFTLONGWARN 2
-#define ISOFTWARN 3
-#define BHARDWARN 4
-#define BSOFTLONGWARN 5
-#define BSOFTWARN 6
-
 /* Print warning to user which exceeded quota */
 static void print_warning(struct dquot *dquot, const char warntype)
 {
 	char *msg = NULL;
 	struct tty_struct *tty;
-	int flag = (warntype == BHARDWARN || warntype == BSOFTLONGWARN) ? DQ_BLKS_B :
-	  ((warntype == IHARDWARN || warntype == ISOFTLONGWARN) ? DQ_INODES_B : 0);
+	int flag = (warntype == QUOTA_NL_BHARDWARN ||
+		warntype == QUOTA_NL_BSOFTLONGWARN) ? DQ_BLKS_B :
+		((warntype == QUOTA_NL_IHARDWARN ||
+		warntype == QUOTA_NL_ISOFTLONGWARN) ? DQ_INODES_B : 0);
 
 	if (!need_print_warning(dquot) || (flag && test_and_set_bit(flag, &dquot->dq_flags)))
 		return;
@@ -864,28 +862,28 @@ static void print_warning(struct dquot *
 	if (!tty)
 		goto out_lock;
 	tty_write_message(tty, dquot->dq_sb->s_id);
-	if (warntype == ISOFTWARN || warntype == BSOFTWARN)
+	if (warntype == QUOTA_NL_ISOFTWARN || warntype == QUOTA_NL_BSOFTWARN)
 		tty_write_message(tty, ": warning, ");
 	else
 		tty_write_message(tty, ": write failed, ");
 	tty_write_message(tty, quotatypes[dquot->dq_type]);
 	switch (warntype) {
-		case IHARDWARN:
+		case QUOTA_NL_IHARDWARN:
 			msg = " file limit reached.\r\n";
 			break;
-		case ISOFTLONGWARN:
+		case QUOTA_NL_ISOFTLONGWARN:
 			msg = " file quota exceeded too long.\r\n";
 			break;
-		case ISOFTWARN:
+		case QUOTA_NL_ISOFTWARN:
 			msg = " file quota exceeded.\r\n";
 			break;
-		case BHARDWARN:
+		case QUOTA_NL_BHARDWARN:
 			msg = " block limit reached.\r\n";
 			break;
-		case BSOFTLONGWARN:
+		case QUOTA_NL_BSOFTLONGWARN:
 			msg = " block quota exceeded too long.\r\n";
 			break;
-		case BSOFTWARN:
+		case QUOTA_NL_BSOFTWARN:
 			msg = " block quota exceeded.\r\n";
 			break;
 	}
@@ -893,14 +891,93 @@ static void print_warning(struct dquot *
 out_lock:
 	mutex_unlock(&tty_mutex);
 }
+#endif
+
+#ifdef CONFIG_QUOTA_NETLINK_INTERFACE
+
+/* Size of quota netlink message - actually an upperbound for buffer size */
+#define QUOTA_NL_MSG_SIZE 32
+
+/* Netlink family structure for quota */
+static struct genl_family quota_genl_family = {
+	.id = GENL_ID_GENERATE,
+	.hdrsize = 0,
+	.name = "VFS_DQUOT",
+	.version = 1,
+	.maxattr = QUOTA_NL_A_MAX,
+};
+
+/* Send warning to userspace about user which exceeded quota */
+static void send_warning(const struct dquot *dquot, const char warntype)
+{
+	static atomic_t seq;
+	struct sk_buff *skb;
+	void *msg_head;
+	int ret;
+
+	/* We have to allocate using GFP_NOFS as we are called from a
+	 * filesystem performing write and thus further recursion into
+	 * the fs to free some data could cause deadlocks. */
+	skb = genlmsg_new(QUOTA_NL_MSG_SIZE, GFP_NOFS);
+	if (!skb) {
+		printk(KERN_ERR
+		  "VFS: Not enough memory to send quota warning.\n");
+		return;
+	}
+	msg_head = genlmsg_put(skb, 0, atomic_add_return(1, &seq),
+			&quota_genl_family, 0, QUOTA_NL_C_WARNING);
+	if (!msg_head) {
+		printk(KERN_ERR
+		  "VFS: Cannot store netlink header in quota warning.\n");
+		goto err_out;
+	}
+	ret = nla_put_u32(skb, QUOTA_NL_A_QTYPE, dquot->dq_type);
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u64(skb, QUOTA_NL_A_EXCESS_ID, dquot->dq_id);
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u32(skb, QUOTA_NL_A_WARNING, warntype);
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MAJOR,
+		MAJOR(dquot->dq_sb->s_dev));
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MINOR,
+		MINOR(dquot->dq_sb->s_dev));
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID, current->user->uid);
+	if (ret)
+		goto attr_err_out;
+	genlmsg_end(skb, msg_head);
+
+	ret = genlmsg_multicast(skb, 0, quota_genl_family.id, GFP_NOFS);
+	if (ret < 0 && ret != -ESRCH)
+		printk(KERN_ERR
+			"VFS: Failed to send notification message: %d\n", ret);
+	return;
+attr_err_out:
+	printk(KERN_ERR "VFS: Failed to compose quota message: %d\n", ret);
+err_out:
+	kfree_skb(skb);
+}
+#endif
 
 static inline void flush_warnings(struct dquot **dquots, char *warntype)
 {
 	int i;
 
 	for (i = 0; i < MAXQUOTAS; i++)
-		if (dquots[i] != NODQUOT && warntype[i] != NOWARN)
+		if (dquots[i] != NODQUOT && warntype[i] != QUOTA_NL_NOWARN) {
+#ifdef CONFIG_PRINT_QUOTA_WARNING
 			print_warning(dquots[i], warntype[i]);
+#endif
+#ifdef CONFIG_QUOTA_NETLINK_INTERFACE
+			send_warning(dquots[i], warntype[i]);
+#endif
+		}
 }
 
 static inline char ignore_hardlimit(struct dquot *dquot)
@@ -914,14 +991,14 @@ static inline char ignore_hardlimit(stru
 /* needs dq_data_lock */
 static int check_idq(struct dquot *dquot, ulong inodes, char *warntype)
 {
-	*warntype = NOWARN;
+	*warntype = QUOTA_NL_NOWARN;
 	if (inodes <= 0 || test_bit(DQ_FAKE_B, &dquot->dq_flags))
 		return QUOTA_OK;
 
 	if (dquot->dq_dqb.dqb_ihardlimit &&
 	   (dquot->dq_dqb.dqb_curinodes + inodes) > dquot->dq_dqb.dqb_ihardlimit &&
             !ignore_hardlimit(dquot)) {
-		*warntype = IHARDWARN;
+		*warntype = QUOTA_NL_IHARDWARN;
 		return NO_QUOTA;
 	}
 
@@ -929,14 +1006,14 @@ static int check_idq(struct dquot *dquot
 	   (dquot->dq_dqb.dqb_curinodes + inodes) > dquot->dq_dqb.dqb_isoftlimit &&
 	    dquot->dq_dqb.dqb_itime && get_seconds() >= dquot->dq_dqb.dqb_itime &&
             !ignore_hardlimit(dquot)) {
-		*warntype = ISOFTLONGWARN;
+		*warntype = QUOTA_NL_ISOFTLONGWARN;
 		return NO_QUOTA;
 	}
 
 	if (dquot->dq_dqb.dqb_isoftlimit &&
 	   (dquot->dq_dqb.dqb_curinodes + inodes) > dquot->dq_dqb.dqb_isoftlimit &&
 	    dquot->dq_dqb.dqb_itime == 0) {
-		*warntype = ISOFTWARN;
+		*warntype = QUOTA_NL_ISOFTWARN;
 		dquot->dq_dqb.dqb_itime = get_seconds() + sb_dqopt(dquot->dq_sb)->info[dquot->dq_type].dqi_igrace;
 	}
 
@@ -946,7 +1023,7 @@ static int check_idq(struct dquot *dquot
 /* needs dq_data_lock */
 static int check_bdq(struct dquot *dquot, qsize_t space, int prealloc, char *warntype)
 {
-	*warntype = 0;
+	*warntype = QUOTA_NL_NOWARN;
 	if (space <= 0 || test_bit(DQ_FAKE_B, &dquot->dq_flags))
 		return QUOTA_OK;
 
@@ -954,7 +1031,7 @@ static int check_bdq(struct dquot *dquot
 	   toqb(dquot->dq_dqb.dqb_curspace + space) > dquot->dq_dqb.dqb_bhardlimit &&
             !ignore_hardlimit(dquot)) {
 		if (!prealloc)
-			*warntype = BHARDWARN;
+			*warntype = QUOTA_NL_BHARDWARN;
 		return NO_QUOTA;
 	}
 
@@ -963,7 +1040,7 @@ static int check_bdq(struct dquot *dquot
 	    dquot->dq_dqb.dqb_btime && get_seconds() >= dquot->dq_dqb.dqb_btime &&
             !ignore_hardlimit(dquot)) {
 		if (!prealloc)
-			*warntype = BSOFTLONGWARN;
+			*warntype = QUOTA_NL_BSOFTLONGWARN;
 		return NO_QUOTA;
 	}
 
@@ -971,7 +1048,7 @@ static int check_bdq(struct dquot *dquot
 	   toqb(dquot->dq_dqb.dqb_curspace + space) > dquot->dq_dqb.dqb_bsoftlimit &&
 	    dquot->dq_dqb.dqb_btime == 0) {
 		if (!prealloc) {
-			*warntype = BSOFTWARN;
+			*warntype = QUOTA_NL_BSOFTWARN;
 			dquot->dq_dqb.dqb_btime = get_seconds() + sb_dqopt(dquot->dq_sb)->info[dquot->dq_type].dqi_bgrace;
 		}
 		else
@@ -1066,7 +1143,7 @@ out_add:
 		return QUOTA_OK;
 	}
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		warntype[cnt] = NOWARN;
+		warntype[cnt] = QUOTA_NL_NOWARN;
 
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	if (IS_NOQUOTA(inode)) {	/* Now we can do reliable test... */
@@ -1112,7 +1189,7 @@ int dquot_alloc_inode(const struct inode
 	if (IS_NOQUOTA(inode))
 		return QUOTA_OK;
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		warntype[cnt] = NOWARN;
+		warntype[cnt] = QUOTA_NL_NOWARN;
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	if (IS_NOQUOTA(inode)) {
 		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
@@ -1234,7 +1311,7 @@ int dquot_transfer(struct inode *inode, 
 	/* Clear the arrays */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		transfer_to[cnt] = transfer_from[cnt] = NODQUOT;
-		warntype[cnt] = NOWARN;
+		warntype[cnt] = QUOTA_NL_NOWARN;
 	}
 	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	/* Now recheck reliably when holding dqptr_sem */
@@ -1808,6 +1885,7 @@ static ctl_table fs_dqstats_table[] = {
 		.mode		= 0444,
 		.proc_handler	= &proc_dointvec,
 	},
+#ifdef CONFIG_PRINT_QUOTA_WARNING
 	{
 		.ctl_name	= FS_DQ_WARNINGS,
 		.procname	= "warnings",
@@ -1816,6 +1894,7 @@ static ctl_table fs_dqstats_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#endif
 	{ .ctl_name = 0 },
 };
 
@@ -1877,6 +1956,11 @@ static int __init dquot_init(void)
 
 	register_shrinker(&dqcache_shrinker);
 
+#ifdef CONFIG_QUOTA_NETLINK_INTERFACE
+	if (genl_register_family(&quota_genl_family) != 0)
+		printk(KERN_ERR "VFS: Failed to create quota netlink interface.\n");
+#endif
+
 	return 0;
 }
 module_init(dquot_init);
diff -puN include/linux/quota.h~quota-send-messages-via-netlink include/linux/quota.h
--- a/include/linux/quota.h~quota-send-messages-via-netlink
+++ a/include/linux/quota.h
@@ -128,6 +128,37 @@ struct if_dqinfo {
 	__u32 dqi_valid;
 };
 
+/*
+ * Definitions for quota netlink interface
+ */
+#define QUOTA_NL_NOWARN 0
+#define QUOTA_NL_IHARDWARN 1		/* Inode hardlimit reached */
+#define QUOTA_NL_ISOFTLONGWARN 2 	/* Inode grace time expired */
+#define QUOTA_NL_ISOFTWARN 3		/* Inode softlimit reached */
+#define QUOTA_NL_BHARDWARN 4		/* Block hardlimit reached */
+#define QUOTA_NL_BSOFTLONGWARN 5	/* Block grace time expired */
+#define QUOTA_NL_BSOFTWARN 6		/* Block softlimit reached */
+
+enum {
+	QUOTA_NL_C_UNSPEC,
+	QUOTA_NL_C_WARNING,
+	__QUOTA_NL_C_MAX,
+};
+#define QUOTA_NL_C_MAX (__QUOTA_NL_C_MAX - 1)
+
+enum {
+	QUOTA_NL_A_UNSPEC,
+	QUOTA_NL_A_QTYPE,
+	QUOTA_NL_A_EXCESS_ID,
+	QUOTA_NL_A_WARNING,
+	QUOTA_NL_A_DEV_MAJOR,
+	QUOTA_NL_A_DEV_MINOR,
+	QUOTA_NL_A_CAUSED_ID,
+	__QUOTA_NL_A_MAX,
+};
+#define QUOTA_NL_A_MAX (__QUOTA_NL_A_MAX - 1)
+
+
 #ifdef __KERNEL__
 #include <linux/spinlock.h>
 #include <linux/rwsem.h>
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size-checkpatch-fixes.patch
jbd-config_jbd_debug-cannot-create-proc-entry.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
jbd-fix-commit-code-to-properly-abort-journal.patch
