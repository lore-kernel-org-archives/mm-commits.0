From: akpm@linux-foundation.org
Subject: + x86-mm-setting-fields-in-deferred-pages.patch added to -mm tree
Date: Fri, 13 Oct 2017 14:18:39 -0700
Message-ID: <59e12daf.j5N+j6CN5c+N04va%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58732 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbdJMVSm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 17:18:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, bob.picco@oracle.com, borntraeger@de.ibm.com, catalin.marinas@arm.com, daniel.m.jordan@oracle.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, heiko.carstens@de.ibm.com, hpa@zytor.com, mark.rutland@arm.com, mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com, mingo@redhat.com, sam@ravnborg.org, steven.sistare@oracle.com, tglx@linutronix.de, will.deacon@arm.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/mm: set fields in deferred pages
has been added to the -mm tree.  Its filename is
     x86-mm-setting-fields-in-deferred-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-setting-fields-in-deferred-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-setting-fields-in-deferred-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: x86/mm: set fields in deferred pages

Without deferred struct page feature (CONFIG_DEFERRED_STRUCT_PAGE_INIT),
flags and other fields in "struct page"es are never changed prior to first
initializing struct pages by going through __init_single_page().

With deferred struct page feature enabled, however, we set fields in
register_page_bootmem_info that are subsequently clobbered right after in
free_all_bootmem:

        mem_init() {
                register_page_bootmem_info();
                free_all_bootmem();
                ...
        }

When register_page_bootmem_info() is called only non-deferred struct pages
are initialized.  But, this function goes through some reserved pages
which might be part of the deferred, and thus are not yet initialized.

  mem_init
   register_page_bootmem_info
    register_page_bootmem_info_node
     get_page_bootmem
      .. setting fields here ..
      such as: page->freelist = (void *)type;

  free_all_bootmem()
   free_low_memory_core_early()
    for_each_reserved_mem_region()
     reserve_bootmem_region()
      init_reserved_page() <- Only if this is deferred reserved page
       __init_single_pfn()
        __init_single_page()
            memset(0) <-- Loose the set fields here

We end up with issue where, currently we do not observe problem as memory
is explicitly zeroed.  But, if flag asserts are changed we can start
hitting issues.

Also, because in this patch series we will stop zeroing struct page memory
during allocation, we must make sure that struct pages are properly
initialized prior to using them.

The deferred-reserved pages are initialized in free_all_bootmem(). 
Therefore, the fix is to switch the above calls.

Link: http://lkml.kernel.org/r/20171013173214.27300-3-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reviewed-by: Steven Sistare <steven.sistare@oracle.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: Bob Picco <bob.picco@oracle.com>
Tested-by: Bob Picco <bob.picco@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/init_64.c~x86-mm-setting-fields-in-deferred-pages arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86-mm-setting-fields-in-deferred-pages
+++ a/arch/x86/mm/init_64.c
@@ -1173,12 +1173,18 @@ void __init mem_init(void)
 
 	/* clear_bss() already clear the empty_zero_page */
 
-	register_page_bootmem_info();
-
 	/* this will put all memory onto the freelists */
 	free_all_bootmem();
 	after_bootmem = 1;
 
+	/*
+	 * Must be done after boot memory is put on freelist, because here we
+	 * might set fields in deferred struct pages that have not yet been
+	 * initialized, and free_all_bootmem() initializes all the reserved
+	 * deferred pages for us.
+	 */
+	register_page_bootmem_info();
+
 	/* Register memory areas for /proc/kcore */
 	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_ADDR,
 			 PAGE_SIZE, KCORE_OTHER);
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-deferred_init_memmap-improvements.patch
x86-mm-setting-fields-in-deferred-pages.patch
sparc64-mm-setting-fields-in-deferred-pages.patch
sparc64-simplify-vmemmap_populate.patch
mm-defining-memblock_virt_alloc_try_nid_raw.patch
mm-zero-reserved-and-unavailable-struct-pages.patch
x86-kasan-add-and-use-kasan_map_populate.patch
arm64-kasan-add-and-use-kasan_map_populate.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap.patch
sparc64-optimized-struct-page-zeroing.patch
sparc64-ng4-memset-32-bits-overflow.patch

