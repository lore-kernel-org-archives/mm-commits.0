From: akpm@linux-foundation.org
Subject: [folded] mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve-fix-2.patch removed from -mm tree
Date: Tue, 24 May 2011 16:56:11 -0700
Message-ID: <201105242356.p4ONuBXW023902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932911Ab1EXX4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 19:56:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, arve@android.com, dave@linux.vnet.ibm.com, john.stultz@linaro.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Check end_pfn in pageblock_is_reserved
has been removed from the -mm tree.  Its filename was
     mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-=
migrate_reserve-fix-2.patch

This patch was dropped because it was folded into mm-check-if-any-page-=
in-a-pageblock-is-reserved-before-marking-it-migrate_reserve.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: Check end_pfn in pageblock_is_reserved
=46rom: Minchan Kim <minchan.kim@gmail.com>

[mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migr=
ate_reserve]
added new function "pageblock_is_reserved". But it doesn't check end_pf=
n of system
so it meets following BUG in my system. This patch fixes it.

[    1.859574] type=3D2000 audit(1304330017.656:1): initialized
[    1.884130] BUG: unable to handle kernel paging request at f77fe000
[    1.890557] IP: [<c01dfe3f>] setup_per_zone_wmarks+0x17f/0x280
[    1.896493] *pde =3D 013fb067 *pte =3D 00000000
[    1.900921] Oops: 0000 [#1] SMP
[    1.904309] last sysfs file:
[    1.907324] Modules linked in:
[    1.910482]
[    1.912024] Pid: 1, comm: swapper Not tainted 2.6.39-rc5-mm1+ #49 SA=
MSUNG ELECTRONICS CO.,LTD Samsung DeskT
[    1.924756] EIP: 0060:[<c01dfe3f>] EFLAGS: 00010006 CPU: 0
[    1.930282] EIP is at setup_per_zone_wmarks+0x17f/0x280
[    1.935554] EAX: 00040080 EBX: 000403fe ECX: 00000000 EDX: f77fe000
[    1.941859] ESI: 00110000 EDI: f77fcfc0 EBP: f5077f88 ESP: f5077f50
[    1.948170]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    1.953613] Process swapper (pid: 1, ti=3Df5076000 task=3Df5078000 t=
ask.ti=3Df5076000)
[    1.961056] Stack:
[    1.963116]  00000091 00000000 000003b5 00000286 c0803c80 c0803ca4 0=
003709b 00000000
[    1.971377]  006effe0 006effc0 00040000 00000000 f50783d8 00000001 f=
5077f94 c0846e40
[    1.979633]  00000000 f5077fc4 c0101125 00000000 000002c8 f50783d8 f=
5077fb0 c01a8b44
[    1.987890] Call Trace:
[    1.990386]  [<c0846e40>] init_per_zone_wmark_min+0x39/0x7c
[    1.996001]  [<c0101125>] do_one_initcall+0x35/0x170
[    2.001014]  [<c01a8b44>] ? irq_to_desc+0x14/0x20
[    2.005758]  [<c0846e07>] ? memmap_init_zone+0xca/0xca
[    2.010941]  [<c080c2bc>] kernel_init+0xbd/0x153
[    2.015606]  [<c080c1ff>] ? parse_early_options+0x25/0x25
[    2.021047]  [<c05e7542>] kernel_thread_helper+0x6/0x10
[    2.026318] Code: 76 33 8b 4d ec 39 c3 8b 15 80 62 e0 c0 8d 3c 0e 8d=
 3c 3a 76 67 8b 0f 80 e5 04 75 19 8b 4d
[    2.049095] EIP: [<c01dfe3f>] setup_per_zone_wmarks+0x17f/0x280 SS:E=
SP 0068:f5077f50
[    2.056996] CR2: 00000000f77fe000
[    2.060362] ---[ end trace 82bc55f036371117 ]---

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Arve Hj=F8nnev=E5g <arve@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-check-if-any-page-in-a-pageblock-is-reserv=
ed-before-marking-it-migrate_reserve-fix-2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-check-if-any-page-in-a-pageblock-is-reserved-b=
efore-marking-it-migrate_reserve-fix-2
+++ a/mm/page_alloc.c
@@ -3329,14 +3329,14 @@ static inline unsigned long wait_table_b
 /*
  * Check if a pageblock contains reserved pages
  */
-static int pageblock_is_reserved(unsigned long start_pfn)
+static int pageblock_is_reserved(unsigned long start_pfn, unsigned lon=
g end_pfn)
 {
-	unsigned long end_pfn =3D start_pfn + pageblock_nr_pages;
 	unsigned long pfn;
=20
-	for (pfn =3D start_pfn; pfn < end_pfn; pfn++)
+	for (pfn =3D start_pfn; pfn < end_pfn; pfn++) {
 		if (!pfn_valid_within(pfn) || PageReserved(pfn_to_page(pfn)))
 			return 1;
+	}
 	return 0;
 }
=20
@@ -3349,7 +3349,7 @@ static int pageblock_is_reserved(unsigne
  */
 static void setup_zone_migrate_reserve(struct zone *zone)
 {
-	unsigned long start_pfn, pfn, end_pfn;
+	unsigned long start_pfn, pfn, end_pfn, block_end_pfn;
 	struct page *page;
 	unsigned long block_migratetype;
 	int reserve;
@@ -3379,7 +3379,8 @@ static void setup_zone_migrate_reserve(s
 			continue;
=20
 		/* Blocks with reserved pages will never free, skip them. */
-		if (pageblock_is_reserved(pfn))
+		block_end_pfn =3D min(pfn + pageblock_nr_pages, end_pfn);
+		if (pageblock_is_reserved(pfn, block_end_pfn))
 			continue;
=20
 		block_migratetype =3D get_pageblock_migratetype(page);
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

mm-vmscan-correct-use-of-pgdat_balanced-in-sleeping_prematurely.patch
mm-vmscan-correctly-check-if-reclaimer-should-schedule-during-shrink_sl=
ab.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-shoul=
d-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.pat=
ch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
mm-thp-optimize-memcg-charge-in-khugepaged.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migra=
te_reserve.patch
readahead-readahead-page-allocations-are-ok-to-fail.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patc=
h
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.pa=
tch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3.patch
mm-filter-unevictable-page-out-in-deactivate_page.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
mm-page_allocc-prevent-unending-loop-in-__alloc_pages_slowpath.patch
mm-batch-activate_page-to-reduce-lock-contention.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
