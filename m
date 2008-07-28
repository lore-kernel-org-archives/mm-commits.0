From: akpm@linux-foundation.org
Subject: + cgroup-uninline-cgroup_has_css_refs.patch added to -mm tree
Date: Sun, 27 Jul 2008 20:24:09 -0700
Message-ID: <200807280324.m6S3O9Rd017790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752053AbYG1DZL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 23:25:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@in.ibm.com, clg@fr.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com


The patch titled
     cgroup: uninline cgroup_has_css_refs()
has been added to the -mm tree.  Its filename is
     cgroup-uninline-cgroup_has_css_refs.patch

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
@@ -2367,7 +2367,7 @@ static int cgroup_mkdir(struct inode *di
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
cgroup-fix-possible-memory-leak.patch
cgroup-remove-duplicate-code-in-allocate_cg_link.patch
cgroup-uninline-cgroup_has_css_refs.patch
memcg-remove-redundant-check-in-move_task.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch

