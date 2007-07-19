From: akpm@linux-foundation.org
Subject: + slubcearly_kmem_cache_node_alloc-shouldnt-be.patch added to -mm tree
Date: Thu, 19 Jul 2007 16:59:11 -0700
Message-ID: <200707192359.l6JNxBZe029640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934253AbXGSX7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 19:59:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, clameter@sgi.com


The patch titled
     slub.c:early_kmem_cache_node_alloc() shouldn't be __init
has been added to the -mm tree.  Its filename is
     slubcearly_kmem_cache_node_alloc-shouldnt-be.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub.c:early_kmem_cache_node_alloc() shouldn't be __init
From: Adrian Bunk <bunk@stusta.de>

WARNING: mm/built-in.o(.text+0x24bd3): Section mismatch: reference to .init.text:early_kmem_cache_node_alloc (between 'init_kmem_cache_nodes' and 'calculate_sizes')
...

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slubcearly_kmem_cache_node_alloc-shouldnt-be mm/slub.c
--- a/mm/slub.c~slubcearly_kmem_cache_node_alloc-shouldnt-be
+++ a/mm/slub.c
@@ -1867,8 +1867,8 @@ static void init_kmem_cache_node(struct 
  * Note that this function only works on the kmalloc_node_cache
  * when allocating for the kmalloc_node_cache.
  */
-static struct kmem_cache_node * __init early_kmem_cache_node_alloc(gfp_t gfpflags,
-								int node)
+static struct kmem_cache_node *early_kmem_cache_node_alloc(gfp_t gfpflags,
+							   int node)
 {
 	struct page *page;
 	struct kmem_cache_node *n;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
fix-x86_64-mm-xen-xen-event-channels.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
git-hwmon.patch
git-kbuild.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
git-scsi-misc.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
