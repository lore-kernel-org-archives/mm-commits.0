From: akpm@linux-foundation.org
Subject: [patch 055/114] lib/rhashtable.c: simplify a strange
 allocation pattern
Date: Mon, 08 May 2017 15:57:18 -0700
Message-ID: <20170508225718.XX6xBM2fX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46594 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751959AbdEHW5U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:57:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, eric.dumazet@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org, tom@herbertland.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: lib/rhashtable.c: simplify a strange allocation pattern

alloc_bucket_locks allocation pattern is quite unusual.  We are preferring
vmalloc when CONFIG_NUMA is enabled.  The rationale is that vmalloc will
respect the memory policy of the current process and so the backing memory
will get distributed over multiple nodes if the requester is configured
properly.  At least that is the intention, in reality rhastable is shrunk
and expanded from a kernel worker so no mempolicy can be assumed.

Let's just simplify the code and use kvmalloc helper, which is a
transparent way to use kmalloc with vmalloc fallback, if the caller is
allowed to block and use the flag otherwise.

Link: http://lkml.kernel.org/r/20170306103032.2540-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Tom Herbert <tom@herbertland.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rhashtable.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff -puN lib/rhashtable.c~rhashtable-simplify-a-strange-allocation-pattern lib/rhashtable.c
--- a/lib/rhashtable.c~rhashtable-simplify-a-strange-allocation-pattern
+++ a/lib/rhashtable.c
@@ -86,16 +86,9 @@ static int alloc_bucket_locks(struct rha
 		size = min(size, 1U << tbl->nest);
 
 	if (sizeof(spinlock_t) != 0) {
-		tbl->locks = NULL;
-#ifdef CONFIG_NUMA
-		if (size * sizeof(spinlock_t) > PAGE_SIZE &&
-		    gfp == GFP_KERNEL)
-			tbl->locks = vmalloc(size * sizeof(spinlock_t));
-#endif
-		if (gfp != GFP_KERNEL)
-			gfp |= __GFP_NOWARN | __GFP_NORETRY;
