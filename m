From: akpm@linux-foundation.org
Subject: + mm-rmap-fix-false-positive-vm_bug-in-page_add_file_rmap.patch
 added to -mm tree
Date: Wed, 10 Aug 2016 14:54:19 -0700
Message-ID: <57aba28b.mvG3osMG0qjwcJsJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbcHJVyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2016 17:54:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, labbott@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, rmap: fix false positive VM_BUG() in page_add_file_rmap()
has been added to the -mm tree.  Its filename is
     mm-rmap-fix-false-positive-vm_bug-in-page_add_file_rmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-fix-false-positive-vm_bug-in-page_add_file_rmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-fix-false-positive-vm_bug-in-page_add_file_rmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, rmap: fix false positive VM_BUG() in page_add_file_rmap()

PageTransCompound() doesn't distinguish THP from from any other type of
compound pages.  This can lead to false-positive VM_BUG_ON() in
page_add_file_rmap() if called on compound page from a driver[1].

I think we can exclude such cases by checking if the page belong to a
mapping.

The VM_BUG_ON_PAGE() is downgraded to VM_WARN_ON_ONCE().  This path should
not cause any harm to non-THP page, but good to know if we step on
anything else.

[1] http://lkml.kernel.org/r/c711e067-0bff-a6cb-3c37-04dfe77d2db1@redhat.com

Link: http://lkml.kernel.org/r/20160810161345.GA67522@black.fi.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Laura Abbott <labbott@redhat.com>
Tested-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/rmap.c~mm-rmap-fix-false-positive-vm_bug-in-page_add_file_rmap mm/rmap.c
--- a/mm/rmap.c~mm-rmap-fix-false-positive-vm_bug-in-page_add_file_rmap
+++ a/mm/rmap.c
@@ -1284,8 +1284,9 @@ void page_add_file_rmap(struct page *pag
 		VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
 		__inc_node_page_state(page, NR_SHMEM_PMDMAPPED);
 	} else {
-		if (PageTransCompound(page)) {
-			VM_BUG_ON_PAGE(!PageLocked(page), page);
+		if (PageTransCompound(page) && page_mapping(page)) {
+			VM_WARN_ON_ONCE(!PageLocked(page));
+
 			SetPageDoubleMap(compound_head(page));
 			if (PageMlocked(page))
 				clear_page_mlock(compound_head(page));
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-rmap-fix-false-positive-vm_bug-in-page_add_file_rmap.patch

