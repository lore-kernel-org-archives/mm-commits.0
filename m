From: akpm@linux-foundation.org
Subject: + cgroup-fix-root_count-when-mount-fails-due-to-busy-subsystem.patch added to -mm tree
Date: Tue, 27 Jan 2009 16:53:18 -0800
Message-ID: <200901280053.n0S0rJQQ006739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394AbZA1AyF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 19:54:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, mingo@elte.hu, serue@us.ibm.com


The patch titled
     cgroup: fix root_count when mount fails due to busy subsystem
has been added to the -mm tree.  Its filename is
     cgroup-fix-root_count-when-mount-fails-due-to-busy-subsystem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: fix root_count when mount fails due to busy subsystem
From: Paul Menage <menage@google.com>

root_count was being incremented in cgroup_get_sb() after all error
checking was complete, but decremented in cgroup_kill_sb(), which can be
called on a superblock that we gave up on due to an error.  This patch
changes cgroup_kill_sb() to only decrement root_count if the root was
previously linked into the list of roots.

Signed-off-by: Paul Menage <menage@google.com>
Tested-by: Serge Hallyn <serue@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~cgroup-fix-root_count-when-mount-fails-due-to-busy-subsystem kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-fix-root_count-when-mount-fails-due-to-busy-subsystem
+++ a/kernel/cgroup.c
@@ -1115,8 +1115,10 @@ static void cgroup_kill_sb(struct super_
 	}
 	write_unlock(&css_set_lock);
 
-	list_del(&root->root_list);
-	root_count--;
+	if (!list_empty(&root->root_list)) {
+		list_del(&root->root_list);
+		root_count--;
+	}
 
 	mutex_unlock(&cgroup_mutex);
 
_

Patches currently in -mm which might be from menage@google.com are

cgroups-use-hierarchy-mutex-in-creation-failure-path.patch
memcg-get-put-parents-at-create-free.patch
memcg-get-put-parents-at-create-free-fix.patch
cgroups-fix-lock-inconsistency-in-cgroup_clone.patch
cgroups-add-cpu_relax-calls-in-css_tryget-and-cgroup_clear_css_refs.patch
cgroup-fix-root_count-when-mount-fails-due-to-busy-subsystem.patch
linux-next.patch
cgroups-fix-cgrouph-comments.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-checkpatch-fixes.patch
add-a-refcount-check-in-dput.patch

