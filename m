From: akpm@linux-foundation.org
Subject: - procfs-detect-duplicate-names.patch removed from -mm tree
Date: Mon, 19 Nov 2007 15:49:29 -0800
Message-ID: <200711192349.lAJNnTpx003039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37769 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821AbXKSXtd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:49:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     procfs: detect duplicate names
has been removed from the -mm tree.  Its filename was
     procfs-detect-duplicate-names.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: procfs: detect duplicate names
From: Zhang Rui <rui.zhang@intel.com>

In order to keep the back-compatibility, only a warning is given currently,
but actions must be taken to fix it when such duplicates are detected.

Bug report and a simple fix can be found here:
http://bugzilla.kernel.org/show_bug.cgi?id=8798

[akpm@linux-foundation.org: fix stuff]
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
+	struct proc_dir_entry *de;
 	unsigned int i;
 	
 	i = get_inode_number();
@@ -547,11 +548,22 @@ static int proc_register(struct proc_dir
 	}
 
 	spin_lock(&proc_subdir_lock);
+
+	for (de = dir->subdir, i = 0; de && !i; de = de->next)
+		if (!strcmp(dp->name, de->name))
+			i = 1;
+
 	dp->next = dir->subdir;
 	dp->parent = dir;
 	dir->subdir = dp;
 	spin_unlock(&proc_subdir_lock);
 
+	if (i) {
+		printk(KERN_WARNING "Duplicate file names \"%s\" detected.",
+				dp->name);
+		dump_stack();
+	}
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from rui.zhang@intel.com are

git-acpi.patch
procfs-detect-duplicate-names.patch
