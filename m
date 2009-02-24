From: akpm@linux-foundation.org
Subject: [merged] drm-preserve-shmlba-bits-in-hash-key-for-_drm_shm-mappings.patch removed from -mm tree
Date: Tue, 24 Feb 2009 11:33:17 -0800
Message-ID: <200902241933.n1OJXHNa004511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757075AbZBXTh0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 14:37:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, airlied@linux.ie, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     drm: preserve SHMLBA bits in hash key for _DRM_SHM mappings.
has been removed from the -mm tree.  Its filename was
     drm-preserve-shmlba-bits-in-hash-key-for-_drm_shm-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: preserve SHMLBA bits in hash key for _DRM_SHM mappings.
From: David Miller <davem@davemloft.net>

Platforms such as sparc64 have D-cache aliasing issues.  We cannot allow
virtual mappings in different contexts to be such that two cache lines can
be loaded for the same backing data.  Updates to one cache line won't be
seen by accesses to the other cache line.

Code in sparc64 and other architectures solve this problem by making sure
that all userland mappings of MAP_SHARED objects have the same virtual
address base.  They implement this by keying off of the page offset, and
using that to choose a suitably consistent virtual address for mmap()
requests.

Making things even worse, getting this wrong on sparc64 can result in
hangs during DRM lock acquisition.  This is because, at least on
UltraSPARC-III, normal loads consult the D-cache but atomics such as 'cas'
(which is what cmpxchg() is implement using) only consult the L2 cache. 
So if a D-cache alias is inserted, the load can see different data than
the atomic, and we'll loop forever because the atomic compare-and-exchange
will never complete successfully.

So to make this all work properly, we need to make sure that the hash
address computed by drm_map_handle() preserves the SHMLBA relevant bits,
and that's what this patch does for _DRM_SHM mappings.

As a historical note, many years ago this bug didn't exist because we used
to just use the low 32-bits of the address as the hash and just hope for
the best.  This preserved the SHMLBA bits properly.  But when the hashtab
code was added to DRM, this was no longer the case.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_bufs.c |   35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff -puN drivers/gpu/drm/drm_bufs.c~drm-preserve-shmlba-bits-in-hash-key-for-_drm_shm-mappings drivers/gpu/drm/drm_bufs.c
--- a/drivers/gpu/drm/drm_bufs.c~drm-preserve-shmlba-bits-in-hash-key-for-_drm_shm-mappings
+++ a/drivers/gpu/drm/drm_bufs.c
@@ -34,6 +34,8 @@
  */
 
 #include <linux/vmalloc.h>
+#include <linux/log2.h>
+#include <asm/shmparam.h>
 #include "drmP.h"
 
 resource_size_t drm_get_resource_start(struct drm_device *dev, unsigned int resource)
@@ -83,9 +85,11 @@ static struct drm_map_list *drm_find_mat
 }
 
 static int drm_map_handle(struct drm_device *dev, struct drm_hash_item *hash,
-			  unsigned long user_token, int hashed_handle)
+			  unsigned long user_token, int hashed_handle, int shm)
 {
-	int use_hashed_handle;
+	int use_hashed_handle, shift;
+	unsigned long add;
+
 #if (BITS_PER_LONG == 64)
 	use_hashed_handle = ((user_token & 0xFFFFFFFF00000000UL) || hashed_handle);
 #elif (BITS_PER_LONG == 32)
@@ -101,9 +105,31 @@ static int drm_map_handle(struct drm_dev
 		if (ret != -EINVAL)
 			return ret;
 	}
+
+	shift = 0;
+	add = DRM_MAP_HASH_OFFSET >> PAGE_SHIFT;
+	if (shm && (SHMLBA > PAGE_SIZE)) {
+		int bits = ilog2(SHMLBA >> PAGE_SHIFT) + 1;
+
+		/* For shared memory, we have to preserve the SHMLBA
+		 * bits of the eventual vma->vm_pgoff value during
+		 * mmap().  Otherwise we run into cache aliasing problems
+		 * on some platforms.  On these platforms, the pgoff of
+		 * a mmap() request is used to pick a suitable virtual
+		 * address for the mmap() region such that it will not
+		 * cause cache aliasing problems.
+		 *
+		 * Therefore, make sure the SHMLBA relevant bits of the
+		 * hash value we use are equal to those in the original
+		 * kernel virtual address.
+		 */
+		shift = bits;
+		add |= ((user_token >> PAGE_SHIFT) & ((1UL << bits) - 1UL));
+	}
+
 	return drm_ht_just_insert_please(&dev->map_hash, hash,
 					 user_token, 32 - PAGE_SHIFT - 3,
-					 0, DRM_MAP_HASH_OFFSET >> PAGE_SHIFT);
+					 shift, add);
 }
 
 /**
@@ -323,7 +349,8 @@ static int drm_addmap_core(struct drm_de
 	/* We do it here so that dev->struct_mutex protects the increment */
 	user_token = (map->type == _DRM_SHM) ? (unsigned long)map->handle :
 		map->offset;
-	ret = drm_map_handle(dev, &list->hash, user_token, 0);
+	ret = drm_map_handle(dev, &list->hash, user_token, 0,
+			     (map->type == _DRM_SHM));
 	if (ret) {
 		if (map->type == _DRM_REGISTERS)
 			iounmap(map->handle);
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
linux-next.patch
sfc-modify-allocation-error-message.patch
epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key.patch
epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch
epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch
epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-make-tty-use-keyed-wakeups.patch
kprobes-cleanup-aggr_kprobe-related-code.patch
kprobes-move-export_symbol_gpl-just-after-function-definitions.patch
kprobes-cleanup-comment-style-in-kprobesh.patch
kprobes-rename-kprobe_enabled-to-kprobes_all_disarmed.patch
kprobes-support-per-kprobe-disabling.patch
kprobes-support-kretprobe-and-jprobe-per-probe-disabling.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
sunxvr500-fix-cmap-memory-leaks.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

