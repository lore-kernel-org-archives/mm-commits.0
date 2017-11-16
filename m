From: akpm@linux-foundation.org
Subject: [patch 083/131] sparc64/mm: set fields in deferred pages
Date: Wed, 15 Nov 2017 17:36:18 -0800
Message-ID: <20171116013618.wbOtnhm4-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39854 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933615AbdKPBgU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:36:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, bob.picco@oracle.com, borntraeger@de.ibm.com, catalin.marinas@arm.com, daniel.m.jordan@oracle.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, heiko.carstens@de.ibm.com, hpa@zytor.com, mark.rutland@arm.com, mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com, mingo@redhat.com, mm-commits@vger.kernel.org, pasha.tatashin@oracle.com, sam@ravnborg.org, steven.sistare@oracle.com, tglx@linutronix.de, torvalds@linux-foundation.org, will.deacon@arm.com, willy@infradead.org

From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: sparc64/mm: set fields in deferred pages

Without deferred struct page feature (CONFIG_DEFERRED_STRUCT_PAGE_INIT),
flags and other fields in "struct page"es are never changed prior to first
initializing struct pages by going through __init_single_page().

With deferred struct page feature enabled there is a case where we set some
fields prior to initializing:

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

We end up with similar issue as in the previous patch, where currently we
do not observe problem as memory is zeroed.  But, if flag asserts are
changed we can start hitting issues.

Also, because in this patch series we will stop zeroing struct page memory
during allocation, we must make sure that struct pages are properly
initialized prior to using them.

The deferred-reserved pages are initialized in free_all_bootmem(). 
Therefore, the fix is to switch the above calls.

Link: http://lkml.kernel.org/r/20171013173214.27300-4-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reviewed-by: Steven Sistare <steven.sistare@oracle.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: Bob Picco <bob.picco@oracle.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
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

 arch/sparc/mm/init_64.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN arch/sparc/mm/init_64.c~sparc64-mm-setting-fields-in-deferred-pages arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~sparc64-mm-setting-fields-in-deferred-pages
+++ a/arch/sparc/mm/init_64.c
@@ -2540,10 +2540,17 @@ void __init mem_init(void)
 {
 	high_memory = __va(last_valid_pfn << PAGE_SHIFT);
 
-	register_page_bootmem_info();
 	free_all_bootmem();
 
 	/*
+	 * Must be done after boot memory is put on freelist, because here we
+	 * might set fields in deferred struct pages that have not yet been
+	 * initialized, and free_all_bootmem() initializes all the reserved
+	 * deferred pages for us.
+	 */
+	register_page_bootmem_info();
+
+	/*
 	 * Set up the zero page, mark it reserved, so that page count
 	 * is not manipulated when freeing the page from user ptes.
 	 */
_
