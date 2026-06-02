Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575423B8D4A
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439046; cv=none; b=BH2Y+vOTX0JcmdPi/RRXbgFVDXY3gGzIy46QDNGOupoLAFRcN04xw1z61hOgqnu+h0BtPGvPoPrIfQcNE89ET54e8pQGwkDZr8PhgSwll86lHLOwBhX7HhUHADqRSh+Hen2jEXfyJPPK5i00OfAHFXMMDxBJaAdxSB2OxSS4Dr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439046; c=relaxed/simple;
	bh=CCxi6j1sEag/PN6q1Iv/CfCoEDTK7UPG+5iNYScRp1k=;
	h=Date:To:From:Subject:Message-Id; b=pLQPUgvSB/dVA/NEWAzFX+J2YxdgBRxd3HeBfEH7J7mWbbaP2H2Qtnmvb8PUbqqPByC0T9CJjWM3cZXyRTI4qMusRk41unyHhvYzCE0nstrdeXOXCFWVHNZaNBJbQ2Z0EmAAxLNwq+Mo2kWmFgcfS/50p8f9Ss1lH8MDXLOWfX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b6BzQfR3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b6BzQfR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8661F00893;
	Tue,  2 Jun 2026 22:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439045;
	bh=XboSt0UHdC3iPTRzo1FQmuPa+W5QXZ+NoZI5xFASuPk=;
	h=Date:To:From:Subject;
	b=b6BzQfR3mFiRJn7Tudyrf63mA5jAsMclXVvvcmNbdahfmIO05MqF5h6OATcNsI9wo
	 lXiLWJ8NxQYvl0kV0UXE355BtS2K92srrWpTak9DRDFO94Yvmy3CwB8KP2bj7SRTqL
	 YIpu5LR8hZdA2tq4udx+WZh3+xqr3GOsQQjYXlC0=
Date: Tue, 02 Jun 2026 15:24:04 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,leitao@debian.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-avoid-leaving-unused-extend-table-after-alloc-race.patch removed from -mm tree
Message-Id: <20260602222405.2A8661F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: avoid leaving unused extend table after alloc race
has been removed from the -mm tree.  Its filename was
     mm-swap-avoid-leaving-unused-extend-table-after-alloc-race.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: avoid leaving unused extend table after alloc race
Date: Wed, 13 May 2026 17:21:11 +0800

Allocating an extend table requires dropping the ci lock first.  While the
lock is dropped, a concurrent put can decrease the slot's swap count to a
value that is no longer maxed out, so the extend table is no longer
required.  The current allocation path still attach the new extend table
to the cluster anyway, leaving it unused.

The next maxed out count on the same cluster may still reuse the table,
and frees it properly.  But swapoff could leak it indeed.

To eliminate the waste, re-check under the ci lock that the extend table
is still needed before publishing it, and free the local allocation
otherwise.

Also close the check window by ensuring every count decrement that brings
a slot below SWP_TB_COUNT_MAX - 1 runs swap_extend_table_try_free(), not
just the MAX to MAX - 1 transition.  With this, a freshly published extend
table that becomes redundant due to a racing put is freed on the very next
decrement, restoring the invariant that an empty cluster never has a
non-NULL ci->extend_table.

The added overhead is ignorable.

[kasong@tencent.com: v2]
  Link: https://lore.kernel.org/20260515-swap-extend-table-fix-v2-1-833d72ad53e5@tencent.com
Link: https://lore.kernel.org/20260513-swap-extend-table-fix-v1-1-a71dea851fb3@tencent.com
Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap count")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Breno Leitao <leitao@debian.org>
Closes: https://lore.kernel.org/linux-mm/agG6Dp0umhs6O1SY@gmail.com/
Tested-by: Breno Leitao <leitao@debian.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   42 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 8 deletions(-)

--- a/mm/swapfile.c~mm-swap-avoid-leaving-unused-extend-table-after-alloc-race
+++ a/mm/swapfile.c
@@ -1443,8 +1443,10 @@ start_over:
 }
 
 static int swap_extend_table_alloc(struct swap_info_struct *si,
-				   struct swap_cluster_info *ci, gfp_t gfp)
+				   struct swap_cluster_info *ci,
+				   unsigned int ci_off, gfp_t gfp)
 {
+	int count;
 	void *table;
 
 	table = kzalloc(sizeof(ci->extend_table[0]) * SWAPFILE_CLUSTER, gfp);
@@ -1452,12 +1454,28 @@ static int swap_extend_table_alloc(struc
 		return -ENOMEM;
 
 	spin_lock(&ci->lock);
-	if (!ci->extend_table)
-		ci->extend_table = table;
-	else
-		kfree(table);
+	/*
+	 * Extend table allocation requires releasing ci lock first so it's
+	 * possible that the slot has been freed, no longer overflowed, or
+	 * a concurrent extend table allocation has already succeeded, so
+	 * the allocation is no longer needed.
+	 */
+	if (!cluster_table_is_alloced(ci))
+		goto out_free;
+	count = swp_tb_get_count(__swap_table_get(ci, ci_off));
+	if (count < (SWP_TB_COUNT_MAX - 1))
+		goto out_free;
+	if (ci->extend_table)
+		goto out_free;
+
+	ci->extend_table = table;
 	spin_unlock(&ci->lock);
 	return 0;
+
+out_free:
+	spin_unlock(&ci->lock);
+	kfree(table);
+	return 0;
 }
 
 int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
@@ -1472,7 +1490,7 @@ int swap_retry_table_alloc(swp_entry_t e
 		return 0;
 
 	ci = __swap_offset_to_cluster(si, offset);
-	ret = swap_extend_table_alloc(si, ci, gfp);
+	ret = swap_extend_table_alloc(si, ci, swp_cluster_offset(entry), gfp);
 
 	put_swap_device(si);
 	return ret;
@@ -1519,13 +1537,21 @@ static void __swap_cluster_put_entry(str
 		if (count == (SWP_TB_COUNT_MAX - 1)) {
 			ci->extend_table[ci_off] = 0;
 			__swap_table_set(ci, ci_off, __swp_tb_mk_count(swp_tb, count));
-			swap_extend_table_try_free(ci);
 		} else {
 			ci->extend_table[ci_off] = count;
 		}
 	} else {
 		__swap_table_set(ci, ci_off, __swp_tb_mk_count(swp_tb, --count));
 	}
+
+	/*
+	 * `SWP_TB_COUNT_MAX - 1` triggers extend table allocation. If the
+	 * count was above that, then the extend table is no longer needed,
+	 * so free it. And if we just put the count value from MAX - 1, it's
+	 * also possible that a pending dup just attached an extend table.
+	 */
+	if (unlikely(count == SWP_TB_COUNT_MAX - 2 || count == SWP_TB_COUNT_MAX - 1))
+		swap_extend_table_try_free(ci);
 }
 
 /**
@@ -1665,7 +1691,7 @@ restart:
 		if (unlikely(err)) {
 			if (err == -ENOMEM) {
 				spin_unlock(&ci->lock);
-				err = swap_extend_table_alloc(si, ci, GFP_ATOMIC);
+				err = swap_extend_table_alloc(si, ci, ci_off, GFP_ATOMIC);
 				spin_lock(&ci->lock);
 				if (!err)
 					goto restart;
_

Patches currently in -mm which might be from kasong@tencent.com are


