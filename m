From: akpm@linux-foundation.org
Subject: + tools-cgroup-add-memcg_slabinfopy-tool.patch added to -mm
 tree
Date: Wed, 24 Jun 2020 14:47:41 -0700
Message-ID: <20200624214741.ilKGE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404563AbgFXVrn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 17:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tj@kernel.org, shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: tools/cgroup: add memcg_slabinfo.py tool
has been added to the -mm tree.  Its filename is
     tools-cgroup-add-memcg_slabinfopy-tool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-cgroup-add-memcg_slabinfopy-tool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-cgroup-add-memcg_slabinfopy-tool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: tools/cgroup: add memcg_slabinfo.py tool

Add a drgn-based tool to display slab information for a given memcg.  Can
replace cgroup v1 memory.kmem.slabinfo interface on cgroup v2, but in a
more flexiable way.

Currently supports only SLUB configuration, but SLAB can be trivially
added later.

Output example:
$ sudo ./tools/cgroup/memcg_slabinfo.py /sys/fs/cgroup/user.slice/user-111017.slice/user\@111017.service
shmem_inode_cache     92     92    704   46    8 : tunables    0    0    0 : slabdata      2      2      0
eventpoll_pwq         56     56     72   56    1 : tunables    0    0    0 : slabdata      1      1      0
eventpoll_epi         32     32    128   32    1 : tunables    0    0    0 : slabdata      1      1      0
kmalloc-8              0      0      8  512    1 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-96             0      0     96   42    1 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-2048           0      0   2048   16    8 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-64           128    128     64   64    1 : tunables    0    0    0 : slabdata      2      2      0
mm_struct            160    160   1024   32    8 : tunables    0    0    0 : slabdata      5      5      0
signal_cache          96     96   1024   32    8 : tunables    0    0    0 : slabdata      3      3      0
sighand_cache         45     45   2112   15    8 : tunables    0    0    0 : slabdata      3      3      0
files_cache          138    138    704   46    8 : tunables    0    0    0 : slabdata      3      3      0
task_delay_info      153    153     80   51    1 : tunables    0    0    0 : slabdata      3      3      0
task_struct           27     27   3520    9    8 : tunables    0    0    0 : slabdata      3      3      0
radix_tree_node       56     56    584   28    4 : tunables    0    0    0 : slabdata      2      2      0
btrfs_inode          140    140   1136   28    8 : tunables    0    0    0 : slabdata      5      5      0
kmalloc-1024          64     64   1024   32    8 : tunables    0    0    0 : slabdata      2      2      0
kmalloc-192           84     84    192   42    2 : tunables    0    0    0 : slabdata      2      2      0
inode_cache           54     54    600   27    4 : tunables    0    0    0 : slabdata      2      2      0
kmalloc-128            0      0    128   32    1 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-512           32     32    512   32    4 : tunables    0    0    0 : slabdata      1      1      0
skbuff_head_cache     32     32    256   32    2 : tunables    0    0    0 : slabdata      1      1      0
sock_inode_cache      46     46    704   46    8 : tunables    0    0    0 : slabdata      1      1      0
cred_jar             378    378    192   42    2 : tunables    0    0    0 : slabdata      9      9      0
proc_inode_cache      96     96    672   24    4 : tunables    0    0    0 : slabdata      4      4      0
dentry               336    336    192   42    2 : tunables    0    0    0 : slabdata      8      8      0
filp                 697    864    256   32    2 : tunables    0    0    0 : slabdata     27     27      0
anon_vma             644    644     88   46    1 : tunables    0    0    0 : slabdata     14     14      0
pid                 1408   1408     64   64    1 : tunables    0    0    0 : slabdata     22     22      0
vm_area_struct      1200   1200    200   40    2 : tunables    0    0    0 : slabdata     30     30      0

Link: http://lkml.kernel.org/r/20200623174037.3951353-20-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/cgroup/memcg_slabinfo.py |  226 +++++++++++++++++++++++++++++++
 1 file changed, 226 insertions(+)

