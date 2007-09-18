From: akpm@linux-foundation.org
Subject: + build-failure-on-ppc64-drivers-net-ehea-ehea_mainc.patch added to -mm tree
Date: Tue, 18 Sep 2007 10:11:20 -0700
Message-ID: <200709181711.l8IHBKNZ014403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50452 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759831AbXIRRQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Sep 2007 13:16:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, davem@davemloft.net


The patch titled
     Build failure on ppc64 drivers/net/ehea/ehea_main.c
has been added to the -mm tree.  Its filename is
     build-failure-on-ppc64-drivers-net-ehea-ehea_mainc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Build failure on ppc64 drivers/net/ehea/ehea_main.c
From: mel@skynet.ie (Mel Gorman)

PPC64 failed to build with the driver drivers/net/ehea with the
following error

  CC [M]  drivers/net/ehea/ehea_main.o
drivers/net/ehea/ehea_main.c: In function `ehea_open':
drivers/net/ehea/ehea_main.c:2322: error: implicit declaration of function `port_napi_enable'
drivers/net/ehea/ehea_main.c: At top level:
drivers/net/ehea/ehea_main.c:2340: error: conflicting types for 'port_napi_enable'
drivers/net/ehea/ehea_main.c:2322: error: previous implicit declaration of 'port_napi_enable' was here
make[1]: *** [drivers/net/ehea/ehea_main.o] Error 1

It's buried in git-net.patch and I've cc'd a potential owner based simply
on the mention of EHEA in a leader. I've included a candidate fix for the
error. It seems to be a simple case of port_napi_enable being defined in
the wrong place.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea_main.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN drivers/net/ehea/ehea_main.c~build-failure-on-ppc64-drivers-net-ehea-ehea_mainc drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~build-failure-on-ppc64-drivers-net-ehea-ehea_mainc
+++ a/drivers/net/ehea/ehea_main.c
@@ -2307,6 +2307,22 @@ out:
 	return ret;
 }
 
+static void port_napi_disable(struct ehea_port *port)
+{
+	int i;
+
+	for (i = 0; i < port->num_def_qps; i++)
+		napi_disable(&port->port_res[i].napi);
+}
+
+static void port_napi_enable(struct ehea_port *port)
+{
+	int i;
+
+	for (i = 0; i < port->num_def_qps; i++)
+		napi_enable(&port->port_res[i].napi);
+}
+
 static int ehea_open(struct net_device *dev)
 {
 	int ret;
@@ -2328,22 +2344,6 @@ static int ehea_open(struct net_device *
 	return ret;
 }
 
-static void port_napi_disable(struct ehea_port *port)
-{
-	int i;
-
-	for (i = 0; i < port->num_def_qps; i++)
-		napi_disable(&port->port_res[i].napi);
-}
-
-static void port_napi_enable(struct ehea_port *port)
-{
-	int i;
-
-	for (i = 0; i < port->num_def_qps; i++)
-		napi_enable(&port->port_res[i].napi);
-}
-
 static int ehea_down(struct net_device *dev)
 {
 	int ret;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

fix-numa-memory-policy-reference-counting.patch
build-failure-on-ppc64-drivers-net-ehea-ehea_mainc.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
