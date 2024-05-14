Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A251E491
	for <mm-commits@vger.kernel.org>; Tue, 14 May 2024 21:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715720948; cv=none; b=c86Mg0ETwH7Blulk6ANrtgi5XpVc4fCvqoAIC3Dt9bi5cJInnEWuNIf3B+dBIRPOyGaGjHZ16cQp9UrUjpgXp3dU0KeFKOHpuJ3sk4gPd7pZ3ui6YCFC4bRA4ZJMZ/++gx07zfnVVdy+iIO9qRbe2vm7H8FFrwAIG4+2bP+TlXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715720948; c=relaxed/simple;
	bh=yMOf54BMzPvpJcbPxgwK5QV1qdMt3BNdqkWBeGFYBBs=;
	h=Date:To:From:Subject:Message-Id; b=OCQpLarI+rGupCZYB/k9JAmqhNC1t9MBDktVwTeHXa88NYGYPKXi7pIUgkzaZMa1EhDunMfJPtPK9qoRF/GLB2vxABBUNtjilryYyr2R+vuggYwmJbZUFYRd2+wE+rdSI9aR+WJOq8k5hBhanDGcPYG9sZyIsU/1V8NT1gia4Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kmkRaau2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kmkRaau2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C185C2BD10;
	Tue, 14 May 2024 21:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715720947;
	bh=yMOf54BMzPvpJcbPxgwK5QV1qdMt3BNdqkWBeGFYBBs=;
	h=Date:To:From:Subject:From;
	b=kmkRaau2uyJTeAJySa4uZHEcwJFnCRf3qLPmmZPzkU++Jg3zSimCZ1nhyFfNULGYh
	 8TZnyEHUuZ0JnZL1wDyJjv+bzs7SsEVagbouh01b7S84N1jqGyP61T30hHistAOl+Z
	 8U3eYbGFtE1O/MsIGf7CoqgrJw5iuXW/3Ji5awKo=
Date: Tue, 14 May 2024 14:09:06 -0700
To: mm-commits@vger.kernel.org,xuyu@linux.alibaba.com,willy@infradead.org,shy828301@gmail.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-mark-huge_zero_page-reserved-fix.patch added to mm-unstable branch
Message-Id: <20240514210907.5C185C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-huge_memory-mark-huge_zero_page-reserved-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-mark-huge_zero_page-reserved-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-mark-huge_zero_page-reserved-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-huge_memory-mark-huge_zero_page-reserved-fix
Date: Tue May 14 01:53:37 PM PDT 2024

Update it for 5691753d73a2 ("mm: convert huge_zero_page to huge_zero_folio")

Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-mark-huge_zero_page-reserved-fix
+++ a/mm/huge_memory.c
@@ -212,7 +212,7 @@ retry:
 		folio_put(zero_folio);
 		goto retry;
 	}
-	__SetPageReserved(zero_page);
+	__folio_clear_reserved(zero_folio);
 	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
 
 	/* We take additional reference here. It will be put back by shrinker */
@@ -265,7 +265,7 @@ static unsigned long shrink_huge_zero_pa
 		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
 		BUG_ON(zero_folio == NULL);
 		WRITE_ONCE(huge_zero_pfn, ~0UL);
-		__ClearPageReserved(zero_page);
+		__folio_clear_reserved(zero_folio);
 		folio_put(zero_folio);
 		return HPAGE_PMD_NR;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-huge_memory-mark-huge_zero_page-reserved-fix.patch
lib-add-version-into-proc-allocinfo-output-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

