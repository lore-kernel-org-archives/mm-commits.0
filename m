From: akpm@linux-foundation.org
Subject: + rhashtable-simplify-a-strange-allocation-pattern.patch added to -mm tree
Date: Mon, 06 Mar 2017 13:47:59 -0800
Message-ID: <58bdd90f.GPZxrNfLncr42cCn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55672 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754199AbdCFWc0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 17:32:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, eric.dumazet@gmail.com, tom@herbertland.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/rhashtable.c: simplify a strange allocation pattern
has been added to the -mm tree.  Its filename is
     rhashtable-simplify-a-strange-allocation-pattern.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rhashtable-simplify-a-strange-allocation-pattern.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rhashtable-simplify-a-strange-allocation-pattern.patch

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
-
-		if (!tbl->locks)
+		if (gfpflags_allow_blocking(gfp))
+			tbl->locks = kvmalloc(size * sizeof(spinlock_t), gfp);
+		else
 			tbl->locks = kmalloc_array(size, sizeof(spinlock_t),
 						   gfp);
 		if (!tbl->locks)
_

Patches currently in -mm which might be from mhocko@suse.com are

lockdep-allow-to-disable-reclaim-lockup-detection.patch
xfs-abstract-pf_fstrans-to-pf_memalloc_nofs.patch
mm-introduce-memalloc_nofs_saverestore-api.patch
xfs-use-memalloc_nofs_saverestore-instead-of-memalloc_noio.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch
mm-introduce-kvalloc-helpers.patch
mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb.patch
rhashtable-simplify-a-strange-allocation-pattern.patch
ila-simplify-a-strange-allocation-pattern.patch
xattr-zero-out-memory-copied-to-userspace-in-getxattr.patch
treewide-use-kvalloc-rather-than-opencoded-variants.patch
net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant.patch
md-use-kvmalloc-rather-than-opencoded-variant.patch
bcache-use-kvmalloc.patch

