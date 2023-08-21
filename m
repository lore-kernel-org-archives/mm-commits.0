Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3413EE49B0
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjHUUrR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjHUUrP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:47:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD3B18B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:47:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92D6C64A7B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC09DC433C8;
        Mon, 21 Aug 2023 20:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650826;
        bh=4l4vwOx6tvj+lEncoov70/29UWqc2oG1fYNBZms18XM=;
        h=Date:To:From:Subject:From;
        b=pc9GXs4SzivS1ZKlaCKIzvyc/T+XPPRlqV9De4pnvw6h5ej1/CS/DthbVuKWfSLzl
         ui14jPAJviWVuF6Gj7aNwdTwnejzsUVRwxZTON1MzECZ8VVqGHBGfYNq70GEZ7aDLn
         qdh027++YbZPvYRa4NmG6vFIdX7AvZt32dqtpo8Q=
Date:   Mon, 21 Aug 2023 13:47:05 -0700
To:     mm-commits@vger.kernel.org, qun-wei.lin@mediatek.com,
        matthias.bgg@gmail.com, chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-vmalloc-add-vmallocinfo-support.patch removed from -mm tree
Message-Id: <20230821204705.EC09DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb/vmalloc: add vmallocinfo support
has been removed from the -mm tree.  Its filename was
     scripts-gdb-vmalloc-add-vmallocinfo-support.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: scripts/gdb/vmalloc: add vmallocinfo support
Date: Tue, 8 Aug 2023 16:30:18 +0800

This GDB script shows the vmallocinfo for user to
analyze the vmalloc memory usage.

Example output:
0xffff800008000000-0xffff800008009000      36864 <start_kernel+372> pages=8 vmalloc
0xffff800008009000-0xffff80000800b000       8192 <gicv2m_init_one+400> phys=0x8020000 ioremap
0xffff80000800b000-0xffff80000800d000       8192 <bpf_prog_alloc_no_stats+72> pages=1 vmalloc
0xffff80000800d000-0xffff80000800f000       8192 <bpf_jit_alloc_exec+16> pages=1 vmalloc
0xffff800008010000-0xffff80000ad30000   47316992 <paging_init+452> phys=0x40210000 vmap
0xffff80000ad30000-0xffff80000c1c0000   21561344 <paging_init+556> phys=0x42f30000 vmap
0xffff80000c1c0000-0xffff80000c370000    1769472 <paging_init+592> phys=0x443c0000 vmap
0xffff80000c370000-0xffff80000de90000   28442624 <paging_init+692> phys=0x44570000 vmap
0xffff80000de90000-0xffff80000f4c1000   23269376 <paging_init+788> phys=0x46090000 vmap
0xffff80000f4c1000-0xffff80000f4c3000       8192 <gen_pool_add_owner+112> pages=1 vmalloc
0xffff80000f4c3000-0xffff80000f4c5000       8192 <gen_pool_add_owner+112> pages=1 vmalloc
0xffff80000f4c5000-0xffff80000f4c7000       8192 <gen_pool_add_owner+112> pages=1 vmalloc

Link: https://lkml.kernel.org/r/20230808083020.22254-9-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/constants.py.in |    8 ++++
 scripts/gdb/linux/vmalloc.py      |   56 ++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py        |    1 
 3 files changed, 65 insertions(+)

--- a/scripts/gdb/linux/constants.py.in~scripts-gdb-vmalloc-add-vmallocinfo-support
+++ a/scripts/gdb/linux/constants.py.in
@@ -22,6 +22,7 @@
 #include <linux/radix-tree.h>
 #include <linux/slab.h>
 #include <linux/threads.h>
+#include <linux/vmalloc.h>
 
 /* We need to stringify expanded macros so that they can be parsed */
 
@@ -91,6 +92,13 @@ LX_GDBPARSED(RADIX_TREE_MAP_SIZE)
 LX_GDBPARSED(RADIX_TREE_MAP_SHIFT)
 LX_GDBPARSED(RADIX_TREE_MAP_MASK)
 
+/* linux/vmalloc.h */
+LX_VALUE(VM_IOREMAP)
+LX_VALUE(VM_ALLOC)
+LX_VALUE(VM_MAP)
+LX_VALUE(VM_USERMAP)
+LX_VALUE(VM_DMA_COHERENT)
+
 /* linux/page_ext.h */
 if IS_BUILTIN(CONFIG_PAGE_OWNER):
     LX_GDBPARSED(PAGE_EXT_OWNER)
--- /dev/null
+++ a/scripts/gdb/linux/vmalloc.py
@@ -0,0 +1,56 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2023 MediaTek Inc.
+#
+# Authors:
+#  Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
+#
+
+import gdb
+import re
+from linux import lists, utils, stackdepot, constants, mm
+
+vmap_area_type = utils.CachedType('struct vmap_area')
+vmap_area_ptr_type = vmap_area_type.get_type().pointer()
+
+def is_vmalloc_addr(x):
+    pg_ops = mm.page_ops().ops
+    addr = pg_ops.kasan_reset_tag(x)
+    return addr >= pg_ops.VMALLOC_START and addr < pg_ops.VMALLOC_END
+
+class LxVmallocInfo(gdb.Command):
+    """Show vmallocinfo"""
+
+    def __init__(self):
+        super(LxVmallocInfo, self).__init__("lx-vmallocinfo", gdb.COMMAND_DATA)
+
+    def invoke(self, arg, from_tty):
+        vmap_area_list = gdb.parse_and_eval('vmap_area_list')
+        for vmap_area in lists.list_for_each_entry(vmap_area_list, vmap_area_ptr_type, "list"):
+            if not vmap_area['vm']:
+                gdb.write("0x%x-0x%x %10d vm_map_ram\n" % (vmap_area['va_start'], vmap_area['va_end'],
+                    vmap_area['va_end'] - vmap_area['va_start']))
+                continue
+            v = vmap_area['vm']
+            gdb.write("0x%x-0x%x %10d" % (v['addr'], v['addr'] + v['size'], v['size']))
+            if v['caller']:
+                gdb.write(" %s" % str(v['caller']).split(' ')[-1])
+            if v['nr_pages']:
+                gdb.write(" pages=%d" % v['nr_pages'])
+            if v['phys_addr']:
+                gdb.write(" phys=0x%x" % v['phys_addr'])
+            if v['flags'] & constants.LX_VM_IOREMAP:
+                gdb.write(" ioremap")
+            if v['flags'] & constants.LX_VM_ALLOC:
+                gdb.write(" vmalloc")
+            if v['flags'] & constants.LX_VM_MAP:
+                gdb.write(" vmap")
+            if v['flags'] & constants.LX_VM_USERMAP:
+                gdb.write(" user")
+            if v['flags'] & constants.LX_VM_DMA_COHERENT:
+                gdb.write(" dma-coherent")
+            if is_vmalloc_addr(v['pages']):
+                gdb.write(" vpages")
+            gdb.write("\n")
+
+LxVmallocInfo()
--- a/scripts/gdb/vmlinux-gdb.py~scripts-gdb-vmalloc-add-vmallocinfo-support
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -48,3 +48,4 @@ else:
     import linux.stackdepot
     import linux.page_owner
     import linux.slab
+    import linux.vmalloc
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are


