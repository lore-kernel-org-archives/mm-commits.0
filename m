From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 011/128] mm/slub: fix stack overruns with
 SLUB_STATS
Date: Tue, 02 Jun 2020 13:10:30 -0700
Message-ID: <20200602201030.DnC5rBi5F%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727982AbgFBUKc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:10:32 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cai@lca.pw, cl@linux.com, glauber@scylladb.com, iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, torvalds@linux-foundation.org

From: Qian Cai <cai@lca.pw>
Subject: mm/slub: fix stack overruns with SLUB_STATS

There is no need to copy SLUB_STATS items from root memcg cache to new
memcg cache copies.  Doing so could result in stack overruns because the
store function only accepts 0 to clear the stat and returns an error for
everything else while the show method would print out the whole stat. 
Then, the mismatch of the lengths returns from show and store methods
happens in memcg_propagate_slab_attrs(),

else if (root_cache->max_attr_size < ARRAY_SIZE(mbuf))
	buf = mbuf;

max_attr_size is only 2 from slab_attr_store(), then, it uses mbuf[64] in
show_stat() later where a bounch of sprintf() would overrun the stack
variable.  Fix it by always allocating a page of buffer to be used in
show_stat() if SLUB_STATS=y which should only be used for debug purpose.

 # echo 1 > /sys/kernel/slab/fs_cache/shrink
 BUG: KASAN: stack-out-of-bounds in number+0x421/0x6e0
 Write of size 1 at addr ffffc900256cfde0 by task kworker/76:0/53251

 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019
 Workqueue: memcg_kmem_cache memcg_kmem_cache_create_func
 Call Trace:
  dump_stack+0xa7/0xea
  print_address_description.constprop.5.cold.7+0x64/0x384
  __kasan_report.cold.8+0x76/0xda
  kasan_report+0x41/0x60
  __asan_store1+0x6d/0x70
  number+0x421/0x6e0
  vsnprintf+0x451/0x8e0
  sprintf+0x9e/0xd0
  show_stat+0x124/0x1d0
  alloc_slowpath_show+0x13/0x20
  __kmem_cache_create+0x47a/0x6b0

 addr ffffc900256cfde0 is located in stack of task kworker/76:0/53251 at offset 0 in frame:
  process_one_work+0x0/0xb90

 this frame has 1 object:
  [32, 72) 'lockdep_map'

 Memory state around the buggy address:
  ffffc900256cfc80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffffc900256cfd00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 >ffffc900256cfd80: 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1
                                                        ^
  ffffc900256cfe00: 00 00 00 00 00 f2 f2 f2 00 00 00 00 00 00 00 00
  ffffc900256cfe80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ==================================================================
 Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: __kmem_cache_create+0x6ac/0x6b0
 Workqueue: memcg_kmem_cache memcg_kmem_cache_create_func
 Call Trace:
  dump_stack+0xa7/0xea
  panic+0x23e/0x452
  __stack_chk_fail+0x22/0x30
  __kmem_cache_create+0x6ac/0x6b0

Link: http://lkml.kernel.org/r/20200429222356.4322-1-cai@lca.pw
Fixes: 107dab5c92d5 ("slub: slub-specific propagation changes")
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Glauber Costa <glauber@scylladb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-fix-stack-overruns-with-slub_stats
+++ a/mm/slub.c
@@ -5691,7 +5691,8 @@ static void memcg_propagate_slab_attrs(s
 		 */
 		if (buffer)
 			buf = buffer;
-		else if (root_cache->max_attr_size < ARRAY_SIZE(mbuf))
+		else if (root_cache->max_attr_size < ARRAY_SIZE(mbuf) &&
+			 !IS_ENABLED(CONFIG_SLUB_STATS))
 			buf = mbuf;
 		else {
 			buffer = (char *) get_zeroed_page(GFP_KERNEL);
_
