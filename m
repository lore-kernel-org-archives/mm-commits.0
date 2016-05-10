From: akpm@linux-foundation.org
Subject: + mm-memblockc-remove-unnecessary-always-true-comparison.patch
 added to -mm tree
Date: Tue, 10 May 2016 12:29:18 -0700
Message-ID: <5732368e.45nSqCJdJ0A2HJbN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbcEJT3T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 15:29:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dev@g0hl1n.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: remove unnecessary always-true comparison
has been added to the -mm tree.  Its filename is
     mm-memblockc-remove-unnecessary-always-true-comparison.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblockc-remove-unnecessary-always-true-comparison.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblockc-remove-unnecessary-always-true-comparison.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Richard Leitner <dev@g0hl1n.net>
Subject: mm/memblock.c: remove unnecessary always-true comparison

Comparing an u64 variable to >= 0 returns always true and can therefore
be removed. This issue was detected using the -Wtype-limits gcc flag.

This patch fixes following type-limits warning:

mm/memblock.c: In function `__next_reserved_mem_region':
mm/memblock.c:843:11: warning: comparison of unsigned expression >= 0 is
always true [-Wtype-limits]
  if (*idx >= 0 && *idx < type->cnt) {

Link: http://lkml.kernel.org/r/20160510103625.3a7f8f32@g0hl1n.net
Signed-off-by: Richard Leitner <dev@g0hl1n.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-memblockc-remove-unnecessary-always-true-comparison mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-remove-unnecessary-always-true-comparison
+++ a/mm/memblock.c
@@ -824,7 +824,7 @@ void __init_memblock __next_reserved_mem
 {
 	struct memblock_type *type = &memblock.reserved;
 
-	if (*idx >= 0 && *idx < type->cnt) {
+	if (*idx < type->cnt) {
 		struct memblock_region *r = &type->regions[*idx];
 		phys_addr_t base = r->base;
 		phys_addr_t size = r->size;
_

Patches currently in -mm which might be from dev@g0hl1n.net are

mm-memblockc-remove-unnecessary-always-true-comparison.patch

