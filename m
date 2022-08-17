Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED65DC25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 19:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241633AbiHQTzq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 15:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241634AbiHQTzl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 15:55:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5EFA599D
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 12:55:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13993614EE
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 19:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E973C433D7;
        Wed, 17 Aug 2022 19:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660766138;
        bh=VHbZeOIsYkJo4KM4cMt6RV36GjWJBqgBzMCsdwHsh9Q=;
        h=Date:To:From:Subject:From;
        b=y/db16Z5SMJjJrF1WwlV1j5JvO8Qcu/PcpE5PsqQm9buPJimTvWv3z/rjOjLvd8g7
         PV5Euz9CY4fcZAWp0nAJ7FfIi76FJ7xcTry6YewOzkdZ9wV8jqiVz6lu6UKOXJYrD4
         l3qvWJFDbYBS32ft9lsNqim/N0EtyZ4oObmDzi4U=
Date:   Wed, 17 Aug 2022 12:55:37 -0700
To:     mm-commits@vger.kernel.org, josh@joshtriplett.org,
        adobriyan@gmail.com, deller@gmx.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-add-get_task_cmdline_kernel-function.patch added to mm-nonmm-unstable branch
Message-Id: <20220817195538.5E973C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: add get_task_cmdline_kernel() function
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-add-get_task_cmdline_kernel-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-add-get_task_cmdline_kernel-function.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Helge Deller <deller@gmx.de>
Subject: proc: add get_task_cmdline_kernel() function
Date: Mon, 8 Aug 2022 15:09:14 +0200

Patch series "Dump command line of faulting process to syslog", v3.

This patch series dumps the command line (including the program
parameters) of a faulting process to the syslog.

The motivation for this patch is that it's sometimes quite hard to find
out and annoying to not know which program *exactly* faulted when looking
at the syslog.

For example, a dump on parisc shows:
   do_page_fault() command='cc1' type=15 address=0x00000000 in libc-2.33.so[f6abb000+184000]

-> We see the "cc1" compiler crashed, but it would be useful to know which
   file was compiled.  With this patch you will see that cc1 crashed while
   compiling some haskell code:

   cc1[13472] cmdline: /usr/lib/gcc/hppa-linux-gnu/12/cc1 -quiet @/tmp/ccRkFSfY -imultilib . -imultiarch hppa-linux-gnu -D USE_MINIINTERPRETER -D NO_REGS -D _HPUX_SOURCE -D NOSMP -D THREADED_RTS -include /build/ghc/ghc-9.0.2/includes/dist-install/build/ghcversion.h -iquote compiler/GHC/Iface -quiet -dumpdir /tmp/ghc13413_0/ -dumpbase ghc_5.hc -dumpbase-ext .hc -O -Wimplicit -fno-PIC -fwrapv -fno-builtin -fno-strict-aliasing -o /tmp/ghc13413_0/ghc_5.s

Another example are the glibc testcases which always segfault in "ld.so.1"
with no other info:

   do_page_fault() command='ld.so.1' type=15 address=0x565921d8 in libc.so[f7339000+1bb000]

-> With the patch you can see it was the
   "tst-safe-linking-malloc-hugetlb1" testcase:

   ld.so.1[1151] cmdline: /home/gnu/glibc/objdir/elf/ld.so.1 --library-path /home/gnu/glibc/objdir:/home/gnu/glibc/objdir/math:/home/gnu/
        /home/gnu/glibc/objdir/malloc/tst-safe-linking-malloc-hugetlb1

An example of a typical x86 fault shows up as:
   crash[2326]: segfault at 0 ip 0000561a7969c12e sp 00007ffe97a05630 error 6 in crash[561a7969c000+1000]
   Code: 68 ff ff ff c6 05 19 2f 00 00 01 5d c3 0f 1f 80 00 00 00 00 c3 0f 1f 80 00 00 ...

-> with this patch you now see the whole command line: crash[2326]
   cmdline: ./crash test_write_to_page_0

The patches are relatively small, and reuse functions which are used to
create the output for the /proc/<pid>/cmdline files.

