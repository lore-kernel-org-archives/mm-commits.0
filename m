From: akpm@linux-foundation.org
Subject: [patch 056/114] net/ipv6/ila/ila_xlat.c: simplify a
 strange allocation pattern
Date: Mon, 08 May 2017 15:57:21 -0700
Message-ID: <20170508225721.a2i5wVia7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46670 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751959AbdEHW5X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:57:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, eric.dumazet@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org, tom@herbertland.com, torvalds@linux-foundation.org, vbabka@suse.cz

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
