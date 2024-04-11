Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2345A1754B
	for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2024 20:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712868457; cv=none; b=oYFDpiY1xWYOT+VVlYNt3Ut11s92CdU1CY97T/rrLtlOsq5JVgzv7pzscahAL3PkQH0T014nRzpCDegLvBvLL7Ua5jb76WYOFIxWLSW66tgW6h5vF8wftcy28U4ZmLWfAPgZgtSb1Nknq6OMCunBWqCiVwUbSBIvRxmafbA4uq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712868457; c=relaxed/simple;
	bh=AR7Fqd/lNeZ18C0a7LqC97znOosG13bS1k6y2qrzghw=;
	h=Date:To:From:Subject:Message-Id; b=kD6xkHLreDCJE6Y1arjmx+prZe+OaJw8rWbZaSeM6buciqGFPwlxeQSq9ErqTfdSHDNVm/StbLJAf0CcEg8n7+aCIeh01riNSDHCLRfhKrKPlacXyEIxbFi+jWvit9fE23AJA78mGla0/Pr9vew6GKzhyE3QJavH0yLn3wnqukk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ntqXz/1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ntqXz/1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEB4C072AA;
	Thu, 11 Apr 2024 20:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712868456;
	bh=AR7Fqd/lNeZ18C0a7LqC97znOosG13bS1k6y2qrzghw=;
	h=Date:To:From:Subject:From;
	b=ntqXz/1lk00PtqtWb4d9G42vcEo5b0nu/qipq0bwyekkbKP8jUWd9zUOyGI0f0FyB
	 0PoqSzkKfgmtgspm/Z7gHio91/kKRuhFmVxiwPJRR7gsPoM2RPTsNQ/FHqOonOPgEY
	 TzxeuAoOQDuz3mvrM5+coYTbTrEXjkXeDD8QPUcM=
Date: Thu, 11 Apr 2024 13:47:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,hughd@google.com,david@redhat.com,chrisw@sous-sol.org,aarcange@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-use-ksm_get_folio-in-scan_get_next_rmap_item.patch added to mm-unstable branch
Message-Id: <20240411204736.8FEB4C072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: use ksm_get_folio in scan_get_next_rmap_item
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-use-ksm_get_folio-in-scan_get_next_rmap_item.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-use-ksm_get_folio-in-scan_get_next_rmap_item.patch

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
Subject: mm/ksm: use ksm_get_folio in scan_get_next_rmap_item
Date: Thu, 11 Apr 2024 14:17:07 +0800

Save a compound calls.

Link: https://lkml.kernel.org/r/20240411061713.1847574-7-alexs@kernel.org
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

--- a/mm/ksm.c~mm-ksm-use-ksm_get_folio-in-scan_get_next_rmap_item
+++ a/mm/ksm.c
@@ -2611,14 +2611,14 @@ static struct ksm_rmap_item *scan_get_ne
 		 */
 		if (!ksm_merge_across_nodes) {
 			struct ksm_stable_node *stable_node, *next;
-			struct page *page;
+			struct folio *folio;
 
 			list_for_each_entry_safe(stable_node, next,
 						 &migrate_nodes, list) {
-				page = get_ksm_page(stable_node,
-						    GET_KSM_PAGE_NOLOCK);
-				if (page)
-					put_page(page);
+				folio = ksm_get_folio(stable_node,
+						      GET_KSM_PAGE_NOLOCK);
+				if (folio)
+					folio_put(folio);
 				cond_resched();
 			}
 		}
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

