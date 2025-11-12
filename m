Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3796B17C77
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762906457; cv=none; b=Le44cLTDkr0ji32jwpkQJ0HL2Kh/gYZHYc2KvUFqMOTuJcXq/4ajQSjZswwCPDC/wuKSwh31kdoPpO9qyiEncKSUkA6O36JrSIBHFcgO8uYSHvGfKqvN7JVxWvpjtsJK5WHR89K07kYWcvAhoMrpeTCG2lXRVGjmMzlAKlY3m48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762906457; c=relaxed/simple;
	bh=063dKJgC/d8eX0YzZyRaxMcWPsdGKJw69IENoXZB0C0=;
	h=Date:To:From:Subject:Message-Id; b=CAy+CZT6djHRPWOuyTMBcMa6Ubx0mKr8diGFpSRTBslkPDEBbQx+8GRfYADvMEzytENUSl7MWKh97NAlaq4O41q6SiYEm+FcFwzeaTp5+LEjMlkIXOe4KSEGwv8/4c2X/MsxsOFDo4gl3YCAEOlnT1m+vo55m5NufEHv2iOcxog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W40T4Vjj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W40T4Vjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9511CC4CEF5;
	Wed, 12 Nov 2025 00:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762906456;
	bh=063dKJgC/d8eX0YzZyRaxMcWPsdGKJw69IENoXZB0C0=;
	h=Date:To:From:Subject:From;
	b=W40T4Vjj2BWtEjKhRA/ZqvfvDUdcOnPnmlRyalzxbD99kyeJ/4lf4LB3I4b9mjYUm
	 TM2uqrHtDJfS/gC/DsxKeI3klaLGLfvrXoRPAKRGPdaYuvmiRS2rfRprAk1TqkCQdd
	 RDdzSjpsGEJhHt+ZT1m/zq4kf+r/TQxfYnwO9ffE=
Date: Tue, 11 Nov 2025 16:14:15 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hch@infradead.org,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-manually-uninline-__memcg_memory_event-fix.patch removed from -mm tree
Message-Id: <20251112001416.9511CC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-manually-uninline-__memcg_memory_event-fix
has been removed from the -mm tree.  Its filename was
     memcg-manually-uninline-__memcg_memory_event-fix.patch

This patch was dropped because it was folded into memcg-manually-uninline-__memcg_memory_event.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-manually-uninline-__memcg_memory_event-fix
Date: Mon Oct 27 04:58:56 PM PDT 2025

use EXPORT_SYMBOL_GPL for __memcg_memory_event, per Michal and Christoph

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-manually-uninline-__memcg_memory_event-fix
+++ a/mm/memcontrol.c
@@ -1655,7 +1655,7 @@ void __memcg_memory_event(struct mem_cgr
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
 }
-EXPORT_SYMBOL(__memcg_memory_event);
+EXPORT_SYMBOL_GPL(__memcg_memory_event);
 
 static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 				     int order)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-manually-uninline-__memcg_memory_event.patch
mm-change-type-of-state-in-struct-memory_block-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix-fix.patch
init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch
liveupdate-luo_file-implement-file-systems-callbacks-fix.patch
mm-shmem-use-shmem_f_-flags-instead-of-vm_-flags-fix.patch

