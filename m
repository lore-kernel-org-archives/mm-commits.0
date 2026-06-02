Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502633BADAA
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439061; cv=none; b=JoCkXD4Bhw2intXgt78mstDhlMZZs5oIF9gJw7vXTcswV6aJgvR4Y3f3jQu/AC+vUwj55LQTu93Q9kYlwothZmGxlztnnmPjT3uZP2Apft0KFZxyGyCHTmqXOtqVEEE2K+G023gbh2uX/KEo3GrDz2T7LUJTnVz8dn0djoOVal0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439061; c=relaxed/simple;
	bh=tWDgdRgxUgIEmkRyAYOlh6KntkYKBT4gyPqrRCaSjwU=;
	h=Date:To:From:Subject:Message-Id; b=Dc8MVDTCAxF0Be2gqjU4TKETFZJHZR0GuB9KCgANDKaeTttdbcPMOuTK9DmlpDFLIkZClyW3mQIgsmWF4jrUP5qCpEZTVesak9JZMCD86YdtJT/C+r0mITUd0A9MvI3kFnkHI79KNSSe8kCCObpt0p2TUJM6UJtcu+2lTp40gAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iBkYwJhY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iBkYwJhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270D21F00898;
	Tue,  2 Jun 2026 22:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439060;
	bh=25NA6yI3lwVF7UXKnSgrBuvOvhFK09miUIfUj5vr2Pc=;
	h=Date:To:From:Subject;
	b=iBkYwJhY1uxwBOWcNV0SC3VEsm+J63xQhx6zNgGZewHDATVT2CV8x/NSqccH+mceV
	 3mAQvmvhiQtIQiqOXtFKkrIHPfP0upvC/h+LPtY7Sio5LZvOewAmUPSnuFH4i0ouCR
	 lbugQq66I/S7O6InIBa8y9KcRxkT2ZNEj7oXWvi8=
Date: Tue, 02 Jun 2026 15:24:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,mhocko@suse.com,hannes@cmpxchg.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-drop-a-misleading-__always_inline.patch removed from -mm tree
Message-Id: <20260602222420.270D21F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: drop a misleading __always_inline
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-drop-a-misleading-__always_inline.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: drop a misleading __always_inline
Date: Sun, 17 May 2026 23:37:05 +0000

get_pfnblock_migratetype() is called from outside page_alloc.c, so it
cannot always be inlined.  Remove the annotation to avoid misleading
readers.

At least in my minimal config, with GCC, this doesn't change
mm/page_alloc.o at all.

Link: https://lore.kernel.org/all/20260517-b4-drop-always-inline-v1-1-97b90930e8b8@google.com/
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Suggested-by: Vlastimil Babka <vbabka@kernel.org>
Link: https://lore.kernel.org/all/016c8bef-57ef-44ef-bf60-86dbfd368dcd@kernel.org/
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Vishal Moola <vishal.moola@gmail.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-drop-a-misleading-__always_inline
+++ a/mm/page_alloc.c
@@ -434,7 +434,7 @@ bool get_pfnblock_bit(const struct page
  * Use get_pfnblock_migratetype() if caller already has both @page and @pfn
  * to save a call to page_to_pfn().
  */
-__always_inline enum migratetype
+enum migratetype
 get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
 {
 	unsigned long mask = PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK;
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-delete-stale-comment-about-cachelines.patch

