From: akpm@linux-foundation.org
Subject: + vfs-__read_cache_page-should-use-gfp-argument-rather-than-gfp_kernel.patch added to -mm tree
Date: Wed, 21 Dec 2011 12:29:44 -0800
Message-ID: <20111221202945.186515C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:42904 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab1LUU3r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2011 15:29:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave.kleikamp@oracle.com, hughd@google.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: vfs: __read_cache_page() should use gfp argument rather than GFP_KERNEL
has been added to the -mm tree.  Its filename is
     vfs-__read_cache_page-should-use-gfp-argument-rather-than-gfp_kernel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: vfs: __read_cache_page() should use gfp argument rather than GFP_KERNEL

lockdep reports a deadlock in jfs because a special inode's rw semaphore
is taken recursively.  The mapping's gfp mask is GFP_NOFS, but is not used
when __read_cache_page() calls add_to_page_cache_lru().

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/filemap.c~vfs-__read_cache_page-should-use-gfp-argument-rather-than-gfp_kernel mm/filemap.c
--- a/mm/filemap.c~vfs-__read_cache_page-should-use-gfp-argument-rather-than-gfp_kernel
+++ a/mm/filemap.c
@@ -1814,7 +1814,7 @@ repeat:
 		page = __page_cache_alloc(gfp | __GFP_COLD);
 		if (!page)
 			return ERR_PTR(-ENOMEM);
-		err = add_to_page_cache_lru(page, mapping, index, GFP_KERNEL);
+		err = add_to_page_cache_lru(page, mapping, index, gfp);
 		if (unlikely(err)) {
 			page_cache_release(page);
 			if (err == -EEXIST)
@@ -1911,10 +1911,7 @@ static struct page *wait_on_page_read(st
  * @gfp:	the page allocator flags to use if allocating
  *
  * This is the same as "read_mapping_page(mapping, index, NULL)", but with
- * any new page allocations done using the specified allocation flags. Note
- * that the Radix tree operations will still use GFP_KERNEL, so you can't
- * expect to do this atomically or anything like that - but you can pass in
- * other page requirements.
+ * any new page allocations done using the specified allocation flags.
  *
  * If the page does not get brought uptodate, return -EIO.
  */
_
Subject: Subject: vfs: __read_cache_page() should use gfp argument rather than GFP_KERNEL

Patches currently in -mm which might be from dave.kleikamp@oracle.com are

vfs-__read_cache_page-should-use-gfp-argument-rather-than-gfp_kernel.patch

