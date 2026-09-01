Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7F7488DAD;
	Tue,  1 Sep 2026 17:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788282640; cv=none; b=tnPdtXv2RXQ+1KxHecR/DjTuWt476UQ95O/flrV59DObAbXBkne/frL7YEH7PsZuTn7CfYCdH+EED4Sjit2ECQjB+tucqi8yRWLpjVgE6bBvmzGp5qji4PwkaaLQWoXFydxKnHm9LstwPECkKRmA0thTB15+NhHv5vGPVEhaBgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788282640; c=relaxed/simple;
	bh=lUWOYHc0MdAusjEtVTNEL48TQY+kDoyUWIieMStTa1w=;
	h=Date:To:From:Subject:Message-Id; b=LbCVX3z74LEkDN0QKtU2l2u7KGKNUIf6F1T4PjfbVdGoEslvY689UoZLy613vGkxbNBkCbOtG47Ub1kq3VrB3LSRP6vGHbFe4nDG0lKILYffSFuC4IfDVVmYPS38vfuqGfPoFy0he8T18/i2UOk2rPb5iEhStS2FEoq3ZaPzhLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K4tny4xh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K4tny4xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB0C1F000E9;
	Tue,  1 Sep 2026 17:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788282638;
	bh=nHm4iUYgDe+eEkB1jDs4+K57q4vrQxSrAggDGZmnMrM=;
	h=Date:To:From:Subject;
	b=K4tny4xhBAXlbaaKh80fQylxJ7nRBJzKnU0S39YX/8DeOWl/1hBPkMxe+Ie3a0FMp
	 fYbNZLmAfhP1/AS2zBIChq468qqNZWu51w0Fzjkmqvkitqk5jnnT2EZ5Q/pfxx4YlI
	 Jhu9rTqJ6lPhk4c4yOF0Q5SETE5+t9yFuUyQ8Jtw=
Date: Tue, 01 Sep 2026 10:10:37 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch added to mm-new branch
Message-Id: <20260901171038.3FB0C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: respect folio end for DAMOS actions except STAT
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/paddr: respect folio end for DAMOS actions except STAT
Date: Tue, 1 Sep 2026 06:18:44 -0700

A few functions for applying DAMOS actions including pageout, lru_[de]prio
and migrate_{hot,cold} in DAMON physical address space operation set
(paddr) collect folios of the given region by getting the folios of
region-internal addresses.  Then, those functions apply the action to the
collected folios at once.  The collection starts from the region start
address and advances the address by the size of the folio of the address
until it goes out of the region.  If the start address is in the middle of
a large folio, and if the next folios are small, some of the next folios
could be skipped.  Fix the issue by advancing the address to exactly the
start address of the next folio.

The user impact is that DAMOS action is applied to less than expected
amount of memory.  Given the best effort nature of DAMON, it is no big
problem, but it is clearly a bug that is better to be fixed.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-4-sj@kernel.org
Link: https://lore.kernel.org/20260517234112.89245-1-sj@kernel.org [1]
Fixes: 3a06696305e7 ("mm/damon/ops: have damon_get_folio return folio even for tail pages")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat
+++ a/mm/damon/paddr.c
@@ -264,7 +264,7 @@ static unsigned long damon_pa_pageout(st
 		else
 			list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	if (install_young_filter)
@@ -302,7 +302,7 @@ static inline unsigned long damon_pa_de_
 			folio_deactivate(folio);
 		applied += folio_nr_pages(folio);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	s->last_applied = folio;
@@ -350,7 +350,7 @@ static unsigned long damon_pa_migrate(st
 				folio_is_file_lru(folio));
 		list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	applied = damon_migrate_pages(&folio_list, s->target_nid);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-skip-applying-scheme-if-region-split-for-quota-fails.patch
mm-damon-paddr-respect-folio-end-for-damos_stat.patch
mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch
mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch

