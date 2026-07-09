Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A524499AB;
	Thu,  9 Jul 2026 21:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783633025; cv=none; b=tfJF8pG/NrKF+3gm9F6uZEUsl4Q+u3d2m00QX2sxDS0L/6kcQM/EevO5Ply/f+DpL8rtiLlo84/UKfSu9yVT21EjVTjhY8P6QCmAGVmBYM3wQPLen5TqTBOZDVxRoeDtvrJaGHjLi///5BdJJOjFoF9BwTyevJQtkUBQdBWW5CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783633025; c=relaxed/simple;
	bh=RhgYNwi3nu2DKCYq9fwdnfknrJJ8lS+kAuuxezYJpHw=;
	h=Date:To:From:Subject:Message-Id; b=U9gGL/x782tOJ3f12EO02/gTv64EypvLCcM9UnnLKKoXADJZEntLV9A54quROTSiaAv5HAhSLlr9FrxwHhEi4b5PxXFvyvgntO+O2MORwEdQBlR3WHW+yRO2JxnRKOZlMvvz/0vPxnmxfgudg+/j3Ts+OZzlruhoYILemzgqt7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fpHNkJDW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fpHNkJDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDD91F00A3A;
	Thu,  9 Jul 2026 21:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783633023;
	bh=nCWVjzIEzU9eOYfm2dNBWZa14PTVFafJPf5PNE2ocdQ=;
	h=Date:To:From:Subject;
	b=fpHNkJDWXf2pJKQLSJNWCXUuDo7lMtaSWvECXBC5pYndfM0IWLEH4jLX9CEQPXwRN
	 0ShzKzKJwhMXCZUVq3Wl3aK2e4P2hwnDQXF3zxVj0VjuGYjpFIPyS/dRdZltd22pIv
	 hhPpVOIPqTsql3Rvt6UQJz0tn2oa8d0P0O/R+qSo=
Date: Thu, 09 Jul 2026 14:37:02 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,dennis@kernel.org,cl@linux.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-km-fix-bitmap-overflow-and-accounting-in-pcpu_create_chunk.patch added to mm-hotfixes-unstable branch
Message-Id: <20260709213703.7FDD91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/percpu-km: fix bitmap overflow and accounting in pcpu_create_chunk()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-percpu-km-fix-bitmap-overflow-and-accounting-in-pcpu_create_chunk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-km-fix-bitmap-overflow-and-accounting-in-pcpu_create_chunk.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/percpu-km: fix bitmap overflow and accounting in pcpu_create_chunk()
Date: Thu, 09 Jul 2026 15:12:01 -0400

In pcpu_create_chunk(), nr_pages is the total contiguous backing
allocation, i.e., nr_units * pcpu_unit_pages, but pcpu_chunk_populated()
uses it to set chunk->populated, whose size is pcpu_unit_pages, bitmap. 
Since bit N in chunk->populated means page offset N inside every unit is
backed.  When nr_units > 1, the function writes beyond chunk->populated. 
Fix it by using chunk->nr_pages.

It also fixes the global pcpu_nr_empty_pop_pages accounting, since
pcpu_balance_free() only iterates up to chunk->nr_pages.

Commit a63d4ac4ab609 ("percpu: make percpu-km set chunk->populated bitmap
properly") introduced the bitmap overflow issue.  Later, commit
b539b87fed37f ("percpu: implmeent pcpu_nr_empty_pop_pages and
chunk->nr_populated") added pcpu_nr_empty_pop_pages and caused the
accounting issue.

Link: https://lore.kernel.org/20260709-fix-pcpu_create_chunk-in-percpu-km-v1-1-1f64745a84cc@nvidia.com
Fixes: a63d4ac4ab609 ("percpu: make percpu-km set chunk->populated bitmap properly")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6%40nvidia.com?part=1
Assisted-by: Codex:GPT-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-km.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu-km.c~mm-percpu-km-fix-bitmap-overflow-and-accounting-in-pcpu_create_chunk
+++ a/mm/percpu-km.c
@@ -75,7 +75,7 @@ static struct pcpu_chunk *pcpu_create_ch
 	chunk->base_addr = page_address(pages);
 
 	spin_lock_irqsave(&pcpu_lock, flags);
-	pcpu_chunk_populated(chunk, 0, nr_pages);
+	pcpu_chunk_populated(chunk, 0, chunk->nr_pages);
 	spin_unlock_irqrestore(&pcpu_lock, flags);
 
 	pcpu_stats_chunk_alloc();
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-percpu-km-fix-bitmap-overflow-and-accounting-in-pcpu_create_chunk.patch
mm-page_owner-add-numa-node-filter-fix.patch
mm-percpu-km-clear-page-private-before-free-them.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

