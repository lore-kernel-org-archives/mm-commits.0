From: akpm@linux-foundation.org
Subject: + mm-zswap-numa-aware-allocation-for-zswap_dstmem.patch added to
 -mm tree
Date: Tue, 27 May 2014 13:50:29 -0700
Message-ID: <5384fa95.iJIIH48uW8/9Ugmi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaE0Uua (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 May 2014 16:50:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, edumazet@google.com

Subject: + mm-zswap-numa-aware-allocation-for-zswap_dstmem.patch added to -mm tree
To: edumazet@google.com
From: akpm@linux-foundation.org
Date: Tue, 27 May 2014 13:50:29 -0700


The patch titled
     Subject: mm/zswap: NUMA aware allocation for zswap_dstmem
has been added to the -mm tree.  Its filename is
     mm-zswap-numa-aware-allocation-for-zswap_dstmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-numa-aware-allocation-for-zswap_dstmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-numa-aware-allocation-for-zswap_dstmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: mm/zswap: NUMA aware allocation for zswap_dstmem

zswap_dstmem is a percpu block of memory, which should be allocated using
kmalloc_node(), to get better NUMA locality.

Without it, all the blocks are allocated from a single node.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Seth Jennings <sjennings@variantweb.net>
David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zswap.c~mm-zswap-numa-aware-allocation-for-zswap_dstmem mm/zswap.c
--- a/mm/zswap.c~mm-zswap-numa-aware-allocation-for-zswap_dstmem
+++ a/mm/zswap.c
@@ -347,7 +347,7 @@ static int __zswap_cpu_notifier(unsigned
 			return NOTIFY_BAD;
 		}
 		*per_cpu_ptr(zswap_comp_pcpu_tfms, cpu) = tfm;
-		dst = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
+		dst = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
 		if (!dst) {
 			pr_err("can't allocate compressor buffer\n");
 			crypto_free_comp(tfm);
_

Patches currently in -mm which might be from edumazet@google.com are

mm-zswap-numa-aware-allocation-for-zswap_dstmem.patch
linux-next.patch

