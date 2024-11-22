Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53831482E2;
	Fri, 22 Nov 2024 06:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732256139; cv=none; b=QJW6HJQWDG8TnzLIK3AMHYcnLqU/39phb9MPrNUIqRJJZQI7bzDtIuM4UhKoLBP62vo4BLlQKqR5gf+JR2ntXoyadhI6KwD37eTq6Zvb7N14KhN5AqzHDAYC2H2ijmsyNxU9rES8pAnX/SHenats1jJnl+/lOaAyXMfGEvRLvKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732256139; c=relaxed/simple;
	bh=vRVp1NjRk5s07DOH0NSEFo8dZWdlapAnkXdnd4H2coA=;
	h=Date:To:From:Subject:Message-Id; b=qmZ2lJNmEpkhGo1Vq2ATXLBcssgklVSeklnqnkqMxPMx+y+FRIW4DbkMMlyfwjm6DYjLfrjrL32S9Gxi7rN4XTIp1ICN7fAIpCy4R6LIGv9ZkKp6VrGna3kDqfgbZIOhb/vo8U1/vyQRnBOGnn2Atqh4IF5MOse0q+OefbRCOCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PLDCrx02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PLDCrx02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05AEC4CECE;
	Fri, 22 Nov 2024 06:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732256139;
	bh=vRVp1NjRk5s07DOH0NSEFo8dZWdlapAnkXdnd4H2coA=;
	h=Date:To:From:Subject:From;
	b=PLDCrx02hDrPzy7HJdy55rv6jHTAoTSppDsY5wkKQe/h2BQyf6YsVSZyDYKka9EXy
	 91ltMcxXcZKv+7jTVsfPnEX4eBR5Fb6/7HD4omV2J4YwBwBP97Ry69z/CX6b7qDgNI
	 tC/E/kYLGnVSC44cBYoi88Z6CvLEOObdbHV9+WlA=
Date: Thu, 21 Nov 2024 22:15:34 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,stable@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,airlied@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-handle-null-pages-in-unpin_user_pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20241122061538.A05AEC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: handle NULL pages in unpin_user_pages()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-gup-handle-null-pages-in-unpin_user_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-handle-null-pages-in-unpin_user_pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-gup-handle-null-pages-in-unpin_user_pages.patch

