From: akpm@linux-foundation.org
Subject: +
 subject-mm-slab-trivial-change-to-replace-round-up-code-with-align.patch
 added to -mm tree
Date: Fri, 16 Jun 2017 11:10:28 -0700
Message-ID: <59441f14.L+W7UdsJHLfBGSsr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56724 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750982AbdFPSK3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 14:10:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: canjiang.lu@samsung.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: replace open-coded round-up code with ALIGN
has been added to the -mm tree.  Its filename is
     subject-mm-slab-trivial-change-to-replace-round-up-code-with-align.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/subject-mm-slab-trivial-change-to-replace-round-up-code-with-align.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/subject-mm-slab-trivial-change-to-replace-round-up-code-with-align.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from canjiang.lu@samsung.com are

subject-mm-slab-trivial-change-to-replace-round-up-code-with-align.patch

