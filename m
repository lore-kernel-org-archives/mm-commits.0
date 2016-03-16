From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblock-remove-unnecessary-memblock_type-variable.patch removed from
 -mm tree
Date: Wed, 16 Mar 2016 12:57:11 -0700
Message-ID: <56e9ba97.lV0THCwytlSvfaSI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934499AbcCPT5M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: remove unnecessary memblock_type variable
has been removed from the -mm tree.  Its filename was
     mm-memblock-remove-unnecessary-memblock_type-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/memblock.c: remove unnecessary memblock_type variable

We define struct memblock_type *type in the memblock_add_region() and
memblock_reserve_region() functions only for passing it to the
memlock_add_range() and memblock_reserve_range() functions.  Let's remove
these variables and will pass a type directly.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN mm/memblock.c~mm-memblock-remove-unnecessary-memblock_type-variable mm/memblock.c
--- a/mm/memblock.c~mm-memblock-remove-unnecessary-memblock_type-variable
+++ a/mm/memblock.c
@@ -612,14 +612,12 @@ static int __init_memblock memblock_add_
 						int nid,
 						unsigned long flags)
 {
-	struct memblock_type *type = &memblock.memory;
-
 	memblock_dbg("memblock_add: [%#016llx-%#016llx] flags %#02lx %pF\n",
 		     (unsigned long long)base,
 		     (unsigned long long)base + size - 1,
 		     flags, (void *)_RET_IP_);
 
-	return memblock_add_range(type, base, size, nid, flags);
+	return memblock_add_range(&memblock.memory, base, size, nid, flags);
 }
 
 int __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
@@ -740,14 +738,12 @@ static int __init_memblock memblock_rese
 						   int nid,
 						   unsigned long flags)
 {
-	struct memblock_type *type = &memblock.reserved;
