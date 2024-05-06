Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE72238FB9
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957138; cv=none; b=cC/LBECLAc0Y1w+MTkftzTtVzDYWhtvMRMqkJpiPQTpy8vmc+HKggJ7ytMMF+oTrCOC5s3c/hkCa63HRFJOdA/ipwR+TvNgfd4gZRG6zCIOrEhIovhAcva5pim3ds37bhg1SqQJNM0gp7iJunQTkF2ZHVt1hgGxxYrk1VWoh45I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957138; c=relaxed/simple;
	bh=qizOVJhsDdUS2rBY3McBW1aDXEupeCQ67QrdF1lScDw=;
	h=Date:To:From:Subject:Message-Id; b=BM8sQoDXHCLGr4Po7/8ZDU4gu/MAxwdEkJdE6l8OSKc/RpZGJV+qjh9GYWD1qyHZ7Yob50EUqjnQRXGBCHxeYA8i3AY+SpcxTDFyhlJ4kFizAq/0iMpTyYE8ipC88EQM3vXDEHonqlykC00JaaAFgs4FbacZjL/Wuyor+w40owI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TngKDwba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TngKDwba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956CBC113CC;
	Mon,  6 May 2024 00:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957138;
	bh=qizOVJhsDdUS2rBY3McBW1aDXEupeCQ67QrdF1lScDw=;
	h=Date:To:From:Subject:From;
	b=TngKDwba3Gvddo7iOw7tIi7d44g7LBUnDWxLBsh+h+OHb32r7JxiEUMDvPZ4QZycy
	 IywfEi4lvebbo1qFYqyV1mdzRRVh53K+WxQ32k6LnnfkZ5tq4s77i5o+NVpKTkGUVe
	 S7wzTouFp5fE8MlWQGvAURD5yfC5DMYX6Q/z7Tzw=
Date: Sun, 05 May 2024 17:58:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-change-the-type-of-we_locked-from-int-to-bool.patch removed from -mm tree
Message-Id: <20240506005858.956CBC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: change the type of we_locked from int to bool
has been removed from the -mm tree.  Its filename was
     mm-rmap-change-the-type-of-we_locked-from-int-to-bool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/rmap: change the type of we_locked from int to bool
Date: Sun, 28 Apr 2024 09:20:48 +0800

Change the type of we_locked from int to bool because folio_trylock return
bool

Link: https://lkml.kernel.org/r/20240428012049.8182-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-change-the-type-of-we_locked-from-int-to-bool
+++ a/mm/rmap.c
@@ -964,7 +964,7 @@ static bool invalid_folio_referenced_vma
 int folio_referenced(struct folio *folio, int is_locked,
 		     struct mem_cgroup *memcg, unsigned long *vm_flags)
 {
-	int we_locked = 0;
+	bool we_locked = false;
 	struct folio_referenced_arg pra = {
 		.mapcount = folio_mapcount(folio),
 		.memcg = memcg,
_

Patches currently in -mm which might be from gehao@kylinos.cn are


