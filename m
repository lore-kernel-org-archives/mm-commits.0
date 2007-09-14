From: akpm@linux-foundation.org
Subject: + procfs-detect-duplicate-names.patch added to -mm tree
Date: Thu, 13 Sep 2007 18:35:46 -0700
Message-ID: <200709140135.l8E1ZkAN015641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57634 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397AbXINBft (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 21:35:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rui.zhang@intel.com


The patch titled
     procfs: detect duplicate names
has been added to the -mm tree.  Its filename is
     procfs-detect-duplicate-names.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: procfs: detect duplicate names
From: Zhang Rui <rui.zhang@intel.com>

In order to keep the back-compatibility, only a warning is given currently,
but actions must be taken to fix it when such duplicates are detected.

Bug report and a simple fix can be found here:
http://bugzilla.kernel.org/show_bug.cgi?id=8798

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN fs/proc/generic.c~procfs-detect-duplicate-names fs/proc/generic.c
--- a/fs/proc/generic.c~procfs-detect-duplicate-names
+++ a/fs/proc/generic.c
@@ -523,6 +523,7 @@ static const struct inode_operations pro
 
 static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp)
 {
+	struct proc_dir_entry *tmp = NULL;
 	unsigned int i;
 	
 	i = get_inode_number();
@@ -547,11 +548,22 @@ static int proc_register(struct proc_dir
 	}
 
 	spin_lock(&proc_subdir_lock);
+
+	for (tmp = dir->subdir, i = 0; tmp && !i; tmp = tmp->next)
+		if (!strcmp(dp->name, tmp->name))
+			i = 1;
+
 	dp->next = dir->subdir;
 	dp->parent = dir;
 	dir->subdir = dp;
 	spin_unlock(&proc_subdir_lock);
 
+	if (i) {
+		printk(KERN_WARNING
+			"Duplicate file names \"%s\" detected.", dp->name);
+		dump_stack();
+	}
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from rui.zhang@intel.com are

procfs-detect-duplicate-names.patch
procfs-detect-duplicate-names-fix.patch
