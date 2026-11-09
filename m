Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794202470;
	b=u+hRP6g3H01ztuOAwNFU+D3fXJ94esR2LeI3GiMIku4CthjOFl+UsJPPldov5CZl51at
	 +ZYL7eSQvtPoR5IBhnJoT3bGRopD58tXFUdVly7Rh0gKTaOa0ffTNvBJyVa3pUFGAOYUK
	 FOAk17CcOJ3zrcYxwWw61YPWcM6jnLOg1yPOEA2Lfy3HEEkeRIqfxZYOaZg1ouLe7g9Yk
	 HYOWBwKPRBCpLf2XHZacCiBM2vd1nvmaDFcExuiwT1LnYk1seQcnlghm6GxmrWqcws/c8
	 +ed4f80B5LA/elmVWPFFRn0DguU56SpPFUjQiCSik/N/AAuUdX48ZF3yw1lp5Xv9kQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794202470;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=qIB2rDMDYvp1yEaaGY14vFL8VskkGyzN/nKRJpYU9xk=;
	b=RTuG3R86NkjL/isoN2eOFbzxYyTxZ07UruQA1TRNMcExi9D0RV3BmEQ/7JWhwQ2GRamH
	 wZ+e2qkTLKvZQVHbf2ZQKSZSmvgtueJU4U77bwSSXtceG2GQnjPK5TzCMpxrEr5WOWbqc
	 l1bGO/ExjN1ovoW2H1o0Dahx29gpjODgI5YFAFfbyZ56zy2PdtXrw3N41GZUKNDEmKL4f
	 hIUaB9w1qlvLtqHGaE1PawtWOiTJQ5ofmYfEt3ZXpGSbXurgPpA4d395TXLfMdohgdG59
	 r5cQBwGRRjifeSSH923rbEV9J3ng2+VbkmnDYt6V+qVSjp6fsbj/qmPdhhnHYqXWZ1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=p4vBpRc3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F86606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 05:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=p4vBpRc3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0322E1F0089F;
	Mon,  9 Nov 2026 05:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794202470;
	bh=qIB2rDMDYvp1yEaaGY14vFL8VskkGyzN/nKRJpYU9xk=;
	h=Date:To:From:Subject;
	b=p4vBpRc33jpXXloSX+Na+p1ssKhF39itCatCv8OHMkO4C0c+04uTYo97Q8uiJs1aZ
	 t1FYr30Gxs6m/AqVt5wSr3rFCR9/qMwJtZTgiwmNefmkL1lg4wjrboKC6vWbESieZt
	 Qk6Rm34wfEXUpCTKF2O89jHJk/6B2LqYWwyFYtsg=
Date: Sun, 08 Nov 2026 21:34:29 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,joannelkoong@gmail.com,
	jack@suse.cz,thnkslprpt@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page-writeback-avoid-unnecessary-strictlimit-background-wakeups.patch added to mm-new branch
Message-Id: <20261109053430.0322E1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/page-writeback: avoid unnecessary strictlimit background wakeups
has been added to the -mm mm-new branch.  Its filename is
     mm-page-writeback-avoid-unnecessary-strictlimit-background-wakeups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page-writeback-avoid-unnecessary-strictlimit-background-wakeups.patch

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
From: Avi Weiss <thnkslprpt@gmail.com>
Subject: mm/page-writeback: avoid unnecessary strictlimit background wakeups
Date: Sun,  8 Nov 2026 10:54:57 +0200

balance_dirty_pages() includes pages under writeback in gdtc->wb_dirty
when checking the per-wb background threshold for strictlimit BDIs. 
However, wb_over_bg_thresh() only considers reclaimable dirty pages when
deciding whether to start more background writeback.

This can repeatedly wake the background worker even when there are too few
dirty pages to write.  In a 15-second FUSE writeback test, background
wakeup requests dropped from 2657 to 682 (74% drop), while writeback_start
events remained nearly unchanged at 99 and 98.

Check wb_over_bg_thresh() before starting background writeback through the
strictlimit condition.  Leave the global background threshold check and
the wakeup required for dirty throttling unchanged.

Link: https://lore.kernel.org/20261108085456.2093096-2-thnkslprpt@gmail.com
Fixes: 0437906841d0 ("mm: start background writeback based on per-wb threshold for strictlimit BDIs")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
---

 mm/page-writeback.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-page-writeback-avoid-unnecessary-strictlimit-background-wakeups
+++ a/mm/page-writeback.c
@@ -1827,9 +1827,15 @@ static int balance_dirty_pages(struct bd
 			balance_domain_limits(mdtc, strictlimit);
 		}
 
+		/*
+		 * gdtc->wb_dirty includes pages under writeback, so use it as
+		 * a cheap preliminary check before wb_over_bg_thresh() decides
+		 * whether background writeback is needed.
+		 */
 		if (!writeback_in_progress(wb) &&
 		    (nr_dirty > gdtc->bg_thresh ||
-		     (strictlimit && gdtc->wb_dirty > gdtc->wb_bg_thresh)))
+		     (strictlimit && gdtc->wb_dirty > gdtc->wb_bg_thresh &&
+		      wb_over_bg_thresh(wb))))
 			wb_start_background_writeback(wb);
 
 		/*
_

Patches currently in -mm which might be from thnkslprpt@gmail.com are

mm-page-writeback-avoid-unnecessary-strictlimit-background-wakeups.patch

