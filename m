From: akpm@linux-foundation.org
Subject: + mm-slab-fix-unaligned-access-on-sparc64.patch added to -mm tree
Date: Mon, 13 Oct 2014 12:27:57 -0700
Message-ID: <543c27bd.tTCE7KqfP6APVAEa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbaJMT16 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 15:27:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, davem@davemloft.net, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: fix unaligned access on sparc64
has been added to the -mm tree.  Its filename is
     mm-slab-fix-unaligned-access-on-sparc64.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-fix-unaligned-access-on-sparc64.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-fix-unaligned-access-on-sparc64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: fix unaligned access on sparc64

commit bf0dea23a9c0 ("mm/slab: use percpu allocator for cpu cache")
changes allocation method for cpu cache array from slab allocator to
percpu allocator.  Alignment should be provided for aligned memory in
percpu allocator case, but, that commit mistakenly set this alignment to
0.  So, percpu allocator returns unaligned memory address.  It doesn't
cause any problem on x86 which permits unaligned access, but, it causes
the problem on sparc64 which needs strong guarantee of alignment.

Following bug report is reported from David Miller.

  I'm getting tons of the following on sparc64:

  [603965.383447] Kernel unaligned access at TPC[546b58] free_block+0x98/0x1a0
  [603965.396987] Kernel unaligned access at TPC[546b60] free_block+0xa0/0x1a0
  [603965.410523] Kernel unaligned access at TPC[546b58] free_block+0x98/0x1a0
  [603965.424061] Kernel unaligned access at TPC[546b60] free_block+0xa0/0x1a0
  [603965.437617] Kernel unaligned access at TPC[546b58] free_block+0x98/0x1a0
  [603970.554394] log_unaligned: 333 callbacks suppressed
  [603970.564041] Kernel unaligned access at TPC[546b58] free_block+0x98/0x1a0
  [603970.577576] Kernel unaligned access at TPC[546b60] free_block+0xa0/0x1a0
  [603970.591122] Kernel unaligned access at TPC[546b58] free_block+0x98/0x1a0
  [603970.604669] Kernel unaligned access at TPC[546b60] free_block+0xa0/0x1a0
  [603970.618216] Kernel unaligned access at TPC[546b58] free_block+0x98/0x1a0
  [603976.515633] log_unaligned: 31 callbacks suppressed
  snip...

This patch provides proper alignment parameter when allocating cpu cache
to fix this unaligned memory access problem on sparc64.

Reported-by: David Miller <davem@davemloft.net>
Tested-by: David Miller <davem@davemloft.net>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~mm-slab-fix-unaligned-access-on-sparc64 mm/slab.c
--- a/mm/slab.c~mm-slab-fix-unaligned-access-on-sparc64
+++ a/mm/slab.c
@@ -1992,7 +1992,7 @@ static struct array_cache __percpu *allo
 	struct array_cache __percpu *cpu_cache;
 
 	size = sizeof(void *) * entries + sizeof(struct array_cache);
-	cpu_cache = __alloc_percpu(size, 0);
+	cpu_cache = __alloc_percpu(size, sizeof(void *));
 
 	if (!cpu_cache)
 		return NULL;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-slab-fix-unaligned-access-on-sparc64.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree.patch
page-owners-correct-page-order-when-to-free-page.patch

