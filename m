Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00571E884
	for <mm-commits@vger.kernel.org>; Tue, 12 Nov 2024 01:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374338; cv=none; b=FSBt4e/+Z7zsIicPS7yLzx8Y5+FgH2kQVY9/I972rQYsQKBYVc801kfMWnFI0CAAfRT2po3PvxcNF8d8q4RtmKTuFBM5Mh/ux9Uw0E0xu4vIgyaDpu/kuZDoZYTBndsDK5dLJIvmuSHFWOchYgKZrMwI9nE5zfPyG/r2DZ4nZWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374338; c=relaxed/simple;
	bh=SNWdrbmS5zPxrl0aeJQnidBlnhebeVDA5zYAJT5302c=;
	h=Date:To:From:Subject:Message-Id; b=XGQJ5YPr3AeKi4xkhsoKo1GeJCpcXiT8q2+E/sz+OhGhx0FB0Luq7rX/AxVxLiw5IsVUFS20PiflT5Dw7WRWZ7vkqJS43hbvffS80NJlNTSX8yRLYUPICYy0lIzAvaxYSfVWEAC6RWpmvh3rWbt9I/XpG5urlkj1nPprvNixCR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fs0smoUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fs0smoUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36FAC4CECF;
	Tue, 12 Nov 2024 01:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731374337;
	bh=SNWdrbmS5zPxrl0aeJQnidBlnhebeVDA5zYAJT5302c=;
	h=Date:To:From:Subject:From;
	b=Fs0smoUt662DpblzMdLSfcgYavKQUCPOCOcBxJHFa9JnhZAjM8fHrEEFdcNz2Uw1R
	 NSJbq2x3a/pnFaLfY3wKMxQAwJJ2PKMcZbeco7rjx5Qi9NnoG5ta8PcLZKDi2lVjZu
	 OcZiQKHuahBw9IZPPbVzHEvKvz6a+ka5wLo0kdfc=
Date: Mon, 11 Nov 2024 17:18:57 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,peterx@redhat.com,osalvador@suse.de,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,airlied@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix.patch removed from -mm tree
Message-Id: <20241112011857.C36FAC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix
has been removed from the -mm tree.  Its filename was
     mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix.patch

This patch was dropped because it was folded into mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases.patch

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix
Date: Tue, 5 Nov 2024 13:31:01 -0800

whitespace tweak, per David

Link: https://lkml.kernel.org/r/131cf9c8-ebc0-4cbb-b722-22fa8527bf3c@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>
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

 mm/gup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix
+++ a/mm/gup.c
@@ -2435,8 +2435,8 @@ check_and_migrate_movable_pages_or_folio
 	LIST_HEAD(movable_folio_list);
 	unsigned long collected;
 
-	collected =
-		collect_longterm_unpinnable_folios(&movable_folio_list, pofs);
+	collected = collect_longterm_unpinnable_folios(&movable_folio_list,
+						       pofs);
 	if (!collected)
 		return 0;
 
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases.patch
mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix-2.patch

