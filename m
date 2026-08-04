Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D11244AB8D
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 23:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785887791; cv=none; b=C5YSYZ29uCv0bteNmSIw+IqIkPjTVygeIPBr+5bfjUuMPpKUAq8rA83TSbIgdePLdWXemS3AxABzOMD2KytWQBlYToI18c5f32ldZm8Tq6WNuzavnnfUAgv0597PrzE2EuU9aKenlmrzZCzShh0oNdM2yjOkOQg39anrMzvjWz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785887791; c=relaxed/simple;
	bh=BrDUGYBirStaL4zYvqS7Zf9WecPyvHsWsmHl7WDQCkQ=;
	h=Date:To:From:Subject:Message-Id; b=HazZhbGCxZVhwj5vKXPfhAMYBpj2AcO25TSk+aDgHhBe43MpjOMc1tkbIjU8vR9lMtPjvPYKs3xvkWa6/CTc4a0fNHADy2q74Z4eRU8bwXDGkSLK7k3Xk5Sq0ZV71OjSe/DtrzwmAXWP9tvnMx5fvucOSzhxcz7zTMvQRucCmMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F7Kk4kUB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F7Kk4kUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B9F1F00A3D;
	Tue,  4 Aug 2026 23:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785887789;
	bh=xGi4hfNiBtwwQgzuBPDDOB88Q+58ZAj5UBiKaLaT+/Q=;
	h=Date:To:From:Subject;
	b=F7Kk4kUB7WiGDctoXnJ6hIWbjpmGuIBp8fT2gp/ALU3xm8I/skVAqrI3K62Eoe1YQ
	 io6/Ffcjxykg4KSNRs9VcCX4VzzQALZhi6lJx0HU9zxPNIrTXlRldrxBtV7iMWv+kI
	 YpTVKmoO5Tx7aMulsqItKrUSi6FbguIAcy0vNtjU=
Date: Tue, 04 Aug 2026 16:56:29 -0700
To: mm-commits@vger.kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,liyouhong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-refcount-leak-on-soft-offline-lbs-folio.patch added to mm-new branch
Message-Id: <20260804235629.C5B9F1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: fix refcount leak on soft-offline LBS folio
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-failure-fix-refcount-leak-on-soft-offline-lbs-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-fix-refcount-leak-on-soft-offline-lbs-folio.patch

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

mm-damon-ops-common-putback-folios-on-invalid-migrate-nid.patch
mm-memory-failure-fix-refcount-leak-on-soft-offline-lbs-folio.patch

