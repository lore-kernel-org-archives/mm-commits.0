Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2980D13AF2
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957016; cv=none; b=Z/Yc5rkRfKBXF+HX6e6MtD5e5IonUDEIMTXbbKETgBa6LSQuOljjPV7WqQc1pC8+UWqWPoCbBmsy6egvB+iML0FSeYwCk7OKgB0ZA6EXMjrmflAF2aWFmWbNI1pX0Oo65RC08fFOihHZKWlOoZoP2V3SD22RG4WXJ3jOwkqwtS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957016; c=relaxed/simple;
	bh=1acyU8Ts628xy2jFd7WkhcpG/VYwqx1CIyrEmbwhPMY=;
	h=Date:To:From:Subject:Message-Id; b=b5HKZ1VTzqqEWxT/MYFUXLb1qCmIm5WPY4K3LwMbmT0YAqL0FiXJbm8e68ZH0DXAn8T1T4+NGvXskQv7eO2Q6jwPDoyiDhvO/wa1KcgfR6cbuDQfN83SVOVPJ8G5QNa4uDRDiMg6vLBafyHabJaficetmHfZvciLJNSLT74ko54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RLPfIJai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RLPfIJai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1533C113CC;
	Mon,  6 May 2024 00:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957016;
	bh=1acyU8Ts628xy2jFd7WkhcpG/VYwqx1CIyrEmbwhPMY=;
	h=Date:To:From:Subject:From;
	b=RLPfIJaiQ1STuVdUmlVgHeigD8yiHbYNhEKI1VDcgnAJ7DaPCROWLKnK1GscueYRh
	 vnNbk1mJ09Qwk0zlZWydDpzzpKg1RR1Fz95N4yXFRQ7j6yr5qLYr11l+hSHqQCY1jf
	 G2ew6IBZDW6WgqFSsZJ6tIytTAInA2ScaJPSfC+0=
Date: Sun, 05 May 2024 17:56:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch removed from -mm tree
Message-Id: <20240506005655.F1533C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/debug: print only page mapcount (excluding folio entire mapcount) in __dump_folio()
has been removed from the -mm tree.  Its filename was
     mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/debug: print only page mapcount (excluding folio entire mapcount) in __dump_folio()
Date: Tue, 9 Apr 2024 21:23:00 +0200

Let's simplify and only print the page mapcount: we already print the
large folio mapcount and the entire folio mapcount for large folios
separately; that should be sufficient to figure out what's happening.

While at it, print the page mapcount also if it had an underflow,
filtering out only typed pages.

Link: https://lkml.kernel.org/r/20240409192301.907377-18-david@redhat.com
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

 mm/debug.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/debug.c~mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio
+++ a/mm/debug.c
@@ -55,15 +55,10 @@ static void __dump_folio(struct folio *f
 		unsigned long pfn, unsigned long idx)
 {
 	struct address_space *mapping = folio_mapping(folio);
-	int mapcount = atomic_read(&page->_mapcount) + 1;
+	int mapcount = atomic_read(&page->_mapcount);
 	char *type = "";
 
-	/* Open-code page_mapcount() to avoid looking up a stale folio */
-	if (mapcount < 0)
-		mapcount = 0;
-	if (folio_test_large(folio))
-		mapcount += folio_entire_mapcount(folio);
-
+	mapcount = page_type_has_type(mapcount) ? 0 : mapcount + 1;
 	pr_warn("page: refcount:%d mapcount:%d mapping:%p index:%#lx pfn:%#lx\n",
 			folio_ref_count(folio), mapcount, mapping,
 			folio->index + idx, pfn);
_

Patches currently in -mm which might be from david@redhat.com are


