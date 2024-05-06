Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31F35CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957011; cv=none; b=QyV1iAqIY0SD2+JxttAR2cBYmXuolKjGkrndM65KJCo01SwK05iHQWSPPqVtovMk9rcK5/Qs6LXAUAnpF+EZ6000xo7jJTFjpPtWZVz++SpMAQU9frvhBKzZUwUloq3unYLepdoCdaJnMnFOFLik41ZN3odaNA+hMrSI+tIOoWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957011; c=relaxed/simple;
	bh=LLjJ1uN1Mc2NnPnO2+YQNRVvjZs6nNnIC3wslheXxso=;
	h=Date:To:From:Subject:Message-Id; b=ptyzBksHa426mGQkoxOTPLekNmysOtLuJ3OlSjYD7Ou8LXdPFlXzBw8tbW6xGMNsGtBYOastPaogxZVi4D6khYiCxo2ZmB4hHo/Bty8g5sVQxhSUf8egIAUTz84Imc/r9d2tcQ4/aGoYVNZe9qKgiR81huhrnuUXwVj1SwsjAO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gu/TCaOn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gu/TCaOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0C0C116B1;
	Mon,  6 May 2024 00:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957011;
	bh=LLjJ1uN1Mc2NnPnO2+YQNRVvjZs6nNnIC3wslheXxso=;
	h=Date:To:From:Subject:From;
	b=gu/TCaOnmaAeOIfQIGp25uXgTWmfvLD1L1Y2Eg45fvw2J+uRl7MXYZrZFNpL9P2pu
	 8fwGdYRvr/I3ZdAR1nuvVuxYRYH4UlwMgsvCFRPLm8cpNcav/JDLY15R9w14CQ8Qi2
	 78j5HpR+1E8dsdsdaUI6TSnIBVmIKWFEw2ccqwss=
Date: Sun, 05 May 2024 17:56:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-use-folio_mapcount-in-filemap_unaccount_folio.patch removed from -mm tree
Message-Id: <20240506005651.2E0C0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: use folio_mapcount() in filemap_unaccount_folio()
has been removed from the -mm tree.  Its filename was
     mm-filemap-use-folio_mapcount-in-filemap_unaccount_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/filemap: use folio_mapcount() in filemap_unaccount_folio()
Date: Tue, 9 Apr 2024 21:22:56 +0200

We want to limit the use of page_mapcount() to the places where it is
absolutely necessary.

Let's use folio_mapcount() instead of filemap_unaccount_folio().

No functional change intended, because we're only dealing with small
folios.

Link: https://lkml.kernel.org/r/20240409192301.907377-14-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-use-folio_mapcount-in-filemap_unaccount_folio
+++ a/mm/filemap.c
@@ -168,7 +168,7 @@ static void filemap_unaccount_folio(stru
 		add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 
 		if (mapping_exiting(mapping) && !folio_test_large(folio)) {
-			int mapcount = page_mapcount(&folio->page);
+			int mapcount = folio_mapcount(folio);
 
 			if (folio_ref_count(folio) >= mapcount + 2) {
 				/*
_

Patches currently in -mm which might be from david@redhat.com are


