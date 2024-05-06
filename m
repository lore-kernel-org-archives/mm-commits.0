Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819DE5CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957006; cv=none; b=lpYTTh6Pwq5E4Bgwchf2o7zUfj47PJ6jiNE5wsReaT+AiiPTUonOUhLqA1MbGK129agBBIXTmxkS1bcq++KG5M7mtQ3I5bec/aon3MInjR0zfI9KfuUzunc8diqzQCROcPcwdkxiCzzX+5UC6wb+psUQ2ln1eIUK3A42nWxJC+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957006; c=relaxed/simple;
	bh=7M17UzpxMt0rMXsWr8FDKrh1wjaT6Fk3ERLueHsXcpo=;
	h=Date:To:From:Subject:Message-Id; b=sY3Vn4lzkxPz9SoVkpuGM/wIVm8WnbYGHIKI3QDT6g2NvcfV5RlzsGlZIhTOUJm/YZb/AhnUw5HJ57SqfrBbsodHMF5HUaBWxitjnBvHIr3euCeFvrhqwJgAyhG1qkxSa4sjk5Qn6abMAkGn7BLox2YY7tPFLioRKPEf94FKYLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OtKSuj7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OtKSuj7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5884EC113CC;
	Mon,  6 May 2024 00:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957006;
	bh=7M17UzpxMt0rMXsWr8FDKrh1wjaT6Fk3ERLueHsXcpo=;
	h=Date:To:From:Subject:From;
	b=OtKSuj7a2oEEY7rb6SGyueBj97Ag9f5UDGIAKoMFOtPh/e0hGMqMloT7ODPo/oONw
	 9w1E/bOvAZf9xrpmPl26f9NPxSyMcILY8yLBK+C8+6jhcPIKC/VbhFSTr7Z5ih0N2B
	 SlYrOvTnNXkbcklMdRydKvSNt0QEn23tHixnL1R0=
Date: Sun, 05 May 2024 17:56:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-use-folio_mapcount-in-hwpoison_user_mappings.patch removed from -mm tree
Message-Id: <20240506005646.5884EC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: use folio_mapcount() in hwpoison_user_mappings()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-use-folio_mapcount-in-hwpoison_user_mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory-failure: use folio_mapcount() in hwpoison_user_mappings()
Date: Tue, 9 Apr 2024 21:22:52 +0200

We want to limit the use of page_mapcount() to the places where it is
absolutely necessary.  We can only unmap full folios; page_mapped(), which
we check here, is translated to folio_mapped() -- based on
folio_mapcount().  So let's print the folio mapcount instead.

Link: https://lkml.kernel.org/r/20240409192301.907377-10-david@redhat.com
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

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-use-folio_mapcount-in-hwpoison_user_mappings
+++ a/mm/memory-failure.c
@@ -1634,8 +1634,8 @@ static bool hwpoison_user_mappings(struc
 
 	unmap_success = !page_mapped(p);
 	if (!unmap_success)
-		pr_err("%#lx: failed to unmap page (mapcount=%d)\n",
-		       pfn, page_mapcount(p));
+		pr_err("%#lx: failed to unmap page (folio mapcount=%d)\n",
+		       pfn, folio_mapcount(page_folio(p)));
 
 	/*
 	 * try_to_unmap() might put mlocked page in lru cache, so call
_

Patches currently in -mm which might be from david@redhat.com are


