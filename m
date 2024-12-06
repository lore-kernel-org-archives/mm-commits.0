Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724966FBF;
	Fri,  6 Dec 2024 03:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457312; cv=none; b=O4CF4IzKDRHFjcKn5Q13LwxzVqXNbiCPvMUwt/2Ns0BOMT4StwkjsN4NY6ejb8wEQZCShkUFBc1copZuLQImXb1nxuH4fWyb6U5rf3pUdX949s/AJz+XsltH9ofeTK+9RdQqEfdimL8YI853vWcNhcI2McyY6Ow52Ki/gXubVt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457312; c=relaxed/simple;
	bh=xgYVcPZkGGINY7KFRwixATEVBYjyb9MnEMw96gCcvzc=;
	h=Date:To:From:Subject:Message-Id; b=JJvie9+x07eeKR0zERhl3cGBrAnFtsDwImpVldi1QpmcqeByfmyrZyVqnFy0ORrzrPUD9MbeUM+CCN6RNDfdZ5Y2AeyV9t8ULy40DRbv6qZJzPqHisP1GJz94S7xO/lx1TaTSXoZHcKSv29JkBK4uL8MK5YgYyHvwEBmdxFTdf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sIvq/qRy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sIvq/qRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22927C4CED1;
	Fri,  6 Dec 2024 03:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457312;
	bh=xgYVcPZkGGINY7KFRwixATEVBYjyb9MnEMw96gCcvzc=;
	h=Date:To:From:Subject:From;
	b=sIvq/qRyf+fk1rTuaQ3QL0+TKSgz2ifCYj6xCvQmusi3SbaHhh10a3jdA4w7AnhbY
	 SZJ1R3JBn08pH88dLpPBY5DLhKzXoIoGum9uCZ0zTE7gfwSe1WIMzYbiCd8QSBDGyP
	 IGwIexXSJKjfz/e6aU40ejQMoNSMiMAoUZ8Wmq1M=
Date: Thu, 05 Dec 2024 19:55:11 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,stable@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,airlied@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-gup-handle-null-pages-in-unpin_user_pages.patch removed from -mm tree
Message-Id: <20241206035512.22927C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: handle NULL pages in unpin_user_pages()
has been removed from the -mm tree.  Its filename was
     mm-gup-handle-null-pages-in-unpin_user_pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: handle NULL pages in unpin_user_pages()
Date: Wed, 20 Nov 2024 19:49:33 -0800

The recent addition of "pofs" (pages or folios) handling to gup has a
flaw: it assumes that unpin_user_pages() handles NULL pages in the pages**
array.  That's not the case, as I discovered when I ran on a new
configuration on my test machine.

Fix this by skipping NULL pages in unpin_user_pages(), just like
unpin_folios() already does.

Details: when booting on x86 with "numa=fake=2 movablecore=4G" on Linux
6.12, and running this:

    tools/testing/selftests/mm/gup_longterm

...I get the following crash:

BUG: kernel NULL pointer dereference, address: 0000000000000008
RIP: 0010:sanity_check_pinned_pages+0x3a/0x2d0
...
Call Trace:
 <TASK>
 ? __die_body+0x66/0xb0
 ? page_fault_oops+0x30c/0x3b0
 ? do_user_addr_fault+0x6c3/0x720
 ? irqentry_enter+0x34/0x60
 ? exc_page_fault+0x68/0x100
 ? asm_exc_page_fault+0x22/0x30
 ? sanity_check_pinned_pages+0x3a/0x2d0
 unpin_user_pages+0x24/0xe0
 check_and_migrate_movable_pages_or_folios+0x455/0x4b0
 __gup_longterm_locked+0x3bf/0x820
 ? mmap_read_lock_killable+0x12/0x50
 ? __pfx_mmap_read_lock_killable+0x10/0x10
 pin_user_pages+0x66/0xa0
 gup_test_ioctl+0x358/0xb20
 __se_sys_ioctl+0x6b/0xc0
 do_syscall_64+0x7b/0x150
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Link: https://lkml.kernel.org/r/20241121034933.77502-1-jhubbard@nvidia.com
Fixes: 94efde1d1539 ("mm/gup: avoid an unnecessary allocation call for FOLL_LONGTERM cases")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-handle-null-pages-in-unpin_user_pages
+++ a/mm/gup.c
@@ -52,7 +52,12 @@ static inline void sanity_check_pinned_p
 	 */
 	for (; npages; npages--, pages++) {
 		struct page *page = *pages;
-		struct folio *folio = page_folio(page);
+		struct folio *folio;
+
+		if (!page)
+			continue;
+
+		folio = page_folio(page);
 
 		if (is_zero_page(page) ||
 		    !folio_test_anon(folio))
@@ -409,6 +414,10 @@ void unpin_user_pages(struct page **page
 
 	sanity_check_pinned_pages(pages, npages);
 	for (i = 0; i < npages; i += nr) {
+		if (!pages[i]) {
+			nr = 1;
+			continue;
+		}
 		folio = gup_folio_next(pages, npages, i, &nr);
 		gup_put_folio(folio, nr, FOLL_PIN);
 	}
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


