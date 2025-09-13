Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD80254855
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801892; cv=none; b=Em6yGAXCJPdcV49TqtNQyecXCtksoo2tCKxtYWIsRhWYmq2a7yjyhRxyDIJeCAyBmCzOZOtLshukjBEYIkXk9ctWqWdbSOvgM+mFZ9dwNMv6sibGpO+tPSpo7ksxa3YgFf8K6/UWKFGhdRe4mWtAjQthM3Nplk069jnDmewK6ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801892; c=relaxed/simple;
	bh=36PuQ0gzQ2btBbMz7hslZq2vbKpromCRFaDSw8EKLGM=;
	h=Date:To:From:Subject:Message-Id; b=WQTtiH10m4+bdCFz9tjaS8lVhSfkvYB/yl7/Y/NfPdzLu5GVIG6mHQZYz00M7W9fUR4Tf3GMcoL3fDUPcee+wMEUDziKLgfIn1Jx/DoKcc5+Hnt65125MUym4oJbZZlC0h9+VbPB0Sj/O6sOedVrjTeoEswTTCuEd54ra4UpHZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hqslPhxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hqslPhxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7E8C4CEEB;
	Sat, 13 Sep 2025 22:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801892;
	bh=36PuQ0gzQ2btBbMz7hslZq2vbKpromCRFaDSw8EKLGM=;
	h=Date:To:From:Subject:From;
	b=hqslPhxYW6e+eo1M8cmqyH4YMOYP5S1akLw93u75hwk6bhjBpqWYOFzfKWp5nWt8A
	 bO6bynmBAvt3oBEmhfEZSJtl6QZ6zaM8MY38S7nhzNe5iM97Mim0M5jksoTVOzdklH
	 XDm8ahLceXBIxKrpsQMGwYsX7aKfOO0WtnEcoYgU=
Date: Sat, 13 Sep 2025 15:18:11 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,shakeel.butt@linux.dev,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-optimize-exit-to-user-space-fix.patch removed from -mm tree
Message-Id: <20250913221812.1F7E8C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-optimize-exit-to-user-space-fix
has been removed from the -mm tree.  Its filename was
     memcg-optimize-exit-to-user-space-fix.patch

This patch was dropped because it was folded into memcg-optimize-exit-to-user-space.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-optimize-exit-to-user-space-fix
Date: Wed Aug 13 03:38:42 PM PDT 2025

remove now-unneeded test of memcg_nr_pages_over_high==0, per Shakeel

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memcontrol.c~memcg-optimize-exit-to-user-space-fix
+++ a/mm/memcontrol.c
@@ -2213,9 +2213,6 @@ void __mem_cgroup_handle_over_high(gfp_t
 	struct mem_cgroup *memcg;
 	bool in_retry = false;
 
-	if (likely(!nr_pages))
-		return;
-
 	memcg = get_mem_cgroup_from_mm(current->mm);
 	current->memcg_nr_pages_over_high = 0;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
panic-remove-redundant-panic-cpu-backtrace-fix.patch
crash-add-kunit-tests-for-crash_exclude_mem_range-fix.patch

