Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C303E5A1F
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 20:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789418496; cv=none; b=s2yt1Ew5hUz9/z/e+5xpQJDH9gFfN24Btw1gi5/aOvomQmsaDUOBeMoQK8yIX5HY/8O2CdzrtD6d1nsvYp6HDSNSPDEWEmJ/B6OxmT2qwVJ+kDgp1axbVxiIkfW6pw+rIRWWM9uG+EA1DxWh7hbrbCbAWCZiqQcX6TfdVLwwLag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789418496; c=relaxed/simple;
	bh=y7Ljtfc7GDVtSOvlLE/J6ndIj9LHkjePAk0ajZon1Us=;
	h=Date:To:From:Subject:Message-Id; b=Hl57SVv096ckv6dRkBzIM+lV6y4qmyW+xUlbjItZ5NEJe8uoZhVVXqeqlPC1CBvbS4z9JqIZ5k9jxAI7UBfPZseucpO+qsPRoK6NHsAQ2C57EOvm4k9m1hMW7nMHE6TQT/haSRFLsWgBV7zBcbkZ9NhRyMPd/VnY6oHPr39fvhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B0DXIlFV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B0DXIlFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00CF1F000FF;
	Mon, 14 Sep 2026 20:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789418495;
	bh=25mTjzM9CMb9cbGhuVLt7NmTZdUbcV1lEGVYoirCtik=;
	h=Date:To:From:Subject;
	b=B0DXIlFVPKR3xuiqfKXDBX3dwIU2+j/gaYmaJIAxCDMNrez5Q+R0CbsUbiONwZgGr
	 s5O2iaQE5Yh3k9fWkLSZ6TO5eunaWSlnOe02VLDMBWZwoUp1ul2myjn7GqlnYG+dQH
	 lK4w8kw2Mh8rnmnP3psLip8MlilLN9ulJ9C7z6YY=
Date: Mon, 14 Sep 2026 13:41:34 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch removed from -mm tree
Message-Id: <20260914204134.F00CF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
has been removed from the -mm tree.  Its filename was
     proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
Date: Mon Sep 14 12:31:01 PM PDT 2026

fix build with

# CONFIG_PROC_PAGE_MONITOR is not set
# CONFIG_NUMA is not set

Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c~proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
+++ a/fs/proc/task_mmu.c
@@ -130,7 +130,7 @@ static void release_task_mempolicy(struc
 }
 #endif
 
-static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
+static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
 {
 	int ret = mmap_read_lock_killable(lock_ctx->mm);
 
@@ -194,7 +194,7 @@ static bool fallback_to_mmap_lock(struct
 	return true;
 }
 
-static void drop_rcu(struct proc_maps_private *priv)
+static inline void drop_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
 		return;
@@ -202,7 +202,7 @@ static void drop_rcu(struct proc_maps_pr
 	rcu_read_unlock();
 }
 
-static void reacquire_rcu(struct proc_maps_private *priv)
+static inline void reacquire_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
 		return;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

