From: akpm@linux-foundation.org
Subject: [patch 6/8] mm, rmap: fix false positive VM_BUG() in
 page_add_file_rmap()
Date: Wed, 10 Aug 2016 16:27:52 -0700
Message-ID: <57abb878.yb4DFzQN90bL28f0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbcHJX1x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2016 19:27:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, labbott@redhat.com

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
