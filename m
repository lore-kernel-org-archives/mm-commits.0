Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F253EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905037; cv=none; b=KWz0NUuhy6BAurGjff9IibbVDr0fSoy/9EN2nFVBn2wiq3784QM7CQIDeRRshLnpcGJwKIPxaSDY7Ag/vzDIXWbMwFrcvWITiXo0rqUCzisd7d6uACdgiQvLbryzsn+GhOYXZFsQ+TYbhg8ByGmR5DKrq2GA4PAjmZAo5cI0cxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905037; c=relaxed/simple;
	bh=Ap16usH4D0LdYxCtqg7/1lP/ozdbB805aYWPDagznI8=;
	h=Date:To:From:Subject:Message-Id; b=DDAI348WfpU3CPWe2A0jmFIsadKBEM4hA+E62vcb3M/QGMxeoSseBvKhMRo6iVreCLWUp3I7Y9ictmKg1Ckb3qxYrhVLBz+SZ6tvw2tN0Muu3U+rmNC4dtgCr89/guxl3YQVfeg/dc4gB+TCROHtTvbtsCK+3oOny9zvINZcGus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q8NiRp3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q8NiRp3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA83C4CEF1;
	Sun,  1 Feb 2026 00:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905036;
	bh=Ap16usH4D0LdYxCtqg7/1lP/ozdbB805aYWPDagznI8=;
	h=Date:To:From:Subject:From;
	b=Q8NiRp3+mVWCpRtpKTKdNhHx/utXRC6zQUp0gt2ER85JEP4izU2VD7yT61zPN9wzK
	 LuZb2fU3jqKGzCTTv7SoC7y2Fn7R3WQU8A68qfDQeZZJTfBb22jV5PnQvR9SS37Pnj
	 m57E0++SMnan6PWpFX7XcEF+vyimOMvsWcmd7x68=
Date: Sat, 31 Jan 2026 16:17:16 -0800
To: mm-commits@vger.kernel.org,steven.price@arm.com,pabeni@redhat.com,leon@kernel.org,kuba@kernel.org,horms@kernel.org,felix.kuehling@amd.com,edumazet@google.com,davem@davemloft.net,christian.koenig@amd.com,boris.brezillon@collabora.com,aliceryhl@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] drm-pan-dont-abuse-current-group_leader.patch removed from -mm tree
Message-Id: <20260201001716.CAA83C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm/pan*: don't abuse current->group_leader
has been removed from the -mm tree.  Its filename was
     drm-pan-dont-abuse-current-group_leader.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


