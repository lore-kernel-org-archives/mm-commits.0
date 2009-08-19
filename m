From: akpm@linux-foundation.org
Subject: + mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch added to -mm tree
Date: Wed, 19 Aug 2009 14:34:51 -0700
Message-ID: <200908192134.n7JLYplh023075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753114AbZHSVfk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 17:35:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, airlied@linux.ie, davem@davemloft.net, hugh.dickins@tiscali.co.uk, jbeulich@novell.com, jeremy@goop.org, kaber@trash.net, kyle@mcmartin.ca, mingo@elte.hu, penberg@cs.helsinki.fi, rusty@rustcorp.com.au


The patch titled
     mm: replace various uses of num_physpages by  totalram_pages
has been added to the -mm tree.  Its filename is
     mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch

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
Subject: mm: replace various uses of num_physpages by  totalram_pages
From: "Jan Beulich" <JBeulich@novell.com>

Sizing of memory allocations shouldn't depend on the number of physical
pages found in a system, as that generally includes (perhaps a huge amount
of) non-RAM pages.  The amount of what actually is usable as storage
should instead be used as a basis here.

Some of the calculations (i.e.  those not intending to use high memory)
should likely even use (totalram_pages - totalhigh_pages).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/microcode_core.c  |    4 ++--
 drivers/char/agp/backend.c        |    4 ++--
 drivers/parisc/ccio-dma.c         |    4 ++--
 drivers/parisc/sba_iommu.c        |    4 ++--
 drivers/xen/balloon.c             |    4 ----
 fs/ntfs/malloc.h                  |    2 +-
 include/linux/mm.h                |    1 +
 init/main.c                       |    4 ++--
 mm/slab.c                         |    2 +-
 mm/swap.c                         |    2 +-
 mm/vmalloc.c                      |    4 ++--
 net/core/sock.c                   |    4 ++--
 net/dccp/proto.c                  |    6 +++---
 net/decnet/dn_route.c             |    2 +-
 net/ipv4/route.c                  |    2 +-
 net/ipv4/tcp.c                    |    4 ++--
 net/netfilter/nf_conntrack_core.c |    4 ++--
 net/netfilter/x_tables.c          |    2 +-
 net/netfilter/xt_hashlimit.c      |    8 ++++----
 net/netlink/af_netlink.c          |    6 +++---
 net/sctp/protocol.c               |    6 +++---
 21 files changed, 38 insertions(+), 41 deletions(-)

