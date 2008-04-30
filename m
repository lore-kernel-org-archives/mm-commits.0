From: akpm@linux-foundation.org
Subject: - cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:31 -0700
Message-ID: <200804300542.m3U5gVW1029153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758315AbYD3GM3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     CGroups _s64 files: add cgroups read_s64/write_s64 file methods
has been removed from the -mm tree.  Its filename was
     cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1299,14 +1299,13 @@ enum cgroup_filetype {
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
@@ -1318,12 +1317,17 @@ static ssize_t cgroup_write_u64(struct c
 
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
@@ -1404,8 +1408,8 @@ static ssize_t cgroup_file_write(struct 
 		return -ENODEV;
 	if (cft->write)
 		return cft->write(cgrp, cft, file, buf, nbytes, ppos);
-	if (cft->write_u64)
-		return cgroup_write_u64(cgrp, cft, file, buf, nbytes, ppos);
+	if (cft->write_u64 || cft->write_s64)
+		return cgroup_write_X64(cgrp, cft, file, buf, nbytes, ppos);
 	return -EINVAL;
 }
 
@@ -1421,6 +1425,18 @@ static ssize_t cgroup_read_u64(struct cg
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
@@ -1477,6 +1493,8 @@ static ssize_t cgroup_file_read(struct f
 		return cft->read(cgrp, cft, file, buf, nbytes, ppos);
 	if (cft->read_u64)
 		return cgroup_read_u64(cgrp, cft, file, buf, nbytes, ppos);
+	if (cft->read_s64)
+		return cgroup_read_s64(cgrp, cft, file, buf, nbytes, ppos);
 	return -EINVAL;
 }
 
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
disable-the-memory-controller-by-default-v3.patch
add-a-refcount-check-in-dput.patch

