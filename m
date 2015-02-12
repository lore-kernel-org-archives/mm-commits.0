From: akpm@linux-foundation.org
Subject: [folded-merged]
 slub-never-fail-to-shrink-cache-init-discard-list-after-freeing-slabs.patch removed from -mm tree
Date: Thu, 12 Feb 2015 14:14:54 -0800
Message-ID: <54dd25de.79yU4IKvmjCj+yC0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbbBLWOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 17:14:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: kmem_cache_shrink: fix crash due to uninitialized discard list
has been removed from the -mm tree.  Its filename was
     slub-never-fail-to-shrink-cache-init-discard-list-after-freeing-slabs.patch

This patch was dropped because it was folded into slub-never-fail-to-shrink-cache.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slub: kmem_cache_shrink: fix crash due to uninitialized discard list

Currently, the discard list is only initialized at the beginning of the
function.  As a result, if there are > 1 nodes, we can get use-after-free
while processing the second or higher node:

    WARNING: CPU: 60 PID: 1 at lib/list_debug.c:29 __list_add+0x3c/0xa9()
    list_add corruption. next->prev should be prev (ffff881ff0a6bb98), but was ffffea007ff57020. (next=ffffea007fbf7320).
    Modules linked in:
    CPU: 60 PID: 1 Comm: swapper/0 Not tainted 3.19.0-rc7-next-20150203-gb50cadf #2178
    Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BIVTSDP1.86B.0038.R02.1307231126 07/23/2013
     0000000000000009 ffff881ff0a6ba88 ffffffff81c2e096 ffffffff810e2d03
     ffff881ff0a6bad8 ffff881ff0a6bac8 ffffffff8108b320 ffff881ff0a6bb18
     ffffffff8154bbc7 ffff881ff0a6bb98 ffffea007fbf7320 ffffea00ffc3c220
    Call Trace:
     [<ffffffff81c2e096>] dump_stack+0x4c/0x65
     [<ffffffff810e2d03>] ? console_unlock+0x398/0x3c7
     [<ffffffff8108b320>] warn_slowpath_common+0xa1/0xbb
     [<ffffffff8154bbc7>] ? __list_add+0x3c/0xa9
     [<ffffffff8108b380>] warn_slowpath_fmt+0x46/0x48
     [<ffffffff8154bbc7>] __list_add+0x3c/0xa9
     [<ffffffff811bf5aa>] __kmem_cache_shrink+0x12b/0x24c
     [<ffffffff81190ca9>] kmem_cache_shrink+0x26/0x38
     [<ffffffff815848b4>] acpi_os_purge_cache+0xe/0x12
     [<ffffffff815c6424>] acpi_purge_cached_objects+0x32/0x7a
     [<ffffffff825f70f1>] acpi_initialize_objects+0x17e/0x1ae
     [<ffffffff825f5177>] ? acpi_sleep_proc_init+0x2a/0x2a
     [<ffffffff825f5209>] acpi_init+0x92/0x25e
     [<ffffffff810002bd>] ? do_one_initcall+0x90/0x17f
     [<ffffffff811bdfcd>] ? kfree+0x1fc/0x2d5
     [<ffffffff825f5177>] ? acpi_sleep_proc_init+0x2a/0x2a
     [<ffffffff8100031a>] do_one_initcall+0xed/0x17f
     [<ffffffff825ae0e2>] kernel_init_freeable+0x1f0/0x278
     [<ffffffff81c1f31a>] ? rest_init+0x13e/0x13e
     [<ffffffff81c1f328>] kernel_init+0xe/0xda
     [<ffffffff81c3ca7c>] ret_from_fork+0x7c/0xb0
     [<ffffffff81c1f31a>] ? rest_init+0x13e/0x13e

Fix this by initializing the discard list at each iteration of the
for_each_kmem_cache_node loop.  Also, move promote lists initialization to
the beginning of the loop to conform.

fixes: slub-never-fail-to-shrink-cache
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reported-by: Huang Ying <ying.huang@intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/slub.c~slub-never-fail-to-shrink-cache-init-discard-list-after-freeing-slabs mm/slub.c
--- a/mm/slub.c~slub-never-fail-to-shrink-cache-init-discard-list-after-freeing-slabs
+++ a/mm/slub.c
@@ -3376,18 +3376,19 @@ int __kmem_cache_shrink(struct kmem_cach
 	struct kmem_cache_node *n;
 	struct page *page;
 	struct page *t;
-	LIST_HEAD(discard);
+	struct list_head discard;
 	struct list_head promote[SHRINK_PROMOTE_MAX];
 	unsigned long flags;
 
-	for (i = 0; i < SHRINK_PROMOTE_MAX; i++)
-		INIT_LIST_HEAD(promote + i);
-
 	flush_all(s);
 	for_each_kmem_cache_node(s, node, n) {
 		if (!n->nr_partial)
 			continue;
 
+		INIT_LIST_HEAD(&discard);
+		for (i = 0; i < SHRINK_PROMOTE_MAX; i++)
+			INIT_LIST_HEAD(promote + i);
+
 		spin_lock_irqsave(&n->list_lock, flags);
 
 		/*
@@ -3417,7 +3418,7 @@ int __kmem_cache_shrink(struct kmem_cach
 		 * partial list.
 		 */
 		for (i = SHRINK_PROMOTE_MAX - 1; i >= 0; i--)
-			list_splice_init(promote + i, &n->partial);
+			list_splice(promote + i, &n->partial);
 
 		spin_unlock_irqrestore(&n->list_lock, flags);
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
slub-never-fail-to-shrink-cache.patch
slub-fix-kmem_cache_shrink-return-value.patch
slub-make-dead-caches-discard-free-slabs-immediately.patch
memcg-cleanup-static-keys-decrement.patch

