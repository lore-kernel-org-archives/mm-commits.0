From: akpm@linux-foundation.org
Subject: + slob-statify-slob_alloc_node-and-remove-symbol.patch added to
 -mm tree
Date: Thu, 09 Apr 2015 13:50:31 -0700
Message-ID: <5526e617.DdJ+duqnzHy8b4gx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbbDIUuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2015 16:50:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slob: make slob_alloc_node() static and remove EXPORT_SYMBOL()
has been added to the -mm tree.  Its filename is
     slob-statify-slob_alloc_node-and-remove-symbol.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slob-statify-slob_alloc_node-and-remove-symbol.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slob-statify-slob_alloc_node-and-remove-symbol.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
slob-statify-slob_alloc_node-and-remove-symbol.patch
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

