Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658BA17DFFA
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 00:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789085876; cv=none; b=FTvpsTDKfYDn7K0pJ/gPGZeMpoPFKEQJ8h4BrfmqHyveGgpPzof3FqMWlPbi+AfHqwb1s/rf8SAhLzm9jDC0KLtHGq58mjo9F9LHbyWXWT+kBj8a+6/NYLbh0gZwDLyIpCOrJsRnfI3sRni17QUTmD5sYB8kLKJfGbiSNLPj3Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789085876; c=relaxed/simple;
	bh=4sIxhoqjobS38qvoMUzC3kmyNuhBXD49PjcCPzAef6s=;
	h=Date:To:From:Subject:Message-Id; b=iBlb90oxxxs1I8C51g8ceAVyy517gUoBPKUZLCBDNdYW8fWc557pBYcnYXiZmRQPIUAq1OD5ASf76O8C1bNThZJzzfQ33FpqKjCbYfncq+L6uzdurkHjyVvFoe/Nk6ekFYuLtzpCR06+zSSFvzHAggWiRNLuob7kDLr+RVvBGfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MdlfmQTT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MdlfmQTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D628C1F000FF;
	Fri, 11 Sep 2026 00:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789085874;
	bh=kDYpHrL9YRzhxcLmENegPov1S9BidUanlqHCpoIPbus=;
	h=Date:To:From:Subject;
	b=MdlfmQTTll2BiU3cpZQWHcSZSLkS5yiNarsyzvoaRE8CuYPXk9+1Khg32RnM7TAgB
	 QttDb703gw937ki6K2mNDxBcjlPb9Mdc8xSKpodet+ftSzCKCMfxbvT+H0LEJ+R3vi
	 iIMNq8Bg4IOQQj9pLE31/s0zpxRKQMOmDfjFCJyg=
Date: Thu, 10 Sep 2026 17:17:54 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,nphamcs@gmail.com,luizcap@redhat.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-return-early-from-swap_extend_table_try_free-on-first-non-zero-entry.patch added to mm-new branch
Message-Id: <20260911001754.D628C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: return early from swap_extend_table_try_free() on first non-zero entry
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-return-early-from-swap_extend_table_try_free-on-first-non-zero-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-return-early-from-swap_extend_table_try_free-on-first-non-zero-entry.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm, swap: return early from swap_extend_table_try_free() on first non-zero entry
Date: Mon, 7 Sep 2026 17:13:55 +0800

Return immediately when the first non-zero swap count is found as any
non-zero swap count prevents freeing extend_table and further iteration is
pointless.

Link: https://lore.kernel.org/20260907091356.53026-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/swapfile.c~mm-swap-return-early-from-swap_extend_table_try_free-on-first-non-zero-entry
+++ a/mm/swapfile.c
@@ -1523,20 +1523,17 @@ int swap_retry_table_alloc(swp_entry_t e
 static void swap_extend_table_try_free(struct swap_cluster_info *ci)
 {
 	unsigned long i;
-	bool can_free = true;
 
 	if (!ci->extend_table)
 		return;
 
 	for (i = 0; i < SWAPFILE_CLUSTER; i++) {
 		if (ci->extend_table[i])
-			can_free = false;
+			return;
 	}
 
-	if (can_free) {
-		kfree(ci->extend_table);
-		ci->extend_table = NULL;
-	}
+	kfree(ci->extend_table);
+	ci->extend_table = NULL;
 }
 
 /* Decrease the swap count of one slot, without freeing it */
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-fix-potential-null-dereference-when-trying-a-sleep-table-allocation.patch
mm-swap-move-setup_swap_clusters_info-after-swp_solidstate-initialization.patch
mm-swap-return-early-from-swap_extend_table_try_free-on-first-non-zero-entry.patch
mm-swap-remove-unneeded-swap_extend_table_try_free-in-swap_dup_entries_cluster.patch

