Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF58F16FF26
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 20:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272445; cv=none; b=MFfzbBSD7/I8L64zAEDoK81CT8iVmXRFqjAD1q7bmbkT3QIFPQEUsyfPb1bpQhTPLoA+dNOzgMpicnVdUerlogt4kNq3UoZh1ytvE/CgPdWrU21FEBCCq2MOEjjChtXHVRpR5NXWYJBdR7gyuXBjU1g6pXZI9vAOQApkgp1gmWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272445; c=relaxed/simple;
	bh=sGqqr3ewHxvxTUiaVKVxEJk5NBaFokEPB+Oq4l1KdY0=;
	h=Date:To:From:Subject:Message-Id; b=a7HP6sHjx5SVkmvEKLixGr+4bHMYsOXfLDGrI+EcMT7YEVA1/T6zs9ifxOBttRxZtdZcvmntaS4VH17IHWyT1uNIXEosL7NcRoT/dWsSnX/ovjtspwA4GIgwh6MIxnC10zkxJnA4Iy3QyLE8mEcku6069VRUkEFCK613JMkOVJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E+MRmE46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E+MRmE46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B14FC32782;
	Wed, 21 Aug 2024 20:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724272445;
	bh=sGqqr3ewHxvxTUiaVKVxEJk5NBaFokEPB+Oq4l1KdY0=;
	h=Date:To:From:Subject:From;
	b=E+MRmE46T3cD8uBeYcdit0x6tYuSrdd/X5ILi1rKwPUAgSe/DCgBef2TNWxOiQHv7
	 rUwXwtsMmGxTgYPL0FlsLAJnUTVVDGS6Y1a9/SyWsVHIi4qEEFhX7ZXzkCSYf3mArt
	 +oh7XkhQXCc8M2iGN7uOcHj8Fw/EmClWATpSxtFo=
Date: Wed, 21 Aug 2024 13:34:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pagemlocked.patch added to mm-unstable branch
Message-Id: <20240821203405.2B14FC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PageMlocked
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-pagemlocked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pagemlocked.patch

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

