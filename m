From: akpm@linux-foundation.org
Subject: + memblock-add-memblock_start_of_dram.patch added to -mm tree
Date: Tue, 23 Aug 2011 14:03:22 -0700
Message-ID: <201108232103.p7NL3MVX006515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755344Ab1HWVD5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 17:03:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, davem@davemloft.net, hpa@zytor.com, tj@kernel.org, yinghai@kernel.org


The patch titled
     memblock: add memblock_start_of_DRAM()
has been added to the -mm tree.  Its filename is
     memblock-add-memblock_start_of_dram.patch

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
Subject: memblock: add memblock_start_of_DRAM()
From: Sam Ravnborg <sam@ravnborg.org>

SPARC32 require access to the start address.  Add a new helper
memblock_start_of_DRAM() to give access to the address of the first
memblock - which contains the lowest address.

The awkward name was chosen to match the already present
memblock_end_of_DRAM().

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Yinghai Lu <yinghai@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    1 +
 mm/memblock.c            |    6 ++++++
 2 files changed, 7 insertions(+)

diff -puN include/linux/memblock.h~memblock-add-memblock_start_of_dram include/linux/memblock.h
--- a/include/linux/memblock.h~memblock-add-memblock_start_of_dram
+++ a/include/linux/memblock.h
@@ -80,6 +80,7 @@ extern phys_addr_t __memblock_alloc_base
 					   phys_addr_t align,
 					   phys_addr_t max_addr);
 extern phys_addr_t memblock_phys_mem_size(void);
+extern phys_addr_t memblock_start_of_DRAM(void);
 extern phys_addr_t memblock_end_of_DRAM(void);
 extern void memblock_enforce_memory_limit(phys_addr_t memory_limit);
 extern int memblock_is_memory(phys_addr_t addr);
diff -puN mm/memblock.c~memblock-add-memblock_start_of_dram mm/memblock.c
--- a/mm/memblock.c~memblock-add-memblock_start_of_dram
+++ a/mm/memblock.c
@@ -626,6 +626,12 @@ phys_addr_t __init memblock_phys_mem_siz
 	return memblock.memory_size;
 }
 
+/* lowest address */
+phys_addr_t __init_memblock memblock_start_of_DRAM(void)
+{
+	return memblock.memory.regions[0].base;
+}
+
 phys_addr_t __init_memblock memblock_end_of_DRAM(void)
 {
 	int idx = memblock.memory.cnt - 1;
_

Patches currently in -mm which might be from sam@ravnborg.org are

linux-next.patch
memblock-add-memblock_start_of_dram.patch
memblock-add-no_bootmem-config-symbol.patch

