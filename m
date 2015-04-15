From: akpm@linux-foundation.org
Subject: [merged] memtest-use-phys_addr_t-for-physical-addresses.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 12:30:53 -0700
Message-ID: <552ebc6d.euCgFUV0/aZ1l99/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbbDOTZg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:25:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, catalin.marinas@arm.com, hpa@zytor.com, mark.rutland@arm.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memtest: use phys_addr_t for physical addresses
has been removed from the -mm tree.  Its filename was
     memtest-use-phys_addr_t-for-physical-addresses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: memtest: use phys_addr_t for physical addresses

Since memtest might be used by other architectures pass input parameters
as phys_addr_t instead of long to prevent overflow.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 ++--
 mm/memtest.c             |   16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN include/linux/memblock.h~memtest-use-phys_addr_t-for-physical-addresses include/linux/memblock.h
--- a/include/linux/memblock.h~memtest-use-phys_addr_t-for-physical-addresses
+++ a/include/linux/memblock.h
@@ -366,9 +366,9 @@ static inline unsigned long memblock_reg
 #endif
 
 #ifdef CONFIG_MEMTEST
-extern void early_memtest(unsigned long start, unsigned long end);
+extern void early_memtest(phys_addr_t start, phys_addr_t end);
 #else
-static inline void early_memtest(unsigned long start, unsigned long end)
+static inline void early_memtest(phys_addr_t start, phys_addr_t end)
 {
 }
 #endif
diff -puN mm/memtest.c~memtest-use-phys_addr_t-for-physical-addresses mm/memtest.c
--- a/mm/memtest.c~memtest-use-phys_addr_t-for-physical-addresses
+++ a/mm/memtest.c
@@ -29,7 +29,7 @@ static u64 patterns[] __initdata = {
 	0x7a6c7258554e494cULL, /* yeah ;-) */
 };
 
-static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
+static void __init reserve_bad_mem(u64 pattern, phys_addr_t start_bad, phys_addr_t end_bad)
 {
 	printk(KERN_INFO "  %016llx bad mem addr %010llx - %010llx reserved\n",
 	       (unsigned long long) pattern,
@@ -38,11 +38,11 @@ static void __init reserve_bad_mem(u64 p
 	memblock_reserve(start_bad, end_bad - start_bad);
 }
 
-static void __init memtest(u64 pattern, u64 start_phys, u64 size)
+static void __init memtest(u64 pattern, phys_addr_t start_phys, phys_addr_t size)
 {
 	u64 *p, *start, *end;
-	u64 start_bad, last_bad;
-	u64 start_phys_aligned;
+	phys_addr_t start_bad, last_bad;
+	phys_addr_t start_phys_aligned;
 	const size_t incr = sizeof(pattern);
 
 	start_phys_aligned = ALIGN(start_phys, incr);
@@ -69,14 +69,14 @@ static void __init memtest(u64 pattern,
 		reserve_bad_mem(pattern, start_bad, last_bad + incr);
 }
 
-static void __init do_one_pass(u64 pattern, u64 start, u64 end)
+static void __init do_one_pass(u64 pattern, phys_addr_t start, phys_addr_t end)
 {
 	u64 i;
 	phys_addr_t this_start, this_end;
 
 	for_each_free_mem_range(i, NUMA_NO_NODE, &this_start, &this_end, NULL) {
-		this_start = clamp_t(phys_addr_t, this_start, start, end);
-		this_end = clamp_t(phys_addr_t, this_end, start, end);
+		this_start = clamp(this_start, start, end);
+		this_end = clamp(this_end, start, end);
 		if (this_start < this_end) {
 			printk(KERN_INFO "  %010llx - %010llx pattern %016llx\n",
 			       (unsigned long long)this_start,
@@ -102,7 +102,7 @@ static int __init parse_memtest(char *ar
 
 early_param("memtest", parse_memtest);
 
-void __init early_memtest(unsigned long start, unsigned long end)
+void __init early_memtest(phys_addr_t start, phys_addr_t end)
 {
 	unsigned int i;
 	unsigned int idx = 0;
_

Patches currently in -mm which might be from vladimir.murzin@arm.com are

origin.patch

