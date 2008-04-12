From: akpm@linux-foundation.org
Subject: + slub-add-missing-slab_unlock-to-__kmem_cache_shrink.patch added to -mm tree
Date: Fri, 11 Apr 2008 20:55:09 -0700
Message-ID: <200804120355.m3C3t91g018251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756844AbYDLDzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Apr 2008 23:55:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, adobriyan@gmail.com, clameter@sgi.com


The patch titled
     slub: add missing slab_unlock() to __kmem_cache_shrink()
has been added to the -mm tree.  Its filename is
     slub-add-missing-slab_unlock-to-__kmem_cache_shrink.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slub: add missing slab_unlock() to __kmem_cache_shrink()
From: Pekka J Enberg <penberg@cs.helsinki.fi>

If page is not kickable, remember to slab_unlock() before continuing the loop.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-add-missing-slab_unlock-to-__kmem_cache_shrink mm/slub.c
--- a/mm/slub.c~slub-add-missing-slab_unlock-to-__kmem_cache_shrink
+++ a/mm/slub.c
@@ -2926,8 +2926,10 @@ static unsigned long __kmem_cache_shrink
 			continue;
 
 		if (page->inuse) {
-			if (!SlabKickable(page))
+			if (!SlabKickable(page)) {
+				slab_unlock(page);
 				continue;
+			}
 
 			if (page->inuse * 100 >=
 					s->defrag_ratio * page->objects) {
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
git-x86.patch
git-unionfs.patch
git-pekka.patch
mm-move-cache_line_size-to-linux-cacheh.patch
fs-coda-remove-static-inline-forward-declarations.patch
documentation-patch-tags-one-more-time.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
slab-leaks3-default-y.patch
slub-add-missing-slab_unlock-to-__kmem_cache_shrink.patch

