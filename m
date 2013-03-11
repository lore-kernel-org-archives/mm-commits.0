From: akpm@linux-foundation.org
Subject: [merged] memcg-initialize-kmem-cache-destroying-work-earlier.patch removed from -mm tree
Date: Mon, 11 Mar 2013 13:16:54 -0700
Message-ID: <20130311201654.983A331C18B@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:51618 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab3CKUQz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 16:16:55 -0400
Received: by mail-yh0-f74.google.com with SMTP id z6so423845yhz.3
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 13:16:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, glommer@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: initialize kmem-cache destroying work earlier
has been removed from the -mm tree.  Its filename was
     memcg-initialize-kmem-cache-destroying-work-earlier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: memcg: initialize kmem-cache destroying work earlier

Fix a warning from lockdep caused by calling cancel_work_sync() for
uninitialized struct work.  This path has been triggered by destructon
kmem-cache hierarchy via destroying its root kmem-cache.

[  250.781400] cache ffff88003c072d80
[  250.783706] obj ffff88003b410000 cache ffff88003c072d80
[  250.786312] obj ffff88003b924000 cache ffff88003c20bd40
[  250.787233] INFO: trying to register non-static key.
[  250.788046] the code is fine but needs lockdep annotation.
[  250.788184] turning off the locking correctness validator.
[  250.788184] Pid: 2825, comm: insmod Tainted: G           O 3.9.0-rc1-next-20130307+ #611
[  250.788184] Call Trace:
[  250.788184]  [<ffffffff81092ea2>] __lock_acquire+0x16a2/0x1cb0
[  250.788184]  [<ffffffff81093a6a>] lock_acquire+0x8a/0x120
[  250.788184]  [<ffffffff81058ae0>] ? cancel_delayed_work+0xb0/0xb0
[  250.788184]  [<ffffffff81058b18>] flush_work+0x38/0x2a0
[  250.788184]  [<ffffffff81058ae0>] ? cancel_delayed_work+0xb0/0xb0
[  250.788184]  [<ffffffff8109438e>] ? mark_held_locks+0xae/0x120
[  250.788184]  [<ffffffff81058dfd>] ? __cancel_work_timer+0x7d/0xf0
[  250.788184]  [<ffffffff81094505>] ? trace_hardirqs_on_caller+0x105/0x1d0
[  250.788184]  [<ffffffff81058e09>] __cancel_work_timer+0x89/0xf0
[  250.788184]  [<ffffffff81058e8b>] cancel_work_sync+0xb/0x10
[  250.788184]  [<ffffffff8114a401>] kmem_cache_destroy_memcg_children+0x81/0xb0
[  250.788184]  [<ffffffff81114a6f>] kmem_cache_destroy+0xf/0xe0
[  250.788184]  [<ffffffffa000a0cb>] init_module+0xcb/0x1000 [kmem_test]
[  250.788184]  [<ffffffffa000a000>] ? 0xffffffffa0009fff
[  250.788184]  [<ffffffff810002fa>] do_one_initcall+0x11a/0x170
[  250.788184]  [<ffffffff8109fdb0>] load_module+0x19b0/0x2320
[  250.788184]  [<ffffffff8109bfa0>] ? __unlink_module+0x30/0x30
[  250.788184]  [<ffffffff817f365c>] ? retint_restore_args+0xe/0xe
[  250.788184]  [<ffffffff817f365c>] ? retint_restore_args+0xe/0xe
[  250.788184]  [<ffffffff810a07e6>] SyS_init_module+0xc6/0xf0
[  250.788184]  [<ffffffff817fb1d2>] system_call_fastpath+0x16/0x1b

#include <linux/module.h>
#include <linux/slab.h>
#include <linux/mm.h>
#include <linux/workqueue.h>

int __init mod_init(void)
{
	int size = 256;
	struct kmem_cache *cache;
	void *obj;
	struct page *page;

	cache = kmem_cache_create("kmem_cache_test", size, size, 0, NULL);
	if (!cache)
		return -ENOMEM;

	printk("cache %p\n", cache);

	obj = kmem_cache_alloc(cache, GFP_KERNEL);
	if (obj) {
		page = virt_to_head_page(obj);
		printk("obj %p cache %p\n", obj, page->slab_cache);
		kmem_cache_free(cache, obj);
	}

	flush_scheduled_work();

	obj = kmem_cache_alloc(cache, GFP_KERNEL);
	if (obj) {
		page = virt_to_head_page(obj);
		printk("obj %p cache %p\n", obj, page->slab_cache);
		kmem_cache_free(cache, obj);
	}

	kmem_cache_destroy(cache);

	return -EBUSY;
}

module_init(mod_init);
MODULE_LICENSE("GPL");

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-initialize-kmem-cache-destroying-work-earlier mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-initialize-kmem-cache-destroying-work-earlier
+++ a/mm/memcontrol.c
@@ -3012,6 +3012,8 @@ void memcg_update_array_size(int num)
 		memcg_limited_groups_array_size = memcg_caches_array_size(num);
 }
 
+static void kmem_cache_destroy_work_func(struct work_struct *w);
+
 int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
 {
 	struct memcg_cache_params *cur_params = s->memcg_params;
@@ -3031,6 +3033,8 @@ int memcg_update_cache_size(struct kmem_
 			return -ENOMEM;
 		}
 
+		INIT_WORK(&s->memcg_params->destroy,
+				kmem_cache_destroy_work_func);
 		s->memcg_params->is_root_cache = true;
 
 		/*
@@ -3078,6 +3082,8 @@ int memcg_register_cache(struct mem_cgro
 	if (!s->memcg_params)
 		return -ENOMEM;
 
+	INIT_WORK(&s->memcg_params->destroy,
+			kmem_cache_destroy_work_func);
 	if (memcg) {
 		s->memcg_params->memcg = memcg;
 		s->memcg_params->root_cache = root_cache;
@@ -3358,8 +3364,6 @@ static void mem_cgroup_destroy_all_cache
 	list_for_each_entry(params, &memcg->memcg_slab_caches, list) {
 		cachep = memcg_params_to_cache(params);
 		cachep->memcg_params->dead = true;
-		INIT_WORK(&cachep->memcg_params->destroy,
-				  kmem_cache_destroy_work_func);
 		schedule_work(&cachep->memcg_params->destroy);
 	}
 	mutex_unlock(&memcg->slab_caches_mutex);
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
drm-fb-helper-dont-sleep-for-screen-unblank-when-an-oopps-is-in-progress.patch

