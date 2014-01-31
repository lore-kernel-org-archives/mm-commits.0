From: akpm@linux-foundation.org
Subject: [merged] memblock-bootmem-restore-goal-for-alloc_low.patch
 removed from -mm tree
Date: Fri, 31 Jan 2014 11:15:57 -0800
Message-ID: <52ebf66d.e6LA58/gH9BmoZGT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491AbaAaTP6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:15:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, tony.luck@gmail.com, yinghai@kernel.org

Subject: [merged] memblock-bootmem-restore-goal-for-alloc_low.patch removed from -mm tree
To: yinghai@kernel.org,tony.luck@gmail.com,tony.luck@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:15:57 -0800


The patch titled
     Subject: memblock, bootmem: restore goal for alloc_low
has been removed from the -mm tree.  Its filename was
     memblock-bootmem-restore-goal-for-alloc_low.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: memblock, bootmem: restore goal for alloc_low

Now we have memblock_virt_alloc_low to replace original bootmem api
in swiotlb.

But we should not use BOOTMEM_LOW_LIMIT for arch that does not support
CONFIG_NOBOOTMEM, as old api take 0.

| #define alloc_bootmem_low(x) \
|        __alloc_bootmem_low(x, SMP_CACHE_BYTES, 0)
|#define alloc_bootmem_low_pages_nopanic(x) \
|        __alloc_bootmem_low_nopanic(x, PAGE_SIZE, 0)

and we have
 #define BOOTMEM_LOW_LIMIT __pa(MAX_DMA_ADDRESS)
for CONFIG_NOBOOTMEM.

Restore goal to 0 to fix ia64 crash, that Tony found.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reported-by: Tony Luck <tony.luck@gmail.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/bootmem.h~memblock-bootmem-restore-goal-for-alloc_low include/linux/bootmem.h
--- a/include/linux/bootmem.h~memblock-bootmem-restore-goal-for-alloc_low
+++ a/include/linux/bootmem.h
@@ -264,7 +264,7 @@ static inline void * __init memblock_vir
 {
 	if (!align)
 		align = SMP_CACHE_BYTES;
-	return __alloc_bootmem_low(size, align, BOOTMEM_LOW_LIMIT);
+	return __alloc_bootmem_low(size, align, 0);
 }
 
 static inline void * __init memblock_virt_alloc_low_nopanic(
@@ -272,7 +272,7 @@ static inline void * __init memblock_vir
 {
 	if (!align)
 		align = SMP_CACHE_BYTES;
-	return __alloc_bootmem_low_nopanic(size, align, BOOTMEM_LOW_LIMIT);
+	return __alloc_bootmem_low_nopanic(size, align, 0);
 }
 
 static inline void * __init memblock_virt_alloc_from_nopanic(
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
linux-next.patch

