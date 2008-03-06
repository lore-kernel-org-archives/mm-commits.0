From: akpm@linux-foundation.org
Subject: + cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods.patch added to -mm tree
Date: Wed, 05 Mar 2008 16:24:24 -0800
Message-ID: <200803060024.m260OPFC031033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096AbYCFAYm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 19:24:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, a.p.zijlstra@chello.nl, mingo@elte.hu


The patch titled
     CGroups _s64 files: add cgroups read_s64/write_s64 file methods
has been added to the -mm tree.  Its filename is
     cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CGroups _s64 files: add cgroups read_s64/write_s64 file methods
From: Paul Menage <menage@google.com>

These patches add cgroups read_s64 and write_s64 control file methods (the
signed equivalent of read_u64/write_u64) and use them to implement the
cpu.rt_runtime_us control file in the CFS cgroup subsystem.


This patch:

These are the signed equivalents of the read_u64/write_u64 methods

Signed-off-by: Paul Menage <menage@google.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    8 ++++++++
 kernel/cgroup.c        |   38 ++++++++++++++++++++++++++++----------
 2 files changed, 36 insertions(+), 10 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods
+++ a/include/linux/cgroup.h
@@ -216,6 +216,10 @@ struct cftype {
 	 */
 	u64 (*read_u64) (struct cgroup *cgrp, struct cftype *cft);
 	/*
+	 * read_s64() is a signed version of read_u64()
+	 */
+	s64 (*read_s64) (struct cgroup *cgrp, struct cftype *cft);
+	/*
 	 * read_map() is used for defining a map of key/value
 	 * pairs. It should call cb->fill(cb, key, value) for each
 	 * entry. The key/value pairs (and their ordering) should not
@@ -234,6 +238,10 @@ struct cftype {
 	 * userspace. Use in place of write(); return 0 or error.
 	 */
 	int (*write_u64) (struct cgroup *cgrp, struct cftype *cft, u64 val);
+	/*
+	 * write_s64() is a signed version of write_u64()
+	 */
+	int (*write_s64) (struct cgroup *cgrp, struct cftype *cft, s64 val);
 
 	int (*release) (struct inode *inode, struct file *file);
 };
diff -puN kernel/cgroup.c~cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods
+++ a/kernel/cgroup.c
@@ -1291,14 +1291,13 @@ enum cgroup_filetype {
 	FILE_RELEASE_AGENT,
 };
 
-static ssize_t cgroup_write_u64(struct cgroup *cgrp, struct cftype *cft,
+static ssize_t cgroup_write_X64(struct cgroup *cgrp, struct cftype *cft,
 				struct file *file,
 				const char __user *userbuf,
 				size_t nbytes, loff_t *unused_ppos)
 {
 	char buffer[64];
 	int retval = 0;
-	u64 val;
 	char *end;
 
 	if (!nbytes)
@@ -1310,12 +1309,17 @@ static ssize_t cgroup_write_u64(struct c
 
 	buffer[nbytes] = 0;     /* nul-terminate */
 	strstrip(buffer);
-	val = simple_strtoull(buffer, &end, 0);
-	if (*end)
-		return -EINVAL;
-
-	/* Pass to subsystem */
-	retval = cft->write_u64(cgrp, cft, val);
+	if (cft->write_u64) {
+		u64 val = simple_strtoull(buffer, &end, 0);
+		if (*end)
+			return -EINVAL;
+		retval = cft->write_u64(cgrp, cft, val);
+	} else {
+		s64 val = simple_strtoll(buffer, &end, 0);
+		if (*end)
+			return -EINVAL;
+		retval = cft->write_s64(cgrp, cft, val);
+	}
 	if (!retval)
 		retval = nbytes;
 	return retval;
@@ -1396,8 +1400,8 @@ static ssize_t cgroup_file_write(struct 
 		return -ENODEV;
 	if (cft->write)
 		return cft->write(cgrp, cft, file, buf, nbytes, ppos);
-	if (cft->write_u64)
-		return cgroup_write_u64(cgrp, cft, file, buf, nbytes, ppos);
+	if (cft->write_u64 || cft->write_s64)
+		return cgroup_write_X64(cgrp, cft, file, buf, nbytes, ppos);
 	return -EINVAL;
 }
 
@@ -1413,6 +1417,18 @@ static ssize_t cgroup_read_u64(struct cg
 	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
 }
 
+static ssize_t cgroup_read_s64(struct cgroup *cgrp, struct cftype *cft,
+			       struct file *file,
+			       char __user *buf, size_t nbytes,
+			       loff_t *ppos)
+{
+	char tmp[64];
+	s64 val = cft->read_s64(cgrp, cft);
+	int len = sprintf(tmp, "%lld\n", (long long) val);
+
+	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
+}
+
 static ssize_t cgroup_common_file_read(struct cgroup *cgrp,
 					  struct cftype *cft,
 					  struct file *file,
@@ -1469,6 +1485,8 @@ static ssize_t cgroup_file_read(struct f
 		return cft->read(cgrp, cft, file, buf, nbytes, ppos);
 	if (cft->read_u64)
 		return cgroup_read_u64(cgrp, cft, file, buf, nbytes, ppos);
+	if (cft->read_s64)
+		return cgroup_read_s64(cgrp, cft, file, buf, nbytes, ppos);
 	return -EINVAL;
 }
 
_

Patches currently in -mm which might be from menage@google.com are

make-cgroup_enable_task_cg_lists-static.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods.patch
cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file.patch
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch
cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets.patch
add-a-refcount-check-in-dput.patch

