Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C672F1D1300
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 20:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272438; cv=none; b=Kzgotv1lEiAAmhEDBZVH499hASByI2IBieoUvBm5rOHiTqjLHgQC5eLEOUUksqSncynGpRaTYsuMS4l0OmL+pfU7AgrUiBlyReZ8QMJVUSdLELC9ikiZHszv37midVOEf6EBCDPuhw7UDegRBn3taOjIFcPxKaJYUlXMTUBt+GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272438; c=relaxed/simple;
	bh=DNL//bDhZAqlDg8CGxNYmmX/BeNzjOI8c7C2w/ofXKc=;
	h=Date:To:From:Subject:Message-Id; b=aVk07ghx+o/i40fibhZh0Y30mXCIMZ1ialEN0hNTih4q7T0gArjGm/YCRSoBEYcDGCdZR94xCKuhDbd/Wrghj5wba7YcCQAwn9ftieCD8BzSOE9WmGfiHKCtksujszVtC0HHj3V1nZ9Emki6/3zSUXjmWNG/t2PGPx36LV7gTKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SUMZa7TB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SUMZa7TB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4014DC32781;
	Wed, 21 Aug 2024 20:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724272438;
	bh=DNL//bDhZAqlDg8CGxNYmmX/BeNzjOI8c7C2w/ofXKc=;
	h=Date:To:From:Subject:From;
	b=SUMZa7TBcGljqG/OS5qpuv+v0ZeghCUBPbmDIcMw+KWCp14cU+7C/spz+hXM39/UY
	 QmpWVRNVKLebQF71uIWHZaFLnVuzqf3vQniCF1YjNOWMsUiCy8pUCwFjP3PqmZeFzV
	 PbcZniwtoVo8ITr9uNRbNjMtNET/vQzwlw2jiUYE=
Date: Wed, 21 Aug 2024 13:33:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pageswapbacked.patch added to mm-unstable branch
Message-Id: <20240821203358.4014DC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PageSwapBacked
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-pageswapbacked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pageswapbacked.patch

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
Subject: mm: remove PageSwapBacked
Date: Wed, 21 Aug 2024 20:34:35 +0100

This flag is now only used on folios, so we can remove all the page
accessors.

Link: https://lkml.kernel.org/r/20240821193445.2294269-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pageswapbacked
+++ a/include/linux/page-flags.h
@@ -528,9 +528,9 @@ PAGEFLAG(XenRemapped, xen_remapped, PF_N
 PAGEFLAG(Reserved, reserved, PF_NO_COMPOUND)
 	__CLEARPAGEFLAG(Reserved, reserved, PF_NO_COMPOUND)
 	__SETPAGEFLAG(Reserved, reserved, PF_NO_COMPOUND)
-PAGEFLAG(SwapBacked, swapbacked, PF_NO_TAIL)
-	__CLEARPAGEFLAG(SwapBacked, swapbacked, PF_NO_TAIL)
-	__SETPAGEFLAG(SwapBacked, swapbacked, PF_NO_TAIL)
+FOLIO_FLAG(swapbacked, FOLIO_HEAD_PAGE)
+	__FOLIO_CLEAR_FLAG(swapbacked, FOLIO_HEAD_PAGE)
+	__FOLIO_SET_FLAG(swapbacked, FOLIO_HEAD_PAGE)
 
 /*
  * Private page markings that may be used by the filesystem that owns the page
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

