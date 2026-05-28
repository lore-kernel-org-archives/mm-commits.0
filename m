Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53D22F1FEC
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 20:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000360; cv=none; b=s0d6K/56FMDg1fbC8uRJ68NH9XpJhcclLkpLpF63DwDIHnQzQgYp8T680qEs1ncgjNvUv09ON6WQckn+T5IGfpJxIgqCbcCL02qUoXJd8gT551QGiZyVTWTX1wJB1DZ1RHafYa1i4FnZxwIgFcMZ+57O0EWo4ECG7/2Dc/20EtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000360; c=relaxed/simple;
	bh=EFmoTOieHgjH3aa/D3NoaDWO91yPQPNLEgPNJBUWfc4=;
	h=Date:To:From:Subject:Message-Id; b=rQ+3jbMRp9OToSyoccJpnsEr7KtVECM21VmSRQ05TPv063UtV0TBc0EsSBPSknRCfCdD03mTqJztEQTCa7+kWyMYreQdHU1RSIgoF6zYWlNM/FdERfsNj0SGw2fQWaovp+GIIdI0XhrFzfNv2wQzIpjGAUghdVEGmCMhHKU44A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YE27LeMO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YE27LeMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD111F000E9;
	Thu, 28 May 2026 20:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780000359;
	bh=ri5FWjSsXezbAr0VlUaUtTWaHmRBhKlGHNirY60meaE=;
	h=Date:To:From:Subject;
	b=YE27LeMOyBFa/N17SZpPIW1uWCbpOGt9T25V0esmJI1W2hA08/CuzI1jFm5wjHdbQ
	 8h5PLAmwt2uLIhOLBz+eSaYN5zxnVJ/3bHSgZCDwN2F5pcD66Yf/ftcgKXOcRtQqPQ
	 XylwRdR+Bk7xdkl8aqfNVi8RShw1wpmet8AnKaDg=
Date: Thu, 28 May 2026 13:32:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,fujunjie1@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-deferred-compaction-accounting.patch added to mm-new branch
Message-Id: <20260528203239.5FD111F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: fix deferred compaction accounting
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-fix-deferred-compaction-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-deferred-compaction-accounting.patch

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
From: fujunjie <fujunjie1@qq.com>
Subject: mm/page_alloc: fix deferred compaction accounting
Date: Tue, 26 May 2026 09:12:48 +0000

COMPACT_DEFERRED means compaction did not start because past failures
caused the zone to be deferred.  try_to_compact_pages() returns the
maximum result seen while walking the zonelist, so a final
COMPACT_DEFERRED result means no later zone reported that compaction
actually ran.

__alloc_pages_direct_compact() skips COMPACTSTALL and COMPACTFAIL
accounting when try_to_compact_pages() returns COMPACT_SKIPPED, but not
when it returns COMPACT_DEFERRED.  A deferred-only direct compaction
attempt can therefore look like a stall, and then a failure if the
allocation still cannot be satisfied.

Treat COMPACT_DEFERRED like COMPACT_SKIPPED in this accounting path.  If a
later zone runs compaction and returns a result above COMPACT_DEFERRED, or
compact_zone_order() reports COMPACT_SUCCESS for a captured page, the
final result is not COMPACT_DEFERRED and the existing accounting still
runs.

Link: https://lore.kernel.org/tencent_368AF1F3821E46232637BE16D65C45CF3308@qq.com
Fixes: 06dac2f467fe ("mm: compaction: update the COMPACT[STALL|FAIL] events properly")
Signed-off-by: fujunjie <fujunjie1@qq.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-deferred-compaction-accounting
+++ a/mm/page_alloc.c
@@ -4161,7 +4161,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	psi_memstall_leave(&pflags);
 	delayacct_compact_end();
 
-	if (*compact_result == COMPACT_SKIPPED)
+	if (*compact_result == COMPACT_SKIPPED ||
+	    *compact_result == COMPACT_DEFERRED)
 		return NULL;
 	/*
 	 * At least in one zone compaction wasn't deferred or skipped, so let's
_

Patches currently in -mm which might be from fujunjie1@qq.com are

mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors.patch
mm-filemap-count-only-the-faulting-address-as-a-mmap-hit.patch
mm-filemap-do-not-count-fault_flag_tried-retries-as-mmap-hits.patch
mm-compaction-respect-cpusets-when-checking-retry-suitability.patch
mm-page_alloc-fix-deferred-compaction-accounting.patch

