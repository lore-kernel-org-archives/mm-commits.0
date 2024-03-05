Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CD9101CF
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600565; cv=none; b=t3E0Mjke0t0KsRT1fLTWjePPJuvWShV6/MvUiS1e7dFJ+/x6RtfGSX8nB/SMoEWdhrOqGyQEmLwJFAuCc8pXM3Ed/TnCVLd9sZAyPRtQ36xOvxTVi7wCsoFJrE2p7KHJJ6sY1fLQDyX4x+MerY8OQxQWpF1moI8ImSexqfL0DTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600565; c=relaxed/simple;
	bh=Zi2+IjnGbHjIIcRxTi9wB01Dv+/7LSJVDjfeHztOQZI=;
	h=Date:To:From:Subject:Message-Id; b=fVisWLuuCuanaEqA8dAoC0YFW84f1K3g56MdNNSXowlzvkH7mU0F3hCsB7Jah6mrz6dwSapFCjfIpc+g/pIMkqz/K3wyuhaqWRtJiOEmHNFP5EURhZDgEtwitd5AUTlZsjZw6oddza557U51/gYHmfuBCmnFTbF20XG8p5nN8zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wD6fDKzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wD6fDKzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC204C433F1;
	Tue,  5 Mar 2024 01:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600564;
	bh=Zi2+IjnGbHjIIcRxTi9wB01Dv+/7LSJVDjfeHztOQZI=;
	h=Date:To:From:Subject:From;
	b=wD6fDKzYLvqgaYjpyOwJOT+vrC20C+tGX78t/GkAaqvZm3uu2jRlqDB6V4htgni/i
	 SWx41YIgDoRbUc9WXo+fOgJ8Js7X7UB3to4JVr9hhjRzSLbEYhb0wY0JFwAbBSukWN
	 MzEcj6ieuGGk3GiDclHmjJvgfbvuco88tnQ3jxsM=
Date: Mon, 04 Mar 2024 17:02:44 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-folios_put-in-__folio_batch_release.patch removed from -mm tree
Message-Id: <20240305010244.DC204C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use folios_put() in __folio_batch_release()
has been removed from the -mm tree.  Its filename was
     mm-use-folios_put-in-__folio_batch_release.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use folios_put() in __folio_batch_release()
Date: Tue, 27 Feb 2024 17:42:38 +0000

There's no need to indirect through release_pages() and iterate over this
batch of folios an extra time; we can just use the batch that we have.

Link: https://lkml.kernel.org/r/20240227174254.710559-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/swap.c~mm-use-folios_put-in-__folio_batch_release
+++ a/mm/swap.c
@@ -1083,8 +1083,7 @@ void __folio_batch_release(struct folio_
 		lru_add_drain();
 		fbatch->percpu_pvec_drained = true;
 	}
-	release_pages(fbatch->folios, folio_batch_count(fbatch));
-	folio_batch_reinit(fbatch);
+	folios_put(fbatch);
 }
 EXPORT_SYMBOL(__folio_batch_release);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-add-__dump_folio-fix.patch
mm-add-__dump_folio-fix-2.patch
mm-add-__dump_folio-fix-3.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch

