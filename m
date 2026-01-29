Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F913090C2
	for <mm-commits@vger.kernel.org>; Thu, 29 Jan 2026 18:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769712673; cv=none; b=Dm3ItlYDBh8jL7IvQc2oSjQ/aaYzO+KEldHviUzGkBRepEM+NO5hB+LQ7O0xZnMDpnnonUOq/AjLeKagMYudUQdWqVoLS7DYW4fCS0ElLlJq/7L8vFFk+SZ6ImTHAhRuU6NRXdWxnWGSlncPC2nLEnnOrfmecgpSwCQupe/jiyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769712673; c=relaxed/simple;
	bh=WrKHsOHXL2pc/VdAXi6x8XRC5pnKmXgwij7934caL9c=;
	h=Date:To:From:Subject:Message-Id; b=ZeLAgZkwTQomhmKV1J4+EjyECZugn8P+v2y5rH4vrsQcGbGYw2sBoERl2oZkSW3q+7j08sjsx1NK+vKFv4NvFAdWRlaHd8/xl4QFdCjit0fxRCyOy6vdWn/vJgFFx+P4HEavkq2Z0PFo5FQ1KuHE6JJLm8ZCPg7XQiRZZ5ZlToY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KUrsxQ3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KUrsxQ3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005CEC4CEF7;
	Thu, 29 Jan 2026 18:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769712673;
	bh=WrKHsOHXL2pc/VdAXi6x8XRC5pnKmXgwij7934caL9c=;
	h=Date:To:From:Subject:From;
	b=KUrsxQ3K+KZoa1kym4uDWnhS3VX2i1J5IMmNOYcpfKjyHZP9FSlP6xgqodBPh/9uP
	 XnPoKtZQn9IpHpDk5n7PyFq77gV5VpytwiWHiw1fRpEB39Rb1QKbVsMjIHhoOgs8N9
	 5zuB08EUw/vWCv2mj4CkDwV2nXG7iyMq4MQUnnvI=
Date: Thu, 29 Jan 2026 10:51:12 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usamaarif642@gmail.com,songliubraving@fb.com,ryan.roberts@arm.com,riel@surriel.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-nr_file_pages-accounting-in-collapse_file.patch added to mm-hotfixes-unstable branch
Message-Id: <20260129185113.005CEC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: fix NR_FILE_PAGES accounting in collapse_file()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-khugepaged-fix-nr_file_pages-accounting-in-collapse_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-nr_file_pages-accounting-in-collapse_file.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm: khugepaged: fix NR_FILE_PAGES accounting in collapse_file()
Date: Thu, 29 Jan 2026 10:40:54 -0800

In META's fleet, we are seeing high level cgroups with zero file memcg
stat but their descendants have non-zero file stat.  This should not be
possible.  On further inspection by looking at kernel data structures
though drgn, it was revealed that the high level cgroups have negative
file stat which was aggregated from their children.

Another interesting point was that this specific issue start happening
more often as we started deploying thp-always more widely which indicates
some correlation between file memory and THPs and indeed it was found that
file memcg stat accounting is buggy in the collapse code path from the
start.

When collapse_file() replaces small folios with a large THP, it fails to
properly update the NR_FILE_PAGES memcg stat for both the old folios being
freed and the new THP being added.  It assumes the old and new folios
belong to the same cgroup.  However this assumption breaks in couple of
scenarios:

1. Binary (executable) package downloader running in a different cgroup
   than the actual job executing the downloaded package.

2. File shared and mapped by processes running in different cgroups. One
   process read-in the file and the second process either through
   madvise(COLLAPSE) or khugepaged on behalf of second process
   collapsing the file.

So, the current code has two bugs:

1. For non-shmem files, NR_FILE_PAGES is never incremented for the new
   THP because nr_none is always 0 for non-shmem, and the stat update is
   inside the "if (nr_none)" block.

2. When freeing old folios, NR_FILE_PAGES is never decremented because
   folio->mapping is set to NULL directly without calling
   filemap_unaccount_folio().

These bugs cause incorrect per-memcg accounting when the process
triggering the collapse (MADV_COLLAPSE or khugepaged) belongs to a
different memcg than the process that originally faulted in the pages:

  - Process A (memcg X) reads file, creating 512 small page cache folios
    charged to memcg X (NR_FILE_PAGES += 512 for memcg X)

  - Process B (memcg Y) triggers collapse via MADV_COLLAPSE or khugepaged
    scans B's mm. The new THP is charged to memcg Y.

  - Old folios freed: NR_FILE_PAGES not decremented (bug)
    New THP added: NR_FILE_PAGES not incremented (bug)

  - Later, THP removed from page cache: NR_FILE_PAGES -= 512 for memcg Y

Result: memcg X has +512 inflated pages, memcg Y has -512 (negative!)

Fix this by:
1. Always incrementing NR_FILE_PAGES by HPAGE_PMD_NR for the new THP
2. Decrementing NR_FILE_PAGES for each old folio before clearing its
   mapping pointer

For shmem with holes (nr_none > 0), the net change is still +nr_none since
we decrement (HPAGE_PMD_NR - nr_none) old pages and increment HPAGE_PMD_NR
new pages.

Link: https://lkml.kernel.org/r/20260129184054.910897-1-shakeel.butt@linux.dev
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-nr_file_pages-accounting-in-collapse_file
+++ a/mm/khugepaged.c
@@ -2199,8 +2199,8 @@ immap_locked:
 	else
 		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
 
+	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, HPAGE_PMD_NR);
 	if (nr_none) {
-		lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_none);
 		/* nr_none is always 0 for non-shmem. */
 		lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_none);
 	}
@@ -2237,6 +2237,8 @@ immap_locked:
 	 */
 	list_for_each_entry_safe(folio, tmp, &pagelist, lru) {
 		list_del(&folio->lru);
+		lruvec_stat_mod_folio(folio, NR_FILE_PAGES,
+				      -folio_nr_pages(folio));
 		folio->mapping = NULL;
 		folio_clear_active(folio);
 		folio_clear_unevictable(folio);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-khugepaged-fix-nr_file_pages-accounting-in-collapse_file.patch

