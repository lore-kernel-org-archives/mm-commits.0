From: akpm@linux-foundation.org
Subject: - cgroup-files-move-notify_on_release-file-to-separate-write-handler.patch removed from -mm tree
Date: Fri, 30 May 2008 17:13:56 -0700
Message-ID: <200805310013.m4V0DuRU018691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757205AbYEaAO4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 20:14:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, pj@sgi.com, rientjes@google.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroup files: move notify_on_release file to separate write handler
has been removed from the -mm tree.  Its filename was
     cgroup-files-move-notify_on_release-file-to-separate-write-handler.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup files: move notify_on_release file to separate write handler
From: Paul Menage <menage@google.com>

This patch moves the write handler for the cgroups notify_on_release file
into a separate handler.  This handler requires no cgroups locking since
it relies on atomic bitops for synchronization.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN kernel/cgroup.c~cgroup-files-move-notify_on_release-file-to-separate-write-handler kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-files-move-notify_on_release-file-to-separate-write-handler
+++ a/kernel/cgroup.c
@@ -1440,13 +1440,6 @@ static ssize_t cgroup_common_file_write(
 	case FILE_TASKLIST:
 		retval = attach_task_by_pid(cgrp, buffer);
 		break;
-	case FILE_NOTIFY_ON_RELEASE:
-		clear_bit(CGRP_RELEASABLE, &cgrp->flags);
-		if (simple_strtoul(buffer, NULL, 10) != 0)
-			set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
-		else
-			clear_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
-		break;
 	default:
 		retval = -EINVAL;
 		goto out2;
@@ -2275,6 +2268,18 @@ static u64 cgroup_read_notify_on_release
 	return notify_on_release(cgrp);
 }
 
+static int cgroup_write_notify_on_release(struct cgroup *cgrp,
+					  struct cftype *cft,
+					  u64 val)
+{
+	clear_bit(CGRP_RELEASABLE, &cgrp->flags);
+	if (val)
+		set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
+	else
+		clear_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
+	return 0;
+}
+
 /*
  * for the common functions, 'private' gives the type of file
  */
@@ -2291,7 +2296,7 @@ static struct cftype files[] = {
 	{
 		.name = "notify_on_release",
 		.read_u64 = cgroup_read_notify_on_release,
-		.write = cgroup_common_file_write,
+		.write_u64 = cgroup_write_notify_on_release,
 		.private = FILE_NOTIFY_ON_RELEASE,
 	},
 };
_

Patches currently in -mm which might be from menage@google.com are

call_usermodehelper-increase-reliability.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
mark-res_counter_charge_locked-with-__must_check.patch
cgroup-dont-call-vfs_mkdir.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
make-cgroup_seqfile_release-static.patch
add-a-refcount-check-in-dput.patch

