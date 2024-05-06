Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD9763D5
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957002; cv=none; b=F3JPO+qOeO2h5Rfps/SRlx6Zu0HMdZOQOKDL2aJlS9k350kazC+WERNl2Z1lSMAl/CGRIU2Q97JiIVbb2xE+WvVuQARxhKUARkb3vAwJDJr5brzopDIJgkJZgU6SkFkKMP+u4iGtHLxmXTvh7rdjPVOBAEHkQGk6RT+J7fMRLGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957002; c=relaxed/simple;
	bh=7eodsEc/3OS4ywdSrBHmjY7XW5TZ0gwrYtl3lOQrSCY=;
	h=Date:To:From:Subject:Message-Id; b=C1rZFw5RsiBMlUKDk1zyXFP1+76uAMrnK453Cxl2xJDWsQ0mKK6bcJ14ZbvSvf6vBRsqg4hvP3ejV+1lNShQC2PCcF9O6VhEyDml3S0UpFl9MZ8dHd/yP821ubKmUJsG9X1ACk0wx5WjtG3UsKqXlJMKRAGnlLCpCrGrV8dIpXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hfhCkk5f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hfhCkk5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD799C113CC;
	Mon,  6 May 2024 00:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957002;
	bh=7eodsEc/3OS4ywdSrBHmjY7XW5TZ0gwrYtl3lOQrSCY=;
	h=Date:To:From:Subject:From;
	b=hfhCkk5faiQ3hljPSS//g09WqVQnxaM6U2HrXrKdrbPksL00TMdu4XhR3rylco4k0
	 hkGGHB+IlgwohvSq8AzTSZs5rONVtYkLcfZRj2iMRU2YYVYwsqCThoLxD96N67o7mB
	 ZmyLED7pQ9+bPIuHCNbWN2IGRgg3D9aZ3J8Pi2II=
Date: Sun, 05 May 2024 17:56:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-folio_mapcount-return-0-for-small-typed-folios.patch removed from -mm tree
Message-Id: <20240506005641.DD799C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make folio_mapcount() return 0 for small typed folios
has been removed from the -mm tree.  Its filename was
     mm-make-folio_mapcount-return-0-for-small-typed-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: make folio_mapcount() return 0 for small typed folios
Date: Tue, 9 Apr 2024 21:22:49 +0200

We already handle it properly for large folios.  Let's also return "0" for
small typed folios, like page_mapcount() currently would.

Consequently, folio_mapcount() will never return negative values for typed
folios, but may return negative values for underflows.

[david@redhat.com: make folio_mapcount() slightly more efficient]
  Link: https://lkml.kernel.org/r/c30fcda1-ed87-46f5-8297-cdedbddac009@redhat.com
Link: https://lkml.kernel.org/r/20240409192301.907377-7-david@redhat.com
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

 include/linux/mm.h |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-make-folio_mapcount-return-0-for-small-typed-folios
+++ a/include/linux/mm.h
@@ -1261,12 +1261,22 @@ static inline int folio_large_mapcount(c
  * references the entire folio counts exactly once, even when such special
  * page table entries are comprised of multiple ordinary page table entries.
  *
+ * Will report 0 for pages which cannot be mapped into userspace, such as
+ * slab, page tables and similar.
+ *
  * Return: The number of times this folio is mapped.
  */
 static inline int folio_mapcount(const struct folio *folio)
 {
-	if (likely(!folio_test_large(folio)))
-		return atomic_read(&folio->_mapcount) + 1;
+	int mapcount;
+
+	if (likely(!folio_test_large(folio))) {
+		mapcount = atomic_read(&folio->_mapcount) + 1;
+		/* Handle page_has_type() pages */
+		if (mapcount < PAGE_MAPCOUNT_RESERVE + 1)
+			mapcount = 0;
+		return mapcount;
+	}
 	return folio_large_mapcount(folio);
 }
 
_

Patches currently in -mm which might be from david@redhat.com are


