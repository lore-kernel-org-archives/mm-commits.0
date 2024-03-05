Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225F911C94
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600571; cv=none; b=NAB8adG63CFnaocKq0xCzstkz8FV3lhNNAsAcPr2QCcmfMJJSJ0CEveDcmjXozHZ7pdm1yj5haVQuAPw5cDrMMm6RrBqo6kzz8TKTKWStFTPRsS8Fc9oc9Q89wGGntH4rZfA1bBCoJNti2OTYoukbZhMvBXhPTQFOXwuCQNxmmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600571; c=relaxed/simple;
	bh=wejam5ddzWlqKvZXwfCuA7bJmL26Y8EOBtzHZoWXtqQ=;
	h=Date:To:From:Subject:Message-Id; b=Anj8jjrvwi7QfxciD/B5aR+WgtjTa7oVXFBwkjugyEjN3OTv/+WVY+T5cELD57wCfFVptW31fbJLQc5LGlhxRdlfiAXkMGI5MhoCrnzJohedw4H41afkWPBMRmZejH8iSQSMhickBYnksaSLaxBBwT0mkQSZT1svGnt8JvaqLog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I28c0Nzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I28c0Nzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAB8C433C7;
	Tue,  5 Mar 2024 01:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600571;
	bh=wejam5ddzWlqKvZXwfCuA7bJmL26Y8EOBtzHZoWXtqQ=;
	h=Date:To:From:Subject:From;
	b=I28c0NznPDheg7xuuNBQ5Vuht7LBwUxSQZsriRkw0tobdbSo1++8awulCA1cT+zcD
	 J44GN3btBKvFD7FQaXYIZ3p3e8bv5qN2eFqkLKmtcWr0sj5gpHI6VhwEQGJcMxrBGb
	 utJtXOVjPRP6agZufHdywn5dJ0H7BYc0QnS1HcI4=
Date: Mon, 04 Mar 2024 17:02:50 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch removed from -mm tree
Message-Id: <20240305010250.EAAB8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: allow non-hugetlb large folios to be batch processed
has been removed from the -mm tree.  Its filename was
     mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: allow non-hugetlb large folios to be batch processed
Date: Tue, 27 Feb 2024 17:42:44 +0000

Hugetlb folios still get special treatment, but normal large folios can
now be freed by free_unref_folios().  This should have a reasonable
performance impact, TBD.

Link: https://lkml.kernel.org/r/20240227174254.710559-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/swap.c~mm-allow-non-hugetlb-large-folios-to-be-batch-processed
+++ a/mm/swap.c
@@ -1003,12 +1003,13 @@ void folios_put_refs(struct folio_batch
 		if (!folio_ref_sub_and_test(folio, nr_refs))
 			continue;
 
-		if (folio_test_large(folio)) {
+		/* hugetlb has its own memcg */
+		if (folio_test_hugetlb(folio)) {
 			if (lruvec) {
 				unlock_page_lruvec_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
-			__folio_put_large(folio);
+			free_huge_folio(folio);
 			continue;
 		}
 
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

