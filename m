From: akpm@linux-foundation.org
Subject: + mm-swap_slots-use-conditional-compilation-for-swap_slotsc.patch added to -mm tree
Date: Thu, 08 Feb 2018 16:12:02 -0800
Message-ID: <5a7ce752./0ctGWkPbovvl+N0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37714 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbeBIAMD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Feb 2018 19:12:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, akpm@linux-foundation.org, tim.c.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_slots.c: use conditional compilation
has been added to the -mm tree.  Its filename is
     mm-swap_slots-use-conditional-compilation-for-swap_slotsc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap_slots-use-conditional-compilation-for-swap_slotsc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap_slots-use-conditional-compilation-for-swap_slotsc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/swap_slots.c: use conditional compilation

For mm/swap_slots.c, use the traditional Linux method of conditional
compilation and linking instead of always compiling it by using #ifdef
CONFIG_SWAP and #endif for the entire source file (excluding header
files).

Link: http://lkml.kernel.org/r/c2a47015-0b5a-d0d9-8bc7-9984c049df20@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Makefile     |    4 ++--
 mm/swap_slots.c |    4 ----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -puN mm/Makefile~mm-swap_slots-use-conditional-compilation-for-swap_slotsc mm/Makefile
--- a/mm/Makefile~mm-swap_slots-use-conditional-compilation-for-swap_slotsc
+++ a/mm/Makefile
@@ -37,7 +37,7 @@ obj-y			:= filemap.o mempool.o oom_kill.
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   util.o mmzone.o vmstat.o backing-dev.o \
 			   mm_init.o mmu_context.o percpu.o slab_common.o \
-			   compaction.o vmacache.o swap_slots.o \
+			   compaction.o vmacache.o \
 			   interval_tree.o list_lru.o workingset.o \
 			   debug.o $(mmu-y)
 
@@ -55,7 +55,7 @@ ifdef CONFIG_MMU
 endif
 obj-$(CONFIG_HAVE_MEMBLOCK) += memblock.o
 
-obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o
+obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o swap_slots.o
 obj-$(CONFIG_FRONTSWAP)	+= frontswap.o
 obj-$(CONFIG_ZSWAP)	+= zswap.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
diff -puN mm/swap_slots.c~mm-swap_slots-use-conditional-compilation-for-swap_slotsc mm/swap_slots.c
--- a/mm/swap_slots.c~mm-swap_slots-use-conditional-compilation-for-swap_slotsc
+++ a/mm/swap_slots.c
@@ -34,8 +34,6 @@
 #include <linux/mutex.h>
 #include <linux/mm.h>
 
-#ifdef CONFIG_SWAP
-
 static DEFINE_PER_CPU(struct swap_slots_cache, swp_slots);
 static bool	swap_slot_cache_active;
 bool	swap_slot_cache_enabled;
@@ -356,5 +354,3 @@ repeat:
 
 	return entry;
 }