diff -puN arch/x86/kernel/microcode_core.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages arch/x86/kernel/microcode_core.c
--- a/arch/x86/kernel/microcode_core.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/arch/x86/kernel/microcode_core.c
@@ -210,8 +210,8 @@ static ssize_t microcode_write(struct fi
 {
 	ssize_t ret = -EINVAL;
 
-	if ((len >> PAGE_SHIFT) > num_physpages) {
-		pr_err("microcode: too much data (max %ld pages)\n", num_physpages);
+	if ((len >> PAGE_SHIFT) > totalram_pages) {
+		pr_err("microcode: too much data (max %ld pages)\n", totalram_pages);
 		return ret;
 	}
 
diff -puN drivers/char/agp/backend.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages drivers/char/agp/backend.c
--- a/drivers/char/agp/backend.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/drivers/char/agp/backend.c
@@ -114,9 +114,9 @@ static int agp_find_max(void)
 	long memory, index, result;
 
 #if PAGE_SHIFT < 20
-	memory = num_physpages >> (20 - PAGE_SHIFT);
+	memory = totalram_pages >> (20 - PAGE_SHIFT);
 #else
-	memory = num_physpages << (PAGE_SHIFT - 20);
+	memory = totalram_pages << (PAGE_SHIFT - 20);
 #endif
 	index = 1;
 
diff -puN drivers/parisc/ccio-dma.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages drivers/parisc/ccio-dma.c
--- a/drivers/parisc/ccio-dma.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/drivers/parisc/ccio-dma.c
@@ -1266,7 +1266,7 @@ ccio_ioc_init(struct ioc *ioc)
 	** Hot-Plug/Removal of PCI cards. (aka PCI OLARD).
 	*/
 
-	iova_space_size = (u32) (num_physpages / count_parisc_driver(&ccio_driver));
+	iova_space_size = (u32) (totalram_pages / count_parisc_driver(&ccio_driver));
 
 	/* limit IOVA space size to 1MB-1GB */
 
@@ -1305,7 +1305,7 @@ ccio_ioc_init(struct ioc *ioc)
 
 	DBG_INIT("%s() hpa 0x%p mem %luMB IOV %dMB (%d bits)\n",
 			__func__, ioc->ioc_regs,
-			(unsigned long) num_physpages >> (20 - PAGE_SHIFT),
+			(unsigned long) totalram_pages >> (20 - PAGE_SHIFT),
 			iova_space_size>>20,
 			iov_order + PAGE_SHIFT);
 
diff -puN drivers/parisc/sba_iommu.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages drivers/parisc/sba_iommu.c
--- a/drivers/parisc/sba_iommu.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/drivers/parisc/sba_iommu.c
@@ -1390,7 +1390,7 @@ sba_ioc_init(struct parisc_device *sba, 
 	** for DMA hints - ergo only 30 bits max.
 	*/
 
-	iova_space_size = (u32) (num_physpages/global_ioc_cnt);
+	iova_space_size = (u32) (totalram_pages/global_ioc_cnt);
 
 	/* limit IOVA space size to 1MB-1GB */
 	if (iova_space_size < (1 << (20 - PAGE_SHIFT))) {
@@ -1415,7 +1415,7 @@ sba_ioc_init(struct parisc_device *sba, 
 	DBG_INIT("%s() hpa 0x%lx mem %ldMB IOV %dMB (%d bits)\n",
 			__func__,
 			ioc->ioc_hpa,
-			(unsigned long) num_physpages >> (20 - PAGE_SHIFT),
+			(unsigned long) totalram_pages >> (20 - PAGE_SHIFT),
 			iova_space_size>>20,
 			iov_order + PAGE_SHIFT);
 
diff -puN drivers/xen/balloon.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages drivers/xen/balloon.c
--- a/drivers/xen/balloon.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/drivers/xen/balloon.c
@@ -96,11 +96,7 @@ static struct balloon_stats balloon_stat
 /* We increase/decrease in batches which fit in a page */
 static unsigned long frame_list[PAGE_SIZE / sizeof(unsigned long)];
 
-/* VM /proc information for memory */
-extern unsigned long totalram_pages;
-
 #ifdef CONFIG_HIGHMEM
-extern unsigned long totalhigh_pages;
 #define inc_totalhigh_pages() (totalhigh_pages++)
 #define dec_totalhigh_pages() (totalhigh_pages--)
 #else
diff -puN fs/ntfs/malloc.h~mm-replace-various-uses-of-num_physpages-by-totalram_pages fs/ntfs/malloc.h
--- a/fs/ntfs/malloc.h~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/fs/ntfs/malloc.h
@@ -47,7 +47,7 @@ static inline void *__ntfs_malloc(unsign
 		return kmalloc(PAGE_SIZE, gfp_mask & ~__GFP_HIGHMEM);
 		/* return (void *)__get_free_page(gfp_mask); */
 	}
-	if (likely(size >> PAGE_SHIFT < num_physpages))
+	if (likely((size >> PAGE_SHIFT) < totalram_pages))
 		return __vmalloc(size, gfp_mask, PAGE_KERNEL);
 	return NULL;
 }
diff -puN include/linux/mm.h~mm-replace-various-uses-of-num_physpages-by-totalram_pages include/linux/mm.h
--- a/include/linux/mm.h~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/include/linux/mm.h
@@ -25,6 +25,7 @@ extern unsigned long max_mapnr;
 #endif
 
 extern unsigned long num_physpages;
+extern unsigned long totalram_pages;
 extern void * high_memory;
 extern int page_cluster;
 
diff -puN init/main.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages init/main.c
--- a/init/main.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/init/main.c
@@ -664,12 +664,12 @@ asmlinkage void __init start_kernel(void
 #endif
 	thread_info_cache_init();
 	cred_init();
-	fork_init(num_physpages);
+	fork_init(totalram_pages);
 	proc_caches_init();
 	buffer_init();
 	key_init();
 	security_init();
-	vfs_caches_init(num_physpages);
+	vfs_caches_init(totalram_pages);
 	radix_tree_init();
 	signals_init();
 	/* rootfs populating might need page-writeback */
diff -puN mm/slab.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages mm/slab.c
--- a/mm/slab.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/mm/slab.c
@@ -1385,7 +1385,7 @@ void __init kmem_cache_init(void)
 	 * Fragmentation resistance on low memory - only use bigger
 	 * page orders on machines with more than 32MB of memory.
 	 */
-	if (num_physpages > (32 << 20) >> PAGE_SHIFT)
+	if (totalram_pages > (32 << 20) >> PAGE_SHIFT)
 		slab_break_gfp_order = BREAK_GFP_ORDER_HI;
 
 	/* Bootstrap is tricky, because several objects are allocated
diff -puN mm/swap.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages mm/swap.c
--- a/mm/swap.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/mm/swap.c
@@ -496,7 +496,7 @@ EXPORT_SYMBOL(pagevec_lookup_tag);
  */
 void __init swap_setup(void)
 {
-	unsigned long megs = num_physpages >> (20 - PAGE_SHIFT);
+	unsigned long megs = totalram_pages >> (20 - PAGE_SHIFT);
 
 #ifdef CONFIG_SWAP
 	bdi_init(swapper_space.backing_dev_info);
diff -puN mm/vmalloc.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages mm/vmalloc.c
--- a/mm/vmalloc.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/mm/vmalloc.c
@@ -1386,7 +1386,7 @@ void *vmap(struct page **pages, unsigned
 
 	might_sleep();
 
-	if (count > num_physpages)
+	if (count > totalram_pages)
 		return NULL;
 
 	area = get_vm_area_caller((count << PAGE_SHIFT), flags,
@@ -1493,7 +1493,7 @@ static void *__vmalloc_node(unsigned lon
 	unsigned long real_size = size;
 
 	size = PAGE_ALIGN(size);
-	if (!size || (size >> PAGE_SHIFT) > num_physpages)
+	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
 		return NULL;
 
 	area = __get_vm_area_node(size, VM_ALLOC, VMALLOC_START, VMALLOC_END,
diff -puN net/core/sock.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages net/core/sock.c
--- a/net/core/sock.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/net/core/sock.c
@@ -1205,12 +1205,12 @@ EXPORT_SYMBOL_GPL(sk_setup_caps);
 
 void __init sk_init(void)
 {
-	if (num_physpages <= 4096) {
+	if (totalram_pages <= 4096) {
 		sysctl_wmem_max = 32767;
 		sysctl_rmem_max = 32767;
 		sysctl_wmem_default = 32767;
 		sysctl_rmem_default = 32767;
-	} else if (num_physpages >= 131072) {
+	} else if (totalram_pages >= 131072) {
 		sysctl_wmem_max = 131071;
 		sysctl_rmem_max = 131071;
 	}
diff -puN net/dccp/proto.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages net/dccp/proto.c
--- a/net/dccp/proto.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/net/dccp/proto.c
@@ -1049,10 +1049,10 @@ static int __init dccp_init(void)
 	 *
 	 * The methodology is similar to that of the buffer cache.
 	 */
-	if (num_physpages >= (128 * 1024))
-		goal = num_physpages >> (21 - PAGE_SHIFT);
+	if (totalram_pages >= (128 * 1024))
+		goal = totalram_pages >> (21 - PAGE_SHIFT);
 	else
-		goal = num_physpages >> (23 - PAGE_SHIFT);
+		goal = totalram_pages >> (23 - PAGE_SHIFT);
 
 	if (thash_entries)
 		goal = (thash_entries *
diff -puN net/decnet/dn_route.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages net/decnet/dn_route.c
--- a/net/decnet/dn_route.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/net/decnet/dn_route.c
@@ -1750,7 +1750,7 @@ void __init dn_route_init(void)
 	dn_route_timer.expires = jiffies + decnet_dst_gc_interval * HZ;
 	add_timer(&dn_route_timer);
 
-	goal = num_physpages >> (26 - PAGE_SHIFT);
+	goal = totalram_pages >> (26 - PAGE_SHIFT);
 
 	for(order = 0; (1UL << order) < goal; order++)
 		/* NOTHING */;
diff -puN net/ipv4/route.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages net/ipv4/route.c
--- a/net/ipv4/route.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/net/ipv4/route.c
@@ -3412,7 +3412,7 @@ int __init ip_rt_init(void)
 		alloc_large_system_hash("IP route cache",
 					sizeof(struct rt_hash_bucket),
 					rhash_entries,
-					(num_physpages >= 128 * 1024) ?
+					(totalram_pages >= 128 * 1024) ?
 					15 : 17,
 					0,
 					&rt_hash_log,
diff -puN net/ipv4/tcp.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages net/ipv4/tcp.c
--- a/net/ipv4/tcp.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/net/ipv4/tcp.c
@@ -2862,7 +2862,7 @@ void __init tcp_init(void)
 		alloc_large_system_hash("TCP established",
 					sizeof(struct inet_ehash_bucket),
 					thash_entries,
-					(num_physpages >= 128 * 1024) ?
+					(totalram_pages >= 128 * 1024) ?
 					13 : 15,
 					0,
 					&tcp_hashinfo.ehash_size,
@@ -2879,7 +2879,7 @@ void __init tcp_init(void)
 		alloc_large_system_hash("TCP bind",
 					sizeof(struct inet_bind_hashbucket),
 					tcp_hashinfo.ehash_size,
-					(num_physpages >= 128 * 1024) ?
+					(totalram_pages >= 128 * 1024) ?
 					13 : 15,
 					0,
 					&tcp_hashinfo.bhash_size,
diff -puN net/netfilter/nf_conntrack_core.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/net/netfilter/nf_conntrack_core.c
@@ -1245,9 +1245,9 @@ static int nf_conntrack_init_init_net(vo
 	 * machine has 512 buckets. >= 1GB machines have 16384 buckets. */
 	if (!nf_conntrack_htable_size) {
 		nf_conntrack_htable_size
-			= (((num_physpages << PAGE_SHIFT) / 16384)
+			= (((totalram_pages << PAGE_SHIFT) / 16384)
 			   / sizeof(struct hlist_head));
-		if (num_physpages > (1024 * 1024 * 1024 / PAGE_SIZE))
+		if (totalram_pages > (1024 * 1024 * 1024 / PAGE_SIZE))
 			nf_conntrack_htable_size = 16384;
 		if (nf_conntrack_htable_size < 32)
 			nf_conntrack_htable_size = 32;
diff -puN net/netfilter/x_tables.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages net/netfilter/x_tables.c
--- a/net/netfilter/x_tables.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/net/netfilter/x_tables.c
@@ -617,7 +617,7 @@ struct xt_table_info *xt_alloc_table_inf
 	int cpu;
 
 	/* Pedantry: prevent them from hitting BUG() in vmalloc.c --RR */
-	if ((SMP_ALIGN(size) >> PAGE_SHIFT) + 2 > num_physpages)
+	if ((SMP_ALIGN(size) >> PAGE_SHIFT) + 2 > totalram_pages)
 		return NULL;
 
 	newinfo = kzalloc(XT_TABLE_INFO_SZ, GFP_KERNEL);
diff -puN net/netfilter/xt_hashlimit.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages net/netfilter/xt_hashlimit.c
--- a/net/netfilter/xt_hashlimit.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/net/netfilter/xt_hashlimit.c
@@ -194,9 +194,9 @@ static int htable_create_v0(struct xt_ha
 	if (minfo->cfg.size)
 		size = minfo->cfg.size;
 	else {
-		size = ((num_physpages << PAGE_SHIFT) / 16384) /
+		size = ((totalram_pages << PAGE_SHIFT) / 16384) /
 		       sizeof(struct list_head);
-		if (num_physpages > (1024 * 1024 * 1024 / PAGE_SIZE))
+		if (totalram_pages > (1024 * 1024 * 1024 / PAGE_SIZE))
 			size = 8192;
 		if (size < 16)
 			size = 16;
@@ -266,9 +266,9 @@ static int htable_create(struct xt_hashl
 	if (minfo->cfg.size) {
 		size = minfo->cfg.size;
 	} else {
-		size = (num_physpages << PAGE_SHIFT) / 16384 /
+		size = (totalram_pages << PAGE_SHIFT) / 16384 /
 		       sizeof(struct list_head);
-		if (num_physpages > 1024 * 1024 * 1024 / PAGE_SIZE)
+		if (totalram_pages > 1024 * 1024 * 1024 / PAGE_SIZE)
 			size = 8192;
 		if (size < 16)
 			size = 16;
diff -puN net/netlink/af_netlink.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages net/netlink/af_netlink.c
--- a/net/netlink/af_netlink.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/net/netlink/af_netlink.c
@@ -2084,10 +2084,10 @@ static int __init netlink_proto_init(voi
 	if (!nl_table)
 		goto panic;
 
-	if (num_physpages >= (128 * 1024))
-		limit = num_physpages >> (21 - PAGE_SHIFT);
+	if (totalram_pages >= (128 * 1024))
+		limit = totalram_pages >> (21 - PAGE_SHIFT);
 	else
-		limit = num_physpages >> (23 - PAGE_SHIFT);
+		limit = totalram_pages >> (23 - PAGE_SHIFT);
 
 	order = get_bitmask_order(limit) - 1 + PAGE_SHIFT;
 	limit = (1UL << order) / sizeof(struct hlist_head);
diff -puN net/sctp/protocol.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages net/sctp/protocol.c
--- a/net/sctp/protocol.c~mm-replace-various-uses-of-num_physpages-by-totalram_pages
+++ a/net/sctp/protocol.c
@@ -1186,10 +1186,10 @@ SCTP_STATIC __init int sctp_init(void)
 	/* Size and allocate the association hash table.
 	 * The methodology is similar to that of the tcp hash tables.
 	 */
-	if (num_physpages >= (128 * 1024))
-		goal = num_physpages >> (22 - PAGE_SHIFT);
+	if (totalram_pages >= (128 * 1024))
+		goal = totalram_pages >> (22 - PAGE_SHIFT);
 	else
-		goal = num_physpages >> (24 - PAGE_SHIFT);
+		goal = totalram_pages >> (24 - PAGE_SHIFT);
 
 	for (order = 0; (1UL << order) < goal; order++)
 		;
_

Patches currently in -mm which might be from JBeulich@novell.com are

linux-next.patch
memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch

