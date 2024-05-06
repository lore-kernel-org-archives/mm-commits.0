Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E320A5CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957009; cv=none; b=D11fuCgtyhOz0FHNWw8mjhFtTKcWw1it4cE1Tdmvxy2EXoqZPuMffBcCh1l+m1urJffZnmKSuHLhMniCcKVJ9NSIWPq+8T6/rEepf1Ra6dEDGEwFgXkNzkfz8Y07JYsuGTRpUwvkxAxF2L++15eZ0AywcZv+wj4aXWrFPiy62/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957009; c=relaxed/simple;
	bh=dis8MOL20+tlITNxtuI59sUloBarkJAwilc8XWAtR7s=;
	h=Date:To:From:Subject:Message-Id; b=NsLbthshGO+eYOijcESmm1Jl8pxorNw4asNgtzlj+Lc9s2JhDsZha6r4ifEL83JGqBzdsxn3CEjLFBKkOyJ8zQzTMeQARlXLVZunf+QEhxqXG4fcEi9SO5wnxyh+ZMhB0msCof7UxvaH/fSnuViGP6+wy8ZifPSaYWPjSZOj5gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WkQmTKVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WkQmTKVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CFDC113CC;
	Mon,  6 May 2024 00:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957008;
	bh=dis8MOL20+tlITNxtuI59sUloBarkJAwilc8XWAtR7s=;
	h=Date:To:From:Subject:From;
	b=WkQmTKVhURlav7tL5kLS6mbwF/P3GGtOC9KFG48DV+5pIsR7sMCp9NizTcQr2qOBi
	 VE05qXC7W77GXeLRgSInfMK9BaTjSobFJw2kR0tn5wfkmtC8YkGkE6Uxs1Vd05w1lR
	 hAIepEVKjfLPylrREFhSU25juYsx6/ssCwZqSzNI=
Date: Sun, 05 May 2024 17:56:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-use-folio_likely_mapped_shared-in-add_page_for_migration.patch removed from -mm tree
Message-Id: <20240506005648.B6CFDC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: use folio_likely_mapped_shared() in add_page_for_migration()
has been removed from the -mm tree.  Its filename was
     mm-migrate-use-folio_likely_mapped_shared-in-add_page_for_migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/migrate: use folio_likely_mapped_shared() in add_page_for_migration()
Date: Tue, 9 Apr 2024 21:22:54 +0200

We want to limit the use of page_mapcount() to the places where it is
absolutely necessary.  In add_page_for_migration(), we actually want to
check if the folio is mapped shared, to reject such folios.  So let's use
folio_likely_mapped_shared() instead.

For small folios, fully mapped THP, and hugetlb folios, there is no change.
For partially mapped, shared THP, we should now do a better job at
rejecting such folios.

Link: https://lkml.kernel.org/r/20240409192301.907377-12-david@redhat.com
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

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-use-folio_likely_mapped_shared-in-add_page_for_migration
+++ a/mm/migrate.c
@@ -2140,7 +2140,7 @@ static int add_page_for_migration(struct
 		goto out_putfolio;
 
 	err = -EACCES;
-	if (page_mapcount(page) > 1 && !migrate_all)
+	if (folio_likely_mapped_shared(folio) && !migrate_all)
 		goto out_putfolio;
 
 	err = -EBUSY;
_

Patches currently in -mm which might be from david@redhat.com are


