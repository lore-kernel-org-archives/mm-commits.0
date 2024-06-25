Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE4D142E93
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291649; cv=none; b=Np2QwcgKcTdNDHsqvU+sdBBg3D3LVY1b7ro2qehj2pIbPiOm4FaeocN1+hNvgqKa2sX+LuEeBVzSSqD7wzczuf57hL7dvYhYrr77F4rS9PEyo+dVX6xMvuDOS/Vf7x1UoO074iKIGFiD/N3osnDukWL4BB1f1CukIGOhK5ZFDto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291649; c=relaxed/simple;
	bh=NfHAoJlo1v5yFGBMwAR82WF4QRUpWn3RWFiIp8sD+24=;
	h=Date:To:From:Subject:Message-Id; b=N7gUyPGADOUlWnNmUwDVebGjjtv9LQhqBz1U66mwkQEWYbiLHpNIVNdsV8QOn69k/aJkU489tU8fDzBSCRwli0zdx1hiFMwP7khO3X6i6BdxGKINPL85nnTT44L+r9mW0bEn0dhb9wYP8vGhQubRuuLJCl1JG/jRZFGdzCotO0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0tQYbPjx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0tQYbPjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C18CC32789;
	Tue, 25 Jun 2024 05:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291649;
	bh=NfHAoJlo1v5yFGBMwAR82WF4QRUpWn3RWFiIp8sD+24=;
	h=Date:To:From:Subject:From;
	b=0tQYbPjx8kmo5y7+n2h6LRQ7Haq7y9YE9nWVW5hAXhhNBo3nx7HBD29CPBE1Jr2oJ
	 s5LFbcJoOZpznqimyJVI4r9yZg1d6UJs7EWouh2OStwN1ofwnRAXjntWmu/OD+1Jyq
	 VAd5mS8LOLxhmXmstoJNAzI8oBZxlYLxj9JU2CJ4=
Date: Mon, 24 Jun 2024 22:00:48 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,kirill.shutemov@linux.intel.com,ioworker0@gmail.com,corbet@lwn.net,adobriyan@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch removed from -mm tree
Message-Id: <20240625050049.3C18CC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: indicate PM_FILE for PMD-mapped file THP
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/task_mmu: indicate PM_FILE for PMD-mapped file THP
Date: Fri, 7 Jun 2024 14:23:52 +0200

Patch series "fs/proc: move page_mapcount() to fs/proc/internal.h".

With all other page_mapcount() users in the tree gone, move
page_mapcount() to fs/proc/internal.h, rename it and extend the
documentation to prevent future (ab)use.

... of course, I find some issues while working on that code that I sort
first ;)

We'll now only end up calling page_mapcount() [now
folio_precise_page_mapcount()] on pages mapped via present page table
entries.  Except for /proc/kpagecount, that still does questionable
things, but we'll leave that legacy interface as is for now.

Did a quick sanity check.  Likely we would want some better selfestest for
/proc/$/pagemap + smaps.  I'll see if I can find some time to write some
more.


This patch (of 6):

Looks like we never taught pagemap_pmd_range() about the existence of
PMD-mapped file THPs.  Seems to date back to the times when we first added
support for non-anon THPs in the form of shmem THP.

Link: https://lkml.kernel.org/r/20240607122357.115423-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240607122357.115423-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Lance Yang <ioworker0@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp
+++ a/fs/proc/task_mmu.c
@@ -1522,6 +1522,8 @@ static int pagemap_pmd_range(pmd_t *pmdp
 		}
 #endif
 
+		if (page && !PageAnon(page))
+			flags |= PM_FILE;
 		if (page && !migration && page_mapcount(page) == 1)
 			flags |= PM_MMAP_EXCLUSIVE;
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-read-page_type-using-read_once.patch
mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch

