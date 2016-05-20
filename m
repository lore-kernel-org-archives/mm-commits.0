From: akpm@linux-foundation.org
Subject: [patch 044/162] mm/memblock.c: remove unnecessary always-true
 comparison
Date: Fri, 20 May 2016 16:58:33 -0700
Message-ID: <573fa4a9.nzUXMqjhBXu82MrW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbcETX6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:58:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dev@g0hl1n.net

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
