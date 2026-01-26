Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9107298CAB
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 20:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769460863; cv=none; b=S1UtXiW+VxeY2aZh1LgeR9pMUI9KhkJZevD++G0obzryF3bxuUY/U9ocOXOK4NfZKhzMFkzxv7oxDpQ4dP0+HtngWj1YrHOXNiWg0c1y3kykY2NPMXKJMOJLrZ1ohFbK59JGNk//S6yhKT/en2trMptwzeXol5pfYhx0rZC9LZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769460863; c=relaxed/simple;
	bh=byQJE8+w/pN1FtIlhfNqmg9rcpYmbesNbr6ppMb1gYw=;
	h=Date:To:From:Subject:Message-Id; b=Ywanr1HnWK4dRAKLSNZu4TOd5BDaA0qKUqFJ/TEKkZeMcIweaizrGYTg29ky6t/3GH056s80miG0/tIdfnKNAPtRI6V72pxUT1JVHB2TdeuLukCl22U1Q00oaMjbbVJT6zAiLb8KmD+MxcsOmppCiPmD5af5Bu3CmAP/Sl90A3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CC6Q1ZGg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CC6Q1ZGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0108C116C6;
	Mon, 26 Jan 2026 20:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769460862;
	bh=byQJE8+w/pN1FtIlhfNqmg9rcpYmbesNbr6ppMb1gYw=;
	h=Date:To:From:Subject:From;
	b=CC6Q1ZGgjcNJTi+jDSlMjhWfUR4vr8pul7Yw/7wbpdbHGEFlFf22I1FWXlUgAaKCs
	 iX5ZZKBu2dgaws3y0+GIM4dai21vOMko/nReDVF8PDdkiIoxQ+/LHIA8gHCDyDXE4O
	 Th6z9UgiARLSGNUR6KpVVu1Fa5QGwJen1hSx0eIw=
Date: Mon, 26 Jan 2026 12:54:22 -0800
To: mm-commits@vger.kernel.org,steven.price@arm.com,pabeni@redhat.com,leon@kernel.org,kuba@kernel.org,horms@kernel.org,felix.kuehling@amd.com,edumazet@google.com,davem@davemloft.net,christian.koenig@amd.com,boris.brezillon@collabora.com,aliceryhl@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-pan-dont-abuse-current-group_leader.patch added to mm-nonmm-unstable branch
Message-Id: <20260126205422.B0108C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm/pan*: don't abuse current->group_leader
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     drm-pan-dont-abuse-current-group_leader.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-pan-dont-abuse-current-group_leader.patch

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
Subject: drm/pan*: don't abuse current->group_leader
Date: Sun, 25 Jan 2026 17:07:44 +0100

Cleanup and preparation to simplify the next changes.

Use current->tgid instead of current->group_leader->pid.

Link: https://lkml.kernel.org/r/aXY_0MrQBZWKbbmA@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Boris Brezillon <boris.brezillon@collabora.com>
Acked-by: Steven Price <steven.price@arm.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Christan König <christian.koenig@amd.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/panfrost/panfrost_gem.c |    2 +-
 drivers/gpu/drm/panthor/panthor_gem.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_gem.c~drm-pan-dont-abuse-current-group_leader
+++ a/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -17,7 +17,7 @@
 static void panfrost_gem_debugfs_bo_add(struct panfrost_device *pfdev,
 					struct panfrost_gem_object *bo)
 {
-	bo->debugfs.creator.tgid = current->group_leader->pid;
+	bo->debugfs.creator.tgid = current->tgid;
 	get_task_comm(bo->debugfs.creator.process_name, current->group_leader);
 
 	mutex_lock(&pfdev->debugfs.gems_lock);
--- a/drivers/gpu/drm/panthor/panthor_gem.c~drm-pan-dont-abuse-current-group_leader
+++ a/drivers/gpu/drm/panthor/panthor_gem.c
@@ -27,7 +27,7 @@ static void panthor_gem_debugfs_bo_add(s
 	struct panthor_device *ptdev = container_of(bo->base.base.dev,
 						    struct panthor_device, base);
 
-	bo->debugfs.creator.tgid = current->group_leader->pid;
+	bo->debugfs.creator.tgid = current->tgid;
 	get_task_comm(bo->debugfs.creator.process_name, current->group_leader);
 
 	mutex_lock(&ptdev->gems.lock);
_

Patches currently in -mm which might be from oleg@redhat.com are

android-binder-dont-abuse-current-group_leader.patch
android-binder-use-same_thread_groupproc-tsk-current-in-binder_mmap.patch
drm-amdgpu-dont-abuse-current-group_leader.patch
drm-amd-kill-the-outdated-only-the-pthreads-threading-model-is-supported-checks.patch
drm-pan-dont-abuse-current-group_leader.patch
rdma-umem-dont-abuse-current-group_leader.patch
netclassid-use-thread_group_leaderp-in-update_classid_task.patch

