Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A56231845
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343235; cv=none; b=XZ1hAVtyScw4PJ7HusdwHgxgDeNjkqvme80vUCCvETod20/1FYgMttqn/OiqSLXaM4euY2phNJxy+ABFN23o/u6loIPCQeTw/FNN/nojzYwBkpiP/JhsCaq6ojdEimTdbwQhKFeoPHF8qEGUjBPR6i23mRGKIqFJbNe02ix8gxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343235; c=relaxed/simple;
	bh=nyzBryBP1774imdPOfnFQlphrgk32A0s2YblMlAL9Dg=;
	h=Date:To:From:Subject:Message-Id; b=U5yGksNvAUpFh1rEdiBNAfUgqNGogeJabaTIjsBvbkhenFD2DI+XGlRKe8MVk2HZHfkaBk4GxZy6OJ1HAJCLt9zjDeIULuDv2l2Z8fBMoWETBFPf4kdEh/y5DbLc6MB05qX3pF9Cb4MfvJEwrrTAg4P/bqJroTVNHG0WvGgh5aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xaF/C5/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xaF/C5/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA3CC4CEF1;
	Mon, 17 Nov 2025 01:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343234;
	bh=nyzBryBP1774imdPOfnFQlphrgk32A0s2YblMlAL9Dg=;
	h=Date:To:From:Subject:From;
	b=xaF/C5/kqZ43KnSRH9AL+ykI5BApYxg1stECFz91tOePuh7SrJfmRWsWJBamrV0N/
	 RfO54K1ZNcAcqdaiONu/F+MJRdlgGgjyZgHRaj1xI/m5oENMVlG94sbRd3ITdzTndy
	 abxxhtHYTFDaR9+YOwpXVFFCuEyzUHcljdJfPTQs=
Date: Sun, 16 Nov 2025 17:33:53 -0800
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-rename-helper-for-setup-bad-slots.patch removed from -mm tree
Message-Id: <20251117013354.7BA3CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: rename helper for setup bad slots
has been removed from the -mm tree.  Its filename was
     mm-swap-rename-helper-for-setup-bad-slots.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: rename helper for setup bad slots
Date: Fri, 24 Oct 2025 02:00:40 +0800

The name inc_cluster_info_page is very confusing, as this helper is only
used during swapon to mark bad slots.  Rename it properly and turn the
VM_BUG_ON in it into WARN_ON to expose more potential issues.  Swapon is a
cold path, so adding more checks should be a good idea.

No feature change except new WARN_ON.

Link: https://lkml.kernel.org/r/20251024-swap-clean-after-swap-table-p1-v2-2-a709469052e7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/swapfile.c~mm-swap-rename-helper-for-setup-bad-slots
+++ a/mm/swapfile.c
@@ -751,14 +751,14 @@ static void relocate_cluster(struct swap
 }
 
 /*
- * The cluster corresponding to page_nr will be used. The cluster will not be
- * added to free cluster list and its usage counter will be increased by 1.
- * Only used for initialization.
+ * The cluster corresponding to @offset will be accounted as having one bad
+ * slot. The cluster will not be added to the free cluster list, and its
+ * usage counter will be increased by 1. Only used for initialization.
  */
-static int inc_cluster_info_page(struct swap_info_struct *si,
-	struct swap_cluster_info *cluster_info, unsigned long page_nr)
+static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster_info,
+				       unsigned long offset)
 {
-	unsigned long idx = page_nr / SWAPFILE_CLUSTER;
+	unsigned long idx = offset / SWAPFILE_CLUSTER;
 	struct swap_table *table;
 	struct swap_cluster_info *ci;
 
@@ -772,8 +772,8 @@ static int inc_cluster_info_page(struct
 
 	ci->count++;
 
-	VM_BUG_ON(ci->count > SWAPFILE_CLUSTER);
-	VM_BUG_ON(ci->flags);
+	WARN_ON(ci->count > SWAPFILE_CLUSTER);
+	WARN_ON(ci->flags);
 
 	return 0;
 }
@@ -3396,7 +3396,7 @@ static struct swap_cluster_info *setup_c
 	 * See setup_swap_map(): header page, bad pages,
 	 * and the EOF part of the last cluster.
 	 */
-	err = inc_cluster_info_page(si, cluster_info, 0);
+	err = swap_cluster_setup_bad_slot(cluster_info, 0);
 	if (err)
 		goto err;
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
@@ -3404,12 +3404,12 @@ static struct swap_cluster_info *setup_c
 
 		if (page_nr >= maxpages)
 			continue;
-		err = inc_cluster_info_page(si, cluster_info, page_nr);
+		err = swap_cluster_setup_bad_slot(cluster_info, page_nr);
 		if (err)
 			goto err;
 	}
 	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {
-		err = inc_cluster_info_page(si, cluster_info, i);
+		err = swap_cluster_setup_bad_slot(cluster_info, i);
 		if (err)
 			goto err;
 	}
_

Patches currently in -mm which might be from kasong@tencent.com are


