Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1634A384C
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 21:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788384479; cv=none; b=m0ydlRp/5Fu2GzJSNOjY9/+1WAqk9VJoqBbP7YNuBMUBQtwPJoA1SGVvbGvShdlS/Z2q6ZR2Xxhev7rN6/XMAuyNfsNB5opFvuStqQYTFLzIpApxOuomgwKJDAhHXUDd0KVWjSvY9CBZwm/pQnrVqGn01z/xsKZSqcC2LmKzudE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788384479; c=relaxed/simple;
	bh=TyWEtWfcpTaYlTR3OOEfPVeHhV7wjI8/n3bIJrWg6Og=;
	h=Date:To:From:Subject:Message-Id; b=rrIvlkLWjZMpw1EHLYbcreBzUqCXKyWMWQSE1Zy2m7iG/NYUtH8VFY/w4UHDhWLf+cDTyEzI0nPYg8cJpGqJmOdtMFDOQqAc0aXrqLDuW4o9oT/832ujrIyijiTVYQ7MDf+Duly9WKBdAL7puSbDD/BxNm95rSi/HQ50jkUkD0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tq3v7WqC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tq3v7WqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFE71F000E9;
	Wed,  2 Sep 2026 21:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788384471;
	bh=dL8riWdl+n7PnY/gHNpe/cB91wXfUwtNiC86WfHq1i4=;
	h=Date:To:From:Subject;
	b=tq3v7WqCPqI9YVUnGKPIcQwXvwSiPGj/A8pXmglnauSpKI0A+6ImkDn3UP/UPC752
	 GZNu1QiwEQbrGjLj8BdNaRnq8HQppU3aIWCRXWE3MxXhPKVot6jkP8MEqU8kms0ETs
	 qUoh+0w3B7ALexLv40BQtRLi2WPMESuMcY8JyRTk=
Date: Wed, 02 Sep 2026 14:27:51 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,qinyuntan@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-make-unused-huge-shrinker-memcg-aware-fix.patch added to mm-unstable branch
Message-Id: <20260902212751.6FFE71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/list_lru: disable memcg awareness under cgroup_disable=memory
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-make-unused-huge-shrinker-memcg-aware-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-make-unused-huge-shrinker-memcg-aware-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: mm/list_lru: disable memcg awareness under cgroup_disable=memory
Date: Wed, 2 Sep 2026 17:32:02 +0800

__list_lru_init() only collapses a memcg-aware list_lru into plain
per-node lists when kmem accounting is disabled (cgroup.memory=nokmem). 
When the memory controller is disabled entirely (cgroup_disable=memory),
mem_cgroup_kmem_disabled() is false, so the lru stays memcg aware even
though no object will ever be charged to a memcg.

This is more than a semantic inconsistency.  folio_memcg_list_lru_alloc()
trusts list_lru_memcg_aware() and dereferences the folio's memcg, which is
always NULL with the controller disabled.  The only mainline caller,
folio_memcg_alloc_deferred(), papers over this with an explicit
mem_cgroup_disabled() check.  The shmem unused-huge shrinker conversion
("mm: shmem: make unused huge shrinker memcg aware") adds a second caller
without such a guard, so booting with cgroup_disable=memory and writing to
a huge=always tmpfs oopses:

  BUG: unable to handle page fault for address: 0000000000000488
  RIP: 0010:folio_memcg_list_lru_alloc+0x41/0xf0
  Call Trace:
   <TASK>
   shmem_get_folio_gfp+0x1cd/0x7c0
   shmem_write_begin+0x5d/0x100
   generic_perform_write+0x89/0x2a0
   shmem_file_write_iter+0x82/0x90
   vfs_write+0x256/0x410
   ksys_write+0x61/0xe0
   do_syscall_64+0x8d/0x460
   entry_SYSCALL_64_after_hwframe+0x76/0x7e

The faulting address is the offset of mem_cgroup->kmemcg_id, dereferenced
on a NULL memcg in memcg_list_lru_allocated():

  folio_memcg_list_lru_alloc()
    list_lru_memcg_aware()               <- true, only nokmem checked
    memcg = folio_memcg(folio)           <- NULL
    memcg_list_lru_allocated(memcg, lru)
      memcg->kmemcg_id                   <- NULL pointer dereference

Check mem_cgroup_disabled() in __list_lru_init() so that all list_lrus
fall back to plain per-node lists when the controller is disabled,
matching what the shrinker side already does (shrinker_memcg_alloc() bails
out on mem_cgroup_disabled()).  This makes the mem_cgroup_disabled() check
in callers unnecessary rather than mandatory.

Link: https://lore.kernel.org/20260902093202.609559-1-qinyuntan@linux.alibaba.com
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/list_lru.c~mm-shmem-make-unused-huge-shrinker-memcg-aware-fix
+++ a/mm/list_lru.c
@@ -671,7 +671,7 @@ int __list_lru_init(struct list_lru *lru
 	else
 		lru->shrinker_id = -1;
 
-	if (mem_cgroup_kmem_disabled())
+	if (mem_cgroup_disabled() || mem_cgroup_kmem_disabled())
 		memcg_aware = false;
 #endif
 
_

Patches currently in -mm which might be from qinyuntan@linux.alibaba.com are

mm-shmem-make-unused-huge-shrinker-memcg-aware-fix.patch
mm-list_lru-dont-copy-stale-shrinker-id-from-non-memcg-aware-shrinkers.patch

