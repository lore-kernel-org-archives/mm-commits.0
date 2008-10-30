From: akpm@linux-foundation.org
Subject: + cgroups-fix-invalid-cgrp-dentry-before-cgroup-has-been-completely-removed.patch added to -mm tree
Date: Thu, 30 Oct 2008 00:32:41 -0700
Message-ID: <200810300732.m9U7Wfua021358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903AbYJ3Hdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 03:33:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl, menage@google.com, mingo@elte.hu


The patch titled
     cgroups: fix invalid cgrp->dentry before cgroup has been completely removed
has been added to the -mm tree.  Its filename is
     cgroups-fix-invalid-cgrp-dentry-before-cgroup-has-been-completely-removed.patch

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
Subject: cgroups: fix invalid cgrp->dentry before cgroup has been completely removed
From: Li Zefan <lizf@cn.fujitsu.com>

This fixes an oops when reading /proc/sched_debug.

A cgroup won't be removed completely until finishing cgroup_diput(), so we
shouldn't invalidate cgrp->dentry in cgroup_rmdir().  Otherwise, when a
group is being removed while cgroup_path() gets called, we may trigger
NULL dereference BUG.

The bug can be reproduced:

 # cat test.sh
 #!/bin/sh
 mount -t cgroup -o cpu xxx /mnt
 for (( ; ; ))
 {
	mkdir /mnt/sub
	rmdir /mnt/sub
 }
 # ./test.sh &
 # cat /proc/sched_debug

BUG: unable to handle kernel NULL pointer dereference at 00000038
IP: [<c045a47f>] cgroup_path+0x39/0x90
...
Call Trace:
 [<c0420344>] ? print_cfs_rq+0x6e/0x75d
 [<c0421160>] ? sched_debug_show+0x72d/0xc1e
...

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/cgroup.c~cgroups-fix-invalid-cgrp-dentry-before-cgroup-has-been-completely-removed kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-invalid-cgrp-dentry-before-cgroup-has-been-completely-removed
+++ a/kernel/cgroup.c
@@ -2497,7 +2497,6 @@ static int cgroup_rmdir(struct inode *un
 	list_del(&cgrp->sibling);
 	spin_lock(&cgrp->dentry->d_lock);
 	d = dget(cgrp->dentry);
-	cgrp->dentry = NULL;
 	spin_unlock(&d->d_lock);
 
 	cgroup_d_remove_dir(d);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
freezer_cg-fix-improper-bug_on-causing-oops.patch
freezer_cg-remove-redundant-check-in-freezer_can_attach.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup.patch
freezer_cg-simplify-freezer_change_state.patch
cgroups-tiny-cleanups.patch
cgroups-fix-invalid-cgrp-dentry-before-cgroup-has-been-completely-removed.patch

