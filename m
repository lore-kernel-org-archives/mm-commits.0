From: akpm@linux-foundation.org
Subject: - proc-detect-duplicate-names-on-registration.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:11:56 -0800
Message-ID: <200802082011.m18KBbVB010131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33990 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbYBHUuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:50:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rui.zhang@intel.com, adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     proc: detect duplicate names on registration
has been removed from the -mm tree.  Its filename was
     proc-detect-duplicate-names-on-registration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: detect duplicate names on registration
From: Zhang Rui <rui.zhang@intel.com>

Print a warning if PDE is registered with a name which already exists in
target directory.

Bug report and a simple fix can be found here:
http://bugzilla.kernel.org/show_bug.cgi?id=8798

[\n fixlet and no undescriptive variable usage --adobriyan]
[akpm@linux-foundation.org: make printk comprehensible]
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/proc/generic.c~proc-detect-duplicate-names-on-registration fs/proc/generic.c
--- a/fs/proc/generic.c~proc-detect-duplicate-names-on-registration
+++ a/fs/proc/generic.c
@@ -521,6 +521,7 @@ static const struct inode_operations pro
 static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp)
 {
 	unsigned int i;
+	struct proc_dir_entry *tmp;
 	
 	i = get_inode_number();
 	if (i == 0)
@@ -544,6 +545,15 @@ static int proc_register(struct proc_dir
 	}
 
 	spin_lock(&proc_subdir_lock);
+
+	for (tmp = dir->subdir; tmp; tmp = tmp->next)
+		if (strcmp(tmp->name, dp->name) == 0) {
+			printk(KERN_WARNING "proc_dir_entry '%s' already "
+					"registered\n", dp->name);
+			dump_stack();
+			break;
+		}
+
 	dp->next = dir->subdir;
 	dp->parent = dir;
 	dir->subdir = dp;
_

Patches currently in -mm which might be from rui.zhang@intel.com are

origin.patch
