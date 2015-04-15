From: akpm@linux-foundation.org
Subject: [merged] slob-statify-slob_alloc_node-and-remove-symbol.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 12:09:04 -0700
Message-ID: <552eb750.6MD9R34VVmh9Wxzy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbbDOTJE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:09:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slob: make slob_alloc_node() static and remove EXPORT_SYMBOL()
has been removed from the -mm tree.  Its filename was
     slob-statify-slob_alloc_node-and-remove-symbol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: slob: make slob_alloc_node() static and remove EXPORT_SYMBOL()

slob_alloc_node() is only used in slob.c.  Remove the EXPORT_SYMBOL and
make slob_alloc_node() static.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slob.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/slob.c~slob-statify-slob_alloc_node-and-remove-symbol mm/slob.c
--- a/mm/slob.c~slob-statify-slob_alloc_node-and-remove-symbol
+++ a/mm/slob.c
@@ -532,7 +532,7 @@ int __kmem_cache_create(struct kmem_cach
 	return 0;
 }
 
-void *slob_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
+static void *slob_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 {
 	void *b;
 
@@ -558,7 +558,6 @@ void *slob_alloc_node(struct kmem_cache
 	kmemleak_alloc_recursive(b, c->size, 1, c->flags, flags);
 	return b;
 }
-EXPORT_SYMBOL(slob_alloc_node);
 
 void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 {
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-vmalloc-fix-possible-exhaustion-of-vmalloc-space-caused-by-vm_map_ram-allocator.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch
mm-memblock-add-debug-output-for-the-memblock_add.patch
mm-memblock-add-debug-output-for-the-memblock_add-fix.patch
envctrl-ignore-orderly_poweroff-return-value.patch
kernel-rebootc-add-orderly_reboot-for-graceful-reboot.patch
powerpc-powernv-reboot-when-requested-by-firmware.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
befs-replace-typedef-befs_mount_options-by-structure.patch
befs-replace-typedef-befs_sb_info-by-structure.patch
befs-replace-typedef-befs_inode_info-by-structure.patch
fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr.patch
fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr.patch
fs-hfsplus-atomically-set-inode-i_flags.patch
fs-hfsplus-use-bool-instead-of-int-for-is_known_namespace-return-value.patch
fs-hfsplus-replace-if-bug-by-bug_on.patch
hfsplus-dont-store-special-osx-xattr-prefix-on-disk.patch
adfs-returning-correct-return-values.patch
fs-affs-use-affs_mount-prefix-for-mount-options.patch
fs-affs-affsh-add-mount-option-manipulation-macros.patch
fs-affs-superc-use-affs_set_opt.patch
fs-affs-use-affs_test_opt.patch
affs-kstrdup-memory-handling.patch
affs-kstrdup-memory-handling-fix.patch
linux-next.patch

