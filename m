From: akpm@linux-foundation.org
Subject: [merged] mm-memblock-add-debug-output-for-the-memblock_add.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:52:43 -0700
Message-ID: <552fe8db.wcltAw7lE1BLyJCb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbbDPQrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:47:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, Emilian.Medve@freescale.com, akinobu.mita@gmail.com, catalin.marinas@arm.com, fabf@skynet.be, phacht@linux.vnet.ibm.com, schwidefsky@de.ibm.com, tangchen@cn.fujitsu.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: add debug output for memblock_add()
has been removed from the -mm tree.  Its filename was
     mm-memblock-add-debug-output-for-the-memblock_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/memblock.c: add debug output for memblock_add()

memblock_reserve() calls memblock_reserve_region() which prints debugging
information if 'memblock=debug' was passed on the command line.  This
patch adds the same behaviour, but for memblock_add function().

[akpm@linux-foundation.org: s/memblock_memory/memblock_add/ in message]
Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Emil Medve <Emilian.Medve@freescale.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN mm/memblock.c~mm-memblock-add-debug-output-for-the-memblock_add mm/memblock.c
--- a/mm/memblock.c~mm-memblock-add-debug-output-for-the-memblock_add
+++ a/mm/memblock.c
@@ -580,10 +580,24 @@ int __init_memblock memblock_add_node(ph
 	return memblock_add_range(&memblock.memory, base, size, nid, 0);
 }
 
+static int __init_memblock memblock_add_region(phys_addr_t base,
+						phys_addr_t size,
+						int nid,
+						unsigned long flags)
+{
+	struct memblock_type *_rgn = &memblock.memory;
+
+	memblock_dbg("memblock_add: [%#016llx-%#016llx] flags %#02lx %pF\n",
+		     (unsigned long long)base,
+		     (unsigned long long)base + size - 1,
+		     flags, (void *)_RET_IP_);
+
+	return memblock_add_range(_rgn, base, size, nid, flags);
+}
+
 int __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
 {
-	return memblock_add_range(&memblock.memory, base, size,
-				   MAX_NUMNODES, 0);
+	return memblock_add_region(base, size, MAX_NUMNODES, 0);
 }
 
 /**
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

origin.patch
fs-fat-remove-unnecessary-defintion.patch
fs-fat-remove-unnecessary-includes.patch
fs-fat-remove-unnecessary-includes-fix.patch
fs-fat-remove-unnecessary-includes-fix-2.patch
fs-fat-comment-fix-fat_bits-can-be-also-32.patch
linux-next.patch

