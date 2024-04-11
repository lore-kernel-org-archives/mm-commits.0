Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A8D1754B
	for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2024 20:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712868451; cv=none; b=tNoGp70osh/M5j53rv5TU/bopDwIL1dfe6one5WrMUaN9bwd7o7thtE1U4AoTZ7xarL22QzKjxTaIaE2tdP32peWekBeRzKWnkkSvj46Z4cx2pftg7AKuQsn8cT08ujZBoZQ6msIKCg2BFFCY5gfgGEam5r7WPXHaIKYNg7536g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712868451; c=relaxed/simple;
	bh=Gjq92L/8/w6hBA5kxIDMaI8KO6xQBj+TS97HxCKOQnQ=;
	h=Date:To:From:Subject:Message-Id; b=K51Qlkei/tCG71ExqMNY2QnOQ8+cWppx13G4zfmTYkCRCKR78ypPrpiMiWPJmENJcPbX5oDsX3OiNprHyurlaJdpb6R7XNwDmz0zIESeemiRhPc3o4/vncAPsdhEm76TtfJo5z7TLdZk/T8X9NKajhJQQ1pXkcqhJNjmncIhsHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qa0v8NQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qa0v8NQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DD0C072AA;
	Thu, 11 Apr 2024 20:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712868450;
	bh=Gjq92L/8/w6hBA5kxIDMaI8KO6xQBj+TS97HxCKOQnQ=;
	h=Date:To:From:Subject:From;
	b=qa0v8NQ7rd/2yXjDyknqg1UUUMtrVMhIyopQ9TWOriE4kG6Xi0YSKjKTDtqQa/pXK
	 FtLPrqv1WFP1/2DGFtj9VCCJA+bVl9CCmehAl0KSTDLqEDfzWdp35u2LLMWNkPE53G
	 V49oTVw0KXqu8QTALlTnS+qgsCMNX8Huw9ezW/jw=
Date: Thu, 11 Apr 2024 13:47:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,hughd@google.com,david@redhat.com,chrisw@sous-sol.org,aarcange@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-use-folio-in-remove_rmap_item_from_tree.patch added to mm-unstable branch
Message-Id: <20240411204730.B3DD0C072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: use folio in remove_rmap_item_from_tree
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-use-folio-in-remove_rmap_item_from_tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-use-folio-in-remove_rmap_item_from_tree.patch

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
From: "Alex Shi (tencent)" <alexs@kernel.org>
Subject: mm/ksm: use folio in remove_rmap_item_from_tree
Date: Thu, 11 Apr 2024 14:17:03 +0800

To save 2 compound_head calls.

Link: https://lkml.kernel.org/r/20240411061713.1847574-3-alexs@kernel.org
Signed-off-by: Alex Shi (tencent) <alexs@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/ksm.c~mm-ksm-use-folio-in-remove_rmap_item_from_tree
+++ a/mm/ksm.c
@@ -1006,16 +1006,16 @@ static void remove_rmap_item_from_tree(s
 {
 	if (rmap_item->address & STABLE_FLAG) {
 		struct ksm_stable_node *stable_node;
-		struct page *page;
+		struct folio *folio;
 
 		stable_node = rmap_item->head;
-		page = get_ksm_page(stable_node, GET_KSM_PAGE_LOCK);
-		if (!page)
+		folio = ksm_get_folio(stable_node, GET_KSM_PAGE_LOCK);
+		if (!folio)
 			goto out;
 
 		hlist_del(&rmap_item->hlist);
-		unlock_page(page);
-		put_page(page);
+		folio_unlock(folio);
+		folio_put(folio);
 
 		if (!hlist_empty(&stable_node->hlist))
 			ksm_pages_sharing--;
_

Patches currently in -mm which might be from alexs@kernel.org are

mm-ksm-add-ksm_get_folio.patch
mm-ksm-use-folio-in-remove_rmap_item_from_tree.patch
mm-ksm-add-folio_set_stable_node.patch
mm-ksm-use-folio-in-remove_stable_node.patch
mm-ksm-use-folio-in-stable_node_dup.patch
mm-ksm-use-ksm_get_folio-in-scan_get_next_rmap_item.patch
mm-ksm-use-folio-in-write_protect_page.patch
mm-ksm-convert-chain-series-funcs-and-replace-get_ksm_page.patch
mm-ksm-replace-set_page_stable_node-by-folio_set_stable_node.patch

