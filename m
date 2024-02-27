Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9088350277
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059683; cv=none; b=FFsZLcUMvNQLE/+NN5I6Bz6JkDVtUNEZ87qGeq/qeCu+KYzhihNGbatvgqLbzftZttxhGxoZjFCKJynmuPF6bxctx2aiG/01S316acEJhVQ7JnB2Y3LcuGNkUModJ9aA7IOa09KadQpfeLuw6IfbSXyIKWTXnE9cmowxpN3f6H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059683; c=relaxed/simple;
	bh=HduTtOwxHhHpixXSXrthhLeBtJOrEfpn83Yz7l3n4ZA=;
	h=Date:To:From:Subject:Message-Id; b=HkYKS8OHU890qWhKEf0knGxzDAI07xB0kB4/abR7e7dwCfCZXIj36EbIgx7s3gFCy9vz76XHsWWQNd8xO6BmZDVm3YtYA5Wso/Ea6wgFzKx+zj2RFO046gcbKfNRUZcYToygPn+ZRaKUA0EBmn3xO07ZTRGkAPz9nPwTrNNbk6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F3jLMWnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F3jLMWnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CEEC43399;
	Tue, 27 Feb 2024 18:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709059683;
	bh=HduTtOwxHhHpixXSXrthhLeBtJOrEfpn83Yz7l3n4ZA=;
	h=Date:To:From:Subject:From;
	b=F3jLMWnrh0jIEM3LcNZ2PINok2Wolt/vimYr6sAoC3b5LNjEaYuVKUc8SixYY0uWC
	 Duqa5M2k0hW5x0onYzLQYfV0V03pHFgn8lgZhGZIMxyXlDA2eVU930ua0yoK6md7xZ
	 XqNJaOePC2mJG42iFAm4ryX9GkS/1maBXxeD+hgM=
Date: Tue, 27 Feb 2024 10:48:02 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch added to mm-unstable branch
Message-Id: <20240227184803.52CEEC43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: allow non-hugetlb large folios to be batch processed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch

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

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch

