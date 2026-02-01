Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491B53EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905033; cv=none; b=BbbbRSs5/AwelRoWnTpZJstajCcg6WKBOH6pVU8eTNG0d+tad5of7Y/O1BRlQ/2ARdwSyyF04quRX9BHlScRrD6OnIoqGwlwjAjXJT4/SXpzc26JSXmxMjajelqW1z6vfz/aJLmjHqAYNyS0IOqEGDUvLdIstraXXQ183raMZeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905033; c=relaxed/simple;
	bh=rDP8WR9vczK4l4mUSkuzHWmKZTOGrUhTmxsuB7dWciY=;
	h=Date:To:From:Subject:Message-Id; b=C1PG+IbKJEKlAcj2B5eEdozlZH943vNAmyAw6joW/fSFWaDODTssAQQ8YU5jJYI2VtOrsTJYmFnKP7ySHITWztt/6cBc81U1MAp1SFSHWiRz1EJkDCSMQNCd/0m9gPZHRPYsClElJmG7Qs6i3RBgY9FLERuhk+JwLA9xjSReguA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oMaoBy+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oMaoBy+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21081C4CEF1;
	Sun,  1 Feb 2026 00:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905033;
	bh=rDP8WR9vczK4l4mUSkuzHWmKZTOGrUhTmxsuB7dWciY=;
	h=Date:To:From:Subject:From;
	b=oMaoBy+g9fwjqVVFh1yhGcQ51/1im32DUrXKQULpFyolhZb6lhdKO+B7dKQjlfEyg
	 ZassB7F+1hR3EGHpuYGimY+4y06mEcAsT+Pi7q1ZsqkxMYB9a5H+yT08z45bBiA+/8
	 Xl8yVyL9ZxIxEpO6Bu3ktknae7KMRpuuceuzLrB0=
Date: Sat, 31 Jan 2026 16:17:12 -0800
To: mm-commits@vger.kernel.org,steven.price@arm.com,pabeni@redhat.com,leon@kernel.org,kuba@kernel.org,horms@kernel.org,felix.kuehling@amd.com,edumazet@google.com,davem@davemloft.net,christian.koenig@amd.com,boris.brezillon@collabora.com,aliceryhl@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] android-binder-use-same_thread_groupproc-tsk-current-in-binder_mmap.patch removed from -mm tree
Message-Id: <20260201001713.21081C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: android/binder: use same_thread_group(proc->tsk, current) in binder_mmap()
has been removed from the -mm tree.  Its filename was
     android-binder-use-same_thread_groupproc-tsk-current-in-binder_mmap.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: android/binder: use same_thread_group(proc->tsk, current) in binder_mmap()
Date: Sun, 25 Jan 2026 17:07:20 +0100

With or without this change the checked condition can be falsely true if
proc->tsk execs, but this is fine: binder_alloc_mmap_handler() checks
vma->vm_mm == alloc->mm.

Link: https://lkml.kernel.org/r/aXY_uPYyUg4rwNOg@redhat.com
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

 drivers/android/binder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder.c~android-binder-use-same_thread_groupproc-tsk-current-in-binder_mmap
+++ a/drivers/android/binder.c
@@ -6015,7 +6015,7 @@ static int binder_mmap(struct file *filp
 {
 	struct binder_proc *proc = filp->private_data;
 
-	if (proc->tsk != current->group_leader)
+	if (!same_thread_group(proc->tsk, current))
 		return -EINVAL;
 
 	binder_debug(BINDER_DEBUG_OPEN_CLOSE,
_

Patches currently in -mm which might be from oleg@redhat.com are


