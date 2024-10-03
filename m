Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9BF1ABEB4
	for <mm-commits@vger.kernel.org>; Thu,  3 Oct 2024 19:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727985492; cv=none; b=MJFNYrUdH2NEfdWWLJVnRfbu73joUuPZjxsg0L+ZCkhy7ecDSXgOshYrtPX867zlVUsANTJgAgaI43new9SUTtVfXTZTLHVG+z7S/C0Nml3LT/d0g3SNVaSPeY7aed8J4JiJApGp9rkmMZ94jR03tUWpEd+abChJb2HifmkyLx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727985492; c=relaxed/simple;
	bh=IsHytjxizsZ9vIAF7Ee40snQsyTxaxsCBV4PWsJ0ieg=;
	h=Date:To:From:Subject:Message-Id; b=LiZ8+caemay7y/6PgXGbjtGIPkRZEZxIRwqlpV3iplbOWvDEad5+Vyj+7sV4UdxQPnDWD4vRU3t8n+Eu+cLcwA3GBym2c8A7AdusgrQM7bKeFRyREMuO+eDTVdAwZTYaLvoJDRaX1X+jDkZ5XKbV+Eymyvd5pCDIbRRLuxl5APQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ybS0V9Yw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ybS0V9Yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E070BC4CEC5;
	Thu,  3 Oct 2024 19:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727985492;
	bh=IsHytjxizsZ9vIAF7Ee40snQsyTxaxsCBV4PWsJ0ieg=;
	h=Date:To:From:Subject:From;
	b=ybS0V9YwTn9tNR0y+sVg00AMX/cyxgL1doUXeKoUWt+DQ2p0Ew0vSW+Gs5fMWN4VE
	 7CPN9fLpVAp9VC+Y6NBdWdKgfZshIG7lWPOLZQ1oUB7IzDq1ZokbHjMvlUviNMT2Kc
	 CwfuoVRI/sZxJtgMTa6SuhTFa8CpjWgmQSY1vwes=
Date: Thu, 03 Oct 2024 12:58:11 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,wajdi.k.feghali@intel.com,ryan.roberts@arm.com,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,kanchana.p.sridhar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-make-some-count_mthp_stat-call-sites-be-thp-agnostic.patch added to mm-unstable branch
Message-Id: <20241003195811.E070BC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: make some count_mthp_stat() call-sites be THP-agnostic.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-make-some-count_mthp_stat-call-sites-be-thp-agnostic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-make-some-count_mthp_stat-call-sites-be-thp-agnostic.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -1257,8 +1257,8 @@ retry:
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

mm-zswap-delete-comments-for-value-member-of-struct-zswap_entry.patch
mm-define-obj_cgroup_get-if-config_memcg-is-not-defined.patch
mm-zswap-modify-zswap_compress-to-accept-a-page-instead-of-a-folio.patch
mm-zswap-rename-zswap_pool_get-to-zswap_pool_tryget.patch
mm-change-count_objcg_event-to-count_objcg_events-for-batch-event-updates.patch
mm-zswap-modify-zswap_stored_pages-to-be-atomic_long_t.patch
mm-zswap-support-large-folios-in-zswap_store.patch
mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats.patch
mm-zswap-zswap_store_page-will-initialize-entry-after-adding-to-xarray.patch
mm-swap-make-some-count_mthp_stat-call-sites-be-thp-agnostic.patch

