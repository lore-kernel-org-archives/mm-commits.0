Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F2919DFAB
	for <mm-commits@vger.kernel.org>; Mon, 18 Aug 2025 01:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755481596; cv=none; b=qbUb/x6tx907ZW7JHFIHJ8NzVopBRUVZPs4EKH4cg1nVecYKMP4J1C2cuAsmwtSE5U93Pj+wX6H1kxCdpd8LyRuU/EnPHyaAJBd26IAumXJwtlTJQ9cuf23hKDTTxZDGWmUYufS7r4Eb00p+5Z+gtxX0Ob7gYH1/yq+bh6DWAOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755481596; c=relaxed/simple;
	bh=1QnCx+B4bTKG6C5uyq6g3qXYG1xGw7uwFHnP13dMuOw=;
	h=Date:To:From:Subject:Message-Id; b=LrPsTqTmZ6Bj3jNL6Xi/viNnS80dBrYQQMSy+frQYoN5maGASLK+YEAx/5ylKsRh9xHv+8LfzgqJaJ1X/pBA4Gt8lJ6XHy63+h9ASG057+TksVrY3dxhzGnbC0SbTEgrPnaBUcKtWJuIyEvdflxXO40tMAwjVdWpLNBgbbUniW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z0EgkWb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z0EgkWb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF3CC4CEEB;
	Mon, 18 Aug 2025 01:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755481596;
	bh=1QnCx+B4bTKG6C5uyq6g3qXYG1xGw7uwFHnP13dMuOw=;
	h=Date:To:From:Subject:From;
	b=z0EgkWb9FyS5Yd3mL52IUxQ6CQMsCKQRGXGUcsz8hZ/ENnh594VjjXtjPgFQQS7dq
	 PZTAeaajIk4hzWaCAJGTMau3E749/cXhyu7/FP/98Mvs8oheaFMSb+HUyObjY7kFim
	 2q9QCkHLYIzE9lsQTY0hLQ2PVMFecgH7vsBrn4+Q=
Date: Sun, 17 Aug 2025 18:46:35 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,riel@surriel.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,harry.yoo@oracle.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-use-folio_large_nr_pages-when-we-are-sure-it-is-a-large-folio.patch added to mm-new branch
Message-Id: <20250818014636.2FF3CC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: use folio_large_nr_pages() when we are sure it is a large folio
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-use-folio_large_nr_pages-when-we-are-sure-it-is-a-large-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-use-folio_large_nr_pages-when-we-are-sure-it-is-a-large-folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/rmap: use folio_large_nr_pages() when we are sure it is a large folio
Date: Sun, 17 Aug 2025 03:26:47 +0000

Non-large folio is handled at the beginning, so it is a large folio for
sure.

Use folio_large_nr_pages() here like elsewhere.

Link: https://lkml.kernel.org/r/20250817032647.29147-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-use-folio_large_nr_pages-when-we-are-sure-it-is-a-large-folio
+++ a/mm/rmap.c
@@ -1703,7 +1703,7 @@ static __always_inline void __folio_remo
 			nr = folio_sub_return_large_mapcount(folio, nr_pages, vma);
 			if (!nr) {
 				/* Now completely unmapped. */
-				nr = folio_nr_pages(folio);
+				nr = folio_large_nr_pages(folio);
 			} else {
 				partially_mapped = nr < folio_large_nr_pages(folio) &&
 						   !folio_entire_mapcount(folio);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch
selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch
mm-rmap-not-necessary-to-mask-off-folio_pages_mapped.patch
mm-rmap-use-folio_large_nr_pages-when-we-are-sure-it-is-a-large-folio.patch

