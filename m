Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC9E2557E
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059673; cv=none; b=fXVeY7q9xjM/ZPWntxVTwD6aBahkRK8C+TyrgILoCy3HrZpXf4dPCC3vkCZN3abgQuFnltsMC+9+Qew7djNVwd9MMtkqZC384SZFIGdHb04cbdcTRJ0KfeNcKvQGLYvXKJrfFJIfiHr476X2EZQToH78i2GqQtNTaZ+ag2QEjpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059673; c=relaxed/simple;
	bh=OWZd1vLqSUG0LlCU+gczWwID+lHBkfXmS8NWiIZ2Avc=;
	h=Date:To:From:Subject:Message-Id; b=b8PTqUXExCGBeL+X6jYqtOe/fx5caySSCBkAUCDN1AAUg7/+9Xo5YyGIj0/+ZQv/jq/ANGkggPZvPzDeoR1ikKN/Gcs7ezPvUgpfRzQXl3ZTYMZc+iFwWjSzHF2FGINoOjSR7G8M2dNqv8k6hw3VkaYiERGZS1KHY2mv6cl3e7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h1q6uJMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h1q6uJMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E59FC433C7;
	Tue, 27 Feb 2024 18:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709059673;
	bh=OWZd1vLqSUG0LlCU+gczWwID+lHBkfXmS8NWiIZ2Avc=;
	h=Date:To:From:Subject:From;
	b=h1q6uJMaWfZZPJEV6pCozAviYpGlj0ucLmBfVNEVKc63nsDhByBMCOK3TZL14FQg1
	 4ttgEtkVvL6hfHARK3rjS9aujYxyWecv45RRduYMcOo9DeldaS0B0tXcRuDMIEzuSM
	 OakepAAtmvsVbcdM/2XkYlt/IVkyc4y2zEeVN5FY=
Date: Tue, 27 Feb 2024 10:47:52 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-folios_put-in-__folio_batch_release.patch added to mm-unstable branch
Message-Id: <20240227184753.0E59FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use folios_put() in __folio_batch_release()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-folios_put-in-__folio_batch_release.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-folios_put-in-__folio_batch_release.patch

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

