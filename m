From: akpm@linux-foundation.org
Subject: [patch 040/131] mm/memblock.c: make the index explicit
 argument of for_each_memblock_type
Date: Wed, 15 Nov 2017 17:33:42 -0800
Message-ID: <20171116013342.nlFAIP4bV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933553AbdKPBdo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:33:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gi-oh.kim@profitbricks.com, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Gioh Kim <gi-oh.kim@profitbricks.com>
Subject: mm/memblock.c: make the index explicit argument of for_each_memblock_type

for_each_memblock_type macro function relies on idx variable defined in
the caller context.  Silent macro arguments are almost always wrong thing
to do.  They make code harder to read and easier to get wrong.  Let's use
an explicit iterator parameter for for_each_memblock_type and make the
code more obious.  This patch is a mere cleanup and it shouldn't introduce
any functional change.

Link: http://lkml.kernel.org/r/20170913133029.28911-1-gi-oh.kim@profitbricks.com
Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    8 ++++----
 mm/memblock.c            |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN include/linux/memblock.h~mm-memblockc-make-the-index-explicit-argument-of-for_each_memblock_type include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblockc-make-the-index-explicit-argument-of-for_each_memblock_type
+++ a/include/linux/memblock.h
@@ -389,10 +389,10 @@ static inline unsigned long memblock_reg
 	     region < (memblock.memblock_type.regions + memblock.memblock_type.cnt);	\
 	     region++)
 
-#define for_each_memblock_type(memblock_type, rgn)			\
-	for (idx = 0, rgn = &memblock_type->regions[0];			\
-	     idx < memblock_type->cnt;					\
-	     idx++, rgn = &memblock_type->regions[idx])
+#define for_each_memblock_type(i, memblock_type, rgn)			\
+	for (i = 0, rgn = &memblock_type->regions[0];			\
+	     i < memblock_type->cnt;					\
+	     i++, rgn = &memblock_type->regions[i])
 
 #ifdef CONFIG_MEMTEST
 extern void early_memtest(phys_addr_t start, phys_addr_t end);
diff -puN mm/memblock.c~mm-memblockc-make-the-index-explicit-argument-of-for_each_memblock_type mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-make-the-index-explicit-argument-of-for_each_memblock_type
+++ a/mm/memblock.c
@@ -533,7 +533,7 @@ repeat:
 	base = obase;
 	nr_new = 0;
 
-	for_each_memblock_type(type, rgn) {
+	for_each_memblock_type(idx, type, rgn) {
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
 
@@ -637,7 +637,7 @@ static int __init_memblock memblock_isol
 		if (memblock_double_array(type, base, size) < 0)
 			return -ENOMEM;
 
-	for_each_memblock_type(type, rgn) {
+	for_each_memblock_type(idx, type, rgn) {
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
 
@@ -1715,7 +1715,7 @@ static void __init_memblock memblock_dum
 
 	pr_info(" %s.cnt  = 0x%lx\n", type->name, type->cnt);
 
-	for_each_memblock_type(type, rgn) {
+	for_each_memblock_type(idx, type, rgn) {
 		char nid_buf[32] = "";
 
 		base = rgn->base;
@@ -1739,7 +1739,7 @@ memblock_reserved_memory_within(phys_add
 	unsigned long size = 0;
 	int idx;
 
-	for_each_memblock_type((&memblock.reserved), rgn) {
+	for_each_memblock_type(idx, (&memblock.reserved), rgn) {
 		phys_addr_t start, end;
 
 		if (rgn->base + rgn->size < start_addr)
_
