From: akpm@linux-foundation.org
Subject: [merged]
 memblock-dont-mark-memblock_phys_mem_size-as-__init.patch removed from -mm
 tree
Date: Wed, 10 Feb 2016 11:35:30 -0800
Message-ID: <56bb9102.ZKBEsJtPWm4ZXRX6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbcBJTfa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:35:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@gibson.dropbear.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: don't mark memblock_phys_mem_size() as __init
has been removed from the -mm tree.  Its filename was
     memblock-dont-mark-memblock_phys_mem_size-as-__init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Gibson <david@gibson.dropbear.id.au>
Subject: memblock: don't mark memblock_phys_mem_size() as __init

At the moment memblock_phys_mem_size() is marked as __init, and so is
discarded after boot.  This is different from most of the memblock
functions which are marked __init_memblock, and are only discarded after
boot if memory hotplug is not configured.

To allow for upcoming code which will need memblock_phys_mem_size() in the
hotplug path, change it from __init to __init_memblock.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memblock.c~memblock-dont-mark-memblock_phys_mem_size-as-__init mm/memblock.c
--- a/mm/memblock.c~memblock-dont-mark-memblock_phys_mem_size-as-__init
+++ a/mm/memblock.c
@@ -1448,7 +1448,7 @@ void __init __memblock_free_late(phys_ad
  * Remaining API functions
  */
 
-phys_addr_t __init memblock_phys_mem_size(void)
+phys_addr_t __init_memblock memblock_phys_mem_size(void)
 {
 	return memblock.memory.total_size;
 }
_

Patches currently in -mm which might be from david@gibson.dropbear.id.au are


