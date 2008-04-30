From: akpm@linux-foundation.org
Subject: - cgroup-switch-to-proc_create.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:37 -0700
Message-ID: <200804300542.m3U5gbvh029162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754270AbYD3FnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:43:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup: switch to proc_create()
has been removed from the -mm tree.  Its filename was
     cgroup-switch-to-proc_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: switch to proc_create()
From: Li Zefan <lizf@cn.fujitsu.com>

There is a race between create_proc_entry() and the assignment of file ops. 
proc_create() is invented to fix it.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/cgroup.c~cgroup-switch-to-proc_create kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-switch-to-proc_create
+++ a/kernel/cgroup.c
@@ -2545,7 +2545,6 @@ int __init cgroup_init(void)
 {
 	int err;
 	int i;
-	struct proc_dir_entry *entry;
 
 	err = bdi_init(&cgroup_backing_dev_info);
 	if (err)
@@ -2561,9 +2560,7 @@ int __init cgroup_init(void)
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

origin.patch
git-acpi.patch

