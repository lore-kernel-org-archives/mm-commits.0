From: akpm@linux-foundation.org
Subject: [merged] procfs-fix-error-handling-of-proc_register.patch removed from -mm tree
Date: Thu, 11 Dec 2014 10:57:58 -0800
Message-ID: <5489e936.57AUuJGldxHard8l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490AbaLKS57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbanerje@akamai.com, nicolas.dichtel@6wind.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: fix error handling of proc_register()
has been removed from the -mm tree.  Its filename was
     procfs-fix-error-handling-of-proc_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Debabrata Banerjee <dbanerje@akamai.com>
Subject: procfs: fix error handling of proc_register()

proc_register() error paths are leaking inodes and directory refcounts.

Signed-off-by: Debabrata Banerjee <dbanerje@akamai.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/proc/generic.c~procfs-fix-error-handling-of-proc_register fs/proc/generic.c
--- a/fs/proc/generic.c~procfs-fix-error-handling-of-proc_register
+++ a/fs/proc/generic.c
@@ -369,14 +369,21 @@ static int proc_register(struct proc_dir
 		dp->proc_iops = &proc_file_inode_operations;
 	} else {
 		WARN_ON(1);
+		proc_free_inum(dp->low_ino);
 		return -EINVAL;
 	}
 
 	spin_lock(&proc_subdir_lock);
 	dp->parent = dir;
-	if (pde_subdir_insert(dir, dp) == false)
+	if (pde_subdir_insert(dir, dp) == false) {
 		WARN(1, "proc_dir_entry '%s/%s' already registered\n",
 		     dir->name, dp->name);
+		spin_unlock(&proc_subdir_lock);
+		if (S_ISDIR(dp->mode))
+			dir->nlink--;
+		proc_free_inum(dp->low_ino);
+		return -EEXIST;
+	}
 	spin_unlock(&proc_subdir_lock);
 
 	return 0;
_

Patches currently in -mm which might be from dbanerje@akamai.com are

origin.patch

