Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16701E0DE8;
	Sat, 28 Mar 2026 00:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774658356; cv=none; b=euDFwn/8ivuQO41S8ToOwb1cGKcMKXBiI/fTjR9K9dYsuYQXQH8EvKOEMA+vIaTebd2ahpGvI3autfQTKA3x+x/Tjp6GXXTggBOXCCtq5/CMPjbHhi7tAo9HQuwbWYljqwdBWuFt95uHANbgjWbBHyqXglfnt6gW0180wnjWAHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774658356; c=relaxed/simple;
	bh=Xexa08A7/sbEpPFQZxx+Pm3eM8qp5K3G8FWjC9R0K7k=;
	h=Date:To:From:Subject:Message-Id; b=lNTS0sjAGVMILOJ4Zoc3EPTJ6HxIJjupcf54pYCAaahD+gxYI+glt4geTR/xWrQRrMPzkf09DKsk/QogvluqVn31hld0+qTaq2HkeRS7ptBKQRi2+f3iZX4F8K9pxNSHk23y9msbQ+jQNCfkMb1xf13qSkYmJHBeN/kzHweCy5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ps94T5+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ps94T5+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91535C19423;
	Sat, 28 Mar 2026 00:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774658356;
	bh=Xexa08A7/sbEpPFQZxx+Pm3eM8qp5K3G8FWjC9R0K7k=;
	h=Date:To:From:Subject:From;
	b=ps94T5+xdsweG675h+VcX9wpA0NFyKHj0dCaMTyI5LeiOpusad/egIUA2VbGppYfb
	 A+wEzIIaNR2TwFfLt4xO54ewnUFOg8ISGa70PPDPtCGbbpPEgksEuMULDhQr3V2jhz
	 pNTc5IQQVVN0iJS3dgPTHWq+ZPsoYe0Np/sTUC/8=
Date: Fri, 27 Mar 2026 17:39:16 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,alex@ghiti.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swap-fix-swap-cache-memcg-accounting.patch removed from -mm tree
Message-Id: <20260328003916.91535C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: fix swap cache memcg accounting
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-swap-cache-memcg-accounting.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexandre Ghiti <alex@ghiti.fr>
Subject: mm/swap: fix swap cache memcg accounting
Date: Fri, 20 Mar 2026 06:05:59 +0100

The swap readahead path was recently refactored and while doing this, the
order between the charging of the folio in the memcg and the addition of
the folio in the swap cache was inverted.

Since the accounting of the folio is done while adding the folio to the
swap cache and the folio is not charged in the memcg yet, the accounting
is then done at the node level, which is wrong.

Fix this by charging the folio in the memcg before adding it to the swap cache.

Link: https://lkml.kernel.org/r/20260320050601.1833108-1-alex@ghiti.fr
Fixes: 2732acda82c9 ("mm, swap: use swap cache as the swap in synchronize layer")
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Acked-by: Kairui Song <kasong@tencent.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/swap_state.c~mm-swap-fix-swap-cache-memcg-accounting
+++ a/mm/swap_state.c
@@ -494,6 +494,10 @@ static struct folio *__swap_cache_prepar
 
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
+
+	if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, entry))
+		goto failed;
+
 	for (;;) {
 		ret = swap_cache_add_folio(folio, entry, &shadow);
 		if (!ret)
@@ -514,11 +518,6 @@ static struct folio *__swap_cache_prepar
 			goto failed;
 	}
 
-	if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, entry)) {
-		swap_cache_del_folio(folio);
-		goto failed;
-	}
-
 	memcg1_swapin(entry, folio_nr_pages(folio));
 	if (shadow)
 		workingset_refault(folio, shadow);
_

Patches currently in -mm which might be from alex@ghiti.fr are