--- /dev/null
+++ a/tools/cgroup/memcg_slabinfo.py
@@ -0,0 +1,226 @@
+#!/usr/bin/env drgn
+#
+# Copyright (C) 2020 Roman Gushchin <guro@fb.com>
+# Copyright (C) 2020 Facebook
+
+from os import stat
+import argparse
+import sys
+
+from drgn.helpers.linux import list_for_each_entry, list_empty
+from drgn.helpers.linux import for_each_page
+from drgn.helpers.linux.cpumask import for_each_online_cpu
+from drgn.helpers.linux.percpu import per_cpu_ptr
+from drgn import container_of, FaultError, Object
+
+
+DESC = """
+This is a drgn script to provide slab statistics for memory cgroups.
+It supports cgroup v2 and v1 and can emulate memory.kmem.slabinfo
+interface of cgroup v1.
+For drgn, visit https://github.com/osandov/drgn.
+"""
+
+
+MEMCGS = {}
+
+OO_SHIFT = 16
+OO_MASK = ((1 << OO_SHIFT) - 1)
+
+
+def err(s):
+    print('slabinfo.py: error: %s' % s, file=sys.stderr, flush=True)
+    sys.exit(1)
+
+
+def find_memcg_ids(css=prog['root_mem_cgroup'].css, prefix=''):
+    if not list_empty(css.children.address_of_()):
+        for css in list_for_each_entry('struct cgroup_subsys_state',
+                                       css.children.address_of_(),
+                                       'sibling'):
+            name = prefix + '/' + css.cgroup.kn.name.string_().decode('utf-8')
+            memcg = container_of(css, 'struct mem_cgroup', 'css')
+            MEMCGS[css.cgroup.kn.id.value_()] = memcg
+            find_memcg_ids(css, name)
+
+
+def is_root_cache(s):
+    try:
+        return False if s.memcg_params.root_cache else True
+    except AttributeError:
+        return True
+
+
+def cache_name(s):
+    if is_root_cache(s):
+        return s.name.string_().decode('utf-8')
+    else:
+        return s.memcg_params.root_cache.name.string_().decode('utf-8')
+
+
+# SLUB
+
+def oo_order(s):
+    return s.oo.x >> OO_SHIFT
+
+
+def oo_objects(s):
+    return s.oo.x & OO_MASK
+
+
+def count_partial(n, fn):
+    nr_pages = 0
+    for page in list_for_each_entry('struct page', n.partial.address_of_(),
+                                    'lru'):
+         nr_pages += fn(page)
+    return nr_pages
+
+
+def count_free(page):
+    return page.objects - page.inuse
+
+
+def slub_get_slabinfo(s, cfg):
+    nr_slabs = 0
+    nr_objs = 0
+    nr_free = 0
+
+    for node in range(cfg['nr_nodes']):
+        n = s.node[node]
+        nr_slabs += n.nr_slabs.counter.value_()
+        nr_objs += n.total_objects.counter.value_()
+        nr_free += count_partial(n, count_free)
+
+    return {'active_objs': nr_objs - nr_free,
+            'num_objs': nr_objs,
+            'active_slabs': nr_slabs,
+            'num_slabs': nr_slabs,
+            'objects_per_slab': oo_objects(s),
+            'cache_order': oo_order(s),
+            'limit': 0,
+            'batchcount': 0,
+            'shared': 0,
+            'shared_avail': 0}
+
+
+def cache_show(s, cfg, objs):
+    if cfg['allocator'] == 'SLUB':
+        sinfo = slub_get_slabinfo(s, cfg)
+    else:
+        err('SLAB isn\'t supported yet')
+
+    if cfg['shared_slab_pages']:
+        sinfo['active_objs'] = objs
+        sinfo['num_objs'] = objs
+
+    print('%-17s %6lu %6lu %6u %4u %4d'
+          ' : tunables %4u %4u %4u'
+          ' : slabdata %6lu %6lu %6lu' % (
+              cache_name(s), sinfo['active_objs'], sinfo['num_objs'],
+              s.size, sinfo['objects_per_slab'], 1 << sinfo['cache_order'],
+              sinfo['limit'], sinfo['batchcount'], sinfo['shared'],
+              sinfo['active_slabs'], sinfo['num_slabs'],
+              sinfo['shared_avail']))
+
+
+def detect_kernel_config():
+    cfg = {}
+
+    cfg['nr_nodes'] = prog['nr_online_nodes'].value_()
+
+    if prog.type('struct kmem_cache').members[1][1] == 'flags':
+        cfg['allocator'] = 'SLUB'
+    elif prog.type('struct kmem_cache').members[1][1] == 'batchcount':
+        cfg['allocator'] = 'SLAB'
+    else:
+        err('Can\'t determine the slab allocator')
+
+    cfg['shared_slab_pages'] = False
+    try:
+        if prog.type('struct obj_cgroup'):
+            cfg['shared_slab_pages'] = True
+    except:
+        pass
+
+    return cfg
+
+
+def for_each_slab_page(prog):
+    PGSlab = 1 << prog.constant('PG_slab')
+    PGHead = 1 << prog.constant('PG_head')
+
+    for page in for_each_page(prog):
+        try:
+            if page.flags.value_() & PGSlab:
+                yield page
+        except FaultError:
+            pass
+
+
+def main():
+    parser = argparse.ArgumentParser(description=DESC,
+                                     formatter_class=
+                                     argparse.RawTextHelpFormatter)
+    parser.add_argument('cgroup', metavar='CGROUP',
+                        help='Target memory cgroup')
+    args = parser.parse_args()
+
+    try:
+        cgroup_id = stat(args.cgroup).st_ino
+        find_memcg_ids()
+        memcg = MEMCGS[cgroup_id]
+    except KeyError:
+        err('Can\'t find the memory cgroup')
+
+    cfg = detect_kernel_config()
+
+    print('# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab>'
+          ' : tunables <limit> <batchcount> <sharedfactor>'
+          ' : slabdata <active_slabs> <num_slabs> <sharedavail>')
+
+    if cfg['shared_slab_pages']:
+        obj_cgroups = set()
+        stats = {}
+        caches = {}
+
+        # find memcg pointers belonging to the specified cgroup
+        obj_cgroups.add(memcg.objcg.value_())
+        for ptr in list_for_each_entry('struct obj_cgroup',
+                                       memcg.objcg_list.address_of_(),
+                                       'list'):
+            obj_cgroups.add(ptr.value_())
+
+        # look over all slab pages, belonging to non-root memcgs
+        # and look for objects belonging to the given memory cgroup
+        for page in for_each_slab_page(prog):
+            objcg_vec_raw = page.obj_cgroups.value_()
+            if objcg_vec_raw == 0:
+                continue
+            cache = page.slab_cache
+            if not cache:
+                continue
+            addr = cache.value_()
+            caches[addr] = cache
+            # clear the lowest bit to get the true obj_cgroups
+            objcg_vec = Object(prog, page.obj_cgroups.type_,
+                               value=objcg_vec_raw & ~1)
+
+            if addr not in stats:
+                stats[addr] = 0
+
+            for i in range(oo_objects(cache)):
+                if objcg_vec[i].value_() in obj_cgroups:
+                    stats[addr] += 1
+
+        for addr in caches:
+            if stats[addr] > 0:
+                cache_show(caches[addr], cfg, stats[addr])
+
+    else:
+        for s in list_for_each_entry('struct kmem_cache',
+                                     memcg.kmem_caches.address_of_(),
+                                     'memcg_params.kmem_caches_node'):
+            cache_show(s, cfg, None)
+
+
+main()
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-__mod_lruvec_state.patch
mm-memcg-prepare-for-byte-sized-vmstat-items.patch
mm-memcg-convert-vmstat-slab-counters-to-bytes.patch
mm-slub-implement-slub-version-of-obj_to_index.patch
mm-memcg-slab-obj_cgroup-api.patch
mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages.patch
mm-memcg-slab-save-obj_cgroup-for-non-root-slab-objects.patch
mm-memcg-slab-charge-individual-slab-objects-instead-of-pages.patch
mm-memcg-slab-deprecate-memorykmemslabinfo.patch
mm-memcg-slab-move-memcg_kmem_bypass-to-memcontrolh.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-accounted-allocations.patch
mm-memcg-slab-simplify-memcg-cache-creation.patch
mm-memcg-slab-remove-memcg_kmem_get_cache.patch
mm-memcg-slab-deprecate-slab_root_caches.patch
mm-memcg-slab-remove-redundant-check-in-memcg_accumulate_slabinfo.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations.patch
kselftests-cgroup-add-kernel-memory-accounting-tests.patch
tools-cgroup-add-memcg_slabinfopy-tool.patch
percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
