From: akpm@linux-foundation.org
Subject: + pagemap-prepare-to-reuse-constant-bits-with-page-shift.patch added to -mm tree
Date: Tue, 30 Apr 2013 12:19:52 -0700
Message-ID: <20130430191952.8AB885A4394@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:60961 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab3D3TTx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:19:53 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so89616ggm.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:19:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@parallels.com, glommer@parallels.com, kosaki.motohiro@gmail.com, mpm@selenic.com, mtosatti@redhat.com, sfr@canb.auug.org.au, xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: pagemap: prepare to reuse constant bits with page-shift
has been added to the -mm tree.  Its filename is
     pagemap-prepare-to-reuse-constant-bits-with-page-shift.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

diff -puN Documentation/vm/pagemap.txt~pagemap-prepare-to-reuse-constant-bits-with-page-shitf Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~pagemap-prepare-to-reuse-constant-bits-with-page-shitf
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
diff -puN fs/proc/task_mmu.c~pagemap-prepare-to-reuse-constant-bits-with-page-shitf fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-prepare-to-reuse-constant-bits-with-page-shitf
+++ a/fs/proc/task_mmu.c
@@ -688,6 +688,23 @@ const struct file_operations proc_tid_sm
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
@@ -777,6 +794,13 @@ static ssize_t clear_refs_write(struct f
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
@@ -1086,7 +1110,7 @@ static ssize_t pagemap_read(struct file
 	if (!count)
 		goto out_task;
 
-	pm.v2 = false;
+	pm.v2 = soft_dirty_cleared;
 	pm.len = PM_ENTRY_BYTES * (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
 	pm.buffer = kmalloc(pm.len, GFP_TEMPORARY);
 	ret = -ENOMEM;
@@ -1159,9 +1183,18 @@ out:
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
clear_refs-sanitize-accepted-commands-declaration.patch
clear_refs-introduce-private-struct-for-mm_walk.patch
pagemap-introduce-pagemap_entry_t-without-pmshift-bits.patch
pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4.patch
mm-soft-dirty-bits-for-user-memory-changes-tracking.patch
pagemap-prepare-to-reuse-constant-bits-with-page-shift.patch
linux-next.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
kernel-sysc-make-prctlpr_set_mm-generally-available.patch

