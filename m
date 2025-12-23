Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BD334AAED
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 19:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517835; cv=none; b=fSKLMkUrq/uhiVecHUGLpcUOJnVul0OlsU38t4TBvUORLCFr9R0Sj2ISacGpYCdiNRvnv7u3mnA851Ty+2h+bH3pmcr/O/61BGbvaregvcb5NeksYPsiBkGu++rnS9O8DAF0OYfZFRJ5f+qW8GuAADLBSonRMA9GwUHN3ov+c0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517835; c=relaxed/simple;
	bh=3OSvUuozMjWk0mq90DPZ+wTQxSOzlJQsb23fFfHET0A=;
	h=Date:To:From:Subject:Message-Id; b=tjoZkGAiCGkfNhwHd6JMMKsHVGRs7FFoTmnBqxyQFYcdNzOPI/TsU1thpIy+TkPVJXa+mWPinT/l99AHBE3M0EixppMPA1QHDYBvff52zlnI8qaazQHN7/9253erTrcRCJf+lQoEM3204I8CN7HbKSjbiSfdn/jnM3Trf4tpLJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kC0gGkiP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kC0gGkiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27591C113D0;
	Tue, 23 Dec 2025 19:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517835;
	bh=3OSvUuozMjWk0mq90DPZ+wTQxSOzlJQsb23fFfHET0A=;
	h=Date:To:From:Subject:From;
	b=kC0gGkiPlBmTkt9U1FHgNCHc5goUN7BSXurf/hvRQWM/AUO+7iAoDjoaCB6EvaOaQ
	 CHFeWQIDUwsQXxMHU27IX//r6QEVxZ6pC9ue764lRxpDybScCvBC2/2qhX7GLBs0VV
	 cxaAWQqKniIlVV4hdL1mkH6wN93+K9UKatALKiPs=
Date: Tue, 23 Dec 2025 11:23:54 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,rdunlap@infradead.org,alexey.skidanov@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] genalloch-fix-htmldocs-warning.patch removed from -mm tree
Message-Id: <20251223192355.27591C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: genalloc.h: fix htmldocs warning
has been removed from the -mm tree.  Its filename was
     genalloch-fix-htmldocs-warning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: genalloc.h: fix htmldocs warning
Date: Thu Nov 27 10:39:24 AM PST 2025

WARNING: include/linux/genalloc.h:52 function parameter 'start_addr' not described in 'genpool_algo_t'

Fixes: 52fbf1134d47 ("lib/genalloc.c: fix allocation of aligned buffer from non-aligned chunk")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lkml.kernel.org/r/20251127130624.563597e3@canb.auug.org.au
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexey Skidanov <alexey.skidanov@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/genalloc.h~genalloch-fix-htmldocs-warning
+++ a/include/linux/genalloc.h
@@ -44,6 +44,7 @@ struct gen_pool;
  * @nr: The number of zeroed bits we're looking for
  * @data: optional additional data used by the callback
  * @pool: the pool being allocated from
+ * @start_addr: start address of memory chunk
  */
 typedef unsigned long (*genpool_algo_t)(unsigned long *map,
 			unsigned long size,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix.patch
mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch
mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
kernel-watchdogc-fix-unused-var-warning.patch

