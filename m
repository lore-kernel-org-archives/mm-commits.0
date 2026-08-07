Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C9F3B995F
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068097; cv=none; b=r7Wa7fAtkeEmfSFrtFsBfktZox6tQo7EiS3XZqZGjtJOYoqtjn3FzbYMMn0uFItIwtwwcYHVdeY6T9QqUeGjXTB5jbL4DbV5oxZFFlQpj6OkEYAPDNI5o8IhaYBv226CTz06DlKWWozJZ8fElHVPDAmHrgjpw5BbjDKA7fGq9S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068097; c=relaxed/simple;
	bh=z5AT+PKuZtVWHm1qbgNcYN65X4FiXtBM8hEddwfyYXk=;
	h=Date:To:From:Subject:Message-Id; b=rCwJy29pBotEUUTNoQq4kroqrK4Mm5/9PTJ/LzFJ2v+Y2aiMw6dhYYg+NHKD/iis4EeTorEx/5Pt3Nk7FH3IzH5NZvNVzOis5FdAANFvihON91YirvzagpjE/sSNIml38bmGKuDSh466oS181RztasuUAAP7kc9EoQ4JbjGXSbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RCf0n2/I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RCf0n2/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1891F00A3E;
	Fri,  7 Aug 2026 02:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068089;
	bh=Zw2VSuuM5vLzN37Nod9Rh1CxzofIZATXQU9ZdKgB39E=;
	h=Date:To:From:Subject;
	b=RCf0n2/IEiR9JIv4rKrkt0NhUXFYxPdweOMIw9hfThmgtrJQiZg6dX1mK9wI6G1XV
	 xXytJ99HIH9Vf/qgRc45LohjzCVuAeDEAXbBJhuk+I2xcrricsRlC+gd8DD9+SVNyL
	 IO6meKsk/HGOXzl/fFDG/FSnzQ9WD0qzgeVhHoHo=
Date: Thu, 06 Aug 2026 19:01:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tj@kernel.org,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mkoutny@suse.com,mhocko@suse.com,longman@redhat.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,bigeasy@linutronix.de,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cgroup-cpuset-update-some-comments-about-the-page-allocator.patch removed from -mm tree
Message-Id: <20260807020129.5B1891F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cgroup/cpuset: update some comments about the page allocator
has been removed from the -mm tree.  Its filename was
     cgroup-cpuset-update-some-comments-about-the-page-allocator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: cgroup/cpuset: update some comments about the page allocator
Date: Wed, 15 Jul 2026 11:03:19 +0000

These comments describing the page allocator are out of date:

- __alloc_pages() is no longer a public API and has no business being
  described outside of mm/.

- The `wait` variable is gone.

It may be out of date for other reasons too but this patch is just
fixing the issues that stood out.

To fix it:

- Instead of referring to a specific function, instead to "the page
  allocator"

- Completely drop out-of-date details of that function's internal
  behaviour, since they were irrelevant anyway.

Link: https://lore.kernel.org/20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Link: https://lore.kernel.org/all/DJP11T5V7BDW.2FZZZ8R6LOY4I@nvidia.com/
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cpuset.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/kernel/cgroup/cpuset.c~cgroup-cpuset-update-some-comments-about-the-page-allocator
+++ a/kernel/cgroup/cpuset.c
@@ -4198,7 +4198,7 @@ static struct cpuset *nearest_hardwall_a
  * nearest enclosing hardwalled ancestor cpuset.
  *
  * Scanning up parent cpusets requires callback_lock.  The
- * __alloc_pages() routine only calls here with __GFP_HARDWALL bit
+ * page allocator only calls here with __GFP_HARDWALL bit
  * _not_ set if it's a GFP_KERNEL allocation, and all nodes in the
  * current tasks mems_allowed came up empty on the first pass over
  * the zonelist.  So only GFP_KERNEL allocations, if all nodes in the
@@ -4211,11 +4211,8 @@ static struct cpuset *nearest_hardwall_a
  * come before the __GFP_HARDWALL check, otherwise a dying task
  * would be blocked on the fast path.
  *
- * The second pass through get_page_from_freelist() doesn't even call
- * here for GFP_ATOMIC calls.  For those calls, the __alloc_pages()
- * variable 'wait' is not set, and the bit ALLOC_CPUSET is not set
- * in alloc_flags.  That logic and the checks below have the combined
- * affect that:
+ * The second pass through get_page_from_freelist() doesn't even call here for
+ * GFP_ATOMIC calls.  That, and the checks below have the combined affect that:
  *	in_interrupt - any node ok (current task context irrelevant)
  *	GFP_ATOMIC   - any node ok
  *	tsk_is_oom_victim   - any node ok
@@ -4332,8 +4329,8 @@ void cpuset_nodes_allowed(struct cgroup
  * should not be possible for the following code to return an
  * offline node.  But if it did, that would be ok, as this routine
  * is not returning the node where the allocation must be, only
- * the node where the search should start.  The zonelist passed to
- * __alloc_pages() will include all nodes.  If the slab allocator
+ * the node where the search should start.  The zonelist used by
+ * the allocator will include all nodes.  If the slab allocator
  * is passed an offline node, it will fall back to the local node.
  * See kmem_cache_alloc_node().
  */
_

Patches currently in -mm which might be from jackmanb@google.com are


