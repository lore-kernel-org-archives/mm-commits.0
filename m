From: akpm@linux-foundation.org
Subject: +
 mm-memblock-rename-local-variable-of-memblock_type-to-type.patch added to
 -mm tree
Date: Mon, 17 Aug 2015 14:50:14 -0700
Message-ID: <55d25716.noKpHLjkRlGiZB4E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbbHQVuP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Aug 2015 17:50:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: rename local variable of memblock_type to 'type'
has been added to the -mm tree.  Its filename is
     mm-memblock-rename-local-variable-of-memblock_type-to-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-rename-local-variable-of-memblock_type-to-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-rename-local-variable-of-memblock_type-to-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/memblock.c: rename local variable of memblock_type to 'type'

Since e3239ff92a1 (memblock: Rename memblock_region to memblock_type and
memblock_property to memblock_region), all local variables of the
membock_type type were renamed to 'type'.  This commit renames all
remaining local variables with the memblock_type type to the same view.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/memblock.c~mm-memblock-rename-local-variable-of-memblock_type-to-type mm/memblock.c
--- a/mm/memblock.c~mm-memblock-rename-local-variable-of-memblock_type-to-type
+++ a/mm/memblock.c
@@ -615,14 +615,14 @@ static int __init_memblock memblock_add_
 						int nid,
 						unsigned long flags)
 {
-	struct memblock_type *_rgn = &memblock.memory;
+	struct memblock_type *type = &memblock.memory;
 
 	memblock_dbg("memblock_add: [%#016llx-%#016llx] flags %#02lx %pF\n",
 		     (unsigned long long)base,
 		     (unsigned long long)base + size - 1,
 		     flags, (void *)_RET_IP_);
 
-	return memblock_add_range(_rgn, base, size, nid, flags);
+	return memblock_add_range(type, base, size, nid, flags);
 }
 
 int __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
@@ -835,10 +835,10 @@ void __init_memblock __next_reserved_mem
 					   phys_addr_t *out_start,
 					   phys_addr_t *out_end)
 {
-	struct memblock_type *rsv = &memblock.reserved;
+	struct memblock_type *type = &memblock.reserved;
 
-	if (*idx >= 0 && *idx < rsv->cnt) {
-		struct memblock_region *r = &rsv->regions[*idx];
+	if (*idx >= 0 && *idx < type->cnt) {
+		struct memblock_region *r = &type->regions[*idx];
 		phys_addr_t base = r->base;
 		phys_addr_t size = r->size;
 
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

sh-use-pfn_down-macro.patch
memblock-make-memblock_overlaps_region-return-bool.patch
mem-hotplug-handle-node-hole-when-initializing-numa_meminfo.patch
mm-memblock-rename-local-variable-of-memblock_type-to-type.patch
linux-next.patch

