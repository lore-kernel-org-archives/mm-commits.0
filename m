From: akpm@linux-foundation.org
Subject: + clear_refs-sanitize-accepted-commands-declaration.patch added to -mm tree
Date: Thu, 11 Apr 2013 14:24:29 -0700
Message-ID: <20130411212429.E904531C15F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:56441 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab3DKVYb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 17:24:31 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so188419qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 14:24:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@parallels.com, glommer@parallels.com, kosaki.motohiro@gmail.com, mpm@selenic.com, mtosatti@redhat.com, xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: clear_refs: sanitize accepted commands declaration
has been added to the -mm tree.  Its filename is
     clear_refs-sanitize-accepted-commands-declaration.patch

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
Subject: clear_refs: sanitize accepted commands declaration

This is the implementation of the soft-dirty bit concept that should help
keep track of changes in user memory, which in turn is very-very required
by the checkpoint-restore project (http://criu.org).

To create a dump of an application(s) we save all the information about it
to files, and the biggest part of such dump is the contents of tasks' memory.
However, there are usage scenarios where it's not required to get _all_ the
task memory while creating a dump. For example, when doing periodical dumps,
it's only required to take full memory dump only at the first step and then
take incremental changes of memory. Another example is live migration. We 
copy all the memory to the destination node without stopping all tasks, then
stop them, check for what pages has changed, dump it and the rest of the state,
then copy it to the destination node. This decreases freeze time significantly.

That said, some help from kernel to watch how processes modify the contents
of their memory is required.

The proposal is to track changes with the help of new soft-dirty bit this way:

1. First do "echo 4 > /proc/$pid/clear_refs".
   At that point kernel clears the soft dirty _and_ the writable bits from all 
   ptes of process $pid. From now on every write to any page will result in #pf 
   and the subsequent call to pte_mkdirty/pmd_mkdirty, which in turn will set
   the soft dirty flag.

2. Then read the /proc/$pid/pagemap2 and check the soft-dirty bit reported there
   (the 55'th one). If set, the respective pte was written to since last call
   to clear refs.

The soft-dirty bit is the _PAGE_BIT_HIDDEN one. Although it's used by kmemcheck,
the latter one marks kernel pages with it, while the former bit is put on user 
pages so they do not conflict to each other.


This patch:

A new clear-refs type will be added in the next patch, so prepare
code for that.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN fs/proc/task_mmu.c~clear_refs-sanitize-accepted-commands-declaration fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~clear_refs-sanitize-accepted-commands-declaration
+++ a/fs/proc/task_mmu.c
@@ -688,6 +688,13 @@ const struct file_operations proc_tid_sm
 	.release	= seq_release_private,
 };
 
+enum clear_refs_types {
+	CLEAR_REFS_ALL = 1,
+	CLEAR_REFS_ANON,
+	CLEAR_REFS_MAPPED,
+	CLEAR_REFS_LAST,
+};
+
 static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 				unsigned long end, struct mm_walk *walk)
 {
@@ -719,10 +726,6 @@ static int clear_refs_pte_range(pmd_t *p
 	return 0;
 }
 
-#define CLEAR_REFS_ALL 1
-#define CLEAR_REFS_ANON 2
-#define CLEAR_REFS_MAPPED 3
-
 static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
@@ -730,7 +733,7 @@ static ssize_t clear_refs_write(struct f
 	char buffer[PROC_NUMBUF];
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	int type;
+	enum clear_refs_types type;
 	int rv;
 
 	memset(buffer, 0, sizeof(buffer));
@@ -738,10 +741,10 @@ static ssize_t clear_refs_write(struct f
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	rv = kstrtoint(strstrip(buffer), 10, &type);
+	rv = kstrtoint(strstrip(buffer), 10, (int *)&type);
 	if (rv < 0)
 		return rv;
-	if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
+	if (type < CLEAR_REFS_ALL || type >= CLEAR_REFS_LAST)
 		return -EINVAL;
 	task = get_proc_task(file_inode(file));
 	if (!task)
_

Patches currently in -mm which might be from xemul@parallels.com are

linux-next.patch
clear_refs-sanitize-accepted-commands-declaration.patch
clear_refs-sanitize-accepted-commands-declaration-fix.patch
clear_refs-introduce-private-struct-for-mm_walk.patch
pagemap-introduce-pagemap_entry_t-without-pmshift-bits.patch
pagemap-introduce-the-proc-pid-pagemap2-file.patch
mm-soft-dirty-bits-for-user-memory-changes-tracking.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
kernel-sysc-make-prctlpr_set_mm-generally-available.patch

