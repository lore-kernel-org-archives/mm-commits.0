From: akpm@linux-foundation.org
Subject: [merged] clear_refs-sanitize-accepted-commands-declaration.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:49 -0700
Message-ID: <51db11c5.Q0OQGVpvIYZvCRY8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab3GHTXu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com, mtosatti@redhat.com, mpm@selenic.com, kosaki.motohiro@gmail.com, glommer@parallels.com, xemul@parallels.com

Subject: [merged] clear_refs-sanitize-accepted-commands-declaration.patch removed from -mm tree
To: xemul@parallels.com,glommer@parallels.com,kosaki.motohiro@gmail.com,mpm@selenic.com,mtosatti@redhat.com,xiaoguangrong@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:49 -0700


The patch titled
     Subject: clear_refs: sanitize accepted commands declaration
has been removed from the -mm tree.  Its filename was
     clear_refs-sanitize-accepted-commands-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: don't assume that sizeof(enum clear_refs_types) == sizeof(int)]
Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

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
@@ -730,7 +733,8 @@ static ssize_t clear_refs_write(struct f
 	char buffer[PROC_NUMBUF];
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	int type;
+	enum clear_refs_types type;
+	int itype;
 	int rv;
 
 	memset(buffer, 0, sizeof(buffer));
@@ -738,10 +742,11 @@ static ssize_t clear_refs_write(struct f
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	rv = kstrtoint(strstrip(buffer), 10, &type);
+	rv = kstrtoint(strstrip(buffer), 10, &itype);
 	if (rv < 0)
 		return rv;
-	if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
+	type = (enum clear_refs_types)itype;
+	if (type < CLEAR_REFS_ALL || type >= CLEAR_REFS_LAST)
 		return -EINVAL;
 	task = get_proc_task(file_inode(file));
 	if (!task)
_

Patches currently in -mm which might be from xemul@parallels.com are

origin.patch
linux-next.patch

