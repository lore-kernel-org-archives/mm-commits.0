From: akpm@linux-foundation.org
Subject: + use-simple_read_from_buffer-in-kernel.patch added to -mm tree
Date: Thu, 03 May 2007 13:50:46 -0700
Message-ID: <200705032050.l43KokQX019214@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030180AbXECUwv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 16:52:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, pj@sgi.com, rdunlap@xenotime.net


The patch titled
     use simple_read_from_buffer in kernel/
has been added to the -mm tree.  Its filename is
     use-simple_read_from_buffer-in-kernel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use simple_read_from_buffer in kernel/
From: Akinobu Mita <akinobu.mita@gmail.com>

Cleanup using simple_read_from_buffer() for /dev/cpuset/tasks and
/proc/config.gz.

Cc: Paul Jackson <pj@sgi.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs.c |   15 +++------------
 kernel/cpuset.c  |    7 +------
 2 files changed, 4 insertions(+), 18 deletions(-)

diff -puN kernel/configs.c~use-simple_read_from_buffer-in-kernel kernel/configs.c
--- a/kernel/configs.c~use-simple_read_from_buffer-in-kernel
+++ a/kernel/configs.c
@@ -61,18 +61,9 @@ static ssize_t
 ikconfig_read_current(struct file *file, char __user *buf,
 		      size_t len, loff_t * offset)
 {
-	loff_t pos = *offset;
-	ssize_t count;
-
-	if (pos >= kernel_config_data_size)
-		return 0;
-
-	count = min(len, (size_t)(kernel_config_data_size - pos));
-	if (copy_to_user(buf, kernel_config_data + MAGIC_SIZE + pos, count))
-		return -EFAULT;
-
-	*offset += count;
-	return count;
+	return simple_read_from_buffer(buf, len, offset,
+				       kernel_config_data + MAGIC_SIZE,
+				       kernel_config_data_size);
 }
 
 static const struct file_operations ikconfig_file_ops = {
diff -puN kernel/cpuset.c~use-simple_read_from_buffer-in-kernel kernel/cpuset.c
--- a/kernel/cpuset.c~use-simple_read_from_buffer-in-kernel
+++ a/kernel/cpuset.c
@@ -1710,12 +1710,7 @@ static ssize_t cpuset_tasks_read(struct 
 {
 	struct ctr_struct *ctr = file->private_data;
 
-	if (*ppos + nbytes > ctr->bufsz)
-		nbytes = ctr->bufsz - *ppos;
-	if (copy_to_user(buf, ctr->buf + *ppos, nbytes))
-		return -EFAULT;
-	*ppos += nbytes;
-	return nbytes;
+	return simple_read_from_buffer(buf, nbytes, ppos, ctr->buf, ctr->bufsz);
 }
 
 static int cpuset_tasks_release(struct inode *unused_inode, struct file *file)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
slob-handle-slab_panic-flag.patch
fault-injection-fix-failslab-with-config_numa.patch
hugetlbfs-add-null-check-in-hugetlb_zero_setup.patch
slob-fix-page-order-calculation-on-not-4kb-page.patch
git-alsa.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
fault-injection-enable-stacktrace-with-dwarf2-unwinder.patch
use-slab_panic-flag-cleanup.patch
simplify-the-stacktrace-code.patch
dtlk-fix-error-checks-in-module_init.patch
procfs-use-simple_read_from_buffer.patch
cm4000_cs-fix-error-paths.patch
cm4000_cs-use-bitrev.patch
use-simple_read_from_buffer-in-fs.patch
use-simple_read_from_buffer-in-kernel.patch
sunrpc-fix-error-path-in-module_init.patch
