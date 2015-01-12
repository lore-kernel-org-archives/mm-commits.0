From: akpm@linux-foundation.org
Subject: + mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch added to -mm tree
Date: Mon, 12 Jan 2015 12:24:32 -0800
Message-ID: <54b42d80.gpRN3vgNWK2iucQG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbbALUYd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 15:24:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, aarcange@redhat.com, kirill.shutemov@linux.intel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2
has been added to the -mm tree.  Its filename is
     mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2

Oops. I wanted this return code to be accounted into 'bad' in
free_pages_prepare() instead. Incremental patch:

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2
+++ a/mm/page_alloc.c
@@ -795,7 +795,7 @@ static bool free_pages_prepare(struct pa
 	bad += free_pages_check(page);
 	for (i = 1; i < (1 << order); i++) {
 		if (compound)
-			free_tail_pages_check(page, page + i);
+			bad += free_tail_pages_check(page, page + i);
 		bad += free_pages_check(page + i);
 	}
 	if (bad)
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-replace-remap_file_pages-syscall-with-emulation.patch
m68k-drop-_page_file-and-pte_file-related-helpers.patch
mips-drop-_page_file-and-pte_file-related-helpers.patch
mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

