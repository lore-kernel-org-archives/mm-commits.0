Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85C6127E0F;
	Fri, 12 Jul 2024 22:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824915; cv=none; b=ufc/tJuUQ2+2pGZzTAZYj1RU2yewZUQ94SA/2phWBzk6BsAFATi7PpAeBU7IJEyKF63UZ3feOXyUpzX6gf8f/DOqxfWBYr2VsGAAc2ynjpOKsA65WHLzvXSPazn4IYDepdNdEIj3ZXS16v/eyMUG4BAJ64mqd9hL71wuQOE9nVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824915; c=relaxed/simple;
	bh=cViGs+nXtwFxNQ/r1BVDj+HU20pYO5iMAGUQrHRG/ds=;
	h=Date:To:From:Subject:Message-Id; b=O3IrHO7YIJyo0NEQL/iPYFFHYr0dlTOMd2ct1eyFZPtJpfrfVMkKhrl/vTK91HkxG0SmpVE3S+d8h+8guJqbaYF9vcKH0jdeUebuRFGfmn/AoUkCjuM9OSABzWYBVc2ZmkWIZazE13hVuFxHsCq4XuBfW3s4pdzVZyGPJ92Ofwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oPSCEZMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oPSCEZMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AA5C32782;
	Fri, 12 Jul 2024 22:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824914;
	bh=cViGs+nXtwFxNQ/r1BVDj+HU20pYO5iMAGUQrHRG/ds=;
	h=Date:To:From:Subject:From;
	b=oPSCEZMyeVrnUGR5Vlr/vR8Xn3ZrktG7Pbz0HGMXoTfZlvKV8FpExmzzqkOekctwo
	 t0A4qLlsjihaa4OUhGHsTQebSgnJMrZiAx7jBGDvq68Zl8OJubqgvTCeJW1C+cQHMn
	 s5Ncbg+XDEV0jFxMoX5j0OOLyeD+R/Zv6iv/KhYg=
Date: Fri, 12 Jul 2024 15:55:14 -0700
To: mm-commits@vger.kernel.org,weixugc@google.com,stable@vger.kernel.org,mav@ixsystems.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-fix-div-by-zero-in-vmpressure_calc_level.patch removed from -mm tree
Message-Id: <20240712225514.B7AA5C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: fix div-by-zero in vmpressure_calc_level()
has been removed from the -mm tree.  Its filename was
     mm-mglru-fix-div-by-zero-in-vmpressure_calc_level.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


