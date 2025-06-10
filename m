Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CB027472
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 21:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749589730; cv=none; b=BWoXr/6tfB7QB/AlHJIPjPZyf2Mz2nWRbOtFimx48JX8m347uBLCo0mRPczgsel+eAPK4Saw0YfSIhdVekF9O7ljObcawKptZScWDw1fTBosaPgvWjGIVmXfIPNersVWCuRZQaM6SMmX1agPKw2CmoMUcpGNq3BRWwskfqtXhGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749589730; c=relaxed/simple;
	bh=0U53gFHsh7E6x0W8NJhd9NXermDyxqzKsmSqZokevKs=;
	h=Date:To:From:Subject:Message-Id; b=it51Y2An5yL07VCdhEa+i2FnUQZfHlmn4sLoiqQBcLEiEwPnyD8E+qhhuU81xRp9Pf3pUaSNTw5JCOhVNiXTKqpcEaWNYsDvvfaWCCUpWQjxtExmDdFmxR1FyLK+1wGKTrQx+pHlybB+YHzQMkJZlyySk/r4llvHPkeEiP67rM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1pOKD2Jx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1pOKD2Jx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D111C4CEED;
	Tue, 10 Jun 2025 21:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749589730;
	bh=0U53gFHsh7E6x0W8NJhd9NXermDyxqzKsmSqZokevKs=;
	h=Date:To:From:Subject:From;
	b=1pOKD2Jx/mXSrkdoD5hO7iMPJqHwq5nfI6zCCFcemCqFgCYXfvzQblcJ2IPYdOA5B
	 fnBA2mY3ocDbMLFlRqfQhuDad5ZLariUjmFWtG7zNQH+R9a+2HiD4sV5LKAC8CVdXs
	 jUJn60xiTEHZ9SVn4SQI8X0vysg6MB6F4e2fcQEA=
Date: Tue, 10 Jun 2025 14:08:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-tidy-up-swap_writeout.patch added to mm-unstable branch
Message-Id: <20250610210850.3D111C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: tidy up swap_writeout
has been added to the -mm mm-unstable branch.  Its filename is
     mm-tidy-up-swap_writeout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-tidy-up-swap_writeout.patch

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

mm-split-out-a-writeout-helper-from-pageout.patch
mm-stop-passing-a-writeback_control-structure-to-shmem_writeout.patch
mm-tidy-up-swap_writeout.patch
mm-stop-passing-a-writeback_control-structure-to-__swap_writepage.patch
mm-stop-passing-a-writeback_control-structure-to-swap_writeout.patch
mm-remove-the-for_reclaim-field-from-struct-writeback_control.patch

