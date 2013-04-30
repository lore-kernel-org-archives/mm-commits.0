From: akpm@linux-foundation.org
Subject: [to-be-updated] pagemap-introduce-the-proc-pid-pagemap2-file.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:18:40 -0700
Message-ID: <20130430191840.6B5575A4394@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:43440 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723Ab3D3TSl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:18:41 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so90608qad.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:18:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@parallels.com, glommer@parallels.com, kosaki.motohiro@gmail.com, mpm@selenic.com, mtosatti@redhat.com, xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap: introduce the /proc/PID/pagemap2 file
has been removed from the -mm tree.  Its filename was
     pagemap-introduce-the-proc-pid-pagemap2-file.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Pavel Emelyanov <xemul@parallels.com>
Subject: pagemap: introduce the /proc/PID/pagemap2 file

This file is the same as the pagemap one, but shows entries with bits
55-60 being zero (reserved for future use). Next patch will occupy one
of them.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    2 ++
 Documentation/vm/pagemap.txt       |    3 +++
 fs/proc/base.c                     |    2 ++
 fs/proc/internal.h                 |    1 +
 fs/proc/task_mmu.c                 |   11 +++++++++++
 5 files changed, 19 insertions(+)

diff -puN Documentation/filesystems/proc.txt~pagemap-introduce-the-proc-pid-pagemap2-file Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~pagemap-introduce-the-proc-pid-pagemap2-file
+++ a/Documentation/filesystems/proc.txt
@@ -492,6 +492,8 @@ Any other value written to /proc/PID/cle
 The /proc/pid/pagemap gives the PFN, which can be used to find the pageflags
 using /proc/kpageflags and number of times a page is mapped using
 /proc/kpagecount. For detailed explanation, see Documentation/vm/pagemap.txt.
+(There's also a /proc/pid/pagemap2 file which is the 2nd version of the
+ pagemap one).
 
 1.2 Kernel data
 ---------------
diff -puN Documentation/vm/pagemap.txt~pagemap-introduce-the-proc-pid-pagemap2-file Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~pagemap-introduce-the-proc-pid-pagemap2-file
+++ a/Documentation/vm/pagemap.txt
@@ -30,6 +30,9 @@ There are three components to pagemap:
    determine which areas of memory are actually mapped and llseek to
    skip over unmapped regions.
 
+ * /proc/pid/pagemap2.  This file provides the same info as the pagemap
+   does, but bits 55-60 are reserved for future use and thus zero
+
  * /proc/kpagecount.  This file contains a 64-bit count of the number of
    times each page is mapped, indexed by PFN.
 
diff -puN fs/proc/base.c~pagemap-introduce-the-proc-pid-pagemap2-file fs/proc/base.c
--- a/fs/proc/base.c~pagemap-introduce-the-proc-pid-pagemap2-file
+++ a/fs/proc/base.c
@@ -2634,6 +2634,7 @@ static const struct pid_entry tgid_base_
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
 	REG("smaps",      S_IRUGO, proc_pid_smaps_operations),
 	REG("pagemap",    S_IRUGO, proc_pagemap_operations),
+	REG("pagemap2",   S_IRUGO, proc_pagemap2_operations),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
@@ -2982,6 +2983,7 @@ static const struct pid_entry tid_base_s
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
 	REG("smaps",     S_IRUGO, proc_tid_smaps_operations),
 	REG("pagemap",    S_IRUGO, proc_pagemap_operations),
+	REG("pagemap2",   S_IRUGO, proc_pagemap2_operations),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
diff -puN fs/proc/internal.h~pagemap-introduce-the-proc-pid-pagemap2-file fs/proc/internal.h
--- a/fs/proc/internal.h~pagemap-introduce-the-proc-pid-pagemap2-file
+++ a/fs/proc/internal.h
@@ -49,6 +49,7 @@ extern const struct file_operations proc
 extern const struct file_operations proc_tid_smaps_operations;
 extern const struct file_operations proc_clear_refs_operations;
 extern const struct file_operations proc_pagemap_operations;
+extern const struct file_operations proc_pagemap2_operations;
 extern const struct file_operations proc_net_operations;
 extern const struct inode_operations proc_net_inode_operations;
 extern const struct inode_operations proc_pid_link_inode_operations;
diff -puN fs/proc/task_mmu.c~pagemap-introduce-the-proc-pid-pagemap2-file fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-introduce-the-proc-pid-pagemap2-file
+++ a/fs/proc/task_mmu.c
@@ -1163,6 +1163,17 @@ const struct file_operations proc_pagema
 	.llseek		= mem_lseek, /* borrow this */
 	.read		= pagemap_read,
 };
+
+static ssize_t pagemap2_read(struct file *file, char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	return do_pagemap_read(file, buf, count, ppos, true);
+}
+
+const struct file_operations proc_pagemap2_operations = {
+	.llseek		= mem_lseek, /* borrow this */
+	.read		= pagemap2_read,
+};
 #endif /* CONFIG_PROC_PAGE_MONITOR */
 
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from xemul@parallels.com are

origin.patch
clear_refs-sanitize-accepted-commands-declaration.patch
clear_refs-introduce-private-struct-for-mm_walk.patch
pagemap-introduce-pagemap_entry_t-without-pmshift-bits.patch
pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4.patch
mm-soft-dirty-bits-for-user-memory-changes-tracking.patch
linux-next.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
kernel-sysc-make-prctlpr_set_mm-generally-available.patch

