Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D1214430B
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291709; cv=none; b=q8W8X/8iG8n25UQpXd/Lff25yH3KjA/2zHu458eD/w5EEUKS4HOiriVyetGIE4pZ73Wrqn81NHuGeU7fEkN6ninaIbwo2EONhOx7fybRMMqw4XTQAa0gJTFe2X01co+6P01PVwB7zmilKMk8e6PYSYYb4imV0Io8VQAhohbceKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291709; c=relaxed/simple;
	bh=420JtB2lilaqWALtqM+CeTH62uoccXx2BRJa2gdbWco=;
	h=Date:To:From:Subject:Message-Id; b=PfOQEhbZxdFbWzsLPIENEL5mLuSsZYTrJsHeUA+doUP+xgMql5kogjOakNRdJW5Uz8s569H2eh4vuJq7+vHYnV72cq38F/jmaDlyeql62g5ztr0KYmk4FpSAQJ38cPNWFUozU/YLxSlgmhajWcKewupxmIE5j6HWXJETUemnBOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N9Si5q1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N9Si5q1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E02C32782;
	Tue, 25 Jun 2024 05:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291708;
	bh=420JtB2lilaqWALtqM+CeTH62uoccXx2BRJa2gdbWco=;
	h=Date:To:From:Subject:From;
	b=N9Si5q1vNU1tKvWXxTpwwY/MI/ceXr4XFsVV++eMcRIDShzhgTBdomRQCVBrYl+9x
	 YxPVWSIuuHoQQ0MfMMuFoGHYqmWIgMKo45d2c3ISrh+BJsMtijXuQQrsD19EgftlYy
	 e5/Em693Zsriyrvaf9Kd1hCKN3Ib5eVR1SHbvkY0=
Date: Mon, 24 Jun 2024 22:01:48 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-save-some-page_folio-calls.patch removed from -mm tree
Message-Id: <20240625050148.D7E02C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: save some page_folio() calls
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-save-some-page_folio-calls.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: save some page_folio() calls
Date: Wed, 12 Jun 2024 15:18:26 +0800

Use local variable folio directly to save a page_folio() call.  Also use
folio_mapped() to save more page_folio() calls.  No functional change
intended.

Link: https://lkml.kernel.org/r/20240612071835.157004-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: kernel test robot <lkp@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-save-some-page_folio-calls
+++ a/mm/memory-failure.c
@@ -1575,7 +1575,7 @@ static bool hwpoison_user_mappings(struc
 	 * This check implies we don't kill processes if their pages
 	 * are in the swap cache early. Those are always late kills.
 	 */
-	if (!page_mapped(p))
+	if (!folio_mapped(folio))
 		return true;
 
 	if (folio_test_swapcache(folio)) {
@@ -1626,10 +1626,10 @@ static bool hwpoison_user_mappings(struc
 		try_to_unmap(folio, ttu);
 	}
 
-	unmap_success = !page_mapped(p);
+	unmap_success = !folio_mapped(folio);
 	if (!unmap_success)
 		pr_err("%#lx: failed to unmap page (folio mapcount=%d)\n",
-		       pfn, folio_mapcount(page_folio(p)));
+		       pfn, folio_mapcount(folio));
 
 	/*
 	 * try_to_unmap() might put mlocked page in lru cache, so call
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


