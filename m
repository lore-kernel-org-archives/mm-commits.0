From: akpm@linux-foundation.org
Subject: - cgroup-uninline-cgroup_has_css_refs.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:11 -0700
Message-ID: <200807301914.m6UJEB8b010889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753944AbYG3TcL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:32:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, clg@fr.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup: uninline cgroup_has_css_refs()
has been removed from the -mm tree.  Its filename was
     cgroup-uninline-cgroup_has_css_refs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: uninline cgroup_has_css_refs()
From: Li Zefan <lizf@cn.fujitsu.com>

It's not small enough, and has 2 call sites.

 text    data     bss     dec     hex filename
12813    1676    4832   19321    4b79 cgroup.o.orig
12775    1676    4832   19283    4b53 cgroup.o

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-uninline-cgroup_has_css_refs kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-uninline-cgroup_has_css_refs
+++ a/kernel/cgroup.c
@@ -2368,7 +2368,7 @@ static int cgroup_mkdir(struct inode *di
 	return cgroup_create(c_parent, dentry, mode | S_IFDIR);
 }
 
-static inline int cgroup_has_css_refs(struct cgroup *cgrp)
+static int cgroup_has_css_refs(struct cgroup *cgrp)
 {
 	/* Check the reference count on each subsystem. Since we
 	 * already established that there are no tasks in the
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

