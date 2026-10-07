Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABD1296BAF
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334140; cv=none; b=Kh6B/mjf1Iyvuih1dBoI4BkFrwslj1yl7ggw2nWq41i2V4fyDXu5TxJk+ix+kaCvvkfSy99geVgu+K6p0BRCmBxOgAy/12ayTonQZaq1WhJCew/1EgzwhYgJWh+IlE02/Ps6IbCooLiT8bldqA9cTVjDeRq5/v+uQbQvc+7koA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334140; c=relaxed/simple;
	bh=uW49w28KiopNthTjkx7V0+I1ygNcLrGzNDTvPlCZbow=;
	h=Date:To:From:Subject:Message-Id; b=ntDf10uQVeSvCrVLpajPqQ2xrS5TSVmI4ajkX8j1CU5pKINKKxOvN4/Tu0FTQatszXyX+duDZckuxYrVK0kcgUIi6eceUlVBiwlLftRCstRicDmNkVzys8/EQtvXtLtgl1ZG3nYb9Y5qMVhX1IBNFHfc/TANS3KOcBhnlbUewq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G7SIA2tC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G7SIA2tC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8F81F0089B;
	Wed,  7 Oct 2026 00:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334138;
	bh=ieEx5UMrGa5tLWuidbCcV/Iz25k1e8BE/v1sQPWVnc4=;
	h=Date:To:From:Subject;
	b=G7SIA2tCcbx8x6TVfiQHh7LruErjE3ykNixPlJA1YDQ89pPWo1sVTx1SNDs1jR6U6
	 qykmik1e7/TLoPuK+bTmIW0ypL/kBWguYFKcypF4q6oeXKTOXn9lZ1gqr+z3QjfNtS
	 8+NYuDnrqZk+cNSxlzAbad0TfUbzUbmK5yxMZzp4=
Date: Tue, 06 Oct 2026 17:48:58 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shikemeng@huaweicloud.com,sef1548@gmail.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,yuehaibing@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-unused-declaration-swapcache_clear.patch removed from -mm tree
Message-Id: <20261007004858.BF8F81F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: remove unused declaration swapcache_clear()
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-unused-declaration-swapcache_clear.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yue Haibing <yuehaibing@huawei.com>
Subject: mm/swap: remove unused declaration swapcache_clear()
Date: Thu, 27 Aug 2026 16:27:22 +0800

Commit c246d236b18b ("mm/shmem: never bypass the swap cache for
SWP_SYNCHRONOUS_IO") removed the implementations but leave this.

Link: https://lore.kernel.org/20260827082722.1809702-1-yuehaibing@huawei.com
Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Acked-by: Kairui Song <kasong@tencent.com>
Acked-by: Nick Huang <sef1548@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
---

 mm/swap.h |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swap.h~mm-swap-remove-unused-declaration-swapcache_clear
+++ a/mm/swap.h
@@ -324,7 +324,6 @@ void __swap_cache_replace_folio(struct s
 				struct folio *old, struct folio *new);
 
 void show_swap_cache_info(void);
-void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
 struct folio *read_swap_cache_async(struct swap_io_ctx *ctx, swp_entry_t entry,
 		gfp_t gfp_mask, struct vm_area_struct *vma, unsigned long addr);
 struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
_

Patches currently in -mm which might be from yuehaibing@huawei.com are


