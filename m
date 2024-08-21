Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4463C16FF26
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 20:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272447; cv=none; b=Dp2sLWdqbBkqnzSV5c0QXA9LU0JKP0HdTdIeOZZgcT2F/x/Zz4Um4v3Gmo9/OLXnFscwT7m+gYfHkUaFAeweP9FMCarvyj6nb0pQvTRZ5rFWccxxKHPg8OK5jB467OcajDHEUVO8MjOYm13FipJ5//tQfMrTR1po3e6LsU0YAXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272447; c=relaxed/simple;
	bh=Gs0UmyiyRozXvpS/bm1sx88QEoducsH4bPEKTZl8X4Y=;
	h=Date:To:From:Subject:Message-Id; b=lto3VHlCYhWwiuuYuxT4bUjnrw5wXPWoO7LQ/0ZPotBWDmiyq5+bef15R2YWCVH1j8L89ff3rCSegCNyu3X0MZTpjWhyI7HcxJMKJU640VFX3ZHKi61WMw/kJ5kWQKOf15Ugox/MAcBnC60Y9INJCm8kW1CKegr9pkSnm3x0BtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GWcqSle7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GWcqSle7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4614C32781;
	Wed, 21 Aug 2024 20:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724272446;
	bh=Gs0UmyiyRozXvpS/bm1sx88QEoducsH4bPEKTZl8X4Y=;
	h=Date:To:From:Subject:From;
	b=GWcqSle7TdNyo1QQURQaswIqcvyFMTxpT633nD2PYIFPk0CWn08cJIbw43+VYmQVX
	 ZAAeFGmt1O7C+smnLJyUzeWcnZDJ3XLPfqVffHi9GhJhgZUGPwVH3SKkA7MLFl1nEN
	 N91geihwgaul7ONUGC3ZcNTVaZcH2x+A5N03UJAc=
Date: Wed, 21 Aug 2024 13:34:05 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pageownerpriv1.patch added to mm-unstable branch
Message-Id: <20240821203406.B4614C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PageOwnerPriv1
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-pageownerpriv1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pageownerpriv1.patch

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
Subject: mm: remove PageOwnerPriv1
Date: Wed, 21 Aug 2024 20:34:40 +0100

While there are many aliases for this flag, nobody actually uses the
*PageOwnerPriv1() nor folio_*_owner_priv_1() accessors.  Remove them.

Link: https://lkml.kernel.org/r/20240821193445.2294269-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pageownerpriv1
+++ a/include/linux/page-flags.h
@@ -539,8 +539,6 @@ FOLIO_FLAG(swapbacked, FOLIO_HEAD_PAGE)
  */
 PAGEFLAG(Private, private, PF_ANY)
 PAGEFLAG(Private2, private_2, PF_ANY) TESTSCFLAG(Private2, private_2, PF_ANY)
-PAGEFLAG(OwnerPriv1, owner_priv_1, PF_ANY)
-	TESTCLEARFLAG(OwnerPriv1, owner_priv_1, PF_ANY)
 
 /*
  * Only test-and-set exist for PG_writeback.  The unconditional operators are
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

