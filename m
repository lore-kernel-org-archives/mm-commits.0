Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABAE39ADB
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 20:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716582572; cv=none; b=Q64Lya76Z9Kn+qZT1WAAxf7AAXp4zDp1PbB9uVRsCh2jRf30GPkXo6lR8/8DYiPdVSsgivq6Bq0P+oQtVnd+FceLZ7o6pqRlpqZ0p0luPt7FuPCiYcRu8vGluZNRTfgjMhoRs1BdjL4lMljxbCFh60ReuGMxGZJjrGrciX9aBYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716582572; c=relaxed/simple;
	bh=msIxGfcvq5qx4ig5a9S1mYVBhOTTc8FO6d+ug9uwxbk=;
	h=Date:To:From:Subject:Message-Id; b=LGz/HxZgsn0HcWNHN6gl8VOOHQoaNfpkKldgrDPo6DwSVekjqRf9VeCDnX8+cJy62hAMB2/KWpzdEdD4j1ovcyhbz+sITWxsy/xRVG6i81sSmKy2ryZ53FA67MxemZjVRX7GyFGH7HDMBxfbD8ujKMP9XPyJZggIjzJFmQOPvR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GS7fsELk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GS7fsELk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34ECBC2BBFC;
	Fri, 24 May 2024 20:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716582572;
	bh=msIxGfcvq5qx4ig5a9S1mYVBhOTTc8FO6d+ug9uwxbk=;
	h=Date:To:From:Subject:From;
	b=GS7fsELkuzNVcQCAbe0/Ik3z7S9z6yaSMfJ7cq50DJHAn8/T372u9ghferZUJfI8V
	 XxRNAPlSpzSXX6V3gNJvNNiH51z7geePv2ryq75RuAUCNZpqPUxOB+o32YMtBXsia2
	 iSDDtUEu9jiisXrGxUNhaNQvPgwy7qY9919ovNCg=
Date: Fri, 24 May 2024 13:29:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-use-kmap_local_folio-in-zswap_load.patch added to mm-unstable branch
Message-Id: <20240524202932.34ECBC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm :zswap: use kmap_local_folio() in zswap_load()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-use-kmap_local_folio-in-zswap_load.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-use-kmap_local_folio-in-zswap_load.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm :zswap: use kmap_local_folio() in zswap_load()
Date: Fri, 24 May 2024 03:38:17 +0000

Eliminate the last explicit 'struct page' reference in mm/zswap.c.

Link: https://lkml.kernel.org/r/20240524033819.1953587-3-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-use-kmap_local_folio-in-zswap_load
+++ a/mm/zswap.c
@@ -1551,7 +1551,6 @@ bool zswap_load(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
 	pgoff_t offset = swp_offset(swp);
-	struct page *page = &folio->page;
 	bool swapcache = folio_test_swapcache(folio);
 	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
@@ -1582,7 +1581,7 @@ bool zswap_load(struct folio *folio)
 	if (entry->length)
 		zswap_decompress(entry, folio);
 	else {
-		dst = kmap_local_page(page);
+		dst = kmap_local_folio(folio, 0);
 		zswap_fill_page(dst, entry->value);
 		kunmap_local(dst);
 	}
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-use-sg_set_folio-in-zswap_compress-decompress.patch
mm-zswap-use-kmap_local_folio-in-zswap_load.patch
mm-zswap-make-same_filled-functions-folio-friendly.patch

