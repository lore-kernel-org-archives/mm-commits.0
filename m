Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E14217C205;
	Thu, 11 Jul 2024 19:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720727404; cv=none; b=CIEY2XHwfjE6hNpEt/cJR0jig+BMkrPjE1N43bFQU0XuEMwNHO3RPd8I91lXNtBV3wZM/Nmmux7olK2dkEjA3Doz8j2CnTKhk0FCQLyXDrfc8T+CNoZGdpzxdlhiP13QscaRw4Fl+y1ZbQJYkOpEbHE/28UVYH1qG6LYPUNOpTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720727404; c=relaxed/simple;
	bh=uGmt9MhWr+IhldWKO4BjArzwltW7yBIWuStFuU0aH74=;
	h=Date:To:From:Subject:Message-Id; b=mva2MbbGc4NGjky+PtLTgqQQs/97gTkzgd0j9ph48fkn9kLpI7D5MwWhD5/DNocpZlW3cYcEw6tyuERqnQ/7yu71oIZkCEsbRyRLA0EKBz0GeeuzqswpupQpLh1Cq8qmoE7nvx958XLNOXgvl/Qgh8xMynizzEQeAy3OfmYA0Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lsOvTLGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lsOvTLGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C777EC116B1;
	Thu, 11 Jul 2024 19:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720727403;
	bh=uGmt9MhWr+IhldWKO4BjArzwltW7yBIWuStFuU0aH74=;
	h=Date:To:From:Subject:From;
	b=lsOvTLGhONXRNQ0UCcwLpGLteXuxmphl3ibn1cUWdyDaAopVQXvgZRSI9+RVtIXqQ
	 E+ah24LUTMlTN/f7ns1zyJGfFoArlANQEq1PHyVLB5yxxoTMGhTxaI31GGr9KZ7/eI
	 huiTPA8U9zsF8FW3rJDkcdavpyvlc3m3kTn6p7lI=
Date: Thu, 11 Jul 2024 12:50:03 -0700
To: mm-commits@vger.kernel.org,weixugc@google.com,stable@vger.kernel.org,mav@ixsystems.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-fix-div-by-zero-in-vmpressure_calc_level.patch added to mm-unstable branch
Message-Id: <20240711195003.C777EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: fix div-by-zero in vmpressure_calc_level()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-fix-div-by-zero-in-vmpressure_calc_level.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-fix-div-by-zero-in-vmpressure_calc_level.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm/mglru: fix div-by-zero in vmpressure_calc_level()
Date: Thu, 11 Jul 2024 13:19:56 -0600

evict_folios() uses a second pass to reclaim folios that have gone through
page writeback and become clean before it finishes the first pass, since
folio_rotate_reclaimable() cannot handle those folios due to the
isolation.

The second pass tries to avoid potential double counting by deducting
scan_control->nr_scanned.  However, this can result in underflow of
nr_scanned, under a condition where shrink_folio_list() does not increment
nr_scanned, i.e., when folio_trylock() fails.

The underflow can cause the divisor, i.e., scale=scanned+reclaimed in
vmpressure_calc_level(), to become zero, resulting in the following crash:

  [exception RIP: vmpressure_work_fn+101]
  process_one_work at ffffffffa3313f2b

Since scan_control->nr_scanned has no established semantics, the potential
double counting has minimal risks.  Therefore, fix the problem by not
deducting scan_control->nr_scanned in evict_folios().

Link: https://lkml.kernel.org/r/20240711191957.939105-1-yuzhao@google.com
Fixes: 359a5e1416ca ("mm: multi-gen LRU: retry folios written back while isolated")
Reported-by: Wei Xu <weixugc@google.com>
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Alexander Motin <mav@ixsystems.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-fix-div-by-zero-in-vmpressure_calc_level
+++ a/mm/vmscan.c
@@ -4597,7 +4597,6 @@ retry:
 
 		/* retry folios that may have missed folio_rotate_reclaimable() */
 		list_move(&folio->lru, &clean);
-		sc->nr_scanned -= folio_nr_pages(folio);
 	}
 
 	spin_lock_irq(&lruvec->lru_lock);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-truncate-batch-clear-shadow-entries.patch
mm-truncate-batch-clear-shadow-entries-v2.patch
mm-mglru-fix-div-by-zero-in-vmpressure_calc_level.patch
mm-mglru-fix-overshooting-shrinker-memory.patch

