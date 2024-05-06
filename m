Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB5510A0E
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957010; cv=none; b=qZlGf6FwBiIgaesMGxyeBCXmzY+t9gfQ9M/h2Fx3Tv20sBU7zsPzwgB7sJLveMofb07UTYJd/Ulx+JRHhWkjRyacxDrt1hidoAtk0EU/9MaDpTXsG1Un38wXMuOMjS91YidTYQo9UjeiKjxEg1Y1UwFXxJVQRKa9sVil0kl4Co4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957010; c=relaxed/simple;
	bh=k6+AMYpWf1v3Z9dbfOFfoZEFlrk9fMRi03z+JzcfkOI=;
	h=Date:To:From:Subject:Message-Id; b=ZfjPN+XERw3JN8jxWmAyYz/qQQIdAIDPtb+Z8dbl7rqoyLIDTDEL4dX69sp2zrww5osUIgeCjuFkBsYRp8AbavJHWsejV+JudAmKHm6ugVUosK5DyOsewDCDU3f/qkhl2INxhGcTxWEgolz5LjzvZKSoqBeFBC8wvBj5eEQxNoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PV+MKzpH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PV+MKzpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BC2C113CC;
	Mon,  6 May 2024 00:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957010;
	bh=k6+AMYpWf1v3Z9dbfOFfoZEFlrk9fMRi03z+JzcfkOI=;
	h=Date:To:From:Subject:From;
	b=PV+MKzpHR186eMcAgksfRHdhJez3+6ZXFX6T2zxPjd8Wpfl1YxjB4+d0yXf6PY5OM
	 kIV++V6Q9rOUwBVTqYhc7CltdVzoSsVRQRIoQlLM5nRL41ZQXx2g93RG83yID1Daet
	 W2Xxc57Rc1E2/Px37iuqlvziaRI5pirSvBhFwj7I=
Date: Sun, 05 May 2024 17:56:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-mm-cache-use-folio_mapped-in-copy_from_user_page.patch removed from -mm tree
Message-Id: <20240506005649.E7BC2C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sh/mm/cache: use folio_mapped() in copy_from_user_page()
has been removed from the -mm tree.  Its filename was
     sh-mm-cache-use-folio_mapped-in-copy_from_user_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: sh/mm/cache: use folio_mapped() in copy_from_user_page()
Date: Tue, 9 Apr 2024 21:22:55 +0200

We want to limit the use of page_mapcount() to the places where it is
absolutely necessary.

We're already using folio_mapped in copy_user_highpage() and
copy_to_user_page() for a similar purpose so ...  let's also simply use it
for copy_from_user_page().

There is no change for small folios.  Likely we won't stumble over many
large folios on sh in that code either way.

Link: https://lkml.kernel.org/r/20240409192301.907377-13-david@redhat.com
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

 arch/sh/mm/cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sh/mm/cache.c~sh-mm-cache-use-folio_mapped-in-copy_from_user_page
+++ a/arch/sh/mm/cache.c
@@ -84,7 +84,7 @@ void copy_from_user_page(struct vm_area_
 {
 	struct folio *folio = page_folio(page);
 
-	if (boot_cpu_data.dcache.n_aliases && page_mapcount(page) &&
+	if (boot_cpu_data.dcache.n_aliases && folio_mapped(folio) &&
 	    test_bit(PG_dcache_clean, &folio->flags)) {
 		void *vfrom = kmap_coherent(page, vaddr) + (vaddr & ~PAGE_MASK);
 		memcpy(dst, vfrom, len);
_

Patches currently in -mm which might be from david@redhat.com are


