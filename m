Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730CF16FF4E
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 20:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272440; cv=none; b=pwCWzKIoP78KTgEG5WbFEI86gyeopoEaenGMb2Yx+5DoFpre9iWbR42uJFBG4vfqgISkpPOagw+TVzroy58hK7yL6sUC2rAIHywSrCcg5yfgwjg5VpFueI0e0L72HZkGkETfjv051FxGao3cFtCJe8YpILC+1uHVBhtfkU34nC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272440; c=relaxed/simple;
	bh=zAQW++saH4HIbXko/AAwSdXgCnmZSWAgtqDb+fYGxhE=;
	h=Date:To:From:Subject:Message-Id; b=ozrhu7FSqP36cHOQd2Sh3Kc88Wqh/tvc2IqbQctmCpPKKTBv5CyJeg/KeqMX9Iua8HXrqwRUDjG4fkVJX2Ud6qVgx/cw7A3d6KvNGeTCcLfAA1LbXHsE9dnn6Ql742t35XyhK93D34ixXZYPEuhfxhcF970Ed4IpHtZiqCRR+oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WvaafMMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WvaafMMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5CAC4AF0E;
	Wed, 21 Aug 2024 20:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724272440;
	bh=zAQW++saH4HIbXko/AAwSdXgCnmZSWAgtqDb+fYGxhE=;
	h=Date:To:From:Subject:From;
	b=WvaafMMH4Fz0WUbifeJkk3H5sc+ut/dPIGADahYtBu2KTyY0nLcSCr4G98DCjo5W4
	 jUcoqXPKFodW9GtxiIfZxK2qfXQpMB6UayeeL2sbfjhx9ULVCW+cVaGWfD/NyIuLRr
	 cpi0esgL3cVNEgWmRRm5IfLTAukZ2UC90KjSvsXo=
Date: Wed, 21 Aug 2024 13:33:59 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pagereadahead.patch added to mm-unstable branch
Message-Id: <20240821203359.DB5CAC4AF0E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PageReadahead
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-pagereadahead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pagereadahead.patch

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
Subject: mm: remove PageReadahead
Date: Wed, 21 Aug 2024 20:34:36 +0100

This flag is now only used on folios, so we can remove all the page
accessors.

Link: https://lkml.kernel.org/r/20240821193445.2294269-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pagereadahead
+++ a/include/linux/page-flags.h
@@ -553,8 +553,8 @@ PAGEFLAG(MappedToDisk, mappedtodisk, PF_
 /* PG_readahead is only used for reads; PG_reclaim is only for writes */
 PAGEFLAG(Reclaim, reclaim, PF_NO_TAIL)
 	TESTCLEARFLAG(Reclaim, reclaim, PF_NO_TAIL)
-PAGEFLAG(Readahead, readahead, PF_NO_COMPOUND)
-	TESTCLEARFLAG(Readahead, readahead, PF_NO_COMPOUND)
+FOLIO_FLAG(readahead, FOLIO_HEAD_PAGE)
+	FOLIO_TEST_CLEAR_FLAG(readahead, FOLIO_HEAD_PAGE)
 
 #ifdef CONFIG_HIGHMEM
 /*
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

