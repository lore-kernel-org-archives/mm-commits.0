Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BE01553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011036; cv=none; b=byJBKeH1iGP3iDisVoWpC1zpkJNBZ4DZmEF/GxFC61ZHeRJdirB1LTIfpaA0BIw4Vd9x0suSF5mvhPrNA9XPdi6WqJnj5tYB0jrUeFm9PfkugsRXJi2uMG8KQKVKCrYsNFxcu9Kq+C7ENh91AJI3MWYlH9/nR43mHD2kfTxo2Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011036; c=relaxed/simple;
	bh=cQMk2F22Ntau+lX1WxGCowzURWT1+60wN3HfCcYrKtU=;
	h=Date:To:From:Subject:Message-Id; b=Ja3OB2xQrK+60VoXuP80xeR8fZ43McKilRJ7neciBaCADItqdyWPAG6PiSiFE9KhiynfVPA2u36pmNYTpjrEp+huFMGc9JgfwCS334PNyRLb5XovLSvHbwWoMNsh0kQyG2wsG9Si6AOOkOGqLH0tOrY4JGKFTnZtdZOsyjMsZl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wQ9wESQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wQ9wESQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDD9C4CEE4;
	Mon, 12 May 2025 00:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011036;
	bh=cQMk2F22Ntau+lX1WxGCowzURWT1+60wN3HfCcYrKtU=;
	h=Date:To:From:Subject:From;
	b=wQ9wESQUl9ksEy3x1X5l3e9XciaR5+rNUEIzo/iz9GjCGbodcJXyLyO+2kUrLi8B+
	 WzBBl223I3pPiDK/cEb0sG2yWbXqrPjRbYeBSvG7tuwyUKM4rkC9b9a3v5UttMLeaT
	 0hRgIOVC7Ogkjt5OPzx7Ja08vA7QLQcpcIPPfnfA=
Date: Sun, 11 May 2025 17:50:36 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,kasong@tencent.com,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-factor-out-helper-to-drop-cache-of-entries-within-a-single-cluster.patch removed from -mm tree
Message-Id: <20250512005036.8BDD9C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: factor out helper to drop cache of entries within a single cluster
has been removed from the -mm tree.  Its filename was
     mm-swap-factor-out-helper-to-drop-cache-of-entries-within-a-single-cluster.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: factor out helper to drop cache of entries within a single cluster
Date: Wed, 26 Mar 2025 00:25:27 +0800

Factor out helper swap_entries_put_cache() from put_swap_folio() to serve
as a general-purpose routine for dropping cache flag of entries within a
single cluster.

Link: https://lkml.kernel.org/r/20250325162528.68385-8-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/mm/swapfile.c~mm-swap-factor-out-helper-to-drop-cache-of-entries-within-a-single-cluster
+++ a/mm/swapfile.c
@@ -1463,6 +1463,22 @@ put_out:
 	return NULL;
 }
 
+static void swap_entries_put_cache(struct swap_info_struct *si,
+				   swp_entry_t entry, int nr)
+{
+	unsigned long offset = swp_offset(entry);
+	struct swap_cluster_info *ci;
+
+	ci = lock_cluster(si, offset);
+	if (swap_only_has_cache(si, offset, nr))
+		swap_entries_free(si, ci, entry, nr);
+	else {
+		for (int i = 0; i < nr; i++, entry.val++)
+			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
+	}
+	unlock_cluster(ci);
+}
+
 static bool swap_entries_put_map(struct swap_info_struct *si,
 				 swp_entry_t entry, int nr)
 {
@@ -1607,8 +1623,6 @@ void swap_free_nr(swp_entry_t entry, int
  */
 void put_swap_folio(struct folio *folio, swp_entry_t entry)
 {
-	unsigned long offset = swp_offset(entry);
-	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
 	int size = 1 << swap_entry_order(folio_order(folio));
 
@@ -1616,14 +1630,7 @@ void put_swap_folio(struct folio *folio,
 	if (!si)
 		return;
 
-	ci = lock_cluster(si, offset);
-	if (swap_only_has_cache(si, offset, size))
-		swap_entries_free(si, ci, entry, size);
-	else {
-		for (int i = 0; i < size; i++, entry.val++)
-			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
-	}
-	unlock_cluster(ci);
+	swap_entries_put_cache(si, entry, size);
 }
 
 int __swap_count(swp_entry_t entry)
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


