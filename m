Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2145235944
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737005771; cv=none; b=j4+QU7erVA6rWA1QFC2IHFvS/jA/xnhIvaGKr/Y7rGLRiQGqw/A2bl5EU5yXHiB7A8uUYrvjFSZi7StdX4RvidrXBE6fIGrMAWY5FrXtBomuFRrK8+wM8vBkWZuntkoJXDhKPEp95Gfrb13iHhZ8sa7ZQDvRvjHTWAfDWoKry68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737005771; c=relaxed/simple;
	bh=es85FfWTOBvzGIEu16gxi1pkBMejM/MZLqTl5YHOwUE=;
	h=Date:To:From:Subject:Message-Id; b=bZvy3dydJr4oaK9I46TSFkpSYrgeuYUZCVr3tG4SU3K5Ja5QeCYfk9ObjQCjNxYsUxbJiyKldnKva6FdP88DEreE7fPTDxE62lMOX1LgB2gqTiCGd8+uK026KQXJSP7hy2/sf1qGpQm4Hty63pFx8PHvBo2Ve7o7G+Mb7P0nSZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TiOwIIl5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TiOwIIl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB44C4CED6;
	Thu, 16 Jan 2025 05:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737005771;
	bh=es85FfWTOBvzGIEu16gxi1pkBMejM/MZLqTl5YHOwUE=;
	h=Date:To:From:Subject:From;
	b=TiOwIIl5Nm/rFW/fwDttob1B1zjBpElKD7+kSOPbv1h2T9u6kE76m3+1G0U1YG3a1
	 s6u3Mu8BGFMVr1dpf5jxWL1GvCDpgQsgCFsi6QE7MQQurn7EVJg6qUabF3kMi3AkLM
	 s9oZZL36gi68HT7tRXgAnQX8b9dk5dlLFKt4Io6w=
Date: Wed, 15 Jan 2025 21:36:10 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zsmalloc-convert-reset_page-to-reset_zpdesc-fix.patch removed from -mm tree
Message-Id: <20250116053610.DDB44C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: reset zpdesc fields in reset_zpdesc()
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-convert-reset_page-to-reset_zpdesc-fix.patch

This patch was dropped because it was folded into mm-zsmalloc-convert-reset_page-to-reset_zpdesc.patch

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
mm-zsmalloc-convert-reset_page-to-reset_zpdesc.patch
mm-zsmalloc-convert-__free_zspage-to-use-zpdesc.patch
mm-zsmalloc-convert-location_to_obj-to-take-zpdesc.patch
mm-zsmalloc-convert-migrate_zspage-to-use-zpdesc.patch
mm-zsmalloc-convert-get_zspage-to-take-zpdesc.patch

