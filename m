From: akpm@linux-foundation.org
Subject: [merged] parisc-redefine-atomic_init-and-atomic64_init-like-other-architectures.patch removed from -mm tree
Date: Thu, 26 Jul 2012 10:44:11 -0700
Message-ID: <20120726174412.7B2C15C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:56410 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab2GZRoP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jul 2012 13:44:15 -0400
Received: by wgbdt11 with SMTP id dt11so99050wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Jul 2012 10:44:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, James.Bottomley@hansenpartnership.com, dave.anglin@bell.net, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: redefine ATOMIC_INIT and ATOMIC64_INIT like other architectures
has been removed from the -mm tree.  Its filename was
     parisc-redefine-atomic_init-and-atomic64_init-like-other-architectures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: parisc: redefine ATOMIC_INIT and ATOMIC64_INIT like other architectures

The following build error occured during a parisc build with
swap-over-NFS patches applied.

net/core/sock.c:274:36: error: initializer element is not constant
net/core/sock.c:274:36: error: (near initialization for 'memalloc_socks')
net/core/sock.c:274:36: error: initializer element is not constant

It's not obvious but this is due to how ATOMIC_INIT is defined on parisc. 
It should affect any user of STATIC_KEY_INIT_FALSE on that platform.

This patch makes the definition of ATOMIC_INIT on parisc to look like
other arches definition.

Apparently due to gcc creating a temporary.  John said "Parisc is a callee
copies architecture.  Thus, a structure passed as an argument may be
copied to a temporary.  This has been a source of numerous bugs as the
majority of architectures do it the other way round."

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/atomic.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/parisc/include/asm/atomic.h~parisc-redefine-atomic_init-and-atomic64_init-like-other-architectures arch/parisc/include/asm/atomic.h
--- a/arch/parisc/include/asm/atomic.h~parisc-redefine-atomic_init-and-atomic64_init-like-other-architectures
+++ a/arch/parisc/include/asm/atomic.h
@@ -141,7 +141,7 @@ static __inline__ int __atomic_add_unles
 
 #define atomic_sub_and_test(i,v)	(atomic_sub_return((i),(v)) == 0)
 
-#define ATOMIC_INIT(i)	((atomic_t) { (i) })
+#define ATOMIC_INIT(i)	{ (i) }
 
 #define smp_mb__before_atomic_dec()	smp_mb()
 #define smp_mb__after_atomic_dec()	smp_mb()
@@ -150,7 +150,7 @@ static __inline__ int __atomic_add_unles
 
 #ifdef CONFIG_64BIT
 
-#define ATOMIC64_INIT(i) ((atomic64_t) { (i) })
+#define ATOMIC64_INIT(i) { (i) }
 
 static __inline__ s64
 __atomic64_add_return(s64 i, atomic64_t *v)
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-fix-wrong-argument-of-migrate_huge_pages-in-soft_offline_huge_page.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-factor-out-memory-isolate-functions.patch
mm-bug-fix-free-page-check-in-zone_watermark_ok.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages.patch
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages-fix.patch
mm-slub-optimise-the-slub-fast-path-to-avoid-pfmemalloc-checks.patch
mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves.patch
mm-allow-pf_memalloc-from-softirq-context.patch
mm-only-set-page-pfmemalloc-when-alloc_no_watermarks-was-used.patch
mm-ignore-mempolicies-when-using-alloc_no_watermark.patch
net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket.patch
netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets.patch
netvm-allow-skb-allocation-to-use-pfmemalloc-reserves.patch
netvm-propagate-page-pfmemalloc-to-skb.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
netvm-set-pf_memalloc-as-appropriate-during-skb-processing.patch
mm-micro-optimise-slab-to-avoid-a-function-call.patch
nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves.patch
mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage.patch
mm-account-for-the-number-of-times-direct-reclaimers-get-throttled.patch
netvm-prevent-a-stream-specific-deadlock.patch
selinux-tag-avc-cache-alloc-as-non-critical.patch
mm-methods-for-teaching-filesystems-about-pg_swapcache-pages.patch
mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o.patch
mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o-fix.patch
mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages.patch
mm-swap-implement-generic-handler-for-swap_activate.patch
mm-add-support-for-direct_io-to-highmem-pages.patch
nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages.patch
nfs-disable-data-cache-revalidation-for-swapfiles.patch
nfs-enable-swap-on-nfs.patch
nfs-prevent-page-allocator-recursions-with-swap-over-nfs.patch
swapfile-avoid-dereferencing-bd_disk-during-swap_entry_free-for-network-storage.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-further-prevent-oom-with-too-many-dirty-pages.patch

