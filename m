From: akpm@linux-foundation.org
Subject: + cgroup-switch-to-proc_create.patch added to -mm tree
Date: Mon, 10 Mar 2008 13:53:14 -0700
Message-ID: <200803102053.m2AKrEOH004980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369AbYCJUxX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 16:53:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroup: switch to proc_create()
has been added to the -mm tree.  Its filename is
     cgroup-switch-to-proc_create.patch

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
Subject: cgroup: switch to proc_create()
From: Li Zefan <lizf@cn.fujitsu.com>

There is a race between create_proc_entry() and the assignment of file ops. 
proc_create() is invented to fix it.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/cgroup.c~cgroup-switch-to-proc_create kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-switch-to-proc_create
+++ a/kernel/cgroup.c
@@ -2540,7 +2540,6 @@ int __init cgroup_init(void)
 {
 	int err;
 	int i;
-	struct proc_dir_entry *entry;
 
 	err = bdi_init(&cgroup_backing_dev_info);
 	if (err)
@@ -2556,9 +2555,7 @@ int __init cgroup_init(void)
 	if (err < 0)
 		goto out;
 
-	entry = create_proc_entry("cgroups", 0, NULL);
-	if (entry)
-		entry->proc_fops = &proc_cgroupstats_operations;
+	proc_create("cgroups", 0, NULL, &proc_cgroupstats_operations);
 
 out:
 	if (err)
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

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
cgroup-annotate-cgroup_init_subsys-with-__init.patch
cgroup-switch-to-proc_create.patch
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch

