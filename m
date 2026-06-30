Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FFE23EA8A
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 18:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782844890; cv=none; b=Q3Cp+Ts2N+I5sgf4GqqOeE6Dx94VhK1bR07Tv3BXzoqwnqDLByBRuWN5+RjKREyJCou2gcxN5xEO7hmSuU04Ae9+9BBEgeoCTdaySOhlJWKYFpiZ7VPwANH0L65+BwuiiSsYMmFwJvvyIL1dU+j/7K+sY9ITvLKKPILvehYXxPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782844890; c=relaxed/simple;
	bh=1Jg3MZNgE+afLciWzuE0rsB5tIKVv1MjE1vMUBAMgf8=;
	h=Date:To:From:Subject:Message-Id; b=jg3pu77rY9wY1oDW7UsWE+Jhrp7SBTDZwNkE1ZP2xXwFId9w9BSFvRyuIjYUIHe9N4u0mydcl0G6q5osAsnYGFZUCSlSYPa3HgA4JutkLS5/NCd58uKDOpTqxeTOkpxo40X5Sh0qtqtbd047dwptso5FCviixzScoGh36jJLYEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RYE1NoTl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RYE1NoTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B62B1F00A3A;
	Tue, 30 Jun 2026 18:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782844889;
	bh=ozKfT7xSOiVfwrias6Uy97FOHbpkcxH3/3Qf2pMZqP4=;
	h=Date:To:From:Subject;
	b=RYE1NoTlcUnauRGs/K4mkQcbXRfa6xtiVQK9+/7JU3icf4fmboAYdWEZJcKW45X2g
	 oQPYSBDCbXdgBA4fd2SRolhxW6UQVLyrL5e5ZWn+yj6B1tgGgtCCgrV+SxfuyuAQYI
	 pll1nFJ8BVDaToEvo9uIDGnGqUAXVVFrV5HK18k0=
Date: Tue, 30 Jun 2026 11:41:28 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,leo.yan@arm.com,jiangwenxiaomi@gmail.com,jiangwen6@xiaomi.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,ajd@linux.ibm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix.patch added to mm-unstable branch
Message-Id: <20260630184129.4B62B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix
Date: Tue Jun 30 11:35:55 AM PDT 2026

avoid warnings on architectures whose flush_cache_vmap() don't reference
their args

Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Wen Jiang <jiangwen6@xiaomi.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix
+++ a/mm/vmalloc.c
@@ -3629,6 +3629,7 @@ static int vmap_batched(unsigned long ad
 				prot, pages + idx, prev_shift);
 
 out:
+	(void)start;	/* several archs use a macro for flush_cache_vmap() */
 	flush_cache_vmap(start, end);
 	return err;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix.patch
mm-page_owner-add-print_mode-filter-fix.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