The relevant changes are in patches #1 and #2.
Patch #3 adds the cmdline dump on x86.
Patch #4 drops code from arc which now becomes unnecessary as this is done
by generic code.


This patch (of 4):

Add a new function get_task_cmdline_kernel() which reads the command line
of a process into a kernel buffer.  This command line can then be dumped
by arch code to give additional debug info via the parameters with which a
faulting process was started.

The new function reuses the existing code which provides the cmdline for
the procfs.  For that the existing functions were modified so that the
buffer page is allocated outside of get_mm_proctitle() and
get_mm_cmdline() and instead provided as parameter.

Link: https://lkml.kernel.org/r/20220808130917.30760-1-deller@gmx.de
Link: https://lkml.kernel.org/r/20220808130917.30760-2-deller@gmx.de
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c          |   74 ++++++++++++++++++++++++++------------
 include/linux/proc_fs.h |    5 ++
 2 files changed, 56 insertions(+), 23 deletions(-)

--- a/fs/proc/base.c~proc-add-get_task_cmdline_kernel-function
+++ a/fs/proc/base.c
@@ -217,20 +217,17 @@ static int proc_root_link(struct dentry
  */
 static ssize_t get_mm_proctitle(struct mm_struct *mm, char __user *buf,
 				size_t count, unsigned long pos,
-				unsigned long arg_start)
+				unsigned long arg_start, char *page)
 {
-	char *page;
 	int ret, got;
+	size_t size;
 
-	if (pos >= PAGE_SIZE)
+	size = min_t(size_t, PAGE_SIZE, count);
+	if (pos >= size)
 		return 0;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
-	if (!page)
-		return -ENOMEM;
-
 	ret = 0;
-	got = access_remote_vm(mm, arg_start, page, PAGE_SIZE, FOLL_ANON);
+	got = access_remote_vm(mm, arg_start, page, size, FOLL_ANON);
 	if (got > 0) {
 		int len = strnlen(page, got);
 
@@ -238,7 +235,9 @@ static ssize_t get_mm_proctitle(struct m
 		if (len < got)
 			len++;
 
-		if (len > pos) {
+		if (!buf)
+			ret = len;
+		else if (len > pos) {
 			len -= pos;
 			if (len > count)
 				len = count;
@@ -248,16 +247,15 @@ static ssize_t get_mm_proctitle(struct m
 			ret = len;
 		}
 	}
-	free_page((unsigned long)page);
 	return ret;
 }
 
 static ssize_t get_mm_cmdline(struct mm_struct *mm, char __user *buf,
-			      size_t count, loff_t *ppos)
+			      size_t count, loff_t *ppos, char *page)
 {
 	unsigned long arg_start, arg_end, env_start, env_end;
 	unsigned long pos, len;
-	char *page, c;
+	char c;
 
 	/* Check if process spawned far enough to have cmdline. */
 	if (!mm->env_end)
@@ -283,7 +281,7 @@ static ssize_t get_mm_cmdline(struct mm_
 	len = env_end - arg_start;
 
 	/* We're not going to care if "*ppos" has high bits set */
-	pos = *ppos;
+	pos = ppos ? *ppos : 0;
 	if (pos >= len)
 		return 0;
 	if (count > len - pos)
@@ -299,7 +297,7 @@ static ssize_t get_mm_cmdline(struct mm_
 	 * pos is 0, and set a flag in the 'struct file'.
 	 */
 	if (access_remote_vm(mm, arg_end-1, &c, 1, FOLL_ANON) == 1 && c)
-		return get_mm_proctitle(mm, buf, count, pos, arg_start);
+		return get_mm_proctitle(mm, buf, count, pos, arg_start, page);
 
 	/*
 	 * For the non-setproctitle() case we limit things strictly
@@ -311,10 +309,6 @@ static ssize_t get_mm_cmdline(struct mm_
 	if (count > arg_end - pos)
 		count = arg_end - pos;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
-	if (!page)
-		return -ENOMEM;
-
 	len = 0;
 	while (count) {
 		int got;
@@ -323,7 +317,8 @@ static ssize_t get_mm_cmdline(struct mm_
 		got = access_remote_vm(mm, pos, page, size, FOLL_ANON);
 		if (got <= 0)
 			break;
-		got -= copy_to_user(buf, page, got);
+		if (buf)
+			got -= copy_to_user(buf, page, got);
 		if (unlikely(!got)) {
 			if (!len)
 				len = -EFAULT;
@@ -335,12 +330,11 @@ static ssize_t get_mm_cmdline(struct mm_
 		count -= got;
 	}
 
-	free_page((unsigned long)page);
 	return len;
 }
 
 static ssize_t get_task_cmdline(struct task_struct *tsk, char __user *buf,
-				size_t count, loff_t *pos)
+				size_t count, loff_t *pos, char *page)
 {
 	struct mm_struct *mm;
 	ssize_t ret;
@@ -349,23 +343,57 @@ static ssize_t get_task_cmdline(struct t
 	if (!mm)
 		return 0;
 
-	ret = get_mm_cmdline(mm, buf, count, pos);
+	ret = get_mm_cmdline(mm, buf, count, pos, page);
 	mmput(mm);
 	return ret;
 }
 
+/*
+ * Place up to maxcount chars of the command line of the process into the
+ * cmdline buffer.
+ * NOTE: Requires that the task was locked with task_lock(task) by the caller.
+ */
+void get_task_cmdline_kernel(struct task_struct *task,
+			char *cmdline, size_t maxcount)
+{
+	struct mm_struct *mm;
+	int i;
+
+	mm = task->mm;
+	if (!mm || (task->flags & PF_KTHREAD))
+		return;
+
+	memset(cmdline, 0, maxcount);
+	get_mm_cmdline(mm, NULL, maxcount - 1, NULL, cmdline);
+
+	/* remove NULs between parameters */
+	for (i = 0; i < maxcount - 2; i++) {
+		if (cmdline[i])
+			continue;
+		if (cmdline[i+1] == 0)
+			break;
+		cmdline[i] = ' ';
+	}
+}
+
 static ssize_t proc_pid_cmdline_read(struct file *file, char __user *buf,
 				     size_t count, loff_t *pos)
 {
 	struct task_struct *tsk;
 	ssize_t ret;
+	char *page;
 
 	BUG_ON(*pos < 0);
 
 	tsk = get_proc_task(file_inode(file));
 	if (!tsk)
 		return -ESRCH;
-	ret = get_task_cmdline(tsk, buf, count, pos);
+	page = (char *)__get_free_page(GFP_KERNEL);
+	if (page) {
+		ret = get_task_cmdline(tsk, buf, count, pos, page);
+		free_page((unsigned long)page);
+	} else
+		ret = -ENOMEM;
 	put_task_struct(tsk);
 	if (ret > 0)
 		*pos += ret;
--- a/include/linux/proc_fs.h~proc-add-get_task_cmdline_kernel-function
+++ a/include/linux/proc_fs.h
@@ -158,6 +158,9 @@ int proc_pid_arch_status(struct seq_file
 			struct pid *pid, struct task_struct *task);
 #endif /* CONFIG_PROC_PID_ARCH_STATUS */
 
+void get_task_cmdline_kernel(struct task_struct *task,
+			char *cmdline, size_t maxcount);
+
 #else /* CONFIG_PROC_FS */
 
 static inline void proc_root_init(void)
@@ -216,6 +219,8 @@ static inline struct pid *tgid_pidfd_to_
 	return ERR_PTR(-EBADF);
 }
 
+static inline void get_task_cmdline_kernel(struct task_struct *task, char *cmdl, size_t m) { }
+
 #endif /* CONFIG_PROC_FS */
 
 struct net;
_

Patches currently in -mm which might be from deller@gmx.de are

proc-add-get_task_cmdline_kernel-function.patch
lib-dump_stack-add-dump_stack_print_cmdline-and-wire-up-in-dump_stack_print_info.patch
x86-fault-dump-command-line-of-faulting-process-to-syslog.patch
arc-use-generic-dump_stack_print_cmdline-implementation.patch

