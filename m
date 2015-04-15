From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblockc-name-the-local-variable-of-memblock_type-as-type.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:09:14 -0700
Message-ID: <552eb75a.3Bd2YzgQchiRC6Je%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670AbbDOTJO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:09:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: rename local variable of memblock_type to `type'
has been removed from the -mm tree.  Its filename was
     mm-memblockc-name-the-local-variable-of-memblock_type-as-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/memblock.c: rename local variable of memblock_type to `type'

A small cleanup.  Seems in e3239ff9 ("memblock: Rename memblock_region to
memblock_type and memblock_property to memblock_region") this one was
missed.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memblock.c~mm-memblockc-name-the-local-variable-of-memblock_type-as-type mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-name-the-local-variable-of-memblock_type-as-type
+++ a/mm/memblock.c
@@ -699,14 +699,14 @@ static int __init_memblock memblock_rese
 						   int nid,
 						   unsigned long flags)
 {
-	struct memblock_type *_rgn = &memblock.reserved;
+	struct memblock_type *type = &memblock.reserved;
 
 	memblock_dbg("memblock_reserve: [%#016llx-%#016llx] flags %#02lx %pF\n",
 		     (unsigned long long)base,
 		     (unsigned long long)base + size - 1,
 		     flags, (void *)_RET_IP_);
 
-	return memblock_add_range(_rgn, base, size, nid, flags);
+	return memblock_add_range(type, base, size, nid, flags);
 }
 
 int __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
_

Patches currently in -mm which might be from bhe@redhat.com are

origin.patch

