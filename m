From: akpm@linux-foundation.org
Subject: - proc-calculate-the-correct-proc-pid-link-count.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:49:11 -0700
Message-ID: <200806081949.m58JnBuH017633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754504AbYFHTto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:49:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, adobriyan@gmail.com, davem@davemloft.net, ebiederm@xmission.com, stable@kernel.org, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     proc: calculate the correct /proc/<pid> link count
has been removed from the -mm tree.  Its filename was
     proc-calculate-the-correct-proc-pid-link-count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: calculate the correct /proc/<pid> link count
From: Vegard Nossum <vegard.nossum@gmail.com>

This patch:

  commit e9720acd728a46cb40daa52c99a979f7c4ff195c
  Author: Pavel Emelyanov <xemul@openvz.org>
  Date:   Fri Mar 7 11:08:40 2008 -0800

    [NET]: Make /proc/net a symlink on /proc/self/net (v3)

introduced a /proc/self/net directory without bumping the corresponding
link count for /proc/self.

This patch replaces the static link count initializations with a call that
counts the number of directory entries in the given pid_entry table
whenever it is instantiated, and thus relieves the burden of manually
keeping the two in sync.

[akpm@linux-foundation.org: cleanup]
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff -puN fs/proc/base.c~proc-calculate-the-correct-proc-pid-link-count fs/proc/base.c
--- a/fs/proc/base.c~proc-calculate-the-correct-proc-pid-link-count
+++ a/fs/proc/base.c
@@ -127,6 +127,25 @@ struct pid_entry {
 		NULL, &proc_single_file_operations,	\
 		{ .proc_show = &proc_##OTYPE } )
 
+/*
+ * Count the number of hardlinks for the pid_entry table, excluding the .
+ * and .. links.
+ */
+static unsigned int pid_entry_count_dirs(const struct pid_entry *entries,
+	unsigned int n)
+{
+	unsigned int i;
+	unsigned int count;
+
+	count = 0;
+	for (i = 0; i < n; ++i) {
+		if (S_ISDIR(entries[i].mode))
+			++count;
+	}
+
+	return count;
+}
+
 int maps_protect;
 EXPORT_SYMBOL(maps_protect);
 
@@ -2585,10 +2604,9 @@ static struct dentry *proc_pid_instantia
 	inode->i_op = &proc_tgid_base_inode_operations;
 	inode->i_fop = &proc_tgid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
-	inode->i_nlink = 5;
-#ifdef CONFIG_SECURITY
-	inode->i_nlink += 1;
-#endif
+
+	inode->i_nlink = 2 + pid_entry_count_dirs(tgid_base_stuff,
+		ARRAY_SIZE(tgid_base_stuff));
 
 	dentry->d_op = &pid_dentry_operations;
 
@@ -2816,10 +2834,9 @@ static struct dentry *proc_task_instanti
 	inode->i_op = &proc_tid_base_inode_operations;
 	inode->i_fop = &proc_tid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
-	inode->i_nlink = 4;
-#ifdef CONFIG_SECURITY
-	inode->i_nlink += 1;
-#endif
+
+	inode->i_nlink = 2 + pid_entry_count_dirs(tid_base_stuff,
+		ARRAY_SIZE(tid_base_stuff));
 
 	dentry->d_op = &pid_dentry_operations;
 
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch
linux-next.patch
arm-fix-header-guards.patch
parisc-fix-incomplete-header-guard.patch
kallsyms-fix-potential-overflow-in-binary-search.patch
cputopology-always-define-cpu-topology-information.patch
cputopology-always-define-cpu-topology-information-cleanup.patch
quota-cleanup-loop-in-sync_dquots.patch

