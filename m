Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524EF1E884
	for <mm-commits@vger.kernel.org>; Tue, 12 Nov 2024 01:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374339; cv=none; b=edcyzKsLZ+i5Wgg1pDtvx71+ha9YkWiXkMmaEfsmCw1D0POXbTiHuRnGID+MVg1eszNpqIE7Yrw83gGJVi8VxGWw1VGs296c576D182qCgNhY1gFb4GWKQhhQBY/Pt6/2h/2Uk+FT/3QxXpuzFOqVPgg/ZVhEcqlPSblNorsID4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374339; c=relaxed/simple;
	bh=LrHqHwwT8uTvkhRaD8ZnHg+JiENcX7eMstApVMt9HaU=;
	h=Date:To:From:Subject:Message-Id; b=ck2bLyYgLJDmnCmfKtBezSvgaq/JB6wN8t1yaIF/KpHGIhVfYVIbNOcrsPz0RuiBfoSll8b5GuMKvuVFP6cS8pMW/u+ZReAqfH2Hi/ZHC8/vYGh6JF82l9tXjmBk1WPoHCexFG7o5FmkvHrCaUVpJfZOOWX5gYfzOdxEvFTOiqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WRYrZqEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WRYrZqEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B7EC4CECF;
	Tue, 12 Nov 2024 01:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731374339;
	bh=LrHqHwwT8uTvkhRaD8ZnHg+JiENcX7eMstApVMt9HaU=;
	h=Date:To:From:Subject:From;
	b=WRYrZqEd29NjIKsmW2DkxV4H34r5HEgFT/0nCuUK8N+YDT1ISBAcHLyd7CoFPgCnK
	 JFqF8IKOU15+rrqnkzLm+uKCWYrxG5v0KB4WdMsbY+ozNZXdpMv2E8Fnb7kqAk8NaP
	 dOOkLy8UtfC5pvrRuUCdaJ2k+XCqOEesymy5KmuI=
Date: Mon, 11 Nov 2024 17:18:58 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,peterx@redhat.com,osalvador@suse.de,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,airlied@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix-2.patch removed from -mm tree
Message-Id: <20241112011859.24B7EC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix-2
has been removed from the -mm tree.  Its filename was
     mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix-2.patch

This patch was dropped because it was folded into mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases.patch

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix-2
Date: Wed, 6 Nov 2024 20:20:05 -0800

bypass pofs_get_folio(), per Oscar

Link: https://lkml.kernel.org/r/c1587c7f-9155-45be-bd62-1e36c0dd6923@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix-2
+++ a/mm/gup.c
@@ -2399,7 +2399,7 @@ migrate_longterm_unpinnable_folios(struc
 		 * calling folio_isolate_lru() which takes a reference so the
 		 * folio won't be freed if it's migrating.
 		 */
-		unpin_folio(pofs_get_folio(pofs, i));
+		unpin_folio(folio);
 		pofs_clear_entry(pofs, i);
 	}
 
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases.patch

