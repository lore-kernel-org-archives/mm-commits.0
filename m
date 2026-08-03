Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824DF3264EF
	for <mm-commits@vger.kernel.org>; Mon,  3 Aug 2026 22:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785794873; cv=none; b=A2cG0f5eY5r8w2OCgJDgs6M2qYziGulzOrWl5rHR4hM9ZQDlXMQ6gdgXflAE5mC68BjDbd64MsPkrb18tAT8CuEIP2cFI2SOllawt/INoH4SKpRW0TabA0SMaSnEnDWRx5xAuTFt2Yq+IvQqg8LVsaa2svLBhetifuejgngD+4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785794873; c=relaxed/simple;
	bh=wDXpkh4KsDoJD5JLrIxpgExOltoR2e++1XCXY48HKNs=;
	h=Date:To:From:Subject:Message-Id; b=Hx8An6+hZK+pZZCD4i0/cQOaQq1+rIYxw93JVjplGm9Ks8/oaxU6nx/HuLmph5zAyf/Be9nakocnJ6DV2AfzF1SV18DKqou28hbj8vA7od3hnwQcFtkfl/Xb1ZwO3h3akW9rLMguT2mWgvBEyuXaE8q7lKwOhycxqL966aa1dXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zOkfkDXj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zOkfkDXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CE21F000E9;
	Mon,  3 Aug 2026 22:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785794870;
	bh=tOSd9VSUUqRHFcBEshqY2BVF/KbIdqrfohnBFXe07c8=;
	h=Date:To:From:Subject;
	b=zOkfkDXjBMOfbO5gon90DjQNX9tmxzHFJSniR7LapXRc9sAOlQNIogOl+d425WPZj
	 XB9+ub2coeoAyvTiRoYUnbrLc4/LsJN7+PhGxwTolUv+ybomixxE8WWurLwGdtTFM7
	 OGPDdRgceRtZXbOli75ga/hsTKOQJqc55R5QhJs8=
Date: Mon, 03 Aug 2026 15:07:50 -0700
To: mm-commits@vger.kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,liyouhong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-refcount-leak-on-soft-offline-lbs-folio.patch added to mm-new branch
Message-Id: <20260803220750.D2CE21F000E9@smtp.kernel.org>
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
mm-memory-failure-fix-refcount-leak-on-soft-offline-lbs-folio.patch

