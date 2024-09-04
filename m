Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C48D74402
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423526; cv=none; b=PZXtRcaIhRFDdo3+qBoYg7aRzQXyMBFSZESXNEn+lZrxhuTjXmA/gROJjZxhOYriW6V4f3naiAX/HHq+TG7Msi5aSN9DbWbTcFXby84f/qv/82YIS17tpaiViHbMooTmZH6sUu5xGajWTw7W0Gu6gaCQHalD1NgVHb6cxJpVwgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423526; c=relaxed/simple;
	bh=+kSmluhgiTSERNZazZ8PIZ/DhifQsN/6xCzy4k3bIOQ=;
	h=Date:To:From:Subject:Message-Id; b=aUepg6KS7SChN5UIXHgGvj4cAupbdx4B26WPP5YsCLQ+SbFPQF0BHMXbAbi+8ffgG+yJx2ddDjnejI06sEUHxV0hkpqSjh/6Cn1NqOHugBohqoWeXNvdH2CAElo6xT28IAd2ZY8jJwEHWq1vd52mlVbdWcfwqlg6Z5bN7jzCl7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rDb+MH1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rDb+MH1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BC3C4CEC2;
	Wed,  4 Sep 2024 04:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423526;
	bh=+kSmluhgiTSERNZazZ8PIZ/DhifQsN/6xCzy4k3bIOQ=;
	h=Date:To:From:Subject:From;
	b=rDb+MH1UMGPLTokGZS3I7MZTxmOYUwkHyiPnlwSxNTjzYTInUD765M1fEBR1QOM+Z
	 pbNBuNJ7B64UEgLl+gOMwsoepwSrbNqnF+m90Uhr0QbBqvtiSegiYA40xTvlIsv1vu
	 UaseVFxS2ZXpph9iiXn5tV+HLlGf5M1FnunX38HI=
Date: Tue, 03 Sep 2024 21:18:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pageswapbacked.patch removed from -mm tree
Message-Id: <20240904041846.52BC3C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PageSwapBacked
has been removed from the -mm tree.  Its filename was
     mm-remove-pageswapbacked.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

swap-convert-swapon-to-use-a-folio.patch

