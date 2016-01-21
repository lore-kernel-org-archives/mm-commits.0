From: akpm@linux-foundation.org
Subject: [merged]
 proc-read-mms-argenv_startend-with-mmap-semaphore-taken.patch removed from
 -mm tree
Date: Thu, 21 Jan 2016 15:28:28 -0800
Message-ID: <56a1699c.ssk1W3RvCv+3w88v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbcAUX2b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:28:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mguzik@redhat.com, adobriyan@gmail.com, anshuman.linux@gmail.com, gorcunov@openvz.org, jarod@redhat.com, jstancek@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc read mm's {arg,env}_{start,end} with mmap semaphore taken.
has been removed from the -mm tree.  Its filename was
     proc-read-mms-argenv_startend-with-mmap-semaphore-taken.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Guzik <mguzik@redhat.com>
Subject: proc read mm's {arg,env}_{start,end} with mmap semaphore taken.

Only functions doing more than one read are modified. Consumeres
happened to deal with possibly changing data, but it does not seem
like a good thing to rely on.

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Jan Stancek <jstancek@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anshuman Khandual <anshuman.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   13 ++++++++++---
 mm/util.c      |   16 ++++++++++++----
 2 files changed, 22 insertions(+), 7 deletions(-)

diff -puN fs/proc/base.c~proc-read-mms-argenv_startend-with-mmap-semaphore-taken fs/proc/base.c
--- a/fs/proc/base.c~proc-read-mms-argenv_startend-with-mmap-semaphore-taken
+++ a/fs/proc/base.c
@@ -953,6 +953,7 @@ static ssize_t environ_read(struct file
 	unsigned long src = *ppos;
 	int ret = 0;
 	struct mm_struct *mm = file->private_data;
+	unsigned long env_start, env_end;
 
 	if (!mm)
 		return 0;
@@ -964,19 +965,25 @@ static ssize_t environ_read(struct file
 	ret = 0;
 	if (!atomic_inc_not_zero(&mm->mm_users))
 		goto free;
+
+	down_read(&mm->mmap_sem);
+	env_start = mm->env_start;
+	env_end = mm->env_end;
+	up_read(&mm->mmap_sem);
+
 	while (count > 0) {
 		size_t this_len, max_len;
 		int retval;
 
-		if (src >= (mm->env_end - mm->env_start))
+		if (src >= (env_end - env_start))
 			break;
 
-		this_len = mm->env_end - (mm->env_start + src);
+		this_len = env_end - (env_start + src);
 
 		max_len = min_t(size_t, PAGE_SIZE, count);
 		this_len = min(max_len, this_len);
 
-		retval = access_remote_vm(mm, (mm->env_start + src),
+		retval = access_remote_vm(mm, (env_start + src),
 			page, this_len, 0);
 
 		if (retval <= 0) {
diff -puN mm/util.c~proc-read-mms-argenv_startend-with-mmap-semaphore-taken mm/util.c
--- a/mm/util.c~proc-read-mms-argenv_startend-with-mmap-semaphore-taken
+++ a/mm/util.c
@@ -476,17 +476,25 @@ int get_cmdline(struct task_struct *task
 	int res = 0;
 	unsigned int len;
 	struct mm_struct *mm = get_task_mm(task);
+	unsigned long arg_start, arg_end, env_start, env_end;
 	if (!mm)
 		goto out;
 	if (!mm->arg_end)
 		goto out_mm;	/* Shh! No looking before we're done */
 
-	len = mm->arg_end - mm->arg_start;
+	down_read(&mm->mmap_sem);
+	arg_start = mm->arg_start;
+	arg_end = mm->arg_end;
+	env_start = mm->env_start;
+	env_end = mm->env_end;
+	up_read(&mm->mmap_sem);
+
+	len = arg_end - arg_start;
 
 	if (len > buflen)
 		len = buflen;
 
-	res = access_process_vm(task, mm->arg_start, buffer, len, 0);
+	res = access_process_vm(task, arg_start, buffer, len, 0);
 
 	/*
 	 * If the nul at the end of args has been overwritten, then
@@ -497,10 +505,10 @@ int get_cmdline(struct task_struct *task
 		if (len < res) {
 			res = len;
 		} else {
-			len = mm->env_end - mm->env_start;
+			len = env_end - env_start;
 			if (len > buflen - res)
 				len = buflen - res;
-			res += access_process_vm(task, mm->env_start,
+			res += access_process_vm(task, env_start,
 						 buffer+res, len, 0);
 			res = strnlen(buffer, res);
 		}
_

Patches currently in -mm which might be from mguzik@redhat.com are


