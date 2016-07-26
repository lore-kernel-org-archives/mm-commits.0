From: akpm@linux-foundation.org
Subject: [patch 078/126] include/linux/memblock.h: clean up code for
 several trivial details
Date: Tue, 26 Jul 2016 15:24:47 -0700
Message-ID: <5797e32f.1KJtPVWVFkyPycxW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758415AbcGZWYt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:24:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, chengang@emindsoft.com.cn, gang.chen.5i5j@gmail.com

From: Chen Gang <chengang@emindsoft.com.cn>
Subject: include/linux/memblock.h: Clean up code for several trivial details

Correct the function parameters alignment, since original code already use
both tabs and white spaces together for the incorrect parameters alignment
functions.

If one line can hold one statement within 80 columns, let it in one line
(original code did not consider about the tabs/spaces for 2nd line when a
statement is separated into 2 lines).

Try to let '' aligned within one macro, since all related lines are
short enough.

Remove useless statement "idx = 0;", and always assign rgn within the
'for' statement.

Link: http://lkml.kernel.org/r/1464904899-1714-1-git-send-email-chengang@emindsoft.com.cn
Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN include/linux/memblock.h~include-linux-memblockh-clean-up-code-for-several-trivial-details include/linux/memblock.h
--- a/include/linux/memblock.h~include-linux-memblockh-clean-up-code-for-several-trivial-details
+++ a/include/linux/memblock.h
@@ -73,8 +73,8 @@ extern bool movable_node_enabled;
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 
 phys_addr_t memblock_find_in_range_node(phys_addr_t size, phys_addr_t align,
-					    phys_addr_t start, phys_addr_t end,
-					    int nid, ulong flags);
+					phys_addr_t start, phys_addr_t end,
+					int nid, ulong flags);
 phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 				   phys_addr_t size, phys_addr_t align);
 phys_addr_t get_allocated_memblock_reserved_regions_info(phys_addr_t *addr);
@@ -110,7 +110,7 @@ void __next_mem_range_rev(u64 *idx, int
 			  phys_addr_t *out_end, int *out_nid);
 
 void __next_reserved_mem_region(u64 *idx, phys_addr_t *out_start,
-			       phys_addr_t *out_end);
+				phys_addr_t *out_end);
 
 /**
  * for_each_mem_range - iterate through memblock areas from type_a and not
@@ -148,7 +148,7 @@ void __next_reserved_mem_region(u64 *idx
 			       p_start, p_end, p_nid)			\
 	for (i = (u64)ULLONG_MAX,					\
 		     __next_mem_range_rev(&i, nid, flags, type_a, type_b,\
-					 p_start, p_end, p_nid);	\
+					  p_start, p_end, p_nid);	\
 	     i != (u64)ULLONG_MAX;					\
 	     __next_mem_range_rev(&i, nid, flags, type_a, type_b,	\
 				  p_start, p_end, p_nid))
@@ -163,8 +163,7 @@ void __next_reserved_mem_region(u64 *idx
  * is initialized.
  */
 #define for_each_reserved_mem_region(i, p_start, p_end)			\
-	for (i = 0UL,							\
-	     __next_reserved_mem_region(&i, p_start, p_end);		\
+	for (i = 0UL, __next_reserved_mem_region(&i, p_start, p_end);	\
 	     i != (u64)ULLONG_MAX;					\
 	     __next_reserved_mem_region(&i, p_start, p_end))
 
@@ -403,15 +402,14 @@ static inline unsigned long memblock_reg
 }
 
 #define for_each_memblock(memblock_type, region)					\
-	for (region = memblock.memblock_type.regions;				\
+	for (region = memblock.memblock_type.regions;					\
 	     region < (memblock.memblock_type.regions + memblock.memblock_type.cnt);	\
 	     region++)
 
 #define for_each_memblock_type(memblock_type, rgn)			\
-	idx = 0;							\
-	rgn = &memblock_type->regions[idx];				\
-	for (idx = 0; idx < memblock_type->cnt;				\
-	     idx++,rgn = &memblock_type->regions[idx])
+	for (idx = 0, rgn = &memblock_type->regions[0];			\
+	     idx < memblock_type->cnt;					\
+	     idx++, rgn = &memblock_type->regions[idx])
 
 #ifdef CONFIG_MEMTEST
 extern void early_memtest(phys_addr_t start, phys_addr_t end);
_
