From: akpm@linux-foundation.org
Subject: - pidns-use-kzalloc-when-allocating-new-pid_namespace-struct.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:49 -0700
Message-ID: <200807252302.m6PN2nHn003858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508AbYGYXD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:03:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, balbir@in.ibm.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     pidns: use kzalloc when allocating new pid_namespace struct
has been removed from the -mm tree.  Its filename was
     pidns-use-kzalloc-when-allocating-new-pid_namespace-struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pidns: use kzalloc when allocating new pid_namespace struct
From: Pavel Emelyanov <xemul@openvz.org>

It makes many fields initialization implicit helping in auto-setting
#ifdef-ed fields (bsd-acct related pointer will be such).

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN kernel/pid_namespace.c~pidns-use-kzalloc-when-allocating-new-pid_namespace-struct kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-use-kzalloc-when-allocating-new-pid_namespace-struct
+++ a/kernel/pid_namespace.c
@@ -71,7 +71,7 @@ static struct pid_namespace *create_pid_
 	struct pid_namespace *ns;
 	int i;
 
-	ns = kmem_cache_alloc(pid_ns_cachep, GFP_KERNEL);
+	ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
 	if (ns == NULL)
 		goto out;
 
@@ -84,17 +84,13 @@ static struct pid_namespace *create_pid_
 		goto out_free_map;
 
 	kref_init(&ns->kref);
-	ns->last_pid = 0;
-	ns->child_reaper = NULL;
 	ns->level = level;
 
 	set_bit(0, ns->pidmap[0].page);
 	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
 
-	for (i = 1; i < PIDMAP_ENTRIES; i++) {
-		ns->pidmap[i].page = NULL;
+	for (i = 1; i < PIDMAP_ENTRIES; i++)
 		atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);
-	}
 
 	return ns;
 
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
reiser4.patch

