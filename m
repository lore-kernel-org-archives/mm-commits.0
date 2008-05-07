From: akpm@linux-foundation.org
Subject: + fix-cpuset-sched_relax_domain_level-control-file.patch added to -mm tree
Date: Tue, 06 May 2008 18:39:37 -0700
Message-ID: <200805070139.m471dbM9005318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754976AbYEGBkf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 21:40:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, lizf@cn.fujitsu.com, mingo@elte.hu, pj@sgi.com, seto.hidetoshi@jp.fujitsu.com


The patch titled
     Fix cpuset sched_relax_domain_level control file
has been added to the -mm tree.  Its filename is
     fix-cpuset-sched_relax_domain_level-control-file.patch

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
Subject: Fix cpuset sched_relax_domain_level control file
From: Paul Menage <menage@google.com>

Due to a merge conflict, the sched_relax_domain_level control file was marked
as being handled by cpuset_read/write_u64, but the code to handle it was
actually in cpuset_common_file_read/write.

Since the value being written/read is in fact a signed integer, it should be
treated as such; this patch adds cpuset_read/write_s64 functions, and uses
them to handle the sched_relax_domain_level file.

With this patch, the sched_relax_domain_level can be read and written, and the
correct contents seen/updated.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   52 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 12 deletions(-)

diff -puN kernel/cpuset.c~fix-cpuset-sched_relax_domain_level-control-file kernel/cpuset.c
--- a/kernel/cpuset.c~fix-cpuset-sched_relax_domain_level-control-file
+++ a/kernel/cpuset.c
@@ -1031,11 +1031,9 @@ int current_cpuset_is_being_rebound(void
 	return task_cs(current) == cpuset_being_rebound;
 }
 
-static int update_relax_domain_level(struct cpuset *cs, char *buf)
+static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
-	int val = simple_strtol(buf, NULL, 10);
-
-	if (val < 0)
+	if ((int)val < 0)
 		val = -1;
 
 	if (val != cs->relax_domain_level) {
@@ -1280,9 +1278,6 @@ static ssize_t cpuset_common_file_write(
 	case FILE_MEMLIST:
 		retval = update_nodemask(cs, buffer);
 		break;
-	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
-		retval = update_relax_domain_level(cs, buffer);
-		break;
 	default:
 		retval = -EINVAL;
 		goto out2;
@@ -1348,6 +1343,30 @@ static int cpuset_write_u64(struct cgrou
 	return retval;
 }
 
+static int cpuset_write_s64(struct cgroup *cgrp, struct cftype *cft, s64 val)
+{
+	int retval = 0;
+	struct cpuset *cs = cgroup_cs(cgrp);
+	cpuset_filetype_t type = cft->private;
+
+	cgroup_lock();
+
+	if (cgroup_is_removed(cgrp)) {
+		cgroup_unlock();
+		return -ENODEV;
+	}
+	switch (type) {
+	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
+		retval = update_relax_domain_level(cs, val);
+		break;
+	default:
+		retval = -EINVAL;
+		break;
+	}
+	cgroup_unlock();
+	return retval;
+}
+
 /*
  * These ascii lists should be read in a single call, by using a user
  * buffer large enough to hold the entire map.  If read in smaller
@@ -1406,9 +1425,6 @@ static ssize_t cpuset_common_file_read(s
 	case FILE_MEMLIST:
 		s += cpuset_sprintf_memlist(s, cs);
 		break;
-	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
-		s += sprintf(s, "%d", cs->relax_domain_level);
-		break;
 	default:
 		retval = -EINVAL;
 		goto out;
@@ -1449,6 +1465,18 @@ static u64 cpuset_read_u64(struct cgroup
 	}
 }
 
+static s64 cpuset_read_s64(struct cgroup *cont, struct cftype *cft)
+{
+	struct cpuset *cs = cgroup_cs(cont);
+	cpuset_filetype_t type = cft->private;
+	switch (type) {
+	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
+		return cs->relax_domain_level;
+	default:
+		BUG();
+	}
+}
+
 
 /*
  * for the common functions, 'private' gives the type of file
@@ -1499,8 +1527,8 @@ static struct cftype files[] = {
 
 	{
 		.name = "sched_relax_domain_level",
-		.read_u64 = cpuset_read_u64,
-		.write_u64 = cpuset_write_u64,
+		.read_s64 = cpuset_read_s64,
+		.write_s64 = cpuset_write_s64,
 		.private = FILE_SCHED_RELAX_DOMAIN_LEVEL,
 	},
 
_

Patches currently in -mm which might be from menage@google.com are

fix-cpuset-sched_relax_domain_level-control-file.patch
make-cgroup_seqfile_release-static.patch
add-a-refcount-check-in-dput.patch

