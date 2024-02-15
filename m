Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A42113F001
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 21:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708034192; cv=none; b=TcDUzi1XsgCeJY+/SoIvuPFDD/AFmAINo1MNU497S3w57RM3pBojMGjgYx29zLffAiYhzhNod+fH3LgkpQvIeuGXANtryNmmzNnLlAmDo9IfSDRPin/cT9ApDpGPGPRPqfOpPlL/N7U/CrDfCT7Gjo4R4QNFJFJkH2tp6+mK898=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708034192; c=relaxed/simple;
	bh=VSHYI4Ideoitd8KH6N79lGnOSsas22YoiIkBMKpAdH0=;
	h=Date:To:From:Subject:Message-Id; b=bIihDD062U5myZ8vWYD8Q3+7gpnuFb4vDxqtJnZJxnUF6i4bWKNbRLDxskcL/zKYdP6T75s+xg+SeJuaOrlbiQAgE+lgm6LMb4LvY5U9P7uNrY0251tRCvGLI3APj1RRRXjylpGGu2KvhoULYVLjmGGRrWvU0rtiZPK1mwJ9dlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I5J+8fxh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I5J+8fxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEA6C433C7;
	Thu, 15 Feb 2024 21:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708034191;
	bh=VSHYI4Ideoitd8KH6N79lGnOSsas22YoiIkBMKpAdH0=;
	h=Date:To:From:Subject:From;
	b=I5J+8fxhT/hn6Gz8VA76mq2Fvig+RdunXgqB/KxNfbz2A3nj4meaAy0zcOlLxvXV7
	 UEV4IY3u2rSh77cFSSetP1bAg/1Wd1aR0BjC3wGdMOoTut1PkLWDw4YIZ4zJo1hLB0
	 Ntp1eVebF8glr5hRwldpKH0tx5wtGPfRgn+hhgr8=
Date: Thu, 15 Feb 2024 13:56:30 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rmap-replace-two-calls-to-compound_order-with-folio_order.patch added to mm-unstable branch
Message-Id: <20240215215631.9EEA6C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rmap: peplace two calls to compound_order with folio_order
has been added to the -mm mm-unstable branch.  Its filename is
     rmap-replace-two-calls-to-compound_order-with-folio_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rmap-replace-two-calls-to-compound_order-with-folio_order.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: rmap: peplace two calls to compound_order with folio_order
Date: Thu, 15 Feb 2024 20:53:05 +0000

Removes two unnecessary conversions from folio to page.  Should be no
difference in behaviour.

Link: https://lkml.kernel.org/r/20240215205307.674707-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~rmap-replace-two-calls-to-compound_order-with-folio_order
+++ a/mm/rmap.c
@@ -2169,7 +2169,7 @@ static bool try_to_migrate_one(struct fo
 				swp_pte = pte_swp_mkuffd_wp(swp_pte);
 			set_pte_at(mm, pvmw.address, pvmw.pte, swp_pte);
 			trace_set_migration_pte(pvmw.address, pte_val(swp_pte),
-						compound_order(&folio->page));
+						folio_order(folio));
 			/*
 			 * No need to invalidate here it will synchronize on
 			 * against the special swap migration pte.
@@ -2261,7 +2261,7 @@ static bool try_to_migrate_one(struct fo
 			else
 				set_pte_at(mm, address, pvmw.pte, swp_pte);
 			trace_set_migration_pte(address, pte_val(swp_pte),
-						compound_order(&folio->page));
+						folio_order(folio));
 			/*
 			 * No need to invalidate here it will synchronize on
 			 * against the special swap migration pte.
_

Patches currently in -mm which might be from willy@infradead.org are

memcg-convert-mem_cgroup_move_charge_pte_range-to-use-a-folio.patch
memcg-return-the-folio-in-union-mc_target.patch
memcg-use-a-folio-in-get_mctgt_type.patch
memcg-use-a-folio-in-get_mctgt_type_thp.patch
mm-add-pfn_swap_entry_folio.patch
proc-use-pfn_swap_entry_folio-where-obvious.patch
mprotect-use-pfn_swap_entry_folio.patch
highmem-add-kernel-doc-for-memcpy__folio.patch
rmap-replace-two-calls-to-compound_order-with-folio_order.patch
bounds-support-non-power-of-two-config_nr_cpus.patch

