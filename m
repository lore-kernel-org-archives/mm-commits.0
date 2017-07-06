From: akpm@linux-foundation.org
Subject: [patch 025/108] mm/slab.c: replace open-coded round-up
 code with ALIGN
Date: Thu, 06 Jul 2017 15:36:37 -0700
Message-ID: <20170706223637.q2G_9p5Hx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34822 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752913AbdGFWgi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:36:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, canjiang.lu@samsung.com, cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, torvalds@linux-foundation.org

From: Canjiang Lu <canjiang.lu@samsung.com>
Subject: mm/slab.c: replace open-coded round-up code with ALIGN

Link: http://lkml.kernel.org/r/20170616072918epcms5p4ff16c24ef8472b4c3b4371823cd87856@epcms5p4
Signed-off-by: Canjiang Lu <canjiang.lu@samsung.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN mm/slab.c~subject-mm-slab-trivial-change-to-replace-round-up-code-with-align mm/slab.c
--- a/mm/slab.c~subject-mm-slab-trivial-change-to-replace-round-up-code-with-align
+++ a/mm/slab.c
@@ -2040,17 +2040,13 @@ __kmem_cache_create (struct kmem_cache *
 	 * unaligned accesses for some archs when redzoning is used, and makes
 	 * sure any on-slab bufctl's are also correctly aligned.
 	 */
-	if (size & (BYTES_PER_WORD - 1)) {
-		size += (BYTES_PER_WORD - 1);
-		size &= ~(BYTES_PER_WORD - 1);
-	}
+	size = ALIGN(size, BYTES_PER_WORD);
 
 	if (flags & SLAB_RED_ZONE) {
 		ralign = REDZONE_ALIGN;
 		/* If redzoning, ensure that the second redzone is suitably
 		 * aligned, by adjusting the object size accordingly. */
-		size += REDZONE_ALIGN - 1;
-		size &= ~(REDZONE_ALIGN - 1);
+		size = ALIGN(size, REDZONE_ALIGN);
 	}
 
 	/* 3) caller mandated alignment */
_
