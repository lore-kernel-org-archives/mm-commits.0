Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CDB4A06
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 01:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758071166; cv=none; b=O4N1JLgBqomyW8pQ58hX8DDoRK2I0KX2f9LLijkDUDnxw2sfkIJYHJXni7r74UrexEv2la/UEkjLWFVVtpmup0/CPm5GixlSRryeBdNUJBlJsGFbaH+MJK15dCRdo9kqvOZr7fSbLGGMwdp5v2cj5fjy35OxD5R5SJgoiDGiSp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758071166; c=relaxed/simple;
	bh=zVTpizj8z1AhDwc4w1AR9rI8YQV8pCFfVA4+rmMTRfg=;
	h=Date:To:From:Subject:Message-Id; b=RXBA8v/mUTf+pb7AtEihMVkXX5iyO7ZLPdO8UdsoSxFcmo2nzy5AI8nDwPgoMWZPULIPRTzo071hsZYWx7UdKWMbAf/5n4Fgi/ar6mDu7HyOiu3hHvkA8UQzA2NTorvftP251dd2u/Nhd73FNKuOROxU7ckKmPnh0lt0VXmTLdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UxO6pGCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UxO6pGCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F06C4CEF9;
	Wed, 17 Sep 2025 01:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758071165;
	bh=zVTpizj8z1AhDwc4w1AR9rI8YQV8pCFfVA4+rmMTRfg=;
	h=Date:To:From:Subject:From;
	b=UxO6pGCCwnabuhj9CPlpCZ30fwKYCBCwW2FlyJuDtxZwPHh6q2mQI2o9038w0J4YL
	 kbhMdvG/QQrHopSHJZO2CS00SfahcXFaToJMzd8NuaarkNDEFP99R3Y4eBwy3W1xHW
	 wPzbVGI3O5wHCKDBq5JSfUTPvavsXR4AkQNmpt98=
Date: Tue, 16 Sep 2025 18:06:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio.patch added to mm-unstable branch
Message-Id: <20250917010605.B2F06C4CEF9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: remove redundant error handling for replacing folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio.patch

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
Subject: mm/shmem, swap: remove redundant error handling for replacing folio
Date: Wed, 17 Sep 2025 00:00:54 +0800

Shmem may replace a folio in the swap cache if the cached one doesn't fit
the swapin's GFP zone.  When doing so, shmem has already double checked
that the swap cache folio is locked, still has the swap cache flag set,
and contains the wanted swap entry.  So it is impossible to fail due to an
XArray mismatch.  There is even a comment for that.

Delete the defensive error handling path, and add a WARN_ON instead: if
that happened, something has broken the basic principle of how the swap
cache works, we should catch and fix that.

Link: https://lkml.kernel.org/r/20250916160100.31545-10-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio
+++ a/mm/shmem.c
@@ -2121,35 +2121,17 @@ static int shmem_replace_folio(struct fo
 	/* Swap cache still stores N entries instead of a high-order entry */
 	xa_lock_irq(&swap_mapping->i_pages);
 	for (i = 0; i < nr_pages; i++) {
-		void *item = xas_load(&xas);
-
-		if (item != old) {
-			error = -ENOENT;
-			break;
-		}
-
-		xas_store(&xas, new);
+		WARN_ON_ONCE(xas_store(&xas, new) != old);
 		xas_next(&xas);
 	}
-	if (!error) {
-		mem_cgroup_replace_folio(old, new);
-		shmem_update_stats(new, nr_pages);
-		shmem_update_stats(old, -nr_pages);
-	}
+
+	mem_cgroup_replace_folio(old, new);
+	shmem_update_stats(new, nr_pages);
+	shmem_update_stats(old, -nr_pages);
 	xa_unlock_irq(&swap_mapping->i_pages);
 
-	if (unlikely(error)) {
-		/*
-		 * Is this possible?  I think not, now that our callers
-		 * check both the swapcache flag and folio->private
-		 * after getting the folio lock; but be defensive.
-		 * Reverse old to newpage for clear and free.
-		 */
-		old = new;
-	} else {
-		folio_add_lru(new);
-		*foliop = new;
-	}
+	folio_add_lru(new);
+	*foliop = new;
 
 	folio_clear_swapcache(old);
 	old->private = NULL;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-use-unified-helper-for-swap-cache-look-up.patch
mm-swap-fix-swap-cache-index-error-when-retrying-reclaim.patch
mm-swap-check-page-poison-flag-after-locking-it.patch
mm-swap-always-lock-and-check-the-swap-cache-folio-before-use.patch
mm-swap-rename-and-move-some-swap-cluster-definition-and-helpers.patch
mm-swap-tidy-up-swap-device-and-cluster-info-helpers.patch
mm-swap-cleanup-swap-cache-api-and-add-kerneldoc.patch
mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio.patch
mm-swap-wrap-swap-cache-replacement-with-a-helper.patch
mm-swap-use-the-swap-table-for-the-swap-cache-and-switch-api.patch
mm-swap-mark-swap-address-space-ro-and-add-context-debug-check.patch
mm-swap-remove-contention-workaround-for-swap-cache.patch
mm-swap-implement-dynamic-allocation-of-swap-table.patch
mm-swap-use-a-single-page-for-swap-table-when-the-size-fits.patch

