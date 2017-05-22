From: akpm@linux-foundation.org
Subject: + mm-adaptive-hash-table-scaling-v2.patch added to -mm tree
Date: Mon, 22 May 2017 12:49:40 -0700
Message-ID: <592340d4.zsoevrHbSA2Gf/Wo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38832 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751309AbdEVTtl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 May 2017 15:49:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, babu.moger@oracle.com, davem@davemloft.net, sfr@canb.auug.org.au, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-adaptive-hash-table-scaling-v2
has been added to the -mm tree.  Its filename is
     mm-adaptive-hash-table-scaling-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-adaptive-hash-table-scaling-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-adaptive-hash-table-scaling-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm-adaptive-hash-table-scaling-v2

UL -> ULL fix

Link: http://lkml.kernel.org/r/1495300013-653283-2-git-send-email-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Babu Moger <babu.moger@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-adaptive-hash-table-scaling-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-adaptive-hash-table-scaling-v2
+++ a/mm/page_alloc.c
@@ -7173,7 +7173,7 @@ static unsigned long __init arch_reserve
  * quadruples the scale is increased by one, which means the size of hash table
  * only doubles, instead of quadrupling as well.
  */
-#define ADAPT_SCALE_BASE	(64ul << 30)
+#define ADAPT_SCALE_BASE	(64ull << 30)
 #define ADAPT_SCALE_SHIFT	2
 #define ADAPT_SCALE_NPAGES	(ADAPT_SCALE_BASE >> PAGE_SHIFT)
 
@@ -7209,7 +7209,7 @@ void *__init alloc_large_system_hash(con
 			numentries = round_up(numentries, (1<<20)/PAGE_SIZE);
 
 		if (!high_limit) {
-			unsigned long adapt;
+			unsigned long long adapt;
 
 			for (adapt = ADAPT_SCALE_NPAGES; adapt < numentries;
 			     adapt <<= ADAPT_SCALE_SHIFT)
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-zeroing-hash-tables-in-allocator.patch
mm-updated-callers-to-use-hash_zero-flag.patch
mm-adaptive-hash-table-scaling.patch
mm-adaptive-hash-table-scaling-v2.patch
sparc64-ng4-memset-32-bits-overflow.patch

