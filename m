Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAC03515D5
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 04:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785990262; cv=none; b=RFTvGQ06ov/8RMiQJYZWTeHbFiMxPPH4Ek02S+BhVspF2rxOrcIvijZH4cTuR/QKL2HjGyyY/xfGYk+DqflFXjAMpW7q3gCzpn4KRRi7FD5iFOg6fbHeZbTcDhnRopvjRPQLeLqq6QYfbWFwqj0Uv/zpFBrwStmYWZ36xvg1MG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785990262; c=relaxed/simple;
	bh=s0EfMyyjqX9C/Q8pfTchWWguHk2bCRKP6uPGvL2C8CI=;
	h=Date:To:From:Subject:Message-Id; b=HxBPnw7oJSdBS7ABMp8IVtht54m/pbMjazYgUxx804pTrtuyAIqufOwnmqrgy5y4/Y0hzCu03du7Uofn3lIXHQdnPpqYDdzNiJo/oTvv0D34kdVgK2JQM0ZzIkctSSPRbfGaOBLiBwyg7GgqQiE559q7PlVrVbz+nYIIvKZMzJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xQ4hfC9I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xQ4hfC9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C6C1F000E9;
	Thu,  6 Aug 2026 04:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785990261;
	bh=bUVl0lWAG6Vt2nlLgxZmX9xV1iirds85dWNiRzE1mMQ=;
	h=Date:To:From:Subject;
	b=xQ4hfC9Ig66fwBpB4OGG5tHNcWkqvkgzdAIfpz8Ojkv07ciNmZjetyLUEqVenRJFg
	 CBoghoU85PnuFZjhkcxv7lpqhzc651igNqtTVQyJAfvmr8Eo17XwcfsN2MVL0ssSpg
	 h/nM2Ba98jzdJKktPucT82vuVkRGRKwGiPU8u5G8=
Date: Wed, 05 Aug 2026 21:24:20 -0700
To: mm-commits@vger.kernel.org,liyouhong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failure-fix-refcount-leak-on-soft-offline-lbs-folio.patch removed from -mm tree
Message-Id: <20260806042420.E6C6C1F000E9@smtp.kernel.org>
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
Date: Tue, 4 Aug 2026 11:53:56 +0800

soft_offline_in_use_page() runs with a folio reference taken by
get_hwpoison_page().

Soft-offline skips splitting when min_order_for_split() is non-zero, so
large folios stay intact.  That early return -EBUSY path never drops the
reference.

The other failure path is fine: try_to_split_thp_page(..., release=true)
puts the page when the split itself fails.  memory_failure() also puts
explicitly on its analogous unsplit path.

Handle the new_order != 0 case separately and call folio_put() before
returning.

Link: https://lore.kernel.org/20260804035356.2615408-1-dayou5941@163.com
Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
Signed-off-by: liyouhong <liyouhong@kylinos.cn>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-refcount-leak-on-soft-offline-lbs-folio
+++ a/mm/memory-failure.c
@@ -2845,6 +2845,9 @@ EXPORT_SYMBOL(unpoison_memory);
  * soft_offline_in_use_page handles hugetlb-pages and non-hugetlb pages.
  * If the page is a non-dirty unmapped page-cache page, it simply invalidates.
  * If the page is mapped, it migrates the contents over.
+ *
+ * The folio refcount has been incremented before entering this function.
+ * This folio reference must be released before the function returns on all paths.
  */
 static int soft_offline_in_use_page(struct page *page)
 {
@@ -2870,9 +2873,19 @@ static int soft_offline_in_use_page(stru
 		 * NOTE: if minimizing the number of soft offline pages is
 		 * preferred, split it to non-zero new_order like it is done in
 		 * memory_failure().
+		 *
+		 * Drop the reference obtained upon entry;
+		 * try_to_split_thp_page(..., release=true) handles refcounting itself
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


