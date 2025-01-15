Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0089135944
	for <mm-commits@vger.kernel.org>; Wed, 15 Jan 2025 22:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736980150; cv=none; b=aJE1gYk5Sp4Z/jIsJ3gE476Gj11snGXLDCb0bmjBRbGa+KtpzxFVYsXWi3yTIRhjWlgJ57X0uUnxmDFGJdAUZDHYGUGptkCf4eWi9UjrxX7AU3Hv4Tvi/CnmCGo3DAXC15NGOmL7DI9a2um8rt0MXYAqssj4UE4Gn+XWYnSi+70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736980150; c=relaxed/simple;
	bh=1Jx/L4KLgDndq5u/U/aN8uN7vvkQPkoO0p9DfwAZk7Q=;
	h=Date:To:From:Subject:Message-Id; b=pHCT3MpZ/IxmcFSdNU0LOO3JDn8AaFGltRK71pkpGZNkrYVW23thWoKuL0slxEURHRZAFD7t7MeOKB+FOZbADvlaD7NdC1Gs3GHGFGH1MQ/m9R+6XlXP4uqWihX1ROg7yzQKNUYplYyh3TL6vSocs6eClvmAxb3ib7vphspgv0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cikFSqFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cikFSqFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65365C4CED1;
	Wed, 15 Jan 2025 22:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736980149;
	bh=1Jx/L4KLgDndq5u/U/aN8uN7vvkQPkoO0p9DfwAZk7Q=;
	h=Date:To:From:Subject:From;
	b=cikFSqFIyKKerz6JRuM8WmbCHbwzA+qRKmE2UMPFWRHvUzCVNCl8Waj9H2eYk7Mmh
	 b6iPzHEDExHrQp5HZaNaWQNyCDQphVHSfTPMCQBMFRM6hWIwRaz6DYY2DJHwTtRkTj
	 tTYqzEu+wy/QXEGCkKoAMpCweRZVcMPvPnCHRsUU=
Date: Wed, 15 Jan 2025 14:29:08 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-convert-reset_page-to-reset_zpdesc-fix.patch added to mm-unstable branch
Message-Id: <20250115222909.65365C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: reset zpdesc fields in reset_zpdesc()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-convert-reset_page-to-reset_zpdesc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-convert-reset_page-to-reset_zpdesc-fix.patch

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
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/zsmalloc: reset zpdesc fields in reset_zpdesc()
Date: Tue, 14 Jan 2025 00:29:52 +0900

To prepare for the future removal of struct page fields (e.g.  the removal
of page->index [1]), update reset_zpdesc() to reset the descriptor via
struct zpdesc instead of struct page.

As struct zpdesc overlays struct page for now, no functional change is
intended.

[1] https://lore.kernel.org/linux-mm/Z09hOy-UY9KC8WMb@casper.infradead.org

Link: https://lkml.kernel.org/r/Z4Uw136VdG7vlKCL@localhost.localdomain
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-convert-reset_page-to-reset_zpdesc-fix
+++ a/mm/zsmalloc.c
@@ -849,8 +849,8 @@ static void reset_zpdesc(struct zpdesc *
 
 	__ClearPageMovable(page);
 	ClearPagePrivate(page);
-	set_page_private(page, 0);
-	page->index = 0;
+	zpdesc->zspage = NULL;
+	zpdesc->next = NULL;
 	__ClearPageZsmalloc(page);
 }
 
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mm-zsmalloc-convert-__zs_map_object-__zs_unmap_object-to-use-zpdesc.patch
mm-zsmalloc-add-and-use-pfn-zpdesc-seeking-funcs.patch
mm-zsmalloc-convert-obj_malloc-to-use-zpdesc.patch
mm-zsmalloc-convert-obj_allocated-and-related-helpers-to-use-zpdesc.patch
mm-zsmalloc-convert-init_zspage-to-use-zpdesc.patch
mm-zsmalloc-convert-obj_to_page-and-zs_free-to-use-zpdesc.patch
mm-zsmalloc-add-two-helpers-for-zs_page_migrate-and-make-it-use-zpdesc.patch
mm-zsmalloc-convert-reset_page-to-reset_zpdesc-fix.patch
mm-zsmalloc-convert-__free_zspage-to-use-zpdesc.patch
mm-zsmalloc-convert-location_to_obj-to-take-zpdesc.patch
mm-zsmalloc-convert-migrate_zspage-to-use-zpdesc.patch
mm-zsmalloc-convert-get_zspage-to-take-zpdesc.patch

