Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05007494
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628198; cv=none; b=PTKqh218BKZjd01NrnIWuhsDVT/RvM9ZSIX/C19jmp0+gEjV5ApW93zqkiLUrzNF83PRmzPcztG32GLxQIfD7/V0oDfKhAhlHMEygweI10XIYnQU/bKR0QjG5etPb2b6xdr5ozDvDB3HU1ljat5BvY/EF3kYhBtitYCfY4S4unM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628198; c=relaxed/simple;
	bh=y4xGL5m1pdc/gNz3pwI9LPzlEOCg0Xzh9syIOp7QX2E=;
	h=Date:To:From:Subject:Message-Id; b=byYxcZO8XY3ZKHYuKSlICxzKiYj9ue17++uW9UmG1Q/IyzISlhY2Ra6b5SETpEEMax6hwfjlj41Fr3C/WK01qXtlTr8gjdb86sfD9PewG4PivLBaW1ySGMsA1etPMykkGBYTOpcenxn5hUAYlFetIuahYrQJhx4utWjlyBhJIIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nheXcafN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nheXcafN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77822C32781;
	Sat, 29 Jun 2024 02:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628198;
	bh=y4xGL5m1pdc/gNz3pwI9LPzlEOCg0Xzh9syIOp7QX2E=;
	h=Date:To:From:Subject:From;
	b=nheXcafNPEK/SB9YYu2uETjlraRmShCpWAeaAUSckn9BByUKyGms0VUuAQb9gowys
	 fEGEOqSycde5K3Iw//P5l4Mxeza195LS4+etEkI8BST+GCqlnfNlgqYCFpd3DPtLHq
	 Zowp4XF+IRdkmJAbaJfnuoGv7PDVSF+MfEXAdOpE=
Date: Fri, 28 Jun 2024 19:29:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,senozhatsky@chromium.org,rppt@kernel.org,minchan@kernel.org,42.hyeyoo@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-reinitialize-folio-_mapcount-directly.patch removed from -mm tree
Message-Id: <20240629022958.77822C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: reinitialize folio->_mapcount directly
has been removed from the -mm tree.  Its filename was
     mm-filemap-reinitialize-folio-_mapcount-directly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/filemap: reinitialize folio->_mapcount directly
Date: Wed, 29 May 2024 13:19:03 +0200

Let's get rid of the page_mapcount_reset() call and simply reinitialize
folio->_mapcount directly.

Link: https://lkml.kernel.org/r/20240529111904.2069608-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>	[zram/zsmalloc workloads]
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-reinitialize-folio-_mapcount-directly
+++ a/mm/filemap.c
@@ -177,7 +177,7 @@ static void filemap_unaccount_folio(stru
 				 * and we'd rather not leak it: if we're wrong,
 				 * another bad page check should catch it later.
 				 */
-				page_mapcount_reset(&folio->page);
+				atomic_set(&folio->_mapcount, -1);
 				folio_ref_sub(folio, mapcount);
 			}
 		}
_

Patches currently in -mm which might be from david@redhat.com are


