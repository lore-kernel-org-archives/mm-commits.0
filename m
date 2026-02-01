Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBAA3EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905032; cv=none; b=lk7zfNCGDxZJlbWN3rNwnPVCx/g8iENDSpu4uADAhP+bXfEpKYXwDyDpUO9W7LKCdnpO/NSm0XnU1c+DyTTK7w7OJM5tqbo8ml28Rjyq6jUZLdHy/VY8l6QY59Ocs/u2EYzz+So80epVmf9t6pPjnMArUHcOLwOPtHDJT0yBRXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905032; c=relaxed/simple;
	bh=rFaAVV2Ce1UWnblCr5mMEkj7UxJkLH84vD/IDKXF/QA=;
	h=Date:To:From:Subject:Message-Id; b=CcrZ85tDwR3DS7aWGQqg9LA+z1ZYn8bYR6v6Fs2VUiJkJOshouK4FaT7DLvLDQcgVWJF8UWLc0v9Gen+HIW8myL1izCjO4v98WkDD7MEs7AUY4K+IOagPLeNa9YdZ0xQX+iUG5ZIlOHM3SLbcBn5LFyPa+6BV+03ADzzhK68nso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RoUTTWw/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RoUTTWw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D900BC4CEF1;
	Sun,  1 Feb 2026 00:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905031;
	bh=rFaAVV2Ce1UWnblCr5mMEkj7UxJkLH84vD/IDKXF/QA=;
	h=Date:To:From:Subject:From;
	b=RoUTTWw/yzPG45CHUTVcR+yEpkIb3v3flPX5VEz9dnFtq+Bve+dLMHOkvTzLFMDTb
	 fD1TZXQnwepdJxU5moGSaQkrwg2KP90EHdWd661MEvrYAQF54RiBtngYyLCaF4QtqI
	 VOha5OvT/w9Kw+3fOghFQVZmFwG8sToAPTzQ0Xro=
Date: Sat, 31 Jan 2026 16:17:11 -0800
To: mm-commits@vger.kernel.org,steven.price@arm.com,pabeni@redhat.com,leon@kernel.org,kuba@kernel.org,horms@kernel.org,felix.kuehling@amd.com,edumazet@google.com,davem@davemloft.net,christian.koenig@amd.com,boris.brezillon@collabora.com,aliceryhl@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] android-binder-dont-abuse-current-group_leader.patch removed from -mm tree
Message-Id: <20260201001711.D900BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: android/binder: don't abuse current->group_leader
has been removed from the -mm tree.  Its filename was
     android-binder-dont-abuse-current-group_leader.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


