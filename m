Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B44156CA
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743988321; cv=none; b=mocn62ILUwOpaNONBcLvRp6Lk7xnS6/oV1jZ0vsxAYdJPx0qrVbuFy99mTaSbjAqfCQLev697877D/Dws/pem0xmOe7vgw0Rr2rk94Lx/gnmGmmDE8fFXUtigjqxeRk+ugNaFfVliAjcAg8zuf9ZsEocbPkTzv7tacsCXppIo8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743988321; c=relaxed/simple;
	bh=ndy/7QXO7vyCAUgP/tH+SkN6JvhKG23+JalftM3DeKo=;
	h=Date:To:From:Subject:Message-Id; b=QpHBwuIMxyZwrDS+0n8qS0J+8Qq92TjH1XZinTgdy+OmV6/W2Up6aodNOJNx6PGouwZ+ZyN+lidcJNIXzb2MFGY/D1qULpCyeV+jTs8RF9tSiv8t92hMr9B5BBF05MkMcejuHVyAZ+HcsQCfgqG3H1e28dBt1TDgwftTsLW9Eb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G/Nh6l9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G/Nh6l9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E6CC4CEE3;
	Mon,  7 Apr 2025 01:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743988321;
	bh=ndy/7QXO7vyCAUgP/tH+SkN6JvhKG23+JalftM3DeKo=;
	h=Date:To:From:Subject:From;
	b=G/Nh6l9rQjOTcOpYjZ9OPg/UgjBKZJzq//LuxlCgXB9aFAzV5c3KCXgvt2j9/Q8fB
	 Pk0HXpKiTQ0lqptpTarA+9D9o0n58IfBt0zUoAwe/f/BSZQ90x3glUFLlWdnbTCndE
	 nwPCT9OZYzash8/CI/S2eyygiSmcoYHxItqN64Rc=
Date: Sun, 06 Apr 2025 18:12:00 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,kasong@tencent.com,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-replace-cluster_swap_free_nr-with-swap_entries_put_.patch added to mm-new branch
Message-Id: <20250407011200.E7E6CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: replace cluster_swap_free_nr() with swap_entries_put_[map/cache]()
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-replace-cluster_swap_free_nr-with-swap_entries_put_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-replace-cluster_swap_free_nr-with-swap_entries_put_.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: replace cluster_swap_free_nr() with swap_entries_put_[map/cache]()
Date: Wed, 26 Mar 2025 00:25:28 +0800

Replace cluster_swap_free_nr() with swap_entries_put_[map/cache]() to
remove repeat code and leverage batch-remove for entries with last flag. 
After removing cluster_swap_free_nr, only functions with "_nr" suffix
could free entries spanning cross clusters.  Add corresponding description
in comment of swap_entries_put_map_nr() as is first function with "_nr"
suffix and have a non-suffix variant function swap_entries_put_map().

Link: https://lkml.kernel.org/r/20250325162528.68385-9-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

--- a/mm/swapfile.c~mm-swap-replace-cluster_swap_free_nr-with-swap_entries_put_
+++ a/mm/swapfile.c
@@ -1511,6 +1511,11 @@ locked_fallback:
 
 }
 
+/*
+ * Only functions with "_nr" suffix are able to free entries spanning
+ * cross multi clusters, so ensure the range is within a single cluster
+ * when freeing entries with functions without "_nr" suffix.
+ */
 static bool swap_entries_put_map_nr(struct swap_info_struct *si,
 				    swp_entry_t entry, int nr)
 {
@@ -1568,21 +1573,6 @@ static void swap_entries_free(struct swa
 		partial_free_cluster(si, ci);
 }
 
-static void cluster_swap_free_nr(struct swap_info_struct *si,
-		unsigned long offset, int nr_pages,
-		unsigned char usage)
-{
-	struct swap_cluster_info *ci;
-	unsigned long end = offset + nr_pages;
-
-	ci = lock_cluster(si, offset);
-	do {
-		swap_entry_put_locked(si, ci, swp_entry(si->type, offset),
-				      usage);
-	} while (++offset < end);
-	unlock_cluster(ci);
-}
-
 /*
  * Caller has made sure that the swap device corresponding to entry
  * is still around or has not been recycled.
@@ -1599,7 +1589,7 @@ void swap_free_nr(swp_entry_t entry, int
 
 	while (nr_pages) {
 		nr = min_t(int, nr_pages, SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
-		cluster_swap_free_nr(sis, offset, nr, 1);
+		swap_entries_put_map(sis, swp_entry(sis->type, offset), nr);
 		offset += nr;
 		nr_pages -= nr;
 	}
@@ -3645,11 +3635,13 @@ int swapcache_prepare(swp_entry_t entry,
 	return __swap_duplicate(entry, SWAP_HAS_CACHE, nr);
 }
 
+/*
+ * Caller should ensure entries belong to the same folio so
+ * the entries won't span cross cluster boundary.
+ */
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr)
 {
-	unsigned long offset = swp_offset(entry);
-
-	cluster_swap_free_nr(si, offset, nr, SWAP_HAS_CACHE);
+	swap_entries_put_cache(si, entry, nr);
 }
 
 struct swap_info_struct *swp_swap_info(swp_entry_t entry)
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-rename-__swap__free-to-swap__put.patch
mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref.patch
mm-swap-use-swap_entries_free-to-free-swap-entry-in-swap_entry_put_locked.patch
mm-swap-use-swap_entries_free-drop-last-ref-count-in-swap_entries_put_nr.patch
mm-swap-drop-last-swap_map_shmem-flag-in-batch-in-swap_entries_put_nr.patch
mm-swap-free-each-cluster-individually-in-swap_entries_put_map_nr.patch
mm-swap-factor-out-helper-to-drop-cache-of-entries-within-a-single-cluster.patch
mm-swap-replace-cluster_swap_free_nr-with-swap_entries_put_.patch

