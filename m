Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01082190486;
	Sat,  1 Feb 2025 11:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410857; cv=none; b=PtZLGj9g4Z6qbp4H+ve2/vJbOWl0SaraLy7eXcmVRiC4k0bQQZCo3ZUMjLIM1qrndOiy1FGNPpWJsEHbNZhKrVncCFpnG2nsE3tGi6GoB0t+7ktE28fogzvX272fmK16DbuIKuWpYc+ITeFJDKEt57GnupqDnBs6SlkbcidnNs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410857; c=relaxed/simple;
	bh=QdjsQGAxvMlNJ2nX5c+fxo52LZSANcuYx6Nb20i+T/k=;
	h=Date:To:From:Subject:Message-Id; b=OO3f9DPcPZ4CUBDAyYiogrvRM/T5sKjLHUKX9dCVIpwHMG/NwduMAduoPBhuUi3qCSeFss5I+ntlyUwyHdpDx8JkyFxRdngBWsY5DO5rfO/iGII73bRHmr5Y02yP365VVlzxjQgyHhmF0w901c37pBZKLfPf0x21ycg08CPv0SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fYFGIDl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fYFGIDl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6507DC4CEE1;
	Sat,  1 Feb 2025 11:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410856;
	bh=QdjsQGAxvMlNJ2nX5c+fxo52LZSANcuYx6Nb20i+T/k=;
	h=Date:To:From:Subject:From;
	b=fYFGIDl1vrgEhMkqUBDW721/jW0nZpdMoC/lXWl8AeFofkfyvW/+xiOdnK+XGdYEt
	 D4SBEBtMP0gbLnzV2Oue1FHqtSEJEJOcJf5ulLlbfa80erntcFMNDpZ6zYzHCLWiWM
	 mKArkav6GBakQO9rVdgURMQ1rVjH5L2iwjttegRY=
Date: Sat, 01 Feb 2025 03:54:15 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jhubbard@nvidia.com,david@redhat.com,apopple@nvidia.com,aijun.sun@unisoc.com,zhaoyang.huang@unisoc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-gup-fix-infinite-loop-within-__get_longterm_locked.patch removed from -mm tree
Message-Id: <20250201115416.6507DC4CEE1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: gup: fix infinite loop within __get_longterm_locked
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-infinite-loop-within-__get_longterm_locked.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm: gup: fix infinite loop within __get_longterm_locked
Date: Tue, 21 Jan 2025 10:01:59 +0800

We can run into an infinite loop in __get_longterm_locked() when
collect_longterm_unpinnable_folios() finds only folios that are isolated
from the LRU or were never added to the LRU.  This can happen when all
folios to be pinned are never added to the LRU, for example when
vm_ops->fault allocated pages using cma_alloc() and never added them to
the LRU.

Fix it by simply taking a look at the list in the single caller, to see if
anything was added.

[zhaoyang.huang@unisoc.com: move definition of local]
  Link: https://lkml.kernel.org/r/20250122012604.3654667-1-zhaoyang.huang@unisoc.com
Link: https://lkml.kernel.org/r/20250121020159.3636477-1-zhaoyang.huang@unisoc.com
Fixes: 67e139b02d99 ("mm/gup.c: refactor check_and_migrate_movable_pages()")
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Aijun Sun <aijun.sun@unisoc.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/mm/gup.c~mm-gup-fix-infinite-loop-within-__get_longterm_locked
+++ a/mm/gup.c
@@ -2320,13 +2320,13 @@ static void pofs_unpin(struct pages_or_f
 /*
  * Returns the number of collected folios. Return value is always >= 0.
  */
-static unsigned long collect_longterm_unpinnable_folios(
+static void collect_longterm_unpinnable_folios(
 		struct list_head *movable_folio_list,
 		struct pages_or_folios *pofs)
 {
-	unsigned long i, collected = 0;
 	struct folio *prev_folio = NULL;
 	bool drain_allow = true;
+	unsigned long i;
 
 	for (i = 0; i < pofs->nr_entries; i++) {
 		struct folio *folio = pofs_get_folio(pofs, i);
@@ -2338,8 +2338,6 @@ static unsigned long collect_longterm_un
 		if (folio_is_longterm_pinnable(folio))
 			continue;
 
-		collected++;
-
 		if (folio_is_device_coherent(folio))
 			continue;
 
@@ -2361,8 +2359,6 @@ static unsigned long collect_longterm_un
 				    NR_ISOLATED_ANON + folio_is_file_lru(folio),
 				    folio_nr_pages(folio));
 	}
-
-	return collected;
 }
 
 /*
@@ -2439,11 +2435,9 @@ static long
 check_and_migrate_movable_pages_or_folios(struct pages_or_folios *pofs)
 {
 	LIST_HEAD(movable_folio_list);
-	unsigned long collected;
 
-	collected = collect_longterm_unpinnable_folios(&movable_folio_list,
-						       pofs);
-	if (!collected)
+	collect_longterm_unpinnable_folios(&movable_folio_list, pofs);
+	if (list_empty(&movable_folio_list))
 		return 0;
 
 	return migrate_longterm_unpinnable_folios(&movable_folio_list, pofs);
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are


