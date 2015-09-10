From: akpm@linux-foundation.org
Subject: [nacked] proc-convert-to-kstrto-kstrto_from_user.patch removed
 from -mm tree
Date: Thu, 10 Sep 2015 13:41:00 -0700
Message-ID: <55f1eadc.xl5dPPuwE2ZUwGX8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbbIJUlA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Sep 2015 16:41:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert to kstrto*()/kstrto*_from_user()
has been removed from the -mm tree.  Its filename was
     proc-convert-to-kstrto-kstrto_from_user.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: convert to kstrto*()/kstrto*_from_user()

Convert from manual allocation/copy_from_user/...  to kstrto*() family
which were designed for exactly that.

One case can not be converted to kstrto*_from_user() to make code even
more simpler because of whitespace stripping, oh well...

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   70 ++++++++++++++---------------------------------
 1 file changed, 21 insertions(+), 49 deletions(-)

diff -puN fs/proc/base.c~proc-convert-to-kstrto-kstrto_from_user fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-to-kstrto-kstrto_from_user
+++ a/fs/proc/base.c
@@ -1230,10 +1230,9 @@ static ssize_t proc_loginuid_write(struc
 				   size_t count, loff_t *ppos)
 {
 	struct inode * inode = file_inode(file);
-	char *page, *tmp;
-	ssize_t length;
 	uid_t loginuid;
 	kuid_t kloginuid;
+	int rv;
 
 	rcu_read_lock();
 	if (current != pid_task(proc_pid(inode), PIDTYPE_PID)) {
@@ -1242,46 +1241,28 @@ static ssize_t proc_loginuid_write(struc
 	}
 	rcu_read_unlock();
 
-	if (count >= PAGE_SIZE)
-		count = PAGE_SIZE - 1;
-
 	if (*ppos != 0) {
 		/* No partial writes. */
 		return -EINVAL;
 	}
-	page = (char*)__get_free_page(GFP_TEMPORARY);
-	if (!page)
-		return -ENOMEM;
-	length = -EFAULT;
-	if (copy_from_user(page, buf, count))
-		goto out_free_page;
 
-	page[count] = '\0';
-	loginuid = simple_strtoul(page, &tmp, 10);
-	if (tmp == page) {
-		length = -EINVAL;
-		goto out_free_page;
-
-	}
+	rv = kstrtou32_from_user(buf, count, 10, &loginuid);
+	if (rv < 0)
+		return rv;
 
 	/* is userspace tring to explicitly UNSET the loginuid? */
 	if (loginuid == AUDIT_UID_UNSET) {
 		kloginuid = INVALID_UID;
 	} else {
 		kloginuid = make_kuid(file->f_cred->user_ns, loginuid);
-		if (!uid_valid(kloginuid)) {
-			length = -EINVAL;
-			goto out_free_page;
-		}
+		if (!uid_valid(kloginuid))
+			return -EINVAL;
 	}
 
-	length = audit_set_loginuid(kloginuid);
-	if (likely(length == 0))
-		length = count;
-
-out_free_page:
-	free_page((unsigned long) page);
-	return length;
+	rv = audit_set_loginuid(kloginuid);
+	if (rv < 0)
+		return rv;
+	return count;
 }
 
 static const struct file_operations proc_loginuid_operations = {
@@ -1335,8 +1316,9 @@ static ssize_t proc_fault_inject_write(s
 			const char __user * buf, size_t count, loff_t *ppos)
 {
 	struct task_struct *task;
-	char buffer[PROC_NUMBUF], *end;
+	char buffer[PROC_NUMBUF];
 	int make_it_fail;
+	int rv;
 
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
@@ -1345,9 +1327,9 @@ static ssize_t proc_fault_inject_write(s
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	make_it_fail = simple_strtol(strstrip(buffer), &end, 0);
-	if (*end)
-		return -EINVAL;
+	rv = kstrtoint(strstrip(buffer), 0, &make_it_fail);
+	if (rv < 0)
+		return rv;
 	if (make_it_fail < 0 || make_it_fail > 1)
 		return -EINVAL;
 
@@ -2488,32 +2470,20 @@ static ssize_t proc_coredump_filter_writ
 {
 	struct task_struct *task;
 	struct mm_struct *mm;
-	char buffer[PROC_NUMBUF], *end;
 	unsigned int val;
 	int ret;
 	int i;
 	unsigned long mask;
 
-	ret = -EFAULT;
-	memset(buffer, 0, sizeof(buffer));
-	if (count > sizeof(buffer) - 1)
-		count = sizeof(buffer) - 1;
-	if (copy_from_user(buffer, buf, count))
-		goto out_no_task;
-
-	ret = -EINVAL;
-	val = (unsigned int)simple_strtoul(buffer, &end, 0);
-	if (*end == '\n')
-		end++;
-	if (end - buffer == 0)
-		goto out_no_task;
+	ret = kstrtouint_from_user(buf, count, 0, &val);
+	if (ret < 0)
+		return ret;
 
 	ret = -ESRCH;
 	task = get_proc_task(file_inode(file));
 	if (!task)
 		goto out_no_task;
 
-	ret = end - buffer;
 	mm = get_task_mm(task);
 	if (!mm)
 		goto out_no_mm;
@@ -2529,7 +2499,9 @@ static ssize_t proc_coredump_filter_writ
  out_no_mm:
 	put_task_struct(task);
  out_no_task:
-	return ret;
+	if (ret < 0)
+		return ret;
+	return count;
 }
 
 static const struct file_operations proc_coredump_filter_operations = {
_

Patches currently in -mm which might be from adobriyan@gmail.com are

kstrto-accept-0-for-signed-conversion.patch
sound-convert-to-parse_integer.patch

