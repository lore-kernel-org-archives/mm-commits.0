From: akpm@linux-foundation.org
Subject: [patch 023/117] mm/slab: remove BAD_ALIEN_MAGIC again
Date: Thu, 19 May 2016 17:10:05 -0700
Message-ID: <573e55dd.XBCjMqhSl+jbLYHB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbcETAKH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:10:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, geert@linux-m68k.org, penberg@kernel.org, rientjes@google.com

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: remove BAD_ALIEN_MAGIC again

Initial attemp to remove BAD_ALIEN_MAGIC is once reverted by 'commit
edcad2509550 ("Revert "slab: remove BAD_ALIEN_MAGIC"")' because it causes
a problem on m68k which has many node but !CONFIG_NUMA.  In this case,
although alien cache isn't used at all but to cope with some
initialization path, garbage value is used and that is BAD_ALIEN_MAGIC. 
Now, this patch set use_alien_caches to 0 when !CONFIG_NUMA, there is no
initialization path problem so we don't need BAD_ALIEN_MAGIC at all.  So
remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~mm-slab-remove-bad_alien_magic-again mm/slab.c
--- a/mm/slab.c~mm-slab-remove-bad_alien_magic-again
+++ a/mm/slab.c
@@ -421,8 +421,6 @@ static struct kmem_cache kmem_cache_boot
 	.name = "kmem_cache",
 };
 
-#define BAD_ALIEN_MAGIC 0x01020304ul
