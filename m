Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C79F3BED0C
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439212; cv=none; b=BOnCtQXERWHeaSfhnNelCF6vt6OH6iWlmE6XOUwQ9ZOh5/911eq6jBg1gpXqWorCbRIO6nPPzNLXRPa7HE2TiecnOtAJUbghEzNoUBkf5chv4yi+ukn2BaxO11bTZcdybiNsbEvEk3SNsbpuJq/ypqH5uuh4nevX3yYOGQVGoro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439212; c=relaxed/simple;
	bh=g1CLvAbjS0b7mpyIYdVxn5s+UfywDstPaVK9wmqN+UQ=;
	h=Date:To:From:Subject:Message-Id; b=V1h8aLBjU5ySmj8mqhTihnUt+fZK+mHXxbc0cPbpYfrsJLwMldiYbBPJ8Q9Zp8lWAOgP0VPBH+e+dWz8+8ypqmYMMwmeEUuQZ4kmrpyTSiPy5TyixBLzCelwcZdMIFBiOSIKv/cLIwPfxInL38Yhqf7p4r71gek/Cy9r11cmeCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lk/86vQk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lk/86vQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108FD1F00893;
	Tue,  2 Jun 2026 22:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439211;
	bh=fXvOPe7Y6OZrYHkT7vzYmWC1kbvqcqbqrUAzLyaZcoQ=;
	h=Date:To:From:Subject;
	b=lk/86vQkrcxoREwjw2Vf1ILTKbt0ADYrjK0KJ74/BftgzD2wIJIFWZuqNSKY6HXV3
	 xWWcSxcPUi9nG/4L1JUkUk6Zrv9PBbZGILXksrWjzHWkJ8ae/Q2uc0L3QSi8EKr0GG
	 sSlUFTQ2L/bwYCcb6GlpVs0eJwvTOi45959sMN84=
Date: Tue, 02 Jun 2026 15:26:50 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,qi.zheng@linux.dev,oliver.sang@intel.com,muchun.song@linux.dev,mhocko@kernel.org,joshua.hahnjy@gmail.com,harry@kernel.org,hannes@cmpxchg.org,alex@ghiti.fr,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch removed from -mm tree
Message-Id: <20260602222651.108FD1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: uint16_t for nr_bytes in obj_stock_pcp
has been removed from the -mm tree.  Its filename was
     memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: uint16_t for nr_bytes in obj_stock_pcp
Date: Mon, 25 May 2026 20:39:29 -0700

Currently struct obj_stock_pcp stores nr_bytes in an 'unsigned int' which
is 4 bytes on 64-bit machines.  Switch the field to uint16_t to shrink the
per-CPU cache.

The kernel supports PAGE_SIZE_4KB, _8KB, _16KB, _32KB, _64KB and _256KB
(see HAVE_PAGE_SIZE_* in arch/Kconfig).  After the PAGE_SIZE-aligned flush
in __refill_obj_stock(), the sub-page remainder fits in uint16_t up
through 64KiB pages where PAGE_SIZE - 1 == U16_MAX, but on 256KiB pages
PAGE_SIZE - 1 == 0x3FFFF exceeds U16_MAX.  The accumulator also needs to
stay within uint16_t between page-aligned flushes on 64KiB pages where
PAGE_SIZE itself is U16_MAX + 1.

Accumulate the new total in an 'unsigned int' local, then on PAGE_SHIFT <=
16 flush whenever the accumulator would hit U16_MAX; together with the
existing allow_uncharge flush at PAGE_SIZE this keeps the uint16_t safe.

On configs with PAGE_SHIFT > 16 (PAGE_SIZE_256KB on hexagon and powerpc
44x, both 32-bit), uint16_t cannot represent the sub-page remainder. 
Define obj_stock_bytes_t as 'unsigned int' on those archs so nr_bytes can
hold the full remainder and the normal page-boundary flush in
__refill_obj_stock() and the page extraction in drain_obj_stock() both
work correctly.

The single-cache-line layout target only applies to PAGE_SHIFT <= 16;
those archs are 32-bit embedded and not the optimization target.

Link: https://lore.kernel.org/20260526033931.1760588-3-shakeel.butt@linux.dev
Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp
+++ a/mm/memcontrol.c
@@ -2020,8 +2020,17 @@ static DEFINE_PER_CPU_ALIGNED(struct mem
 
 struct obj_stock_pcp {
 	local_trylock_t lock;
-	unsigned int nr_bytes;
 	struct obj_cgroup *cached_objcg;
+#if PAGE_SHIFT > 16
+	/*
+	 * On rare archs with 256KiB base page size (hexagon and powerpc 44x)
+	 * keep nr_bytes to unsigned int as uint16_t cannot represent the full
+	 * sub-page remainder.
+	 */
+	unsigned int nr_bytes;
+#else
+	uint16_t nr_bytes;
+#endif
 	int16_t node_id;
 	int nr_slab_reclaimable_b;
 	int nr_slab_unreclaimable_b;
@@ -3334,6 +3343,7 @@ static void __refill_obj_stock(struct ob
 			       bool allow_uncharge)
 {
 	unsigned int nr_pages = 0;
+	unsigned int stock_nr_bytes;
 
 	if (!stock) {
 		nr_pages = nr_bytes >> PAGE_SHIFT;
@@ -3342,21 +3352,24 @@ static void __refill_obj_stock(struct ob
 		goto out;
 	}
 
+	stock_nr_bytes = stock->nr_bytes;
 	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
-		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
+		stock_nr_bytes = atomic_read(&objcg->nr_charged_bytes)
 				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
 		WRITE_ONCE(stock->cached_objcg, objcg);
 
 		allow_uncharge = true;	/* Allow uncharge when objcg changes */
 	}
-	stock->nr_bytes += nr_bytes;
+	stock_nr_bytes += nr_bytes;
 
-	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
-		nr_pages = stock->nr_bytes >> PAGE_SHIFT;
-		stock->nr_bytes &= (PAGE_SIZE - 1);
+	if ((allow_uncharge && (stock_nr_bytes > PAGE_SIZE)) ||
+	    stock_nr_bytes > U16_MAX) {
+		nr_pages = stock_nr_bytes >> PAGE_SHIFT;
+		stock_nr_bytes &= (PAGE_SIZE - 1);
 	}
+	stock->nr_bytes = stock_nr_bytes;
 
 out:
 	if (nr_pages)
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-list_lru-drain-before-clearing-xarray-entry-on-reparent.patch

