From: akpm@linux-foundation.org
Subject: + mm-print-swapcache-page-count-in-show_swap_cache_info.patch added to -mm tree
Date: Tue, 22 Jul 2008 03:23:28 -0700
Message-ID: <200807221023.m6MANSCr023046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397AbYGVK0z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 06:26:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, benh@kernel.crashing.org, chris@zankel.net, cooloney@kernel.org, davem@davemloft.net, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, heiko.carstens@de.ibm.com, hskinnemoen@atmel.com, hugh@veritas.com, ink@jurassic.park.msu.ru, jdike@addtoit.com, lethal@linux-sh.org, mingo@elte.hu, paulus@samba.org, ralf@linux-mips.org, rth@twiddle.net, schwidefsky@de.ibm.com, starvik@axis.com, takata@linux-m32r.org, ysato@users.sourceforge.jp, zippel@linux-m68k.org


The patch titled
     mm: print swapcache page count in show_swap_cache_info()
has been added to the -mm tree.  Its filename is
     mm-print-swapcache-page-count-in-show_swap_cache_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: print swapcache page count in show_swap_cache_info()
From: Johannes Weiner <hannes@saeurebad.de>

Every arch implements its own show_mem() function.  Most of them share
quite some code, some of them are completely identical.

This series implements a generic version of this function and migrates
almost all architectures to it.


This patch:

Most show_mem() implementations calculate the amount of pages within
the swapcache every time.  Move the output to a more appropriate place
and use the anyway available total_swapcache_pages variable.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/swap_state.c~mm-print-swapcache-page-count-in-show_swap_cache_info mm/swap_state.c
--- a/mm/swap_state.c~mm-print-swapcache-page-count-in-show_swap_cache_info
+++ a/mm/swap_state.c
@@ -56,7 +56,8 @@ static struct {
 
 void show_swap_cache_info(void)
 {
-	printk("Swap cache: add %lu, delete %lu, find %lu/%lu\n",
+	printk("%lu pages in swap cache\n", total_swapcache_pages);
+	printk("Swap cache stats: add %lu, delete %lu, find %lu/%lu\n",
 		swap_cache_info.add_total, swap_cache_info.del_total,
 		swap_cache_info.find_success, swap_cache_info.find_total);
 	printk("Free swap  = %lukB\n", nr_swap_pages << (PAGE_SHIFT - 10));
_

Patches currently in -mm which might be from hannes@saeurebad.de are

origin.patch
linux-next.patch
git-xtensa.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
mm-drop-unneeded-pgdat-argument-from-free_area_init_node.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
vma-page-offset-has-no-callees-drop-it.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages.patch
linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-reorder-code-to-match-new-bootmem-structure.patch
revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-clean-up-bootmemc-file-header.patch
revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-add-documentation-to-api-functions.patch
revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-add-debugging-framework.patch
bootmem-add-debugging-framework-fix.patch
bootmem-revisit-bitmap-size-calculations.patch
bootmem-revisit-bootmem-descriptor-list-handling.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
bootmem-clean-up-alloc_bootmem_core.patch
bootmem-clean-up-alloc_bootmem_core-fix-new-alloc_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-free-reserve-helpers-fix.patch
revert-revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
bootmem-respect-goal-more-likely.patch
bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes.patch
bootmem-revisit-alloc_bootmem_section.patch
bootmem-replace-node_boot_start-in-struct-bootmem_data.patch
bootmem-replace-node_boot_start-in-struct-bootmem_data-fix.patch
memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove.patch
documentation-update-codingstyle-tips-for-emacs-users-v2.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
lib-generic-show_mem.patch
alpha-use-generic-show_mem.patch
avr32-use-generic-show_mem.patch
blackfin-use-generic-show_mem.patch
xtensa-use-generic-show_mem.patch
x86-use-generic-show_mem.patch
um-use-generic-show_mem.patch
sparc64-use-generic-show_mem.patch
sh-use-generic-show_mem.patch
s390-use-generic-show_mem.patch
powerpc-use-generic-show_mem.patch
mn10300-use-generic-show_mem.patch
h8300-use-generic-show_mem.patch
mips-use-generic-show_mem.patch
m68knommu-use-generic-show_mem.patch
m68k-use-generic-show_mem.patch
m32r-use-generic-show_mem.patch
frv-use-generic-show_mem.patch
cris-use-generic-show_mem.patch

