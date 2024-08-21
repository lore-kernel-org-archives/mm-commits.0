Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C62F1D1300
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 20:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272437; cv=none; b=BzFvRwmd7PB6JiQP+d5gmORBSJ/JdPFypleklBOAnve4tzUyqFwWyTSSE9+84vDHfXU+1bpz76DERvAIFxv3ha7k+8MT+VyiJKYPK1OEJdOE22f9EYkMBDZVafYsDts2J5PQyJA6kgCu0KBNNwGBv/185E2AacPmsExSqQI7Fms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272437; c=relaxed/simple;
	bh=f8d8yGO6A6w67UVoSp2rXVFA4Li4Zp5J4ns3bxXJlAE=;
	h=Date:To:From:Subject:Message-Id; b=Ch75kr0mGZMmv5Y80BM3gXMdfY6uCb6sFkk9/gleGy5QYcm+PUiTy1mrcTvpm3B7XGegEXFO2w6z02W3P5Yck4uWErDK3HQC26JgdX+sf027kPJdP+LtzoBHZQY7nAA2VJz1ltSSSNaEhJgnbptX0xXsFqPf5UdSCBEtycQQwcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TVWlhs2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TVWlhs2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C24C32781;
	Wed, 21 Aug 2024 20:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724272436;
	bh=f8d8yGO6A6w67UVoSp2rXVFA4Li4Zp5J4ns3bxXJlAE=;
	h=Date:To:From:Subject:From;
	b=TVWlhs2R4JXtkCd8C5PEH3AxnEysSuFzu0UW+jQjv4ka11asYdvyOmxnfBZnJ5DCe
	 BGULgNQ4vve7liABu/9RT6oILs0JrfSkUbI4JGC2KfSx7/QSrhHuHI6bBvPoqdaNuV
	 OLhFBnLt6ODGasSgqzWDzYjoobdMFoNjBWm15LtY=
Date: Wed, 21 Aug 2024 13:33:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pageactive.patch added to mm-unstable branch
Message-Id: <20240821203356.A9C24C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PageActive
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-pageactive.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pageactive.patch

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

Link: https://lkml.kernel.org/r/20240821193445.2294269-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240821193445.2294269-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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

fs-remove-calls-to-set-and-clear-the-folio-error-flag.patch
mm-remove-pg_error.patch
mm-return-the-folio-from-swapin_readahead.patch
printf-remove-%pgt-support.patch
mm-introduce-page_mapcount_is_type.patch
mm-support-only-one-page_type-per-page.patch
zsmalloc-use-all-available-24-bits-of-page_type.patch
mm-remove-pageactive.patch
mm-remove-pageswapbacked.patch
mm-remove-pagereadahead.patch
mm-remove-pageswapcache.patch
mm-remove-pageunevictable.patch
mm-remove-pagemlocked.patch
mm-remove-pageownerpriv1.patch
mm-remove-page_has_private.patch
mm-rename-pg_mappedtodisk-to-pg_owner_2.patch
x86-remove-pg_uncached.patch

