Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3848E13D52B
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854765; cv=none; b=bclXbH397ttcCu2i8obBS0id2obI5z642OiA/0t3EwIAYvtqzH+0xxVZyV5o75Wo/FZT33KdCd9Xu7KmkOJjXJRqMN3+ngejeuqjUlW+zujVXoMSk34q1j8rPJidoMRM6zFJQXlpNNJIc8KC1bb2ekH53jvpyecZ7SMzTFiNUHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854765; c=relaxed/simple;
	bh=ua868Gx2ZsEAnPg6oRdY2mC0/VFXk4Xr/V5tJUomTbg=;
	h=Date:To:From:Subject:Message-Id; b=rUipBhpDNQ4xaWK+hZyhGh6BtwHFSF3AngV6xbSXE3xLUcF5zMxou4VHATbhnwAMcRn7Nhrg5Ss6rSm+nDBd/1ZLtk1dgxDsUXzpgZgybmEoobdirt/LaSTju8DFYQkQ3e+ED+qg4Dy/LARbhoDAtiU4bofo6in8XwWK7HIV73M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YPDKLOhq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YPDKLOhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1C2C4CECF;
	Wed,  6 Nov 2024 00:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854765;
	bh=ua868Gx2ZsEAnPg6oRdY2mC0/VFXk4Xr/V5tJUomTbg=;
	h=Date:To:From:Subject:From;
	b=YPDKLOhqi3lGDN87rukWgIZEJztIViDc03oFGAqTgfLFcZpmxm/xO2ghDeOB5wDSa
	 1nr4yXRT5v18BDbIyhzFkPJGGZ3ri0lsrgbLdrJZ9tOkhESCnrj2roX1RQaIRBki5A
	 FatGNo/ufEKYU/gnqo6eZN2wZWB/0NC46Ndyp3SE=
Date: Tue, 05 Nov 2024 16:59:24 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,wajdi.k.feghali@intel.com,ryan.roberts@arm.com,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,21cnbao@gmail.com,kanchana.p.sridhar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-make-some-count_mthp_stat-call-sites-be-thp-agnostic.patch removed from -mm tree
Message-Id: <20241106005925.0F1C2C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: make some count_mthp_stat() call-sites be THP-agnostic.
has been removed from the -mm tree.  Its filename was
     mm-swap-make-some-count_mthp_stat-call-sites-be-thp-agnostic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: mm: swap: make some count_mthp_stat() call-sites be THP-agnostic.
Date: Wed, 2 Oct 2024 15:58:22 -0700

In commit 246d3aa3e531 ("mm: cleanup count_mthp_stat() definition"), Ryan
Roberts has pointed out the merits of mm code that does not require THP,
to be compile-able without requiring THP ifdefs.  As a step in that
direction, he has moved count_mthp_stat() to be always defined, resolving
to a no-op if THP is not defined.

Barry Song referred me to Ryan's commit when I was working on the "mm:
zswap swap-out of large folios" patch-series [1].

This patch propagates the benefits of the above change to page_io.c and
vmscan.c.  As a result, there is one less reason to have the ifdef THP in
these code sections.

[1]: https://patchwork.kernel.org/project/linux-mm/list/?series=894347

Link: https://lkml.kernel.org/r/20241002225822.9006-1-kanchana.p.sridhar@intel.com
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wajdi Feghali <wajdi.k.feghali@intel.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Barry Song <21cnbao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    2 +-
 mm/vmscan.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_io.c~mm-swap-make-some-count_mthp_stat-call-sites-be-thp-agnostic
+++ a/mm/page_io.c
@@ -289,8 +289,8 @@ static inline void count_swpout_vm_event
 		count_memcg_folio_events(folio, THP_SWPOUT, 1);
 		count_vm_event(THP_SWPOUT);
 	}
-	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
 #endif
+	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
 	count_memcg_folio_events(folio, PSWPOUT, folio_nr_pages(folio));
 	count_vm_events(PSWPOUT, folio_nr_pages(folio));
 }
--- a/mm/vmscan.c~mm-swap-make-some-count_mthp_stat-call-sites-be-thp-agnostic
+++ a/mm/vmscan.c
@@ -1258,8 +1258,8 @@ retry:
 							THP_SWPOUT_FALLBACK, 1);
 						count_vm_event(THP_SWPOUT_FALLBACK);
 					}
-					count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
 #endif
+					count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
 					if (!add_to_swap(folio))
 						goto activate_locked_split;
 				}
_

Patches currently in -mm which might be from kanchana.p.sridhar@intel.com are


