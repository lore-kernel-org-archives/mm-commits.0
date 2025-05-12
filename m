Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4A31553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011037; cv=none; b=FBMR2nM+tLIaJiW+OssOW4zUXP+sfZTsMWcm2oppkk1AxVUZxwWV4mV0PNcd9spc9hB9r3t/1HvfDP4TqMBExVVDjFUyZuVQ5C/Cq7zvCIcZowe35H2NpIBYF4MuM/jBsLrKBvKx7c5XDpIp1os27Ki0esW+/8UHRGCQ5A9dwE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011037; c=relaxed/simple;
	bh=Y2J4G9shnScNCqTuXy5tSutZkZo4fb478sXmhtiHyv0=;
	h=Date:To:From:Subject:Message-Id; b=FD0A3SQYd3tWOhgK6QN7BzuEVfbRfV3eb7qsAbv8s4vaEdDIcnTl1YYlF/knvMlV6bJ93bAKMDXuwHbrl/w6d1pXsmXk99SxEs7Lh3K+eVUeRzTA9O03rCDw2ez8NJ1pW0aML+j6Gc9UeO6FFEnezcD4pLX5308wnZIdKsKVkDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IjYo0TeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IjYo0TeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF77FC4CEE4;
	Mon, 12 May 2025 00:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011037;
	bh=Y2J4G9shnScNCqTuXy5tSutZkZo4fb478sXmhtiHyv0=;
	h=Date:To:From:Subject:From;
	b=IjYo0TeEV/BXCm7o2ryxDaLLai+HRgAW5NUl4mqGJmFotyj1YUSLdN/gMTWkQxp60
	 icgRIvYZKteZ5+Kejwd4+z25FqND9r3dBSd0yzLJ7sd680hySqpLHwVWNVYQqcK7gG
	 KecDyFBEl2D3vu1zHEq3BxcDUIdw0jlUZRuw95NI=
Date: Sun, 11 May 2025 17:50:37 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,kasong@tencent.com,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-replace-cluster_swap_free_nr-with-swap_entries_put_.patch removed from -mm tree
Message-Id: <20250512005037.AF77FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: replace cluster_swap_free_nr() with swap_entries_put_[map/cache]()
has been removed from the -mm tree.  Its filename was
     mm-swap-replace-cluster_swap_free_nr-with-swap_entries_put_.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1520,6 +1520,11 @@ locked_fallback:
 
 }
 
+/*
+ * Only functions with "_nr" suffix are able to free entries spanning
+ * cross multi clusters, so ensure the range is within a single cluster
+ * when freeing entries with functions without "_nr" suffix.
+ */
 static bool swap_entries_put_map_nr(struct swap_info_struct *si,
 				    swp_entry_t entry, int nr)
 {
@@ -1581,21 +1586,6 @@ static void swap_entries_free(struct swa
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
@@ -1612,7 +1602,7 @@ void swap_free_nr(swp_entry_t entry, int
 
 	while (nr_pages) {
 		nr = min_t(int, nr_pages, SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
-		cluster_swap_free_nr(sis, offset, nr, 1);
+		swap_entries_put_map(sis, swp_entry(sis->type, offset), nr);
 		offset += nr;
 		nr_pages -= nr;
 	}
@@ -3658,11 +3648,13 @@ int swapcache_prepare(swp_entry_t entry,
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


