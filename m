From: akpm@linux-foundation.org
Subject: + linux-slabh-fix-three-off-by-one-typos-in-comment.patch added
 to -mm tree
Date: Thu, 23 Apr 2015 14:21:13 -0700
Message-ID: <55396249.v0k9hWpajF/mwX4b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030920AbbDWVVO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Apr 2015 17:21:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/slab.h: fix three off-by-one typos in comment
has been added to the -mm tree.  Its filename is
     linux-slabh-fix-three-off-by-one-typos-in-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-slabh-fix-three-off-by-one-typos-in-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-slabh-fix-three-off-by-one-typos-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: linux/slab.h: fix three off-by-one typos in comment

The first is a keyboard-off-by-one, the other two the ordinary mathy kind.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/slab.h~linux-slabh-fix-three-off-by-one-typos-in-comment include/linux/slab.h
--- a/include/linux/slab.h~linux-slabh-fix-three-off-by-one-typos-in-comment
+++ a/include/linux/slab.h
@@ -262,8 +262,8 @@ extern struct kmem_cache *kmalloc_dma_ca
  * belongs to.
  * 0 = zero alloc
  * 1 =  65 .. 96 bytes
- * 2 = 120 .. 192 bytes
- * n = 2^(n-1) .. 2^n -1
+ * 2 = 129 .. 192 bytes
+ * n = 2^(n-1)+1 .. 2^n
  */
 static __always_inline int kmalloc_index(size_t size)
 {
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-slabh-fix-three-off-by-one-typos-in-comment.patch
__bitmap_parselist-fix-bug-in-empty-string-handling.patch

