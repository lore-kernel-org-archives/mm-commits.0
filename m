Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2B218E375
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925321; cv=none; b=JJ675atqJMk38hHYzb+Udu/iEy+HCbZq00BM1G/imY/EwYj39cNyWQbWgblAgbu2u9uC0p3WZq5Y5LHguDEfXkWxCTKtFjXoN4+VneY0mhYyoszBrJCvqk1GhcwYxGyXTN9yeS/VlNlmUr3MFbp6fGI+sm1Y8XPil072SXCcK+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925321; c=relaxed/simple;
	bh=H8z05cINARIAT/tLXefgF/RaiR/e9aDQ4hz4IDoeQ9o=;
	h=Date:To:From:Subject:Message-Id; b=IuD6kDVfRdC/NsLJAceKSKyjEGGSx51qSgQ+rac3DXN8H4kGhjGxElHi9R1SMIp6Bbnsd3LedO/YZY17ftP61mNl5F78wBj/uLh0/dF3hTwuR6a/abW9DRL3uoVNVW+rJpfWQ9Y/oC2Cs4JCI9Fhq/wiDiwqSEWjFjlMSZgnYfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KiYNBS2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KiYNBS2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81550C4CEC6;
	Mon,  9 Sep 2024 23:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925321;
	bh=H8z05cINARIAT/tLXefgF/RaiR/e9aDQ4hz4IDoeQ9o=;
	h=Date:To:From:Subject:From;
	b=KiYNBS2+P/HcjudFpkGg8MybiNckybg6nUVkHsu1mrgwSMidnvSl9bvELq4Nhmjtc
	 uxM5KhWww2R00bChR2f8VfSVzz0VvSLOxqMxFe1a2gYnkowIR5yXlf6QHFBADLdePU
	 Gyd4XbkvZOuaChX98i6aKKsMKxO4+F24qfQKFNPs=
Date: Mon, 09 Sep 2024 16:42:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,Liam.Howlett@oracle.com,hughd@google.com,baolin.wang@linux.alibaba.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-replace-xa_get_order-with-xas_get_order-where-appropriate.patch removed from -mm tree
Message-Id: <20240909234201.81550C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: replace xa_get_order with xas_get_order where appropriate
has been removed from the -mm tree.  Its filename was
     mm-replace-xa_get_order-with-xas_get_order-where-appropriate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm: replace xa_get_order with xas_get_order where appropriate
Date: Fri, 6 Sep 2024 16:05:12 -0700

The tracing of invalidation and truncation operations on large files
showed that xa_get_order() is among the top functions where kernel spends
a lot of CPUs.  xa_get_order() needs to traverse the tree to reach the
right node for a given index and then extract the order of the entry. 
However it seems like at many places it is being called within an already
happening tree traversal where there is no need to do another traversal. 
Just use xas_get_order() at those places.

Link: https://lkml.kernel.org/r/20240906230512.124643-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 +++---
 mm/shmem.c   |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/mm/filemap.c~mm-replace-xa_get_order-with-xas_get_order-where-appropriate
+++ a/mm/filemap.c
@@ -2112,7 +2112,7 @@ unsigned find_lock_entries(struct addres
 			VM_BUG_ON_FOLIO(!folio_contains(folio, xas.xa_index),
 					folio);
 		} else {
-			nr = 1 << xa_get_order(&mapping->i_pages, xas.xa_index);
+			nr = 1 << xas_get_order(&xas);
 			base = xas.xa_index & ~(nr - 1);
 			/* Omit order>0 value which begins before the start */
 			if (base < *start)
@@ -3001,7 +3001,7 @@ unlock:
 static inline size_t seek_folio_size(struct xa_state *xas, struct folio *folio)
 {
 	if (xa_is_value(folio))
-		return PAGE_SIZE << xa_get_order(xas->xa, xas->xa_index);
+		return PAGE_SIZE << xas_get_order(xas);
 	return folio_size(folio);
 }
 
@@ -4297,7 +4297,7 @@ static void filemap_cachestat(struct add
 		if (xas_retry(&xas, folio))
 			continue;
 
-		order = xa_get_order(xas.xa, xas.xa_index);
+		order = xas_get_order(&xas);
 		nr_pages = 1 << order;
 		folio_first_index = round_down(xas.xa_index, 1 << order);
 		folio_last_index = folio_first_index + nr_pages - 1;
--- a/mm/shmem.c~mm-replace-xa_get_order-with-xas_get_order-where-appropriate
+++ a/mm/shmem.c
@@ -890,7 +890,7 @@ unsigned long shmem_partial_swap_usage(s
 		if (xas_retry(&xas, page))
 			continue;
 		if (xa_is_value(page))
-			swapped += 1 << xa_get_order(xas.xa, xas.xa_index);
+			swapped += 1 << xas_get_order(&xas);
 		if (xas.xa_index == max)
 			break;
 		if (need_resched()) {
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


