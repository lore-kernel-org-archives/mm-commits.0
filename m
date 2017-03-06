From: akpm@linux-foundation.org
Subject: + ila-simplify-a-strange-allocation-pattern.patch added to -mm
 tree
Date: Mon, 06 Mar 2017 13:48:01 -0800
Message-ID: <58bdd911.ZfLC0UyvuEuPRbmh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55674 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754282AbdCFWc0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 17:32:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, davem@davemloft.net, eric.dumazet@gmail.com, tom@herbertland.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: net/ipv6/ila/ila_xlat.c: simplify a strange allocation pattern
has been added to the -mm tree.  Its filename is
     ila-simplify-a-strange-allocation-pattern.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ila-simplify-a-strange-allocation-pattern.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ila-simplify-a-strange-allocation-pattern.patch

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
Subject: net/ipv6/ila/ila_xlat.c: simplify a strange allocation pattern

alloc_ila_locks seemed to c&p from alloc_bucket_locks allocation pattern
which is quite unusual.  The default allocation size is 320 *
sizeof(spinlock_t) which is sub page unless lockdep is enabled when the
performance benefit is really questionable and not worth the subtle code
IMHO.  Also note that the context when we call ila_init_net (modprobe or a
task creating a net namespace) has to be properly configured.

Let's just simplify the code and use kvmalloc helper which is a
transparent way to use kmalloc with vmalloc fallback.

Link: http://lkml.kernel.org/r/20170306103032.2540-5-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Tom Herbert <tom@herbertland.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv6/ila/ila_xlat.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN net/ipv6/ila/ila_xlat.c~ila-simplify-a-strange-allocation-pattern net/ipv6/ila/ila_xlat.c
--- a/net/ipv6/ila/ila_xlat.c~ila-simplify-a-strange-allocation-pattern
+++ a/net/ipv6/ila/ila_xlat.c
@@ -41,13 +41,7 @@ static int alloc_ila_locks(struct ila_ne
 	size = roundup_pow_of_two(nr_pcpus * LOCKS_PER_CPU);
 
 	if (sizeof(spinlock_t) != 0) {
-#ifdef CONFIG_NUMA
-		if (size * sizeof(spinlock_t) > PAGE_SIZE)
-			ilan->locks = vmalloc(size * sizeof(spinlock_t));
-		else
-#endif
-		ilan->locks = kmalloc_array(size, sizeof(spinlock_t),
-					    GFP_KERNEL);
+		ilan->locks = kvmalloc(size * sizeof(spinlock_t), GFP_KERNEL);
 		if (!ilan->locks)
 			return -ENOMEM;
 		for (i = 0; i < size; i++)
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

