From: akpm@linux-foundation.org
Subject: + mm-also-use-alloc_large_system_hash-for-the-pid-hash-table.patch added to -mm tree
Date: Wed, 19 Aug 2009 14:38:03 -0700
Message-ID: <200908192138.n7JLc3fK028640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752930AbZHSVim (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 17:38:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, ebiederm@xmission.com, jbeulich@novell.com, mel@csn.ul.ie, mingo@elte.hu


The patch titled
     mm: also use alloc_large_system_hash() for the PID hash table
has been added to the -mm tree.  Its filename is
     mm-also-use-alloc_large_system_hash-for-the-pid-hash-table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: also use alloc_large_system_hash() for the PID hash table
From: "Jan Beulich" <JBeulich@novell.com>

This is being done by allowing boot time allocations to specify that they
may want a sub-page sized amount of memory.

Overall this seems more consistent with the other hash table allocations,
and allows making two supposedly mm-only variables really mm-only
(nr_{kernel,all}_pages).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    5 ++---
 kernel/pid.c            |   15 ++++-----------
 mm/page_alloc.c         |   13 ++++++++++---
 3 files changed, 16 insertions(+), 17 deletions(-)

diff -puN include/linux/bootmem.h~mm-also-use-alloc_large_system_hash-for-the-pid-hash-table include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-also-use-alloc_large_system_hash-for-the-pid-hash-table
+++ a/include/linux/bootmem.h
@@ -132,9 +132,6 @@ static inline void *alloc_remap(int nid,
 }
 #endif /* CONFIG_HAVE_ARCH_ALLOC_REMAP */
 
-extern unsigned long __meminitdata nr_kernel_pages;
-extern unsigned long __meminitdata nr_all_pages;
-
 extern void *alloc_large_system_hash(const char *tablename,
 				     unsigned long bucketsize,
 				     unsigned long numentries,
@@ -145,6 +142,8 @@ extern void *alloc_large_system_hash(con
 				     unsigned long limit);
 
 #define HASH_EARLY	0x00000001	/* Allocating during early boot? */
+#define HASH_SMALL	0x00000002	/* sub-page allocation allowed, min
+					 * shift passed via *_hash_shift */
 
 /* Only NUMA needs hash distribution. 64bit NUMA architectures have
  * sufficient vmalloc space.
diff -puN kernel/pid.c~mm-also-use-alloc_large_system_hash-for-the-pid-hash-table kernel/pid.c
--- a/kernel/pid.c~mm-also-use-alloc_large_system_hash-for-the-pid-hash-table
+++ a/kernel/pid.c
@@ -40,7 +40,7 @@
 #define pid_hashfn(nr, ns)	\
 	hash_long((unsigned long)nr + (unsigned long)ns, pidhash_shift)
 static struct hlist_head *pid_hash;
-static int pidhash_shift;
+static unsigned int pidhash_shift = 4;
 struct pid init_struct_pid = INIT_STRUCT_PID;
 
 int pid_max = PID_MAX_DEFAULT;
@@ -499,19 +499,12 @@ struct pid *find_ge_pid(int nr, struct p
 void __init pidhash_init(void)
 {
 	int i, pidhash_size;
-	unsigned long megabytes = nr_kernel_pages >> (20 - PAGE_SHIFT);
 
-	pidhash_shift = max(4, fls(megabytes * 4));
-	pidhash_shift = min(12, pidhash_shift);
+	pid_hash = alloc_large_system_hash("PID", sizeof(*pid_hash), 0, 18,
+					   HASH_EARLY | HASH_SMALL,
+					   &pidhash_shift, NULL, 4096);
 	pidhash_size = 1 << pidhash_shift;
 
-	printk("PID hash table entries: %d (order: %d, %Zd bytes)\n",
-		pidhash_size, pidhash_shift,
-		pidhash_size * sizeof(struct hlist_head));
-
-	pid_hash = alloc_bootmem(pidhash_size *	sizeof(*(pid_hash)));
-	if (!pid_hash)
-		panic("Could not alloc pidhash!\n");
 	for (i = 0; i < pidhash_size; i++)
 		INIT_HLIST_HEAD(&pid_hash[i]);
 }
diff -puN mm/page_alloc.c~mm-also-use-alloc_large_system_hash-for-the-pid-hash-table mm/page_alloc.c
--- a/mm/page_alloc.c~mm-also-use-alloc_large_system_hash-for-the-pid-hash-table
+++ a/mm/page_alloc.c
@@ -124,8 +124,8 @@ static char * const zone_names[MAX_NR_ZO
 
 int min_free_kbytes = 1024;
 
-unsigned long __meminitdata nr_kernel_pages;
-unsigned long __meminitdata nr_all_pages;
+static unsigned long __meminitdata nr_kernel_pages;
+static unsigned long __meminitdata nr_all_pages;
 static unsigned long __meminitdata dma_reserve;
 
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
@@ -4842,7 +4842,14 @@ void *__init alloc_large_system_hash(con
 			numentries <<= (PAGE_SHIFT - scale);
 
 		/* Make sure we've got at least a 0-order allocation.. */
-		if (unlikely((numentries * bucketsize) < PAGE_SIZE))
+		if (unlikely(flags & HASH_SMALL)) {
+			/* Makes no sense without HASH_EARLY */
+			WARN_ON(!(flags & HASH_EARLY));
+			if (!(numentries >> *_hash_shift)) {
+				numentries = 1UL << *_hash_shift;
+				BUG_ON(!numentries);
+			}
+		} else if (unlikely((numentries * bucketsize) < PAGE_SIZE))
 			numentries = PAGE_SIZE / bucketsize;
 	}
 	numentries = roundup_pow_of_two(numentries);
_

Patches currently in -mm which might be from JBeulich@novell.com are

linux-next.patch
memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
mm-dont-use-alloc_bootmem_low-where-not-strictly-needed.patch
mm-also-use-alloc_large_system_hash-for-the-pid-hash-table.patch

