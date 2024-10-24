Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19922175D53
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 06:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750544; cv=none; b=J2sdB42sYPPInjUethUiYHi8aXGlDxDkbUZVfnpjy/Mb3wTPZV0i0N59x3MQuXuCcnnkBvrsv7+zHzT8Z8bw4fT/yNsUjGZG7BUDP7BvbZFaoxEurECtvKYHBrOwFvQftxqbcEjqOnW7Gp2nA4FqZrluNMDfrPQIxHJKua9ePmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750544; c=relaxed/simple;
	bh=zPKTJRZ3xmtW6wdkiHEXFHpy1G5BIWs9z+rkXhbYk+g=;
	h=Date:To:From:Subject:Message-Id; b=GS3pA1bwW83vPIrLcatjUd66LZeZqPrivE3Tfy40FBeMVUHc7hRe1VwgfcOv1/FcrpvGPPMWrSXbSMV6bJwUheISimH1WYltpjGslcM+xruuKt65BZGzds+p8ArXDLdlISC82rAi0/Ul4IxAlHsVQLE/DGKY1qkbCTNWhkL4EbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fL4YoN18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fL4YoN18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D9DC4CEC7;
	Thu, 24 Oct 2024 06:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750544;
	bh=zPKTJRZ3xmtW6wdkiHEXFHpy1G5BIWs9z+rkXhbYk+g=;
	h=Date:To:From:Subject:From;
	b=fL4YoN18jh40TRhBVaLrsKO5tAIybfOq4c37FK2261luM7p8urdr0lSGIUvbV+ilE
	 hx6moidVMvBHAi29jJCZrp6JhFrho6DM8yF7IMsd30iDFX5jr+PR1WKYwLYjongmQK
	 FFyh75xABZq6IAOvzEwy0K7cfvbMcRQ823LTnVPg=
Date: Wed, 23 Oct 2024 23:15:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,syoshida@redhat.com,peterx@redhat.com,pasha.tatashin@soleen.com,osalvador@suse.de,minchan@kernel.org,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,apopple@nvidia.com,airlied@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-gup-memfd-stop-leaking-pinned-pages-in-low-memory-conditions.patch removed from -mm tree
Message-Id: <20241024061543.E2D9DC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: memfd: stop leaking pinned pages in low memory conditions
has been removed from the -mm tree.  Its filename was
     mm-gup-memfd-stop-leaking-pinned-pages-in-low-memory-conditions.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: memfd: stop leaking pinned pages in low memory conditions
Date: Thu, 17 Oct 2024 18:17:11 -0700

If check_and_migrate_movable_pages() fails, typically with -ENOMEM, then
memfd_pin_folios() will leave pages pinned. Those are leaked forever,
and are visible to user space as a memory leak.

Fix this by unpinning the folios that try_grab_folio(FOLL_PIN) has
pinned, in such error cases.

Link: https://lkml.kernel.org/r/20241018011711.183642-3-jhubbard@nvidia.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/gup.c~mm-gup-memfd-stop-leaking-pinned-pages-in-low-memory-conditions
+++ a/mm/gup.c
@@ -3724,12 +3724,10 @@ long memfd_pin_folios(struct file *memfd
 		ret = check_and_migrate_movable_folios(nr_folios, folios);
 	} while (ret == -EAGAIN);
 
-	memalloc_pin_restore(flags);
-	return ret ? ret : nr_folios;
 err:
 	memalloc_pin_restore(flags);
-	unpin_folios(folios, nr_folios);
-
-	return ret;
+	if (ret)
+		unpin_folios(folios, nr_folios);
+	return ret ? ret : nr_folios;
 }
 EXPORT_SYMBOL_GPL(memfd_pin_folios);
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end.patch

