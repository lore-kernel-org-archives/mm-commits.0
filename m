Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B5117BCA;
	Fri, 13 Dec 2024 01:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734053330; cv=none; b=plmQkXtEx/w70gaZPxhnhpz1mXBJs4lUnxjoNSH+b7kSlLqoiKBXfeuRXTQYNpb4s/joG0cz2bRUy9j/2UwhUuMOISn4nk5lrX8FbY0ZjBS6fss/tCWFluksVJM/8HkBEkmbVUR12xbvh6EACkRw/hTX53DyhKeXJa4yPPa9d/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734053330; c=relaxed/simple;
	bh=+EXAGMXJQEV0hruqDdUuq/Ucu+skzvxDfnWPEe91D04=;
	h=Date:To:From:Subject:Message-Id; b=Pgv8z77ZU2uwZYbGG6Ik7RBrrDV/X0K7y7muKBgxGT/RxnWDL5lIiSnnusgpYqbldv2Sk5VOYU6/wsVEj54w+l2uVly4CW/3JnOj9vHAyXm0ns4bZkrW605HeTXE3DwQ0VWFMtNUT5VBp0E5o9ZqGSUAXWxnrhZWRvsmmlzEEoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iBwyYMVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iBwyYMVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7784AC4CED3;
	Fri, 13 Dec 2024 01:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734053329;
	bh=+EXAGMXJQEV0hruqDdUuq/Ucu+skzvxDfnWPEe91D04=;
	h=Date:To:From:Subject:From;
	b=iBwyYMVCAapWL2KQguu5GhWaMhvBeKpwHcsubiDaI/CyDbKtEEYvcO3MOiZje82EB
	 COSkAtZnTzoOcRwmYaE1/VSqgynNKbhaItuc8oLLFm1SnTfyMAZAhJOsWvI+ojiCTg
	 RDtO9I8zxEXGfYExNrtO0ZV1i9oNI3l9Z5t70+WY=
Date: Thu, 12 Dec 2024 17:28:48 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,stable@vger.kernel.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,npache@redhat.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,cerasuolodomenico@gmail.com,baohua@kernel.org,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-partially_mapped-set-clear-operations-to-be-atomic.patch added to mm-hotfixes-unstable branch
Message-Id: <20241213012849.7784AC4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert partially_mapped set/clear operations to be atomic
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-convert-partially_mapped-set-clear-operations-to-be-atomic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-partially_mapped-set-clear-operations-to-be-atomic.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm: convert partially_mapped set/clear operations to be atomic
Date: Thu, 12 Dec 2024 18:33:51 +0000

Other page flags in the 2nd page, like PG_hwpoison and PG_anon_exclusive
can get modified concurrently.  Changes to other page flags might be lost
if they are happening at the same time as non-atomic partially_mapped
operations.  Hence, make partially_mapped operations atomic.

Link: https://lkml.kernel.org/r/20241212183351.1345389-1-usamaarif642@gmail.com
Fixes: 8422acdc97ed ("mm: introduce a pageflag for partially mapped folios")
Reported-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/all/e53b04ad-1827-43a2-a1ab-864c7efecf6e@redhat.com/
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   12 ++----------
 mm/huge_memory.c           |    8 ++++----
 2 files changed, 6 insertions(+), 14 deletions(-)

--- a/include/linux/page-flags.h~mm-convert-partially_mapped-set-clear-operations-to-be-atomic
+++ a/include/linux/page-flags.h
@@ -862,18 +862,10 @@ static inline void ClearPageCompound(str
 	ClearPageHead(page);
 }
 FOLIO_FLAG(large_rmappable, FOLIO_SECOND_PAGE)
-FOLIO_TEST_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
-/*
- * PG_partially_mapped is protected by deferred_split split_queue_lock,
- * so its safe to use non-atomic set/clear.
- */
-__FOLIO_SET_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
-__FOLIO_CLEAR_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
+FOLIO_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
 #else
 FOLIO_FLAG_FALSE(large_rmappable)
-FOLIO_TEST_FLAG_FALSE(partially_mapped)
-__FOLIO_SET_FLAG_NOOP(partially_mapped)
-__FOLIO_CLEAR_FLAG_NOOP(partially_mapped)
+FOLIO_FLAG_FALSE(partially_mapped)
 #endif
 
 #define PG_head_mask ((1UL << PG_head))
--- a/mm/huge_memory.c~mm-convert-partially_mapped-set-clear-operations-to-be-atomic
+++ a/mm/huge_memory.c
@@ -3577,7 +3577,7 @@ int split_huge_page_to_list_to_order(str
 		    !list_empty(&folio->_deferred_list)) {
 			ds_queue->split_queue_len--;
 			if (folio_test_partially_mapped(folio)) {
-				__folio_clear_partially_mapped(folio);
+				folio_clear_partially_mapped(folio);
 				mod_mthp_stat(folio_order(folio),
 					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
@@ -3689,7 +3689,7 @@ bool __folio_unqueue_deferred_split(stru
 	if (!list_empty(&folio->_deferred_list)) {
 		ds_queue->split_queue_len--;
 		if (folio_test_partially_mapped(folio)) {
-			__folio_clear_partially_mapped(folio);
+			folio_clear_partially_mapped(folio);
 			mod_mthp_stat(folio_order(folio),
 				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 		}
@@ -3733,7 +3733,7 @@ void deferred_split_folio(struct folio *
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (partially_mapped) {
 		if (!folio_test_partially_mapped(folio)) {
-			__folio_set_partially_mapped(folio);
+			folio_set_partially_mapped(folio);
 			if (folio_test_pmd_mappable(folio))
 				count_vm_event(THP_DEFERRED_SPLIT_PAGE);
 			count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
@@ -3826,7 +3826,7 @@ static unsigned long deferred_split_scan
 		} else {
 			/* We lost race with folio_put() */
 			if (folio_test_partially_mapped(folio)) {
-				__folio_clear_partially_mapped(folio);
+				folio_clear_partially_mapped(folio);
 				mod_mthp_stat(folio_order(folio),
 					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-convert-partially_mapped-set-clear-operations-to-be-atomic.patch

