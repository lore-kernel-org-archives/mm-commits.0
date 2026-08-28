Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1873C31195B
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 18:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787942773; cv=none; b=kEMsOT4i9H2ODf0aQq8mt9Sxje7/gLicIzD3BJmBv0H8gQX0Rp7/cw96bMJOdLo8pKp54FxIRyNAj40f+nVyUaCsNRmGTNtIikuKEk9JUvnshvwXZ1/lDFU6h4I0CGxbc4wB8ICuSm0I7+oITlIVDxrzl1hzDWKGARwS0rehAHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787942773; c=relaxed/simple;
	bh=fxHOyAr6KjB5Z7KZPVVL0bvVRFvOXHTkomargcwgoKI=;
	h=Date:To:From:Subject:Message-Id; b=Jyrfnr5olsuP6HJpIbjqZfHyD8LeQ/krp7HU0MIzlHv8pFdhrxM2Kf5nsw3BoGCa+KWyOMvsXP50QTLUIj8Lnjcv+cDD8NB+k272d41+16LzpPLHy5iv2p9UWkdZrN/b+8ALmwdcNqKvDOdHoFl05Pva1DCEOX6oySyRRHZJ/cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H3lAjgTh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H3lAjgTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F7A1F000E9;
	Fri, 28 Aug 2026 18:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787942771;
	bh=izC/kg3EYQ9WW4pXleXG3HYTBCYJSRfisNjz9e71alQ=;
	h=Date:To:From:Subject;
	b=H3lAjgThE3uRtwc7oMNf6joTxd7O+aXoXA0XkdyrWLigsY1c3Nl7Fz2pH9xJuwGtv
	 qGlQklRbrvI3rrUTlR3RyfLKKbdAJzJqJLX/kbI/0r7KwwgsZkk3ib+Xn63BQqkDJM
	 ZI9J8AMvBKZKuaC8uGU9vNJKN2qsqRRXkIbpc6is=
Date: Fri, 28 Aug 2026 11:46:11 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-fix-missed-removal-of-super_fs_objects_eligible.patch added to mm-new branch
Message-Id: <20260828184611.73F7A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: fix missed removal of super_fs_objects_eligible()
has been added to the -mm mm-new branch.  Its filename is
     fs-fix-missed-removal-of-super_fs_objects_eligible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-fix-missed-removal-of-super_fs_objects_eligible.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: fs: fix missed removal of super_fs_objects_eligible()
Date: Mon, 17 Aug 2026 17:03:25 +0800

Patch series "make unused huge shrinker memcg aware", v4.

The shmem unused huge shrinker maintains a per-superblock list of inodes
whose tail huge folio extends beyond i_size.  Because this list is not
memcg aware, reclaim triggered by memcg A can scan inodes across the
entire superblock and split huge folios charged to unrelated memcg B,
causing unexpected impact on it.

In the worst case, memcg A has no reclaimable shmem at all, making the
reclaim entirely useless and incurring unnecessary latency.  We observed
this in production, where page lock contention during split caused
multi-hundred-millisecond stalls:

  tid 11340 comm scanner locked a page for 182264 us! kstack:
          unlock_page+1
          split_huge_page_to_list+3135
          shmem_unused_huge_shrink+767
          super_cache_scan+329
          do_shrink_slab+291
          shrink_slab+533
          shrink_node+400
          do_try_to_free_pages+206
          try_to_free_mem_cgroup_pages+262
          try_charge_memcg+591
          mem_cgroup_charge+136
          __handle_mm_fault+2431
          handle_mm_fault+194
          do_user_addr_fault+462
          __do_page_fault+176
          do_page_fault+48
          page_fault+62

Usama's recent patch [1] prevents the shmem unused shrinker from being
invoked during memcg-level reclaim altogether, but this is overly
conservative: we can do better by reclaiming only the shmem charged to the
reclaiming memcg.

This series converts the shrinker list to a memcg-aware list_lru, so that
non-root memcg reclaim walks only candidates charged to the reclaiming
memcg.  Global reclaim, root memcg reclaim and shmem quota reclaim retain
their existing global semantics.

To avoid pinning a dying memcg through a long-lived CSS reference, each
inode stores an obj_cgroup reference instead of a mem_cgroup reference. 
The list_lru add/delete paths resolve the current memcg from the objcg
under RCU, staying consistent with list_lru's own memcg migration on
offline.


This patch (of 4):

Commit 0ef8faff490be ("fs: push nr_cached_objects memcg gating into
individual filesystems") forgot to drop the super_fs_objects_eligible(),
just fix it.

Link: https://lore.kernel.org/3b038d373c70ebac7cdabfb0035bb91d1d6e6cfe.1786955972.git.zhengqi.arch@bytedance.com
Link: https://lore.kernel.org/all/20260715103516.2410175-1-usama.arif@linux.dev/ [0]
Fixes: 0ef8faff490be ("fs: push nr_cached_objects memcg gating into individual filesystems")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
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

fs-fix-missed-removal-of-super_fs_objects_eligible.patch
mm-memcontrol-make-obj_cgroup_memcg-handle-null-objcg.patch
mm-shmem-move-unused-huge-shrinklist-queuing-past-the-truncation-check.patch
mm-shmem-make-unused-huge-shrinker-memcg-aware.patch

