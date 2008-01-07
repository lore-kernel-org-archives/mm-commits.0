From: akpm@linux-foundation.org
Subject: + xip-fix-get_zeroed_page-with-__gfp_highmem.patch added to -mm tree
Date: Mon, 07 Jan 2008 01:12:14 -0800
Message-ID: <200801070911.m079BsqT017632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752908AbYAGJMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 04:12:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, cotte@de.ibm.com, hugh@veritas.com


The patch titled
     xip: fix get_zeroed_page with __GFP_HIGHMEM
has been added to the -mm tree.  Its filename is
     xip-fix-get_zeroed_page-with-__gfp_highmem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xip: fix get_zeroed_page with __GFP_HIGHMEM
From: Akinobu Mita <akinobu.mita@gmail.com>

The use of get_zeroed_page() with __GFP_HIGHMEM is invalid.  Use
alloc_page() with __GFP_ZERO instead of invalid get_zeroed_page().

(This patch is only compile tested)

Cc: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap_xip.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/filemap_xip.c~xip-fix-get_zeroed_page-with-__gfp_highmem mm/filemap_xip.c
--- a/mm/filemap_xip.c~xip-fix-get_zeroed_page-with-__gfp_highmem
+++ a/mm/filemap_xip.c
@@ -25,14 +25,15 @@ static struct page *__xip_sparse_page;
 static struct page *xip_sparse_page(void)
 {
 	if (!__xip_sparse_page) {
-		unsigned long zeroes = get_zeroed_page(GFP_HIGHUSER);
-		if (zeroes) {
+		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
+
+		if (page) {
 			static DEFINE_SPINLOCK(xip_alloc_lock);
 			spin_lock(&xip_alloc_lock);
 			if (!__xip_sparse_page)
-				__xip_sparse_page = virt_to_page(zeroes);
+				__xip_sparse_page = page;
 			else
-				free_page(zeroes);
+				__free_page(page);
 			spin_unlock(&xip_alloc_lock);
 		}
 	}
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

xip-fix-get_zeroed_page-with-__gfp_highmem.patch
git-dvb.patch
git-net.patch
git-battery.patch
fs-use-hlist_unhashed.patch
fs-use-list_for_each_entry_reverse-and-kill-sb_entry.patch
ext-fix-comment-for-nonexistent-variable.patch
ext-use-ext_get_group_desc.patch
ext-remove-unused-argument-for-ext_find_goal.patch
ext-cleanup-ext_bg_num_gdb.patch
