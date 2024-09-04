Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC556AFAE
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423531; cv=none; b=tBM4XPGj0lurFidiDfhkT2mQOJwPR2YTilj5DUSogUQej2WGqAP3jodpu75cobeC6brtx1+fxN1l3tYaBc7uZUGeCYGoBvMQuJuuwpHkQuKc4Wanb7arPxmYOpxOWAQsU4OyFB29qrY9dtK3FPD+ds8t8KscU4E+HzKOoQJCad8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423531; c=relaxed/simple;
	bh=FGRU4STByci8NM1tOXPUX478hBpi7MKg/a7897Y360A=;
	h=Date:To:From:Subject:Message-Id; b=ZPctDb26xx4XJqlkJ2Qx/SstGox6BeDtPEirFMzGCObCEUrFwbiAD92deNgzCjoYrcItFa9+H3oWLM22g1DaRyNLmGoKT6e0OJtMzzXY6q4THLwAFFW8TLAfnkABcdggzsbNho+DJYPCiykLRAd5l93AA7dgMQxopntbMMwZyIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EL06FzY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EL06FzY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C79C4CEC2;
	Wed,  4 Sep 2024 04:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423531;
	bh=FGRU4STByci8NM1tOXPUX478hBpi7MKg/a7897Y360A=;
	h=Date:To:From:Subject:From;
	b=EL06FzY0Ue/yXLWckMrFjMpFXxDsnClRgU0QeUFmupRbcJHnxM+yG76qwyqZgRuzp
	 sv7Kmxg4wm4cd52knZOTN5GejOKImVt4OdPgBOqLhyy0SXwpI7tQz0Sl0zJ6usCNUx
	 kD1rm3Y5mVV7Oux2QjhM2Cyb+cdYLsqM4xyFflgs=
Date: Tue, 03 Sep 2024 21:18:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pagemlocked.patch removed from -mm tree
Message-Id: <20240904041851.76C79C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PageMlocked
has been removed from the -mm tree.  Its filename was
     mm-remove-pagemlocked.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove PageMlocked
Date: Wed, 21 Aug 2024 20:34:39 +0100

This flag is now only used on folios, so we can remove all the page
accessors.

Link: https://lkml.kernel.org/r/20240821193445.2294269-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/unevictable-lru.rst |    4 ++--
 include/linux/page-flags.h           |   13 ++++++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/Documentation/mm/unevictable-lru.rst~mm-remove-pagemlocked
+++ a/Documentation/mm/unevictable-lru.rst
@@ -253,8 +253,8 @@ Basic Management
 
 mlocked pages - pages mapped into a VM_LOCKED VMA - are a class of unevictable
 pages.  When such a page has been "noticed" by the memory management subsystem,
-the page is marked with the PG_mlocked flag.  This can be manipulated using the
-PageMlocked() functions.
+the folio is marked with the PG_mlocked flag.  This can be manipulated using
+folio_set_mlocked() and folio_clear_mlocked() functions.
 
 A PG_mlocked page will be placed on the unevictable list when it is added to
 the LRU.  Such pages can be "noticed" by memory management in several places:
--- a/include/linux/page-flags.h~mm-remove-pagemlocked
+++ a/include/linux/page-flags.h
@@ -585,12 +585,15 @@ FOLIO_FLAG(unevictable, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_CLEAR_FLAG(unevictable, FOLIO_HEAD_PAGE)
 
 #ifdef CONFIG_MMU
-PAGEFLAG(Mlocked, mlocked, PF_NO_TAIL)
-	__CLEARPAGEFLAG(Mlocked, mlocked, PF_NO_TAIL)
-	TESTSCFLAG(Mlocked, mlocked, PF_NO_TAIL)
+FOLIO_FLAG(mlocked, FOLIO_HEAD_PAGE)
+	__FOLIO_CLEAR_FLAG(mlocked, FOLIO_HEAD_PAGE)
+	FOLIO_TEST_CLEAR_FLAG(mlocked, FOLIO_HEAD_PAGE)
+	FOLIO_TEST_SET_FLAG(mlocked, FOLIO_HEAD_PAGE)
 #else
-PAGEFLAG_FALSE(Mlocked, mlocked) __CLEARPAGEFLAG_NOOP(Mlocked, mlocked)
-	TESTSCFLAG_FALSE(Mlocked, mlocked)
+FOLIO_FLAG_FALSE(mlocked)
+	__FOLIO_CLEAR_FLAG_NOOP(mlocked)
+	FOLIO_TEST_CLEAR_FLAG_FALSE(mlocked)
+	FOLIO_TEST_SET_FLAG_FALSE(mlocked)
 #endif
 
 #ifdef CONFIG_ARCH_USES_PG_UNCACHED
_

Patches currently in -mm which might be from willy@infradead.org are

swap-convert-swapon-to-use-a-folio.patch

