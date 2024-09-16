Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB92DF53;
	Mon, 16 Sep 2024 06:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726466743; cv=none; b=ORcWjIK1y1cxOLTuZqzvD+EkJeZEw1uSBNKbqCQ/+KWKBIUJkrNQ5e1Rn5+oSUeh/cYVG7Bc8Fki/5SG+Qoou8x4umFDo2Ij+9ynyuiNxAB6/TcYDwZ5f3ohtdvPDOLmQRczW4CIBTbuuh56ajEu7CRxJSy7+EcwBzafFcQz0H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726466743; c=relaxed/simple;
	bh=LMHlqf+5SUEVy+dDEjAoHTTs9vBYdaswX7Gucl4P2rs=;
	h=Date:To:From:Subject:Message-Id; b=Otfov7oXmfNd5nTKzN0qffdZzOukeJeX37OGUINsCNZJI3EsYHvaXUltTxSgrEP+61ERF8DUM9D5qh333XAgWrW+2uYfzWuUevsk8IbO5sOartH/Oq8H3ITKFzrWbIzbZHHlHElWqBwy76cUh1ESapfgh/GvLzKhVG5CMWoV2xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=opPLai0n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="opPLai0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3835C4CEC4;
	Mon, 16 Sep 2024 06:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726466742;
	bh=LMHlqf+5SUEVy+dDEjAoHTTs9vBYdaswX7Gucl4P2rs=;
	h=Date:To:From:Subject:From;
	b=opPLai0nAU8zhBqnrgk50v9bgc6r67P0M6O+JTL22GSO6GxohLDRlTsxCGdnl8n3W
	 ia5qlxGiyZHcZMFgtv2LaZItuncGABkyZafZDc68fkSStQOV90cCeYPk76QmRAipUh
	 +1vIHQLU3xgzclL1oxV/BgdoA1W7k6qA7huOOfF0=
Date: Sun, 15 Sep 2024 23:05:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,david@redhat.com,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-ensure-huge_zero_folio-wont-have-large_rmappable-flag-set.patch added to mm-hotfixes-unstable branch
Message-Id: <20240916060541.F3835C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: ensure huge_zero_folio won't have large_rmappable flag set
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-ensure-huge_zero_folio-wont-have-large_rmappable-flag-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-ensure-huge_zero_folio-wont-have-large_rmappable-flag-set.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory: ensure huge_zero_folio won't have large_rmappable flag set
Date: Sat, 14 Sep 2024 09:53:06 +0800

Ensure huge_zero_folio won't have large_rmappable flag set.  So it can be
reported as thp,zero correctly through stable_page_flags().

Link: https://lkml.kernel.org/r/20240914015306.3656791-1-linmiaohe@huawei.com
Fixes: 5691753d73a2 ("mm: convert huge_zero_page to huge_zero_folio")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-ensure-huge_zero_folio-wont-have-large_rmappable-flag-set
+++ a/mm/huge_memory.c
@@ -220,6 +220,8 @@ retry:
 		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
 		return false;
 	}
+	/* Ensure zero folio won't have large_rmappable flag set. */
+	folio_clear_large_rmappable(zero_folio);
 	preempt_disable();
 	if (cmpxchg(&huge_zero_folio, NULL, zero_folio)) {
 		preempt_enable();
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-ensure-huge_zero_folio-wont-have-large_rmappable-flag-set.patch
mm-memory-failure-fix-vm_bug_on_pagepagepoisonedpage-when-unpoison-memory.patch

