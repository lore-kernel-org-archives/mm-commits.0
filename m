From: akpm@linux-foundation.org
Subject: + mm-enable-hashdist-by-default-on-64bit-numa.patch added to -mm tree
Date: Tue, 10 Mar 2009 15:45:40 -0700
Message-ID: <200903102245.n2AMjeDX014060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753014AbZCJWs7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 18:48:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, benh@kernel.crashing.org, davem@davemloft.net, heiko.carstens@de.ibm.com, ink@jurassic.park.msu.ru, ralf@linux-mips.org, rth@twiddle.net, schwidefsky@de.ibm.com


The patch titled
     mm: enable hashdist by default on 64bit NUMA
has been added to the -mm tree.  Its filename is
     mm-enable-hashdist-by-default-on-64bit-numa.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: enable hashdist by default on 64bit NUMA
From: Anton Blanchard <anton@samba.org>

On PowerPC we allocate large boot time hashes on node 0.  This leads to an
imbalance in the free memory, for example on a 64GB box (4 x 16GB nodes):

Free memory:
Node 0: 97.03%
Node 1: 98.54%
Node 2: 98.42%
Node 3: 98.53%

If we switch to using vmalloc (like ia64 and x86-64) things are more
balanced:

Free memory:
Node 0: 97.53%
Node 1: 98.35%
Node 2: 98.33%
Node 3: 98.33%

For many HPC applications we are limited by the free available memory on
the smallest node, so even though the same amount of memory is used the
better balancing helps.

Since all 64bit NUMA capable architectures should have sufficient vmalloc
space, it makes sense to enable it via CONFIG_64BIT.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/bootmem.h~mm-enable-hashdist-by-default-on-64bit-numa include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-enable-hashdist-by-default-on-64bit-numa
+++ a/include/linux/bootmem.h
@@ -146,10 +146,10 @@ extern void *alloc_large_system_hash(con
 
 #define HASH_EARLY	0x00000001	/* Allocating during early boot? */
 
-/* Only NUMA needs hash distribution.
- * IA64 and x86_64 have sufficient vmalloc space.
+/* Only NUMA needs hash distribution. 64bit NUMA architectures have
+ * sufficient vmalloc space.
  */
-#if defined(CONFIG_NUMA) && (defined(CONFIG_IA64) || defined(CONFIG_X86_64))
+#if defined(CONFIG_NUMA) && defined(CONFIG_64BIT)
 #define HASHDIST_DEFAULT 1
 #else
 #define HASHDIST_DEFAULT 0
_

Patches currently in -mm which might be from anton@samba.org are

linux-next.patch
mm-enable-hashdist-by-default-on-64bit-numa.patch

