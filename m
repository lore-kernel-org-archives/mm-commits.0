Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3072263D5
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957004; cv=none; b=m4iZn0GuxB0yzqxuY+MjYYL9zmyl/dutuKUIQfxtkDoXISskgKJ/e+UlGckk0dIrigkBZS7XyTczH/eD4fAjnl/2W8alry/3JVu4EdM25maUy+dUH0E0sBlKn4C05xRrV6CVgHGJS1nL6/OvUDuSReBZjVer92wPwOUKb86rQPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957004; c=relaxed/simple;
	bh=6uwL7poJMbkY1/5mxWbw0ql5d07vDVeI8xZJhStincA=;
	h=Date:To:From:Subject:Message-Id; b=YGwRu0Gr7ZnViLPiUg0bjd4V2TDEbA4zHdhqTkstkgR0w61EhagPPgYpypANl1vGwsKSMTpEvcO+4XawsDagul9rPfubs6ZEpp53UWASYcQtjj1/q003Y6rUZFL1fNl32NhubkTJNU53yAiFw8AtkmWpdZRLZs2K6AwSfzaUp+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UkgD/Uf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UkgD/Uf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB72BC113CC;
	Mon,  6 May 2024 00:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957004;
	bh=6uwL7poJMbkY1/5mxWbw0ql5d07vDVeI8xZJhStincA=;
	h=Date:To:From:Subject:From;
	b=UkgD/Uf7FwGS/iGSJyBBlYD1c3KWsxEAhVvU/bq9OOayr+5Oxb7UD+ucwi2/lXech
	 SNWllijyraK8aPxv6mLDuDlZn7G8Z+OPPpFRyeHs8daDH3rhX4B3RnwyOH915DyoFs
	 M3XziRmylmOXEtsWTo9qzIzYMkRGTdFi1lh9dmrQ=
Date: Sun, 05 May 2024 17:56:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-use-folio_mapcount-in-zap_present_folio_ptes.patch removed from -mm tree
Message-Id: <20240506005643.EB72BC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: use folio_mapcount() in zap_present_folio_ptes()
has been removed from the -mm tree.  Its filename was
     mm-memory-use-folio_mapcount-in-zap_present_folio_ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: use folio_mapcount() in zap_present_folio_ptes()
Date: Tue, 9 Apr 2024 21:22:50 +0200

We want to limit the use of page_mapcount() to the places where it is
absolutely necessary.  In zap_present_folio_ptes(), let's simply check the
folio mapcount().  If there is some issue, it will underflow at some point
either way when unmapping.

As indicated already in commit 10ebac4f95e7 ("mm/memory: optimize
unmap/zap with PTE-mapped THP"), we already documented "If we ever have a
cheap folio_mapcount(), we might just want to check for underflows
there.".

There is no change for small folios.  For large folios, we'll now catch
more underflows when batch-unmapping, because instead of only testing the
mapcount of the first subpage, we'll test if the folio mapcount
underflows.

Link: https://lkml.kernel.org/r/20240409192301.907377-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory.c~mm-memory-use-folio_mapcount-in-zap_present_folio_ptes
+++ a/mm/memory.c
@@ -1502,8 +1502,7 @@ static __always_inline void zap_present_
 	if (!delay_rmap) {
 		folio_remove_rmap_ptes(folio, page, nr, vma);
 
-		/* Only sanity-check the first page in a batch. */
-		if (unlikely(page_mapcount(page) < 0))
+		if (unlikely(folio_mapcount(folio) < 0))
 			print_bad_pte(vma, addr, ptent, page);
 	}
 
_

Patches currently in -mm which might be from david@redhat.com are


