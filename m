Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F0C4CDE1;
	Mon, 29 Jan 2024 06:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706509202; cv=none; b=daEGcSef9uYQ03T9LPMCvWhyzMPcxw/hekYP4hgo7uMuKo9A1CF+Ymfngfh+uDSveTqIEKxTLQr3usRvccCrpFHcld3VkzrgZfubkKiyY6pdJVdKzNT3OhXoPppXHuxYUTWLW9lqc1bS0wuAMqkoI0421+aNHD6cR+pBI701F58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706509202; c=relaxed/simple;
	bh=WFrUlGyCYH1cPNQ795jmy4LwmAWrppI/AMvtGMgh634=;
	h=Date:To:From:Subject:Message-Id; b=nK9On0pEqgSaB9trmqzcmsjMxAIy+aATX7BtjTkcmJ+4jI0EpzPlcxRQ5XtVUkUCQ5/r30nZ4pZz9DPRhCK8pW1AxOo4MhxkmjgG5KIDQyidxmO3om2dhn8sAJ66rH8PNbexkak9BJqj/pCdWqtnjgIRN5c718fd2jBUiqIoXac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kBA3GuXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kBA3GuXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B2EC433F1;
	Mon, 29 Jan 2024 06:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706509202;
	bh=WFrUlGyCYH1cPNQ795jmy4LwmAWrppI/AMvtGMgh634=;
	h=Date:To:From:Subject:From;
	b=kBA3GuXphcDWfdeCVSnV+LskSlqYZKpQXNrQVwsBuVW+kISGXbL2N2QlEHQf1XtI2
	 MJD4EEY9aODkL6fZ6XybFlCwzH1fmABmtEWCVn61poisy+oJUbJZHtcnyKQPbFVYC/
	 7J5lH32vi/VUzqeFPl7PnZs8aAKhZJZWIeW/n1Do=
Date: Sun, 28 Jan 2024 22:19:58 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,stable@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,cerasuolodomenico@gmail.com,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-missing-folio-cleanup-in-writeback-race-path.patch added to mm-hotfixes-unstable branch
Message-Id: <20240129062001.C3B2EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: fix missing folio cleanup in writeback race path
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-fix-missing-folio-cleanup-in-writeback-race-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-missing-folio-cleanup-in-writeback-race-path.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: fix missing folio cleanup in writeback race path
Date: Thu, 25 Jan 2024 08:51:27 +0000

In zswap_writeback_entry(), after we get a folio from
__read_swap_cache_async(), we grab the tree lock again to check that the
swap entry was not invalidated and recycled.  If it was, we delete the
folio we just added to the swap cache and exit.

However, __read_swap_cache_async() returns the folio locked when it is
newly allocated, which is always true for this path, and the folio is
ref'd.  Make sure to unlock and put the folio before returning.

This was discovered by code inspection, probably because this path handles
a race condition that should not happen often, and the bug would not crash
the system, it will only strand the folio indefinitely.

Link: https://lkml.kernel.org/r/20240125085127.1327013-1-yosryahmed@google.com
Fixes: 04fc7816089c ("mm: fix zswap writeback race condition")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/zswap.c~mm-zswap-fix-missing-folio-cleanup-in-writeback-race-path
+++ a/mm/zswap.c
@@ -1442,6 +1442,8 @@ static int zswap_writeback_entry(struct
 	if (zswap_rb_search(&tree->rbroot, swp_offset(entry->swpentry)) != entry) {
 		spin_unlock(&tree->lock);
 		delete_from_swap_cache(folio);
+		folio_unlock(folio);
+		folio_put(folio);
 		return -ENOMEM;
 	}
 	spin_unlock(&tree->lock);
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated.patch
mm-zswap-fix-missing-folio-cleanup-in-writeback-race-path.patch
mm-swap-enforce-updating-inuse_pages-at-the-end-of-swap_range_free.patch
mm-zswap-remove-unnecessary-trees-cleanups-in-zswap_swapoff.patch
mm-zswap-remove-unused-tree-argument-in-zswap_entry_put.patch
x86-mm-delete-unused-cpu-argument-to-leave_mm.patch
x86-mm-clarify-prev-usage-in-switch_mm_irqs_off.patch

