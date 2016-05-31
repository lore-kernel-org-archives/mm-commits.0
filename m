From: akpm@linux-foundation.org
Subject: + jbd2-get-rid-of-superfluous-__gfp_repeat.patch added to -mm
 tree
Date: Tue, 31 May 2016 12:53:45 -0700
Message-ID: <574debc9.nEq8wdM3f0m88Ds+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbcEaTxq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 15:53:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, jack@suse.cz, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: jbd2: get rid of superfluous __GFP_REPEAT
has been added to the -mm tree.  Its filename is
     jbd2-get-rid-of-superfluous-__gfp_repeat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/jbd2-get-rid-of-superfluous-__gfp_repeat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/jbd2-get-rid-of-superfluous-__gfp_repeat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: jbd2: get rid of superfluous __GFP_REPEAT

jbd2_alloc is explicit about its allocation preferences wrt. the
allocation size. Sub page allocations go to the slab allocator
and larger are using either the page allocator or vmalloc. This
is all good but the logic is unnecessarily complex.

1) as per Ted, the vmalloc fallback is a left-over:

 : jbd2_alloc is only passed in the bh->b_size, which can't be PAGE_SIZE, so
 : the code path that calls vmalloc() should never get called.  When we
 : conveted jbd2_alloc() to suppor sub-page size allocations in commit
 : d2eecb039368, there was an assumption that it could be called with a size
 : greater than PAGE_SIZE, but that's certaily not true today.

Moreover vmalloc allocation might even lead to a deadlock because the
callers expect GFP_NOFS context while vmalloc is GFP_KERNEL.

2) __GFP_REPEAT for requests <= PAGE_ALLOC_COSTLY_ORDER is ignored
   since the flag was introduced.

Let's simplify the code flow and use the slab allocator for sub-page
requests and the page allocator for others.  Even though order > 0 is not
currently used as per above leave that option open.

Link: http://lkml.kernel.org/r/1464599699-30131-18-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |   32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff -puN fs/jbd2/journal.c~jbd2-get-rid-of-superfluous-__gfp_repeat fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd2-get-rid-of-superfluous-__gfp_repeat
+++ a/fs/jbd2/journal.c
@@ -2329,18 +2329,10 @@ void *jbd2_alloc(size_t size, gfp_t flag
 
 	BUG_ON(size & (size-1)); /* Must be a power of 2 */
 
-	flags |= __GFP_REPEAT;
-	if (size == PAGE_SIZE)
-		ptr = (void *)__get_free_pages(flags, 0);
-	else if (size > PAGE_SIZE) {
-		int order = get_order(size);
-
-		if (order < 3)
-			ptr = (void *)__get_free_pages(flags, order);
-		else
-			ptr = vmalloc(size);
-	} else
+	if (size < PAGE_SIZE)
 		ptr = kmem_cache_alloc(get_slab(size), flags);
+	else
+		ptr = (void *)__get_free_pages(flags, get_order(size));
 
 	/* Check alignment; SLUB has gotten this wrong in the past,
 	 * and this can lead to user data corruption! */
@@ -2351,20 +2343,10 @@ void *jbd2_alloc(size_t size, gfp_t flag
 
 void jbd2_free(void *ptr, size_t size)
 {
-	if (size == PAGE_SIZE) {
-		free_pages((unsigned long)ptr, 0);
-		return;
-	}
-	if (size > PAGE_SIZE) {
-		int order = get_order(size);
-
-		if (order < 3)
-			free_pages((unsigned long)ptr, order);
-		else
-			vfree(ptr);
-		return;
-	}
-	kmem_cache_free(get_slab(size), ptr);
+	if (size < PAGE_SIZE)
+		kmem_cache_free(get_slab(size), ptr);
+	else
+		free_pages((unsigned long)ptr, get_order(size));
 };
 
 /*
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom_reaper-do-not-use-siglock-in-try_oom_reaper.patch
tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i.patch
x86-get-rid-of-superfluous-__gfp_repeat.patch
x86-efi-get-rid-of-superfluous-__gfp_repeat.patch
arm-get-rid-of-superfluous-__gfp_repeat.patch
arm64-get-rid-of-superfluous-__gfp_repeat.patch
arc-get-rid-of-superfluous-__gfp_repeat.patch
mips-get-rid-of-superfluous-__gfp_repeat.patch
nios2-get-rid-of-superfluous-__gfp_repeat.patch
parisc-get-rid-of-superfluous-__gfp_repeat.patch
score-get-rid-of-superfluous-__gfp_repeat.patch
powerpc-get-rid-of-superfluous-__gfp_repeat.patch
sparc-get-rid-of-superfluous-__gfp_repeat.patch
s390-get-rid-of-superfluous-__gfp_repeat.patch
sh-get-rid-of-superfluous-__gfp_repeat.patch
tile-get-rid-of-superfluous-__gfp_repeat.patch
unicore32-get-rid-of-superfluous-__gfp_repeat.patch
jbd2-get-rid-of-superfluous-__gfp_repeat.patch

