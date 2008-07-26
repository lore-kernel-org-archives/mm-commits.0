From: akpm@linux-foundation.org
Subject: - mm-print-swapcache-page-count-in-show_swap_cache_info.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:17:15 -0700
Message-ID: <200807262117.m6QLHF2S019919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757945AbYGZVUY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:20:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, benh@kernel.crashing.org, chris@zankel.net, cooloney@kernel.org, davem@davemloft.net, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, heiko.carstens@d


The patch titled
     mm: print swapcache page count in show_swap_cache_info()
has been removed from the -mm tree.  Its filename was
     mm-print-swapcache-page-count-in-show_swap_cache_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
mm-more-likely-reclaim-madv_sequential-mappings.patch

