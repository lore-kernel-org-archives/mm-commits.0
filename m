Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E55C1F4634
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 05:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783660806; cv=none; b=WCVpyaA8DEYcT0z3wZ6HKjs/tfTISPIgKfdBxRbb/OjmABPd5Uk7MMzWYDZgsygKygXabKS69435ohh2j4D77XJnc/mTQYA5W6Z7S12Z6YmaQOpuHufV3pMD7ZBR+JaEIHEWSboi5K4v70bapgr0gT73zSoqc62WpxqY2fggiqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783660806; c=relaxed/simple;
	bh=unnTTU6yZOypfxf7oHgV68WHb+pmcIsg4DxnkPgr9cc=;
	h=Date:To:From:Subject:Message-Id; b=YDpUoVVZT8Vr26cUsGn5ROrvTyqX4bLSrEyKYV0qOfiHYutLwQLsHWO9Vs/sEX37DhRW1KM5jyfDzOnm/DtYlr+OeF/QrQmPTs58dQ3nohJls9Ru8DFeVgENWs2tekL0pgsJafYm6R++o1YqAiZuFLNKiD5tmc7IOmNE+6Ev4+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LEiVUbhj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LEiVUbhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1631F000E9;
	Fri, 10 Jul 2026 05:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783660804;
	bh=anyoVx4lbt+XTXUyfkLQHWUE0rOoDD1OQPmp1YG2tIQ=;
	h=Date:To:From:Subject;
	b=LEiVUbhjO5tlCwTAzt+y+Uy8c/ohFanDQNOv8I0daWSWTnChpIiTjMD9LEKGFzqSQ
	 clPSY4CzkM3h1d8zZ1AA1r/+I1h6LYowXZPauu2cS4HEN1+4vhpgF+7fFZnIbgV9fs
	 UXkawOGIJA73eXAL95hsC9EI2lGj1ECrNAcKLnvg=
Date: Thu, 09 Jul 2026 22:20:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-wb_writeout_inc.patch added to mm-new branch
Message-Id: <20260710052004.AE1631F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove wb_writeout_inc
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-wb_writeout_inc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-wb_writeout_inc.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove wb_writeout_inc
Date: Fri, 10 Jul 2026 07:10:52 +0200

Remove this entirely unused but exported function.

Link: https://lore.kernel.org/20260710051052.1839523-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    2 --
 mm/page-writeback.c         |   10 ----------
 2 files changed, 12 deletions(-)

--- a/include/linux/backing-dev.h~mm-remove-wb_writeout_inc
+++ a/include/linux/backing-dev.h
@@ -76,8 +76,6 @@ static inline s64 wb_stat_sum(struct bdi
 	return percpu_counter_sum_positive(&wb->stat[item]);
 }
 
-extern void wb_writeout_inc(struct bdi_writeback *wb);
-
 /*
  * maximal error of a stat counter.
  */
--- a/mm/page-writeback.c~mm-remove-wb_writeout_inc
+++ a/mm/page-writeback.c
@@ -584,16 +584,6 @@ static inline void __wb_writeout_add(str
 				       wb->bdi->max_prop_frac, nr);
 }
 
-void wb_writeout_inc(struct bdi_writeback *wb)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__wb_writeout_add(wb, 1);
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL_GPL(wb_writeout_inc);
-
 /*
  * On idle system, we can be called long after we scheduled because we use
  * deferred timers so count with missed periods.
_

Patches currently in -mm which might be from hch@lst.de are

mm-remove-wb_writeout_inc.patch

