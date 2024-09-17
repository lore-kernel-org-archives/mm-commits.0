Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A430130E4A;
	Tue, 17 Sep 2024 07:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726559930; cv=none; b=sD8ONCZoc9lnaSduWRv2BEdC6pnBrvbr2s+hrymWcfE2vEXxDji7X6r3v3bAGaXxDQj+YXGhNtN6sB8MDRuTGPfArl5IEY4dLzMXM4K2r604PldTuBqnT5afz+ZutRx2lKFsHe/WRN7IQpOef64XxDAlCqaunXOrTNOhI92c+Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726559930; c=relaxed/simple;
	bh=jhMEuw9L53zT7gzqr7b2+tHYeN7aBj3Ja0AerWp9wg0=;
	h=Date:To:From:Subject:Message-Id; b=WWiD2Ws+DySn7qKnNY6t5jWWm8UoY+iMqdoAxAm8R5mMfuhLkXCZPtmgAslFuRWP3Bse4KerUtBHrxllWhjAIGmkon4pVhg9ClNq3qyWBIL+7iEIS/xCFkc5vMTjXVlw/rZQK/iaHTDULx0ELzWkJFJD5z6gSXp+g+NoSxQIStk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fvtw1fdZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fvtw1fdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4B1C4CEC6;
	Tue, 17 Sep 2024 07:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726559930;
	bh=jhMEuw9L53zT7gzqr7b2+tHYeN7aBj3Ja0AerWp9wg0=;
	h=Date:To:From:Subject:From;
	b=fvtw1fdZdFbCfrEpz9GW5ebmBx4m8p+TZeO76HOAVlbl+uPhLDABvrNMP8OkxhzW5
	 v0TCUjYUr6Mtt4FXnn6iwVaLyFYjIJ8eFyF5NYKTOnL0eeAQXF0QbFCdF9PKVdDP8n
	 V51zGIckZGeAYzy8lXj+5t23wzBO9PVIakDnP5xw=
Date: Tue, 17 Sep 2024 00:58:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,david@redhat.com,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-ensure-huge_zero_folio-wont-have-large_rmappable-flag-set.patch removed from -mm tree
Message-Id: <20240917075849.BF4B1C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: ensure huge_zero_folio won't have large_rmappable flag set
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-ensure-huge_zero_folio-wont-have-large_rmappable-flag-set.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-memory-failure-fix-vm_bug_on_pagepagepoisonedpage-when-unpoison-memory.patch

