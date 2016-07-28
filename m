From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-optimize-copy_page_to-from_iter_iovec-fix-fix.patch removed from -mm
 tree
Date: Thu, 28 Jul 2016 15:12:45 -0700
Message-ID: <579a835d.CobEo8o5/uYwu4xk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbcG1WMq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:12:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@kernel.org, mpatocka@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-optimize-copy_page_to-from_iter_iovec-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-optimize-copy_page_to-from_iter_iovec-fix-fix.patch

This patch was dropped because it was folded into mm-optimize-copy_page_to-from_iter_iovec.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-optimize-copy_page_to-from_iter_iovec-fix-fix

change copy_page_from_iter_iovec() as well

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iov_iter.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN lib/iov_iter.c~mm-optimize-copy_page_to-from_iter_iovec-fix-fix lib/iov_iter.c
--- a/lib/iov_iter.c~mm-optimize-copy_page_to-from_iter_iovec-fix-fix
+++ a/lib/iov_iter.c
@@ -227,8 +227,7 @@ static size_t copy_page_from_iter_iovec(
 	buf = iov->iov_base + skip;
 	copy = min(bytes, iov->iov_len - skip);
 
-#ifdef CONFIG_HIGHMEM
-	if (!fault_in_pages_readable(buf, copy)) {
+	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_pages_readable(buf, copy)) {
 		kaddr = kmap_atomic(page);
 		to = kaddr + offset;
 
@@ -259,7 +258,6 @@ static size_t copy_page_from_iter_iovec(
 		copy = min(bytes, iov->iov_len - skip);
 	}
 	/* Too bad - revert to non-atomic kmap */
-#endif
 
 	kaddr = kmap(page);
 	to = kaddr + offset;
@@ -280,9 +278,7 @@ static size_t copy_page_from_iter_iovec(
 	}
 	kunmap(page);
 
-#ifdef CONFIG_HIGHMEM
 done:
-#endif
 	if (skip == iov->iov_len) {
 		iov++;
 		skip = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements-checkpatch-fixes.patch
mm-optimize-copy_page_to-from_iter_iovec.patch

