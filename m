From: akpm@linux-foundation.org
Subject: + memrlimit-setup-the-memrlimit-controller-cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-memrlimitcgroup.patch added to -mm tree
Date: Tue, 24 Jun 2008 16:25:37 -0700
Message-ID: <200806242325.m5ONPbIj011679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757018AbYFXX0N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 19:26:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com


The patch titled
     From: menage@google.com
has been added to the -mm tree.  Its filename is
     memrlimit-setup-the-memrlimit-controller-cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-memrlimitcgroup.patch

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
Subject: From: menage@google.com


Currently read_counter_write() is a raw file handler even though it's
ultimately taking a number, since in some cases it wants to
pre-process the string when converting it to a number.

This patch converts res_counter_write() from a raw file handler to a
write_string() handler; this allows some of the boilerplate
copying/locking/checking to be removed, and simplies the cleanup path,
since these functions are now performed by the cgroups framework.

Signed-off-by: Paul Menage <menage@google.com>

---

Index: cws-2.6.26-rc5-mm3/include/linux/res_counter.h
===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memrlimitcgroup.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff -puN mm/memrlimitcgroup.c~memrlimit-setup-the-memrlimit-controller-cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-memrlimitcgroup mm/memrlimitcgroup.c
--- a/mm/memrlimitcgroup.c~memrlimit-setup-the-memrlimit-controller-cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-memrlimitcgroup
+++ a/mm/memrlimitcgroup.c
@@ -118,25 +118,12 @@ static u64 memrlimit_cgroup_read(struct 
 					cft->private);
 }
 
-static int memrlimit_cgroup_write_strategy(char *buf, unsigned long long *tmp)
-{
-	*tmp = memparse(buf, &buf);
-	if (*buf != '\0')
-		return -EINVAL;
-
-	*tmp = PAGE_ALIGN(*tmp);
-	return 0;
-}
-
-static ssize_t memrlimit_cgroup_write(struct cgroup *cgrp, struct cftype *cft,
-					struct file *file,
-					const char __user *userbuf,
-					size_t nbytes,
-					loff_t *ppos)
+static int memrlimit_cgroup_write(struct cgroup *cgrp, struct cftype *cft,
+				  const char *buffer)
 {
 	return res_counter_write(&memrlimit_cgroup_from_cgrp(cgrp)->as_res,
-					cft->private, userbuf, nbytes, ppos,
-					memrlimit_cgroup_write_strategy);
+				 cft->private, buffer,
+				 res_counter_memparse_write_strategy);
 }
 
 static struct cftype memrlimit_cgroup_files[] = {
@@ -148,7 +135,7 @@ static struct cftype memrlimit_cgroup_fi
 	{
 		.name = "limit_in_bytes",
 		.private = RES_LIMIT,
-		.write = memrlimit_cgroup_write,
+		.write_string = memrlimit_cgroup_write,
 		.read_u64 = memrlimit_cgroup_read,
 	},
 	{
_

Patches currently in -mm which might be from menage@google.com are

call_usermodehelper-increase-reliability.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
mark-res_counter_charge_locked-with-__must_check.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
cgroup-files-clean-up-whitespace-in-struct-cftype.patch
cgroup-files-add-write_string-cgroup-control-file-method.patch
cgroup-files-move-the-release_agent-file-to-use-typed-handlers.patch
cgroup-files-move-notify_on_release-file-to-separate-write-handler.patch
cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler.patch
cgroup-files-remove-cpuset_common_file_write.patch
cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler.patch
cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-setup-the-memrlimit-controller-cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-memrlimitcgroup.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch
make-cgroup_seqfile_release-static.patch
add-a-refcount-check-in-dput.patch

