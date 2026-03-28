Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15D3C2FD
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774670524; cv=none; b=PWv1XjpIif8iJZxKP+btNENTQaITmKQeHkVqseNTVAm+s2HkhHuYC2fuUqUS+bkM6+E7f4crjGyqf8Wst7ORUxAdfmHfrN7thJLmopkRXJjrRzUXrffg510iItc8aI20TiKmx6/ZOTr71s2rwAQPNp8VGsM8KoPZEf7lBC71n0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774670524; c=relaxed/simple;
	bh=YpqqWes328dwWRv6W8zOIP1asyEZmBVcFqaZii2tj5I=;
	h=Date:To:From:Subject:Message-Id; b=rRAvQGTXW/QXS97180Trp2uoUQxPzgIjRvqPb4U6+WEKw1TI0D8dmGkCVmwPemjB4TTpxpl/Rhzka0WkbNrAcybpquWJu9OZ82AgM5QehiGJaMtUm/SOxhKVivCDg5OGDWEVj9fO8Udk0zAUrbVriefvJLibycwPTSxmXck5vjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2W9oxcze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2W9oxcze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C6FC19424;
	Sat, 28 Mar 2026 04:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774670524;
	bh=YpqqWes328dwWRv6W8zOIP1asyEZmBVcFqaZii2tj5I=;
	h=Date:To:From:Subject:From;
	b=2W9oxczepN2cWoUGenag0j3uhyKcnyvnrYXQhS3qeyQTK9XsUWyWqaXQ4eQ0fkiaG
	 nFU3Y+9esMRRzhQVIstUFzVKogRGhyEgUHEjcyuwvdnt0s5I86W4y5O3N2MdiuIddv
	 qqZg18wwnvtRKfsqWv8yuUPINldMQsYn2dR3WmMM=
Date: Fri, 27 Mar 2026 21:02:03 -0700
To: mm-commits@vger.kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20260328040204.44C6FC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: filemap: fix nr_pages calculation overflow in filemap_map_pages()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: filemap: fix nr_pages calculation overflow in filemap_map_pages()
Date: Tue, 17 Mar 2026 17:29:55 +0800

When running stress-ng on my Arm64 machine with v7.0-rc3 kernel, I
encountered some very strange crash issues showing up as "Bad page state":

"
[  734.496287] BUG: Bad page state in process stress-ng-env  pfn:415735fb
[  734.496427] page: refcount:0 mapcount:1 mapping:0000000000000000 index:0x4cf316 pfn:0x415735fb
[  734.496434] flags: 0x57fffe000000800(owner_2|node=1|zone=2|lastcpupid=0x3ffff)
[  734.496439] raw: 057fffe000000800 0000000000000000 dead000000000122 0000000000000000
[  734.496440] raw: 00000000004cf316 0000000000000000 0000000000000000 0000000000000000
[  734.496442] page dumped because: nonzero mapcount
"

After analyzing this page’s state, it is hard to understand why the
mapcount is not 0 while the refcount is 0, since this page is not where
the issue first occurred.  By enabling the CONFIG_DEBUG_VM config, I can
reproduce the crash as well and captured the first warning where the issue
appears:

"
[  734.469226] page: refcount:33 mapcount:0 mapping:00000000bef2d187 index:0x81a0 pfn:0x415735c0
[  734.469304] head: order:5 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[  734.469315] memcg:ffff000807a8ec00
[  734.469320] aops:ext4_da_aops ino:100b6f dentry name(?):"stress-ng-mmaptorture-9397-0-2736200540"
[  734.469335] flags: 0x57fffe400000069(locked|uptodate|lru|head|node=1|zone=2|lastcpupid=0x3ffff)
......
[  734.469364] page dumped because: VM_WARN_ON_FOLIO((_Generic((page + nr_pages - 1),
const struct page *: (const struct folio *)_compound_head(page + nr_pages - 1), struct page *:
(struct folio *)_compound_head(page + nr_pages - 1))) != folio)
[  734.469390] ------------[ cut here ]------------
[  734.469393] WARNING: ./include/linux/rmap.h:351 at folio_add_file_rmap_ptes+0x3b8/0x468,
CPU#90: stress-ng-mlock/9430
[  734.469551]  folio_add_file_rmap_ptes+0x3b8/0x468 (P)
[  734.469555]  set_pte_range+0xd8/0x2f8
[  734.469566]  filemap_map_folio_range+0x190/0x400
[  734.469579]  filemap_map_pages+0x348/0x638
[  734.469583]  do_fault_around+0x140/0x198
......
[  734.469640]  el0t_64_sync+0x184/0x188
"

