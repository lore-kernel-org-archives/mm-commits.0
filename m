Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F982D9488
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 20:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769460853; cv=none; b=OPvLVHaND6gt60EOTfiq4YiKc/5CGEOjY1cDd67ffWJ+nxoyMWxYBMfvrA3ryU8H8Si8A0EGNDRj7vi9lEy/r7PKzXX+w9lu4yz18+Cf5rGSOc/mWXRKZZ//Tk3sCl2IzzSCF2IzD32Ks1Xv6lgZ3buFP+a2pvpGg45gnmX0Vhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769460853; c=relaxed/simple;
	bh=SmWb3VmfEusbk3jCJJ0QwoMjKFkTuOztr0lxaAKkNWg=;
	h=Date:To:From:Subject:Message-Id; b=Hs3lykCsf6GLEdvcZMMKdidh+RHGyvkUab5qiRX/WBrBrQaqDlpuTt93wg2TgTVp++fgBuD/X8EuTTU7QjPdDxr9cyJdxMF+UO4/OyJ/GPVFAENensH/EwwCrYnWTlt+IyZZxlClRI8RVd8nuH/59R8hbdK5PNRsoDlHjCQxc5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vpcq/O2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vpcq/O2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10BCC116C6;
	Mon, 26 Jan 2026 20:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769460852;
	bh=SmWb3VmfEusbk3jCJJ0QwoMjKFkTuOztr0lxaAKkNWg=;
	h=Date:To:From:Subject:From;
	b=vpcq/O2gvAPK0O8u7tsITFWzqMskdQwxvBxWFwGxQNUrfQWN5CuHHf173wYO5KhnA
	 ZiPbVUtdmE3idXkRZA5bj/KrosHu3TfQW2bVklM2un0OHjyFNE3H+kF4rPp7yDnRKQ
	 3OliNbQLtpRLtkAv6duac01jp4Wiovb0iUtZdQ8A=
Date: Mon, 26 Jan 2026 12:54:12 -0800
To: mm-commits@vger.kernel.org,steven.price@arm.com,pabeni@redhat.com,leon@kernel.org,kuba@kernel.org,horms@kernel.org,felix.kuehling@amd.com,edumazet@google.com,davem@davemloft.net,christian.koenig@amd.com,boris.brezillon@collabora.com,aliceryhl@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + android-binder-dont-abuse-current-group_leader.patch added to mm-nonmm-unstable branch
Message-Id: <20260126205412.C10BCC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: android/binder: don't abuse current->group_leader
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     android-binder-dont-abuse-current-group_leader.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/android-binder-dont-abuse-current-group_leader.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: android/binder: don't abuse current->group_leader
Date: Sun, 25 Jan 2026 17:07:11 +0100

Patch series "don't abuse task_struct.group_leader", v2.

This series removes the usage of ->group_leader when it is "obviously
unnecessary".

I am going to move ->group_leader from task_struct to signal_struct or at
least add the new task_group_leader() helper.  So I will send more
tree-wide changes on top of this series.


This patch (of 7):

Cleanup and preparation to simplify the next changes.

- Use current->tgid instead of current->group_leader->pid

- Use the value returned by get_task_struct() to initialize proc->tsk

Link: https://lkml.kernel.org/r/aXY_h8i78n6yD9JY@redhat.com
Link: https://lkml.kernel.org/r/aXY_ryGDwdygl1Tv@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Christan König <christian.koenig@amd.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/android/binder.c       |    7 +++----
 drivers/android/binder_alloc.c |    2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/android/binder_alloc.c~android-binder-dont-abuse-current-group_leader
+++ a/drivers/android/binder_alloc.c
@@ -1233,7 +1233,7 @@ static struct shrinker *binder_shrinker;
 VISIBLE_IF_KUNIT void __binder_alloc_init(struct binder_alloc *alloc,
 					  struct list_lru *freelist)
 {
-	alloc->pid = current->group_leader->pid;
+	alloc->pid = current->tgid;
 	alloc->mm = current->mm;
 	mmgrab(alloc->mm);
 	mutex_init(&alloc->mutex);
--- a/drivers/android/binder.c~android-binder-dont-abuse-current-group_leader
+++ a/drivers/android/binder.c
@@ -6046,7 +6046,7 @@ static int binder_open(struct inode *nod
 	bool existing_pid = false;
 
 	binder_debug(BINDER_DEBUG_OPEN_CLOSE, "%s: %d:%d\n", __func__,
-		     current->group_leader->pid, current->pid);
+		     current->tgid, current->pid);
 
 	proc = kzalloc(sizeof(*proc), GFP_KERNEL);
 	if (proc == NULL)
@@ -6055,8 +6055,8 @@ static int binder_open(struct inode *nod
 	dbitmap_init(&proc->dmap);
 	spin_lock_init(&proc->inner_lock);
 	spin_lock_init(&proc->outer_lock);
-	get_task_struct(current->group_leader);
-	proc->tsk = current->group_leader;
+	proc->tsk = get_task_struct(current->group_leader);
+	proc->pid = current->tgid;
 	proc->cred = get_cred(filp->f_cred);
 	INIT_LIST_HEAD(&proc->todo);
 	init_waitqueue_head(&proc->freeze_wait);
@@ -6075,7 +6075,6 @@ static int binder_open(struct inode *nod
 	binder_alloc_init(&proc->alloc);
 
 	binder_stats_created(BINDER_STAT_PROC);
-	proc->pid = current->group_leader->pid;
 	INIT_LIST_HEAD(&proc->delivered_death);
 	INIT_LIST_HEAD(&proc->delivered_freeze);
 	INIT_LIST_HEAD(&proc->waiting_threads);
_

Patches currently in -mm which might be from oleg@redhat.com are

android-binder-dont-abuse-current-group_leader.patch
android-binder-use-same_thread_groupproc-tsk-current-in-binder_mmap.patch
drm-amdgpu-dont-abuse-current-group_leader.patch
drm-amd-kill-the-outdated-only-the-pthreads-threading-model-is-supported-checks.patch
drm-pan-dont-abuse-current-group_leader.patch
rdma-umem-dont-abuse-current-group_leader.patch
netclassid-use-thread_group_leaderp-in-update_classid_task.patch

