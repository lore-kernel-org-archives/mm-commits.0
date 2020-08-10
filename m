Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C1F3C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 275542065D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027025;
	bh=fne+IQXCIm25z+XVL/nq5/PZJyFooXvcqEaNBfPtHYc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tf75UaM7BqCZaNQjQ7FMVGUwkMRiX76P1juJon9WfyRikL4hsbdvn5javcdzEvc3B
	 Tm4mVCZGFPJShKmxi+XlD1HSFTwJXIuRbCZvy/W+rK6/SDvGuPIlo58PrKUY2U7Vm8
	 a7DsOXTjUiqexBnv2TqW0PqLGU5sZnGTsQzj+F7w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgHJChE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbgHJChC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:37:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A187D2065D;
        Mon, 10 Aug 2020 02:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027021;
        bh=fne+IQXCIm25z+XVL/nq5/PZJyFooXvcqEaNBfPtHYc=;
        h=Date:From:To:Subject:From;
        b=jEoG9H/xSa9YHPNimIN1Ug58Fd+lkvyNlZEsylFqUFfy+b1/QkoPIPXxGW6OlWPDj
         5Ac6Wh2kvGmbKcpQBWItb0YmAbJsSaRMjgRD8bldTq2bBQL7dhEW/CieQNycQW8UUU
         A45r34eq9/cMrpE/PErwNPasYonGnsyl+vg+20Vk=
Date:   Sun, 09 Aug 2020 19:37:01 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        vbabka@suse.cz
Subject:  [merged] tools-cgroup-add-memcg_slabinfopy-tool.patch
 removed from -mm tree
Message-ID: <20200810023701.slRckOpoj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/cgroup: add memcg_slabinfo.py tool
has been removed from the -mm tree.  Its filename was
     tools-cgroup-add-memcg_slabinfopy-tool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

