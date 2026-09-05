Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9175478D;
	Sat,  5 Sep 2026 18:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788634099; cv=none; b=CtBWygf/UFsfaioeF93ztodXuF6JviJt8ijyXXOxvIGE89yb9W4FtTJ62008twc8X7Tn8seeSh1Rb+mvlwVlpaUCnS7gljIxQIkzYVA9yoFzsh1gAtGKjRpzuMvVkvke+uIKXPjX6ddiPEvhrepEAOkHYGVOrNoSIGczAKwJK8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788634099; c=relaxed/simple;
	bh=ERVF8mcsvrRP3a/zdbtALWHFyYVRyqmW11Iz9NNdEbk=;
	h=Date:To:From:Subject:Message-Id; b=Bi2c9UzltWxArpFK3PgQZAwx2YwN3XogssZr8SBdW3KI3Hh1jZZmw/ozmtGgbxKkgJ3OpmAEXsE4Zh6IlG2B53DqbmS0Gbv7Ig8xCt0jFd/x2Mn/k/GLj7KWwcbiTUGpfvOad7zlwT7xmdSK93F1hUnx0tiWe6gbFPUYii9uohg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AXTc+QVS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AXTc+QVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F771F00A3A;
	Sat,  5 Sep 2026 18:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788634098;
	bh=FQrndT84UChCIu9daBB2CGf51YAeQSge6xo5Rs32/hM=;
	h=Date:To:From:Subject;
	b=AXTc+QVSF8V+jnTg7A5gBG1qwBZPUNJUyg2I/OzGhXFgDlWFUPFYtzejVf4Xl91QN
	 ASApxb9FwtYCjZ4oJSbH/jNXPKrPrXvkI1g7HKuC1cQqWZ4jXEhbicZTtjIHrSrrSd
	 BLgnClVXTuNHHED/uVTGFFNNLXDtiFEKDDvjhXVI=
Date: Sat, 05 Sep 2026 11:48:18 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-fix-missed-removal-of-super_fs_objects_eligible.patch removed from -mm tree
Message-Id: <20260905184818.77F771F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: fix missed removal of super_fs_objects_eligible()
has been removed from the -mm tree.  Its filename was
     fs-fix-missed-removal-of-super_fs_objects_eligible.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: fs: fix missed removal of super_fs_objects_eligible()
Date: Mon, 17 Aug 2026 17:03:25 +0800

Commit 0ef8faff490be ("fs: push nr_cached_objects memcg gating into
individual filesystems") was meant to drop the blanket memcg gate in
fs/super.c and let each ->nr_cached_objects() implementation decide for
itself whether it is meaningful in per-memcg reclaim.  However, when
that patch was applied the removal of super_fs_objects_eligible() and
its two call sites in super_cache_scan() / super_cache_count() was
lost, so the helper is still gating every ->nr_cached_objects() hook
and 0ef8faff490be is effectively a no-op.

Consequences of the leftover gate:

   - XFS's inode-reclaim hook, which is intentionally driven from
     per-memcg contexts to free memcg-charged slab, is still
     short-circuited in fs/super.c  exactly the regression from
     commit 0baad6f9b997 ("fs/super: skip non-memcg-aware
     nr_cached_objects in memcg slab shrink") that 0ef8faff490be was
     written to undo. Memcg-charged XFS inode slab therefore keeps
     piling up under per-memcg pressure until global reclaim kicks in.

   - Any future ->nr_cached_objects()/->free_cached_objects() that
     grows memcg awareness is likewise blocked before it can run, so
     filesystems cannot opt in to per-memcg reclaim on their own 
     defeating the whole point of pushing the gating decision down
     into the callbacks.

Drop the leftover helper and its call sites so the intent of
0ef8faff490be actually takes effect.

Link: https://lore.kernel.org/cover.1786955972.git.zhengqi.arch@bytedance.com
Link: https://lore.kernel.org/3b038d373c70ebac7cdabfb0035bb91d1d6e6cfe.1786955972.git.zhengqi.arch@bytedance.com
Link: https://lore.kernel.org/all/20260715103516.2410175-1-usama.arif@linux.dev/ [0]
Fixes: 0ef8faff490b ("fs: push nr_cached_objects memcg gating into individual filesystems")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

--- a/fs/super.c~fs-fix-missed-removal-of-super_fs_objects_eligible
+++ a/fs/super.c
@@ -172,19 +172,6 @@ static void super_wake(struct super_bloc
 }
 
 /*
- * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
- * operate on filesystem-global state and ignore sc->memcg. Driving them
- * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
- * per-cpu counters and queueing duplicate work: the actual reclaim happens on
- * the global path (kswapd or root direct reclaim) regardless. Restrict them
- * to that path.
- */
-static inline bool super_fs_objects_eligible(struct shrink_control *sc)
-{
-	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
-}
-
-/*
  * One thing we have to be careful of with a per-sb shrinker is that we don't
  * drop the last active reference to the superblock from within the shrinker.
  * If that happens we could trigger unregistering the shrinker from within the
@@ -213,7 +200,7 @@ static unsigned long super_cache_scan(st
 	if (!super_trylock_shared(sb))
 		return SHRINK_STOP;
 
-	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
+	if (sb->s_op->nr_cached_objects)
 		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
@@ -274,8 +261,7 @@ static unsigned long super_cache_count(s
 		return 0;
 	smp_rmb();
 
-	if (sb->s_op && sb->s_op->nr_cached_objects &&
-	    super_fs_objects_eligible(sc))
+	if (sb->s_op && sb->s_op->nr_cached_objects)
 		total_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-memcontrol-make-obj_cgroup_memcg-handle-null-objcg.patch
mm-shmem-move-unused-huge-shrinklist-queuing-past-the-truncation-check.patch
mm-shmem-make-unused-huge-shrinker-memcg-aware.patch

