Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1C21388
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247051; cv=none; b=WP8TjN5dw09SjAyEVAyI7eyy7shPGe+kSKq6CrGJO0laZA39fn3rNecBWwlk7sqXh/RBVHv4WNCcBVmnqWX9sBGNYRSELO1iQwRzDAjwgcF5qTM+VRChsLRWGtN7gURcYrdsBKA+NigrYF9jjW1JsJ46751Y2qMmv82QqVuU4cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247051; c=relaxed/simple;
	bh=YXz0MGnIqYqEpgzwx1TrrmFfuprSm62JbrBZrFi5ccs=;
	h=Date:To:From:Subject:Message-Id; b=AdrwNZ5oBQ1ZI6gNnWxlP0DbapG1rafBFLtWqwvddOqA4+Ml58WCGJxAqeEsY1SpwCjr1QYczp0UJia7bPPuvhBWplh5Am1ImMwE0CdSr3rOdctUrZ4lgeZCsZX8Ta3eoqxwSp8MfOK8NBFmIfyRYmIpaTTFH8ThuQFiKQ+O+ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hKoyBtMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hKoyBtMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD4CC4CEC3;
	Mon,  2 Sep 2024 03:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247051;
	bh=YXz0MGnIqYqEpgzwx1TrrmFfuprSm62JbrBZrFi5ccs=;
	h=Date:To:From:Subject:From;
	b=hKoyBtMTdOya+aMZnHZPyBD6QarPSAFoXx5gTPFp07Ou4i77Nr/O+jwidOTeMHGQ0
	 ASNXRlGIeDEx9rVlNrdmFfHDc0jj2JMGBlMDBCVWcv+QeqptKvVSx6Y/JbAsUTrHRi
	 IXfVFkPeV40pu2nSBMVjREsPTvVxzZhWVwVzP5Tg=
Date: Sun, 01 Sep 2024 20:17:30 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,ioworker0@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-override-mthp-enabled-defaults-at-kernel-cmdline-fix.patch removed from -mm tree
Message-Id: <20240902031731.5DD4CC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use get_oder() and check size is is_power_of_2
has been removed from the -mm tree.  Its filename was
     mm-override-mthp-enabled-defaults-at-kernel-cmdline-fix.patch

This patch was dropped because it was folded into mm-override-mthp-enabled-defaults-at-kernel-cmdline.patch

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: use get_oder() and check size is is_power_of_2
Date: Thu, 15 Aug 2024 10:34:16 +1200

Using get_order() is more robust according to Baolin.  It is also better
to filter illegal size such as 3KB, 16KB according to David.

Link: https://lkml.kernel.org/r/20240814224635.43272-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-override-mthp-enabled-defaults-at-kernel-cmdline-fix
+++ a/mm/huge_memory.c
@@ -929,14 +929,17 @@ static inline int get_order_from_str(con
 	int order;
 
 	size = memparse(size_str, &endptr);
-	order = fls(size >> PAGE_SHIFT) - 1;
-	if ((1 << order) & ~THP_ORDERS_ALL_ANON) {
-		pr_err("invalid size %s(order %d) in thp_anon boot parameter\n",
-			size_str, order);
-		return -EINVAL;
-	}
+
+	if (!is_power_of_2(size >> PAGE_SHIFT))
+		goto err;
+	order = get_order(size);
+	if ((1 << order) & ~THP_ORDERS_ALL_ANON)
+		goto err;
 
 	return order;
+err:
+	pr_err("invalid size %s in thp_anon boot parameter\n", size_str);
+	return -EINVAL;
 }
 
 static char str_dup[PAGE_SIZE] __meminitdata;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios.patch
mm-override-mthp-enabled-defaults-at-kernel-cmdline.patch
mm-rename-instances-of-swap_info_struct-to-meaningful-si.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix.patch
mm-count-the-number-of-anonymous-thps-per-size.patch
mm-count-the-number-of-partially-mapped-anonymous-thps-per-size.patch
mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios.patch
mm-document-__gfp_nofail-must-be-blockable.patch
mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner.patch

