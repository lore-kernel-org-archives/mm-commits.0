From: akpm@linux-foundation.org
Subject: + proc-detect-duplicate-names-on-registration.patch added to -mm tree
Date: Mon, 19 Nov 2007 15:52:00 -0800
Message-ID: <200711192352.lAJNq0ZB003083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53196 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646AbXKSXwl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:52:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rui.zhang@intel.com, adobriyan@sw.ru


The patch titled
     proc: detect duplicate names on registration
has been added to the -mm tree.  Its filename is
     proc-detect-duplicate-names-on-registration.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc: detect duplicate names on registration
From: Zhang Rui <rui.zhang@intel.com>

Print a warning if PDE is registered with a name which already exists in
target directory.

Bug report and a simple fix can be found here:
http://bugzilla.kernel.org/show_bug.cgi?id=8798

[\n fixlet and no undescriptive variable usage --adobriyan]
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/proc/generic.c~proc-detect-duplicate-names-on-registration fs/proc/generic.c
--- a/fs/proc/generic.c~proc-detect-duplicate-names-on-registration
+++ a/fs/proc/generic.c
@@ -518,6 +518,7 @@ static const struct inode_operations pro
 static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp)
 {
 	unsigned int i;
+	struct proc_dir_entry *tmp;
 	
 	i = get_inode_number();
 	if (i == 0)
@@ -536,6 +537,15 @@ static int proc_register(struct proc_dir
 	}
 
 	spin_lock(&proc_subdir_lock);
+
+	for (tmp = dir->subdir; tmp; tmp = tmp->next)
+		if (strcmp(tmp->name, dp->name) == 0) {
+			printk(KERN_WARNING "PDE '%s' already registered\n",
+				dp->name);
+			dump_stack();
+			break;
+		}
+
 	dp->next = dir->subdir;
 	dp->parent = dir;
 	dir->subdir = dp;
_

Patches currently in -mm which might be from rui.zhang@intel.com are

git-acpi.patch
proc-detect-duplicate-names-on-registration.patch
