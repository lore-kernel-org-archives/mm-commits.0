From: akpm@linux-foundation.org
Subject: + sparsemem-clean-up-spelling-error-in-comments.patch added to -mm tree
Date: Thu, 19 Jul 2007 16:37:11 -0700
Message-ID: <200707192337.l6JNbBpv028683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36843 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755193AbXGSXiI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 19:38:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, ak@suse.de, benh@kernel.crashing.org, clameter@sgi.com, davem@davemloft.net, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, paulus@samba.org, tony.luck@intel.com


The patch titled
     sparsemem: clean up spelling error in comments
has been added to the -mm tree.  Its filename is
     sparsemem-clean-up-spelling-error-in-comments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sparsemem: clean up spelling error in comments
From: Andy Whitcroft <apw@shadowen.org>

SPARSEMEM is a pretty nice framework that unifies quite a bit of code over all
the arches.  It would be great if it could be the default so that we can get
rid of various forms of DISCONTIG and other variations on memory maps.  So far
what has hindered this are the additional lookups that SPARSEMEM introduces
for virt_to_page and page_address.  This goes so far that the code to do this
has to be kept in a separate function and cannot be used inline.

This patch introduces a virtual memmap mode for SPARSEMEM, in which the memmap
is mapped into a virtually contigious area, only the active sections are
physically backed.  This allows virt_to_page page_address and cohorts become
simple shift/add operations.  No page flag fields, no table lookups, nothing
involving memory is required.

The two key operations pfn_to_page and page_to_page become:

   #define __pfn_to_page(pfn)      (vmemmap + (pfn))
   #define __page_to_pfn(page)     ((page) - vmemmap)

By having a virtual mapping for the memmap we allow simple access without
wasting physical memory.  As kernel memory is typically already mapped 1:1
this introduces no additional overhead.  The virtual mapping must be big
enough to allow a struct page to be allocated and mapped for all valid
physical pages.  This vill make a virtual memmap difficult to use on 32 bit
platforms that support 36 address bits.

However, if there is enough virtual space available and the arch already maps
its 1-1 kernel space using TLBs (f.e.  true of IA64 and x86_64) then this
technique makes SPARSEMEM lookups even more efficient than CONFIG_FLATMEM. 
FLATMEM needs to read the contents of the mem_map variable to get the start of
the memmap and then add the offset to the required entry.  vmemmap is a
constant to which we can simply add the offset.

This patch has the potential to allow us to make SPARSMEM the default (and
even the only) option for most systems.  It should be optimal on UP, SMP and
NUMA on most platforms.  Then we may even be able to remove the other memory
models: FLATMEM, DISCONTIG etc.

The current aim is to bring a common virtually mapped mem_map to all
architectures.  This should facilitate the removal of the bespoke
implementations from the architectures.  This also brings performance
improvements for most architecture making sparsmem vmemmap the more desirable
memory model.  The ultimate aim of this work is to expand sparsemem support to
encompass all the features of the other memory models.  This could allow us to
drop support for and remove the other models in the longer term.

Below are some comparitive kernbench numbers for various architectures,
comparing default memory model against SPARSEMEM VMEMMAP.  All but ia64 show
marginal improvement; we expect the ia64 figures to be sorted out when the
larger mapping support returns.

x86-64 non-NUMA
             Base    VMEMAP    % change (-ve good)
User        85.07     84.84    -0.26
System      34.32     33.84    -1.39
Total      119.38    118.68    -0.59

ia64
             Base    VMEMAP    % change (-ve good)
User      1016.41   1016.93    0.05
System      50.83     51.02    0.36
Total     1067.25   1067.95    0.07

x86-64 NUMA
             Base   VMEMAP    % change (-ve good)
User        30.77   431.73     0.22
System      45.39    43.98    -3.11
Total      476.17   475.71    -0.10

ppc64
             Base   VMEMAP    % change (-ve good)
User       488.77   488.35    -0.09
System      56.92    56.37    -0.97
Total      545.69   544.72    -0.18

Below are some AIM bencharks on IA64 and x86-64 (thank Bob).  The seems
pretty much flat as you would expect.


ia64 results 2 cpu non-numa 4Gb SCSI disk

Benchmark	Version	Machine	Run Date
AIM Multiuser Benchmark - Suite VII	"1.1"	extreme	Jun  1 07:17:24 2007

