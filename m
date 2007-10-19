From: akpm@linux-foundation.org
Subject: - add-cgroup-write_uint-helper-method.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:50:05 -0700
Message-ID: <200710192250.l9JMo5Wq024048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48849 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966751AbXJSXFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, mm-commits@vger.kernel.org


The patch titled
     Add cgroup write_uint() helper method
has been removed from the -mm tree.  Its filename was
     add-cgroup-write_uint-helper-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add cgroup write_uint() helper method
From: Paul Menage <menage@google.com>

Add write_uint() helper method for cgroup subsystems

This helper is analagous to the read_uint() helper method for
reporting u64 values to userspace. It's designed to reduce the amount
of boilerplate requierd for creating new cgroup subsystems.

Signed-off-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    8 +++++++
 kernel/cgroup.c        |   42 +++++++++++++++++++++++++++++++++++----
 2 files changed, 46 insertions(+), 4 deletions(-)

diff -puN include/linux/cgroup.h~add-cgroup-write_uint-helper-method include/linux/cgroup.h
--- a/include/linux/cgroup.h~add-cgroup-write_uint-helper-method
+++ a/include/linux/cgroup.h
@@ -125,6 +125,14 @@ struct cftype {
 	ssize_t (*write) (struct cgroup *cont, struct cftype *cft,
 			  struct file *file,
 			  const char __user *buf, size_t nbytes, loff_t *ppos);
+
+	/*
+	 * write_uint() is a shortcut for the common case of accepting
+	 * a single integer (as parsed by simple_strtoull) from
+	 * userspace. Use in place of write(); return 0 or error.
+	 */
+	int (*write_uint) (struct cgroup *cont, struct cftype *cft, u64 val);
+
 	int (*release) (struct inode *inode, struct file *file);
 };
 
diff -puN kernel/cgroup.c~add-cgroup-write_uint-helper-method kernel/cgroup.c
--- a/kernel/cgroup.c~add-cgroup-write_uint-helper-method
+++ a/kernel/cgroup.c
@@ -829,6 +829,39 @@ enum cgroup_filetype {
 	FILE_TASKLIST,
 };
 
+static ssize_t cgroup_write_uint(struct cgroup *cont, struct cftype *cft,
+				 struct file *file,
+				 const char __user *userbuf,
+				 size_t nbytes, loff_t *unused_ppos)
+{
+	char buffer[64];
+	int retval = 0;
+	u64 val;
+	char *end;
+
+	if (!nbytes)
+		return -EINVAL;
+	if (nbytes >= sizeof(buffer))
+		return -E2BIG;
+	if (copy_from_user(buffer, userbuf, nbytes))
+		return -EFAULT;
+
+	buffer[nbytes] = 0;     /* nul-terminate */
+
+	/* strip newline if necessary */
+	if (nbytes && (buffer[nbytes-1] == '\n'))
+		buffer[nbytes-1] = 0;
+	val = simple_strtoull(buffer, &end, 0);
+	if (*end)
+		return -EINVAL;
+
+	/* Pass to subsystem */
+	retval = cft->write_uint(cont, cft, val);
+	if (!retval)
+		retval = nbytes;
+	return retval;
+}
+
 static ssize_t cgroup_common_file_write(struct cgroup *cont,
 					   struct cftype *cft,
 					   struct file *file,
@@ -886,10 +919,11 @@ static ssize_t cgroup_file_write(struct 
 
 	if (!cft)
 		return -ENODEV;
-	if (!cft->write)
-		return -EINVAL;
-
-	return cft->write(cont, cft, file, buf, nbytes, ppos);
+	if (cft->write)
+		return cft->write(cont, cft, file, buf, nbytes, ppos);
+	if (cft->write_uint)
+		return cgroup_write_uint(cont, cft, file, buf, nbytes, ppos);
+	return -EINVAL;
 }
 
 static ssize_t cgroup_read_uint(struct cgroup *cont, struct cftype *cft,
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
add-a-refcount-check-in-dput.patch
