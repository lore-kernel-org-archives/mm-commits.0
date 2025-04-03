Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB332E62A2
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 22:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743717661; cv=none; b=KjV6b1N4RxsV6agisuq6m3cBtv1bLlwOt1mlBEuoS3Jhbb4fCTCCIKOnumCdge0G4lDZCqEvXuOAiZIRqv7Xr+MZHgvS7ch9iKDUOBsZSGbJMhoqlQG43zaqhojQ7Y0/hT6y6/QCGJCKza1iuANDu9YsORLDM5kOYi87evtO6SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743717661; c=relaxed/simple;
	bh=rS+0pXv5EI841DizRGTlAvezk8Pe7mk007dYavQDJV0=;
	h=Date:To:From:Subject:Message-Id; b=qUsiLrgK/RK0pwNS6pkFVhUZTA5cu2LRSECxQlg2ojQ9In3Wb4kFwYSreu8uHoqQt7FwhpDOvOWnAvoEtoHuo418cjrmKtQ6EB7nDga9BJecXWAccFYByMttVEKUarcUMxfT+Bpe6tdAKPFr/GYiQWkKZmkEpoDO/kC1Mi5L/b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LZWILy0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LZWILy0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62E2C4CEE8;
	Thu,  3 Apr 2025 22:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743717661;
	bh=rS+0pXv5EI841DizRGTlAvezk8Pe7mk007dYavQDJV0=;
	h=Date:To:From:Subject:From;
	b=LZWILy0iEwIOZh0yLcMHfBd+9BqV2begr1jSaOvp3hhp/LtaFoWE7wt5+/CQOQymp
	 xHO234KcLMXOgn+DBYwpxXk/xrRPjAIOULG/XO65rYLS8M1oyShVpr82Tlwr2ZkcfJ
	 lSSDFWteyXyP1yTQql7CTk/nfRcWaXc24pAZBy2Q=
Date: Thu, 03 Apr 2025 15:01:00 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,shakeel.butt@linux.dev,riel@surriel.com,mgorman@techsingularity.net,liuye@kylinos.cn,hughd@google.com,vny@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-batch-tlb-flush-during-memory-reclaim.patch added to mm-new branch
Message-Id: <20250403220100.E62E2C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: batch TLB flush during memory reclaim
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-batch-tlb-flush-during-memory-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-batch-tlb-flush-during-memory-reclaim.patch

This patch will later appear in the mm-new branch at
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
From: Vinay Banakar <vny@google.com>
Subject: mm/vmscan: batch TLB flush during memory reclaim
Date: Fri, 28 Mar 2025 14:20:55 -0400

The current implementation in shrink_folio_list() performs a full TLB
flush for every individual folio reclaimed.  This causes unnecessary
overhead during memory reclaim.

The current code:
1. Clears PTEs and unmaps each page individually
2. Performs a full TLB flush on every CPU the mm is running on

The new code:
1. Clears PTEs and unmaps each page individually
2. Adds each unmapped page to pageout_folios
3. Flushes the TLB once before procesing pageout_folios

This reduces the number of TLB flushes issued by the memory reclaim code
by 1/N, where N is the number of mapped folios encountered in the batch
processed by shrink_folio_list.

