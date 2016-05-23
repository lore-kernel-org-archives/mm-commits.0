From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblockc-remove-unnecessary-always-true-comparison.patch removed from
 -mm tree
Date: Mon, 23 May 2016 12:46:45 -0700
Message-ID: <57435e25.XjolLj3A6KBR29aW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbcEWTqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dev@g0hl1n.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: remove unnecessary always-true comparison
has been removed from the -mm tree.  Its filename was
     mm-memblockc-remove-unnecessary-always-true-comparison.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


