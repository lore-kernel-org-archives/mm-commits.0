From: akpm@linux-foundation.org
Subject: - slubcearly_kmem_cache_node_alloc-shouldnt-be.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:30:37 -0700
Message-ID: <200710162030.l9GKUbeW014424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59293 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966166AbXJPVnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slub.c:early_kmem_cache_node_alloc() shouldn't be __init
has been removed from the -mm tree.  Its filename was
     slubcearly_kmem_cache_node_alloc-shouldnt-be.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slubcearly_kmem_cache_node_alloc-shouldnt-be mm/slub.c
--- a/mm/slub.c~slubcearly_kmem_cache_node_alloc-shouldnt-be
+++ a/mm/slub.c
@@ -1878,8 +1878,8 @@ static void init_kmem_cache_node(struct 
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
git-acpi.patch
git-alsa.patch
git-kvm.patch
remove-fs-jffs2-ioctlc.patch
parisc-extern-inline-static-inline.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-ipwireless_cs.patch
maps2-add-proc-kpagemap-interface.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
unicode-diacritics-support-s390-fix.patch
script-to-check-for-undefined-kconfig-symbols.patch
drivers-block-ccissc-fix-check-after-use.patch
dontdiff-update-based-on-gitignore-updates.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