The code that triggers the warning is: "VM_WARN_ON_FOLIO(page_folio(page +
nr_pages - 1) != folio, folio)", which indicates that set_pte_range()
tried to map beyond the large folio’s size.

By adding more debug information, I found that 'nr_pages' had overflowed
in filemap_map_pages(), causing set_pte_range() to establish mappings for
a range exceeding the folio size, potentially corrupting fields of pages
that do not belong to this folio (e.g., page->_mapcount).

After above analysis, I think the possible race is as follows:

CPU 0                                                  CPU 1
filemap_map_pages()                                   ext4_setattr()
   //get and lock folio with old inode->i_size
   next_uptodate_folio()

                                                          .......
                                                          //shrink the inode->i_size
                                                          i_size_write(inode, attr->ia_size);

   //calculate the end_pgoff with the new inode->i_size
   file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
   end_pgoff = min(end_pgoff, file_end);

   ......
   //nr_pages can be overflowed, cause xas.xa_index > end_pgoff
   end = folio_next_index(folio) - 1;
   nr_pages = min(end, end_pgoff) - xas.xa_index + 1;

   ......
   //map large folio
   filemap_map_folio_range()
                                                          ......
                                                          //truncate folios
                                                          truncate_pagecache(inode, inode->i_size);

To fix this issue, move the 'end_pgoff' calculation before
next_uptodate_folio(), so the retrieved folio stays consistent with the
file end to avoid 'nr_pages' calculation overflow.  After this patch, the
crash issue is gone.

Link: https://lkml.kernel.org/r/1cf1ac59018fc647a87b0dad605d4056a71c14e4.1773739704.git.baolin.wang@linux.alibaba.com
Fixes: 743a2753a02e ("filemap: cap PTE range to be created to allowed zero fill in folio_map_range()")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
Tested-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/filemap.c~mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages
+++ a/mm/filemap.c
@@ -3883,14 +3883,19 @@ vm_fault_t filemap_map_pages(struct vm_f
 	unsigned int nr_pages = 0, folio_type;
 	unsigned short mmap_miss = 0, mmap_miss_saved;
 
+	/*
+	 * Recalculate end_pgoff based on file_end before calling
+	 * next_uptodate_folio() to avoid races with concurrent
+	 * truncation.
+	 */
+	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
+	end_pgoff = min(end_pgoff, file_end);
+
 	rcu_read_lock();
 	folio = next_uptodate_folio(&xas, mapping, end_pgoff);
 	if (!folio)
 		goto out;
 
-	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
-	end_pgoff = min(end_pgoff, file_end);
-
 	/*
 	 * Do not allow to map with PMD across i_size to preserve
 	 * SIGBUS semantics.
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages.patch
mm-use-inline-helper-functions-instead-of-ugly-macros.patch
mm-rename-ptep-pmdp_clear_young_notify-to-ptep-pmdp_test_and_clear_young_notify.patch
mm-rmap-add-a-zone_device-folio-warning-in-folio_referenced.patch
mm-add-a-batched-helper-to-clear-the-young-flag-for-large-folios.patch
mm-support-batched-checking-of-the-young-flag-for-mglru.patch
arm64-mm-implement-the-architecture-specific-test_and_clear_young_ptes.patch
mm-change-to-return-bool-for-ptep_test_and_clear_young.patch
mm-change-to-return-bool-for-ptep_clear_flush_young-clear_flush_young_ptes.patch
mm-change-to-return-bool-for-pmdp_test_and_clear_young.patch
mm-change-to-return-bool-for-pmdp_clear_flush_young.patch
mm-change-to-return-bool-for-pudp_test_and_clear_young.patch
mm-change-to-return-bool-for-the-mmu-notifiers-young-flag-check.patch
mm-vmscan-fix-dirty-folios-throttling-on-cgroup-v1-for-mglru.patch

