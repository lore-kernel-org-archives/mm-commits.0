Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B111428467B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126220; cv=none; b=ROVnx+m/ChFqQ8dW5R7RAzlarjcaaHq5VNAVxONHcBAdI12AYd9ZWh5ADg92itV5UeTTO96ShNerMAZAbXHHCWeBlR9JKKWkcbvnHrSk7e2ftuSKePguTjhM9qfWDCx0dv5NEtnSgZUNkWXujVmH16z4Gcsv6U8VkxZUFwSZp6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126220; c=relaxed/simple;
	bh=LGyAd7Go+ClJFzuvrJyFtDZnjIlIlr6T5Sc3SbpGnUU=;
	h=Date:To:From:Subject:Message-Id; b=uVk9R/uNgNskhQbWtMuort0p3SrcAehAfwhK9+IDWLQy2ji3MQWfFHilEd7rncYvcOG/PauGC/wc/4xZXU6N46emWhYV1AVb6QxG8E/BR2vr5SdvWyTjK5ze5bu5JcMDR6Jxcyxjly6jD8s6geiy5V5v2KmN8e7hnG7DGnKKQNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LhQBhJh/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LhQBhJh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827A9C4CEE3;
	Thu, 10 Jul 2025 05:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126220;
	bh=LGyAd7Go+ClJFzuvrJyFtDZnjIlIlr6T5Sc3SbpGnUU=;
	h=Date:To:From:Subject:From;
	b=LhQBhJh/T029Lj5bMEf3dgigtZo7wZ1G3q6DcO1eCghLllBm/SnqXS8j1eGo25dWO
	 K4H6B9yEyhfr2OJbvUTKfKdN31i6GqNHzAnrVw+HXnpy31sZBqFrji9Kix8Mcf4/En
	 Xx4j0W52KYF4uZtBx7Wn9t8BvJ8n6akYXAoBF5zc=
Date: Wed, 09 Jul 2025 22:43:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-tidy-up-swap_writeout.patch removed from -mm tree
Message-Id: <20250710054340.827A9C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: tidy up swap_writeout
has been removed from the -mm tree.  Its filename was
     mm-tidy-up-swap_writeout.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: tidy up swap_writeout
Date: Tue, 10 Jun 2025 07:49:39 +0200

Use a goto label to consolidate the unlock folio and return pattern and
don't bother with an else after a return / goto.

Link: https://lkml.kernel.org/r/20250610054959.2057526-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/mm/page_io.c~mm-tidy-up-swap_writeout
+++ a/mm/page_io.c
@@ -239,12 +239,11 @@ static void swap_zeromap_folio_clear(str
  */
 int swap_writeout(struct folio *folio, struct writeback_control *wbc)
 {
-	int ret;
+	int ret = 0;
+
+	if (folio_free_swap(folio))
+		goto out_unlock;
 
-	if (folio_free_swap(folio)) {
-		folio_unlock(folio);
-		return 0;
-	}
 	/*
 	 * Arch code may have to preserve more data than just the page
 	 * contents, e.g. memory tags.
@@ -252,8 +251,7 @@ int swap_writeout(struct folio *folio, s
 	ret = arch_prepare_to_swap(folio);
 	if (ret) {
 		folio_mark_dirty(folio);
-		folio_unlock(folio);
-		return ret;
+		goto out_unlock;
 	}
 
 	/*
@@ -264,20 +262,19 @@ int swap_writeout(struct folio *folio, s
 	 */
 	if (is_folio_zero_filled(folio)) {
 		swap_zeromap_folio_set(folio);
-		folio_unlock(folio);
-		return 0;
-	} else {
-		/*
-		 * Clear bits this folio occupies in the zeromap to prevent
-		 * zero data being read in from any previous zero writes that
-		 * occupied the same swap entries.
-		 */
-		swap_zeromap_folio_clear(folio);
+		goto out_unlock;
 	}
+
+	/*
+	 * Clear bits this folio occupies in the zeromap to prevent zero data
+	 * being read in from any previous zero writes that occupied the same
+	 * swap entries.
+	 */
+	swap_zeromap_folio_clear(folio);
+
 	if (zswap_store(folio)) {
 		count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
-		folio_unlock(folio);
-		return 0;
+		goto out_unlock;
 	}
 	if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
 		folio_mark_dirty(folio);
@@ -286,6 +283,9 @@ int swap_writeout(struct folio *folio, s
 
 	__swap_writepage(folio, wbc);
 	return 0;
+out_unlock:
+	folio_unlock(folio);
+	return ret;
 }
 
 static inline void count_swpout_vm_event(struct folio *folio)
_

Patches currently in -mm which might be from hch@lst.de are


