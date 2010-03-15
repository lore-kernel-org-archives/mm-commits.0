From: akpm@linux-foundation.org
Subject: + fs-splicec-fix-mapping_gfp_mask-usage.patch added to -mm tree
Date: Mon, 15 Mar 2010 13:37:44 -0700
Message-ID: <201003152037.o2FKbikv021251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932138Ab0COUiO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 16:38:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, jens.axboe@oracle.com


The patch titled
     fs/splice.c: fix mapping_gfp_mask usage
has been added to the -mm tree.  Its filename is
     fs-splicec-fix-mapping_gfp_mask-usage.patch

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
Subject: fs/splice.c: fix mapping_gfp_mask usage
From: Nick Piggin <npiggin@suse.de>

mapping_gfp_mask() is not supposed to store allocation contex details,
only page location details.  So mapping_gfp_mask should be applied to the
pagecache page allocation, wheras normal (kernel mapped) memory should be
used for surrounding allocations such as radix-tree nodes allocated by
add_to_page_cache.  Context modifiers should be applied on a per-callsite
basis.

So change splice to follow this convention (which is followed in similar
code patterns in core code).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/splice.c~fs-splicec-fix-mapping_gfp_mask-usage fs/splice.c
--- a/fs/splice.c~fs-splicec-fix-mapping_gfp_mask-usage
+++ a/fs/splice.c
@@ -320,7 +320,7 @@ __generic_file_splice_read(struct file *
 				break;
 
 			error = add_to_page_cache_lru(page, mapping, index,
-						mapping_gfp_mask(mapping));
+						GFP_KERNEL);
 			if (unlikely(error)) {
 				page_cache_release(page);
 				if (error == -EEXIST)
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
fs-splicec-fix-mapping_gfp_mask-usage.patch
reiser4.patch

