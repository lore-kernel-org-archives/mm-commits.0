From: akpm@linux-foundation.org
Subject: + procfs-fix-error-handling-of-proc_register.patch added to -mm
 tree
Date: Wed, 22 Oct 2014 15:40:38 -0700
Message-ID: <54483266.vgWIYv+j5ItJ9kfq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933227AbaJVWkh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 18:40:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbanerje@akamai.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: fix error handling of proc_register()
has been added to the -mm tree.  Its filename is
     procfs-fix-error-handling-of-proc_register.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-fix-error-handling-of-proc_register.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-fix-error-handling-of-proc_register.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Debabrata Banerjee <dbanerje@akamai.com>
Subject: procfs: fix error handling of proc_register()

proc_register() error paths are leaking inodes and directory refcounts.

Signed-off-by: Debabrata Banerjee <dbanerje@akamai.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
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

procfs-fix-error-handling-of-proc_register.patch

