Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463F7448B8C
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 23:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785887741; cv=none; b=DIGklsyIMf7T+Cj0NLH0VgxdSfG21QoxkkIMMmbX4ph+uYW6Q7rdW+5DOl6RgD0LwYq8Xan2pBdC7BoVIc+kuxwwT0JppuvIiixra1teu/lbduCMGiqx5y85CRsxeFYGJczx2s9NnlUCG8De0ElbIEqwhZmOlWEybq7zsDjRqaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785887741; c=relaxed/simple;
	bh=i8ggA6/77yYV2X21PMdr8LnzVZlGcINznywmEjA23iE=;
	h=Date:To:From:Subject:Message-Id; b=q8Grdd/Pv9g/6KjYNjRHyjYhsN482DcWiKzmjLNiFklsiIR6LP3RK2epDwyXpf977l9Qw0NkjeTsCCQ2TFQ6XT3OivMdQlU3P6xRJ3YibRVCMYl1VsNdoH0T8pivinzScHAsaQexsdGIA4lClwO1OuB+IbiyTxaYE7lxlc0cynA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QJ2MEyep; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QJ2MEyep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002C41F00A3F;
	Tue,  4 Aug 2026 23:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785887740;
	bh=ImcRxASVN0HQCNkowUDmSagKJp1q3C2YVXnCpedh88c=;
	h=Date:To:From:Subject;
	b=QJ2MEyepeXKdYdkgvkTU6GjVykkJvuWpnCHUTt9h1ARRsrXF4B3aGId3T/ahyQJ3E
	 Z1IJXDbmY+NSdUHR4S//zejk6xtyth52e1IxJHbbX07NeQ5n0QEC6Tl5pthMUCRgSO
	 36KyPLZH3qqqDx9qhK5UlQ9IO2RmBKs04LIk/ACE=
Date: Tue, 04 Aug 2026 16:55:39 -0700
To: mm-commits@vger.kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,liyouhong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failure-fix-refcount-leak-on-soft-offline-lbs-folio.patch removed from -mm tree
Message-Id: <20260804235540.002C41F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: fix refcount leak on soft-offline LBS folio
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-refcount-leak-on-soft-offline-lbs-folio.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: liyouhong <liyouhong@kylinos.cn>
Subject: mm/memory-failure: fix refcount leak on soft-offline LBS folio
Date: Mon, 3 Aug 2026 14:00:01 +0800

soft_offline_in_use_page() runs with a folio reference taken by
get_hwpoison_page() (or by the caller when MF_COUNT_INCREASED is set, e.g.
madvise(MADV_SOFT_OFFLINE)).

made soft-offline skip splitting when min_order_for_split() is non-zero,
so large-block-size folios stay intact.  That early return -EBUSY path
never drops the reference.

The other failure path is fine: try_to_split_thp_page(..., release=true)
puts the page when the split itself fails.  memory_failure() also puts
explicitly on its analogous unsplit path.

Split the new_order != 0 case out and folio_put() before returning.

Link: https://lore.kernel.org/20260803060001.800638-1-dayou5941@163.com
Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
Signed-off-by: liyouhong <liyouhong@kylinos.cn>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-refcount-leak-on-soft-offline-lbs-folio
+++ a/mm/memory-failure.c
@@ -2870,9 +2870,19 @@ static int soft_offline_in_use_page(stru
 		 * NOTE: if minimizing the number of soft offline pages is
 		 * preferred, split it to non-zero new_order like it is done in
 		 * memory_failure().
+		 *
+		 * Drop the ref from get_hwpoison_page()/MF_COUNT_INCREASED;
+		 * try_to_split_thp_page(..., release=true) does that itself
+		 * when the split fails.
 		 */
-		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
-						       /* release= */ true)) {
+		if (new_order) {
+			pr_info("%#lx: order-%d folio cannot soft offline\n",
+				pfn, new_order);
+			folio_put(folio);
+			return -EBUSY;
+		}
+		if (try_to_split_thp_page(page, /* new_order= */ 0,
+					 /* release= */ true)) {
 			pr_info("%#lx: thp split failed\n", pfn);
 			return -EBUSY;
 		}
_

Patches currently in -mm which might be from liyouhong@kylinos.cn are

mm-damon-ops-common-putback-folios-on-invalid-migrate-nid.patch

