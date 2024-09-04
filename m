Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE88874402
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423523; cv=none; b=QH7oO+E+DSwGWyARDlX5VJ1u4ZP5zK3ZLlxAQQ+MFLH/l16gPW3r4jEooA+pWl2IJ8WutC8Qc05087m8gccu2f4obQjjetVQJSSNfqEdHa9Z8oq8P1F6H+y0YQuvz3XyF9ZW9tvJEwTsTB3PQObZEYfCarecA1aqMOwziv3UrtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423523; c=relaxed/simple;
	bh=8sDIGMjLbkxeHWcWoks7mUrwSd6zwmPFKkIzH83S/1s=;
	h=Date:To:From:Subject:Message-Id; b=QA1q/h6adiOOiuDEaBkA4Qy7WIORhn8WrBH9OS2ET+WRaWu5vwA4m9+9ljuzJSPahnRAyl2j9JnQqAZpBhkjF1T9zV/u9keG/JWbsdA2obXeNVa3Q8fkZjr61SjgygjBoIJhnT4tDrVHQNHpEnrWd9QJoR7j9u/OSKHrv5Hz7Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wavONI54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wavONI54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78CEC4CEC2;
	Wed,  4 Sep 2024 04:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423523;
	bh=8sDIGMjLbkxeHWcWoks7mUrwSd6zwmPFKkIzH83S/1s=;
	h=Date:To:From:Subject:From;
	b=wavONI54L4/HLa8TeDAaTEhhQb9gLiNtbRRv/QptZYS3ycQ9fw8KrdaT7m5dBfA8x
	 0A9TgNgCs6qGfr3gJIrZLdsLYqkU41B3exw071SlXOIYwC3DgCmjnsetH0LbMrkIBg
	 E6T0jvDPlKCfMHPNv60Sk4XdtQfc3MeSOcral3Yo=
Date: Tue, 03 Sep 2024 21:18:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pageactive.patch removed from -mm tree
Message-Id: <20240904041843.B78CEC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PageActive
has been removed from the -mm tree.  Its filename was
     mm-remove-pageactive.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove PageActive
Date: Wed, 21 Aug 2024 20:34:34 +0100

Patch series "Simplify the page flags a little".

In the course of our folio conversions, we have made many page flags only
used on folios, so we can now remove the page-based accessors.  This
should cut down compile time a little, and prevent new users from cropping
up.

There is more that could be done in this area, but it would produce merge
conflicts, so I'll sit on those patches until next merge window.  We now
have line of sight to removing PG_private_2 and PG_private.


This patch (of 10):

This flag is now only used on folios, so we can remove all the page
accessors.

[akpm@linux-foundation.org: fix arch/powerpc/mm/pgtable-frag.c]
Link: https://lkml.kernel.org/r/20240821193445.2294269-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240821193445.2294269-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/pgtable-frag.c |    6 +++---
 include/linux/page-flags.h     |    5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/arch/powerpc/mm/pgtable-frag.c~mm-remove-pageactive
+++ a/arch/powerpc/mm/pgtable-frag.c
@@ -136,10 +136,10 @@ void pte_fragment_free(unsigned long *ta
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 void pte_free_defer(struct mm_struct *mm, pgtable_t pgtable)
 {
-	struct page *page;
+	struct folio *folio;
 
-	page = virt_to_page(pgtable);
-	SetPageActive(page);
+	folio = virt_to_folio(pgtable);
+	folio_set_active(folio);
 	pte_fragment_free((unsigned long *)pgtable, 0);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
--- a/include/linux/page-flags.h~mm-remove-pageactive
+++ a/include/linux/page-flags.h
@@ -510,8 +510,9 @@ PAGEFLAG(Dirty, dirty, PF_HEAD) TESTSCFL
 	__CLEARPAGEFLAG(Dirty, dirty, PF_HEAD)
 PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru, PF_HEAD)
 	TESTCLEARFLAG(LRU, lru, PF_HEAD)
-PAGEFLAG(Active, active, PF_HEAD) __CLEARPAGEFLAG(Active, active, PF_HEAD)
-	TESTCLEARFLAG(Active, active, PF_HEAD)
+FOLIO_FLAG(active, FOLIO_HEAD_PAGE)
+	__FOLIO_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
+	FOLIO_TEST_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
 PAGEFLAG(Workingset, workingset, PF_HEAD)
 	TESTCLEARFLAG(Workingset, workingset, PF_HEAD)
 PAGEFLAG(Checked, checked, PF_NO_COMPOUND)	   /* Used by some filesystems */
_

Patches currently in -mm which might be from willy@infradead.org are

swap-convert-swapon-to-use-a-folio.patch

