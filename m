Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF52A1FE461
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 20:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751660413; cv=none; b=Nr33t1XLAbDTeoQbxt1o71H7NoWz0ESiUmQq8t+9vabtvU8oig4ByIyZuhBkhxuucUfw9cw75yx9tEu0LlcgXxKz9wll0xfGbgS8Ar4lDlS3RWR8n85/RjPTWiWZiozUZedmDt+EX2/yomCSZCIAVmmduaUBtu3N/lYPVIOrrNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751660413; c=relaxed/simple;
	bh=rfceDocrMCz1vqFrq9n62oJTpaLQnTOgS0RDgJkiHGw=;
	h=Date:To:From:Subject:Message-Id; b=NP3aX6U3gQJmwvha+xDlDdLcQ1wWZ+xViXjyiGQPBoCOBsPdKH23bsH+8M5obOCyz+4MGBr5blniTwZsr8biH9jwArfRkzWSQPC9R+Q7hKr25WwMIZ/ArvtzIJxlhqhAxguv5Ph9URP44UiH4ZjhWMtDbXVZhUn/V8wykFe/W8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aSTO3ob0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aSTO3ob0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F94C4CEE3;
	Fri,  4 Jul 2025 20:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751660413;
	bh=rfceDocrMCz1vqFrq9n62oJTpaLQnTOgS0RDgJkiHGw=;
	h=Date:To:From:Subject:From;
	b=aSTO3ob0mKaWPnRAendxfUGDilEyqd8wLOhm+kVtmuZz8MlPqk8pKTU1uBit3M08+
	 JKC/8hz0cBF/Qo1g8mLPtvGGLsPSDz9UwIo2nFpWH4JjaerUx6DV7qE2qR9MJicCgP
	 KZq0AfuVHImWeiPvlbwjbC4g+9dkMEjHhjZ/tcSc=
Date: Fri, 04 Jul 2025 13:20:12 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-simplify-swap-entry-and-index-calculation-of-large-swapin.patch added to mm-unstable branch
Message-Id: <20250704202013.29F94C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: simplify swap entry and index calculation of large swapin
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-swap-simplify-swap-entry-and-index-calculation-of-large-swapin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-simplify-swap-entry-and-index-calculation-of-large-swapin.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem, swap: simplify swap entry and index calculation of large swapin
Date: Sat, 5 Jul 2025 02:17:47 +0800

Noticing large shmem swapin have already calculated the right swap value
to be used before the swap cache look up, simply rounding it down against
the size of the folio brought in the swapin is simple and effective enough
to get the swap value to be verified.  A folio's swap entry is always
aligned by its size.

Any kind of parallel split or race is fine, because the final
shmem_add_to_page_cache always ensures entries covered by the folio are
all correct, and there won't be any data corruption.

This shouldn't cause any increased repeated fault too, instead, no matter
how the shmem mapping is split in parallel, as long as the mapping still
contains the right entries, the swapin will succeed.

This reduced both the final object size and stack usage:

./scripts/bloat-o-meter mm/shmem.o.old mm/shmem.o
add/remove: 0/0 grow/shrink: 1/1 up/down: 5/-214 (-209)
Function                                     old     new   delta
shmem_read_mapping_page_gfp                  143     148      +5
shmem_swapin_folio                          4020    3806    -214
Total: Before=33478, After=33269, chg -0.62%

Stack usage (Before vs After):
shmem.c:2279:12:shmem_swapin_folio     280    static
shmem.c:2279:12:shmem_swapin_folio     264    static

Link: https://lkml.kernel.org/r/20250704181748.63181-9-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-simplify-swap-entry-and-index-calculation-of-large-swapin
+++ a/mm/shmem.c
@@ -2267,7 +2267,7 @@ unlock:
 	if (xas_error(&xas))
 		return xas_error(&xas);
 
-	return entry_order;
+	return 0;
 }
 
 /*
@@ -2288,7 +2288,7 @@ static int shmem_swapin_folio(struct ino
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	bool skip_swapcache = false;
-	int error, nr_pages, order, split_order;
+	int error, nr_pages, order;
 	pgoff_t offset;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
@@ -2336,8 +2336,6 @@ static int shmem_swapin_folio(struct ino
 				folio = NULL;
 				goto failed;
 			} else {
-				if (folio_test_large(folio))
-					swap = index_entry;
 				skip_swapcache = true;
 			}
 		} else {
@@ -2349,6 +2347,7 @@ static int shmem_swapin_folio(struct ino
 			}
 		}
 	}
+
 	if (order > folio_order(folio)) {
 		/*
 		 * Swapin may get smaller folios due to various reasons:
@@ -2358,23 +2357,25 @@ static int shmem_swapin_folio(struct ino
 		 * large swap entries. In such cases, we should split the
 		 * large swap entry to prevent possible data corruption.
 		 */
-		split_order = shmem_split_large_entry(inode, index, index_entry, gfp);
-		if (split_order < 0) {
-			error = split_order;
+		error = shmem_split_large_entry(inode, index, index_entry, gfp);
+		if (error)
 			goto failed_nolock;
-		}
+	}
 
-		/*
-		 * If the large swap entry has already been split, it is
-		 * necessary to recalculate the new swap entry based on
-		 * the old order alignment.
-		 */
-		if (split_order > 0) {
-			offset = index - round_down(index, 1 << split_order);
-			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
-		}
-	} else if (order < folio_order(folio)) {
-		swap.val = round_down(swap.val, 1 << folio_order(folio));
+	/*
+	 * If the folio is large, round down swap and index by folio size.
+	 * No matter what race occurs, the swap layer ensures we either get
+	 * a valid folio that has its swap entry aligned by size, or a
+	 * temporarily invalid one which we'll abort very soon and retry.
+	 *
+	 * shmem_add_to_page_cache ensures the whole range contains expected
+	 * entries and prevents any corruption, so any race split is fine
+	 * too, it will succeed as long as the entries are still there.
+	 */
+	nr_pages = folio_nr_pages(folio);
+	if (nr_pages > 1) {
+		swap.val = round_down(swap.val, nr_pages);
+		index = round_down(index, nr_pages);
 	}
 
 	/* We have to do this with folio locked to prevent races */
@@ -2389,7 +2390,6 @@ static int shmem_swapin_folio(struct ino
 		goto failed;
 	}
 	folio_wait_writeback(folio);
-	nr_pages = folio_nr_pages(folio);
 
 	/*
 	 * Some architectures may have to restore extra metadata to the
@@ -2403,8 +2403,7 @@ static int shmem_swapin_folio(struct ino
 			goto failed;
 	}
 
-	error = shmem_add_to_page_cache(folio, mapping,
-					round_down(index, nr_pages),
+	error = shmem_add_to_page_cache(folio, mapping, index,
 					swp_to_radix_entry(swap), gfp);
 	if (error)
 		goto failed;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-refactor-the-locking-code.patch
mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-tidy-up-swap-entry-splitting.patch
mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling.patch
mm-shmem-swap-simplify-swap-entry-and-index-calculation-of-large-swapin.patch
mm-shmem-swap-fix-major-fault-counting.patch

