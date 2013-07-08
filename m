From: akpm@linux-foundation.org
Subject: [merged]
 pagemap-prepare-to-reuse-constant-bits-with-page-shift.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:23:57 -0700
Message-ID: <51db11cd.W5dV8DYM7OoZK2OY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab3GHTX6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com, sfr@canb.auug.org.au, mtosatti@redhat.com, mpm@selenic.com, kosaki.motohiro@gmail.com, glommer@parallels.com, xemul@parallels.com

Subject: [merged] pagemap-prepare-to-reuse-constant-bits-with-page-shift.patch removed from -mm tree
To: xemul@parallels.com,glommer@parallels.com,kosaki.motohiro@gmail.com,mpm@selenic.com,mtosatti@redhat.com,sfr@canb.auug.org.au,xiaoguangrong@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:57 -0700


The patch titled
     Subject: pagemap: prepare to reuse constant bits with page-shift
has been removed from the -mm tree.  Its filename was
     pagemap-prepare-to-reuse-constant-bits-with-page-shift.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pavel Emelyanov <xemul@parallels.com>
Subject: pagemap: prepare to reuse constant bits with page-shift

In order to reuse bits from pagemap entries gracefully, we leave the
entries as is but on pagemap open emit a warning in dmesg, that bits 55-60
are about to change in a couple of releases.  Next, if a user issues
soft-dirty clear command via the clear_refs file (it was disabled before
v3.9) we assume that he's aware of the new pagemap format, note that fact
and report the bits in pagemap in the new manner.

The "migration strategy" looks like this then:

1. existing users are not affected -- they don't touch soft-dirty feature, thus
   see old bits in pagemap, but are warned and have time to fix themselves
2. those who use soft-dirty know about new pagemap format
3. some time soon we get rid of any signs of page-shift in pagemap as well as
   this trick with clear-soft-dirty affecting pagemap format.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/pagemap.txt |    3 +-
 fs/proc/task_mmu.c           |   35 ++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 2 deletions(-)

diff -puN Documentation/vm/pagemap.txt~pagemap-prepare-to-reuse-constant-bits-with-page-shift Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~pagemap-prepare-to-reuse-constant-bits-with-page-shift
+++ a/Documentation/vm/pagemap.txt
@@ -15,7 +15,8 @@ There are three components to pagemap:
     * Bits 0-54  page frame number (PFN) if present
     * Bits 0-4   swap type if swapped
     * Bits 5-54  swap offset if swapped
-    * Bits 55-60 page shift (page size = 1<<page shift)
+    * Bit  55    pte is soft-dirty (see Documentation/vm/soft-dirty.txt)
+    * Bits 56-60 zero
     * Bit  61    page is file-page or shared-anon
     * Bit  62    page swapped
     * Bit  63    page present
diff -puN fs/proc/task_mmu.c~pagemap-prepare-to-reuse-constant-bits-with-page-shift fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-prepare-to-reuse-constant-bits-with-page-shift
+++ a/fs/proc/task_mmu.c
@@ -689,6 +689,23 @@ const struct file_operations proc_tid_sm
 	.release	= seq_release_private,
 };
 
+/*
+ * We do not want to have constant page-shift bits sitting in
+ * pagemap entries and are about to reuse them some time soon.
+ *
+ * Here's the "migration strategy":
+ * 1. when the system boots these bits remain what they are,
+ *    but a warning about future change is printed in log;
+ * 2. once anyone clears soft-dirty bits via clear_refs file,
+ *    these flag is set to denote, that user is aware of the
+ *    new API and those page-shift bits change their meaning.
+ *    The respective warning is printed in dmesg;
+ * 3. In a couple of releases we will remove all the mentions
+ *    of page-shift in pagemap entries.
+ */
+
+static bool soft_dirty_cleared __read_mostly;
+
 enum clear_refs_types {
 	CLEAR_REFS_ALL = 1,
 	CLEAR_REFS_ANON,
@@ -778,6 +795,13 @@ static ssize_t clear_refs_write(struct f
 	type = (enum clear_refs_types)itype;
 	if (type < CLEAR_REFS_ALL || type >= CLEAR_REFS_LAST)
 		return -EINVAL;
+
+	if (type == CLEAR_REFS_SOFT_DIRTY) {
+		soft_dirty_cleared = true;
+		pr_warn_once("The pagemap bits 55-60 has changed their meaning! "
+				"See the linux/Documentation/vm/pagemap.txt for details.\n");
+	}
+
 	task = get_proc_task(file_inode(file));
 	if (!task)
 		return -ESRCH;
@@ -1091,7 +1115,7 @@ static ssize_t pagemap_read(struct file
 	if (!count)
 		goto out_task;
 
-	pm.v2 = false;
+	pm.v2 = soft_dirty_cleared;
 	pm.len = PM_ENTRY_BYTES * (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
 	pm.buffer = kmalloc(pm.len, GFP_TEMPORARY);
 	ret = -ENOMEM;
@@ -1164,9 +1188,18 @@ out:
 	return ret;
 }
 
+static int pagemap_open(struct inode *inode, struct file *file)
+{
+	pr_warn_once("Bits 55-60 of /proc/PID/pagemap entries are about "
+			"to stop being page-shift some time soon. See the "
+			"linux/Documentation/vm/pagemap.txt for details.\n");
+	return 0;
+}
+
 const struct file_operations proc_pagemap_operations = {
 	.llseek		= mem_lseek, /* borrow this */
 	.read		= pagemap_read,
+	.open		= pagemap_open,
 };
 #endif /* CONFIG_PROC_PAGE_MONITOR */
 
_

Patches currently in -mm which might be from xemul@parallels.com are

origin.patch
linux-next.patch