Tasks	Jobs/Min	JTI	Real	CPU	Jobs/sec/task
1	98.9		100	58.9	1.3	1.6482
101	5547.1		95	106.0	79.4	0.9154
201	6377.7		95	183.4	158.3	0.5288
301	6932.2		95	252.7	237.3	0.3838
401	7075.8		93	329.8	316.7	0.2941
501	7235.6		94	403.0	396.2	0.2407
600	7387.5		94	472.7	475.0	0.2052

Benchmark	Version	Machine	Run Date
AIM Multiuser Benchmark - Suite VII	"1.1"	vmemmap	Jun  1 09:59:04 2007

Tasks	Jobs/Min	JTI	Real	CPU	Jobs/sec/task
1	99.1		100	58.8	1.2	1.6509
101	5480.9		95	107.2	79.2	0.9044
201	6490.3		95	180.2	157.8	0.5382
301	6886.6		94	254.4	236.8	0.3813
401	7078.2		94	329.7	316.0	0.2942
501	7250.3		95	402.2	395.4	0.2412
600	7399.1		94	471.9	473.9	0.2055


open power 710 2 cpu, 4 Gb, SCSI and configured physically

Benchmark	Version	Machine	Run Date
AIM Multiuser Benchmark - Suite VII	"1.1"	extreme	May 29 15:42:53 2007

Tasks	Jobs/Min	JTI	Real	CPU	Jobs/sec/task
1	25.7		100	226.3	4.3	0.4286
101	1096.0		97	536.4	199.8	0.1809
201	1236.4		96	946.1	389.1	0.1025
301	1280.5		96	1368.0	582.3	0.0709
401	1270.2		95	1837.4	771.0	0.0528
501	1251.4		96	2330.1	955.9	0.0416
601	1252.6		96	2792.4	1139.2	0.0347
701	1245.2		96	3276.5	1334.6	0.0296
918	1229.5		96	4345.4	1728.7	0.0223

Benchmark	Version	Machine	Run Date
AIM Multiuser Benchmark - Suite VII	"1.1"	vmemmap	May 30 07:28:26 2007

Tasks	Jobs/Min	JTI	Real	CPU	Jobs/sec/task
1	25.6		100	226.9	4.3	0.4275
101	1049.3		97	560.2	198.1	0.1731
201	1199.1		97	975.6	390.7	0.0994
301	1261.7		96	1388.5	591.5	0.0699
401	1256.1		96	1858.1	771.9	0.0522
501	1220.1		96	2389.7	955.3	0.0406
601	1224.6		96	2856.3	1133.4	0.0340
701	1252.0		96	3258.7	1314.1	0.0298
915	1232.8		96	4319.7	1704.0	0.0225


amd64 2 2-core, 4Gb and SATA

Benchmark	Version	Machine	Run Date
AIM Multiuser Benchmark - Suite VII	"1.1"	extreme	Jun  2 03:59:48 2007

Tasks	Jobs/Min	JTI	Real	CPU	Jobs/sec/task
1	13.0		100	446.4	2.1	0.2173
101	533.4		97	1102.0	110.2	0.0880
201	578.3		97	2022.8	220.8	0.0480
301	583.8		97	3000.6	332.3	0.0323
401	580.5		97	4020.1	442.2	0.0241
501	574.8		98	5072.8	558.8	0.0191
600	566.5		98	6163.8	671.0	0.0157

Benchmark	Version	Machine	Run Date
AIM Multiuser Benchmark - Suite VII	"1.1"	vmemmap	Jun  3 04:19:31 2007

Tasks	Jobs/Min	JTI	Real	CPU	Jobs/sec/task
1	13.0		100	447.8	2.0	0.2166
101	536.5		97	1095.6	109.7	0.0885
201	567.7		97	2060.5	219.3	0.0471
301	582.1		96	3009.4	330.2	0.0322
401	578.2		96	4036.4	442.4	0.0240
501	585.1		98	4983.2	555.1	0.0195
600	565.5		98	6175.2	660.6	0.0157



This patch:

Fix some spelling errors.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse.c~sparsemem-clean-up-spelling-error-in-comments mm/sparse.c
--- a/mm/sparse.c~sparsemem-clean-up-spelling-error-in-comments
+++ a/mm/sparse.c
@@ -101,7 +101,7 @@ static inline int sparse_index_init(unsi
 
 /*
  * Although written for the SPARSEMEM_EXTREME case, this happens
- * to also work for the flat array case becase
+ * to also work for the flat array case because
  * NR_SECTION_ROOTS==NR_MEM_SECTIONS.
  */
 int __section_nr(struct mem_section* ms)
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
generic-virtual-memmap-support-for-sparsemem.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