[riel@surriel.com: forward port to 6.14, adjust code and naming to match surrounding code]
Link: https://lkml.kernel.org/r/20250328142055.313916d1@fangorn
Signed-off-by: Vinay Banakar <vny@google.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liu Ye <liuye@kylinos.cn>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |  112 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 68 insertions(+), 44 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-batch-tlb-flush-during-memory-reclaim
+++ a/mm/vmscan.c
@@ -1101,6 +1101,7 @@ static unsigned int shrink_folio_list(st
 	struct folio_batch free_folios;
 	LIST_HEAD(ret_folios);
 	LIST_HEAD(demote_folios);
+	LIST_HEAD(pageout_folios);
 	unsigned int nr_reclaimed = 0, nr_demoted = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
@@ -1428,51 +1429,10 @@ retry:
 				goto keep_locked;
 
 			/*
-			 * Folio is dirty. Flush the TLB if a writable entry
-			 * potentially exists to avoid CPU writes after I/O
-			 * starts and then write it out here.
+			 * Add to pageout list for batched TLB flushing and IO submission.
 			 */
-			try_to_unmap_flush_dirty();
-			switch (pageout(folio, mapping, &plug, folio_list)) {
-			case PAGE_KEEP:
-				goto keep_locked;
-			case PAGE_ACTIVATE:
-				/*
-				 * If shmem folio is split when writeback to swap,
-				 * the tail pages will make their own pass through
-				 * this function and be accounted then.
-				 */
-				if (nr_pages > 1 && !folio_test_large(folio)) {
-					sc->nr_scanned -= (nr_pages - 1);
-					nr_pages = 1;
-				}
-				goto activate_locked;
-			case PAGE_SUCCESS:
-				if (nr_pages > 1 && !folio_test_large(folio)) {
-					sc->nr_scanned -= (nr_pages - 1);
-					nr_pages = 1;
-				}
-				stat->nr_pageout += nr_pages;
-
-				if (folio_test_writeback(folio))
-					goto keep;
-				if (folio_test_dirty(folio))
-					goto keep;
-
-				/*
-				 * A synchronous write - probably a ramdisk.  Go
-				 * ahead and try to reclaim the folio.
-				 */
-				if (!folio_trylock(folio))
-					goto keep;
-				if (folio_test_dirty(folio) ||
-				    folio_test_writeback(folio))
-					goto keep_locked;
-				mapping = folio_mapping(folio);
-				fallthrough;
-			case PAGE_CLEAN:
-				; /* try to free the folio below */
-			}
+			list_add(&folio->lru, &pageout_folios);
+			continue;
 		}
 
 		/*
@@ -1583,6 +1543,70 @@ keep:
 	}
 	/* 'folio_list' is always empty here */
 
+	if (!list_empty(&pageout_folios)) {
+		/*
+		 * The loop above unmapped the folios from the page tables.
+		 * One TLB flush takes care of the whole batch.
+		 */
+		try_to_unmap_flush_dirty();
+
+		while (!list_empty(&pageout_folios)) {
+			struct folio *folio = lru_to_folio(&pageout_folios);
+			struct address_space *mapping;
+			list_del(&folio->lru);
+
+			/* Recheck if the page got reactivated */
+			if (folio_test_active(folio) || folio_mapped(folio))
+				goto skip_pageout_locked;
+
+			mapping = folio_mapping(folio);
+			switch (pageout(folio, mapping, &plug, &pageout_folios)) {
+			case PAGE_KEEP:
+			case PAGE_ACTIVATE:
+				goto skip_pageout_locked;
+			case PAGE_SUCCESS:
+				/*
+				 * If shmem folio is split when writeback to swap,
+				 * the tail pages will make their own pass through
+				 * this loop and be accounted then.
+				 */
+				stat->nr_pageout += folio_nr_pages(folio);
+
+				if (folio_test_writeback(folio))
+					goto skip_pageout;
+				if (folio_test_dirty(folio))
+					goto skip_pageout;
+
+				/*
+				 * A synchronous write - probably a ramdisk.  Go
+				 * ahead and try to reclaim the folio.
+				 */
+				if (!folio_trylock(folio))
+					goto skip_pageout;
+				if (folio_test_dirty(folio) ||
+				    folio_test_writeback(folio))
+					goto skip_pageout_locked;
+				mapping = folio_mapping(folio);
+				/* try to free the folio below */
+				fallthrough;
+			case PAGE_CLEAN:
+				/* try to free the folio */
+				if (!mapping ||
+				    !remove_mapping(mapping, folio))
+					goto skip_pageout_locked;
+
+				nr_reclaimed += folio_nr_pages(folio);
+				folio_unlock(folio);
+				continue;
+			}
+
+skip_pageout_locked:
+			folio_unlock(folio);
+skip_pageout:
+			list_add(&folio->lru, &ret_folios);
+		}
+	}
+
 	/* Migrate folios selected for demotion */
 	nr_demoted = demote_folio_list(&demote_folios, pgdat);
 	nr_reclaimed += nr_demoted;
_

Patches currently in -mm which might be from vny@google.com are

mm-vmscan-batch-tlb-flush-during-memory-reclaim.patch

