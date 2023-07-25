Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3986C001DE
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jul 2023 18:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbjGYSkK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jul 2023 14:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbjGYSkH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2023 14:40:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA3919A1
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 11:40:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24B566181E
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 18:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C2EC433C8;
        Tue, 25 Jul 2023 18:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690310400;
        bh=ZehIex6qhKNsUmWJVT8AAxX/0GNgSY4g0DjbBdol8iA=;
        h=Date:To:From:Subject:From;
        b=QF4L8ALThE12FPiqJWeJ7RH5an9C4I3LwQ8UWUZsURyZwNB5pLQ9w4fpR4tyn5rro
         5wfvs6NkQVvBUuJZUjWL3NxWfi+qu9ohJvzYjHhVwjT69nMvSazdd5tmF1K/pBasSU
         zZ1HBI/Zsw7tK76NBN7aHY/FBYKqtOceAXK1BiSs=
Date:   Tue, 25 Jul 2023 11:39:59 -0700
To:     mm-commits@vger.kernel.org, qun-wei.lin@mediatek.com,
        matthias.bgg@gmail.com, chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-page_owner-add-page-owner-support.patch added to mm-nonmm-unstable branch
Message-Id: <20230725184000.77C2EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb/page_owner: add page owner support
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-page_owner-add-page-owner-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-page_owner-add-page-owner-support.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: scripts/gdb/page_owner: add page owner support
Date: Tue, 25 Jul 2023 17:34:56 +0800

This GDB scripts print page owner information for user to
analyze the memory usage or memory corruption issue.

Example output from an aarch64 system:

(gdb) lx-dump-page-owner --pfn 655360
page_owner tracks the page as allocated
Page last allocated via order 0, gfp_mask: 0x8, pid: 1, tgid: 1 ("swapper/0\000\000\000\000\000\000"), ts 1295948880 ns, free_ts 1011852016 ns
PFN: 655360, Flags: 0x3fffc0000000000
   0xffff8000086ab964 <post_alloc_hook+452>:    ldp     x19, x20, [sp, #16]
   0xffff80000862e4e0 <split_map_pages+344>:    cbnz    w22, 0xffff80000862e57c <split_map_pages+500>
   0xffff8000086370c4 <isolate_freepages_range+556>:    mov     x0, x27
   0xffff8000086bc1cc <alloc_contig_range+808>: mov     x24, x0
   0xffff80000877d6d8 <cma_alloc+772>:  mov     w1, w0
   0xffff8000082c8d18 <dma_alloc_from_contiguous+104>:  ldr     x19, [sp, #16]
   0xffff8000082ce0e8 <atomic_pool_expand+208>: mov     x19, x0
   0xffff80000c1e41b4 <__dma_atomic_pool_init+172>:     Cannot access memory at address 0xffff80000c1e41b4
   0xffff80000c1e4298 <dma_atomic_pool_init+92>:        Cannot access memory at address 0xffff80000c1e4298
   0xffff8000080161d4 <do_one_initcall+176>:    mov     w21, w0
   0xffff80000c1c1b50 <kernel_init_freeable+952>:       Cannot access memory at address 0xffff80000c1c1b50
   0xffff80000acf87dc <kernel_init+36>: bl      0xffff8000081ab100 <async_synchronize_full>
   0xffff800008018d00 <ret_from_fork+16>:       mrs     x28, sp_el0
page last free stack trace:
   0xffff8000086a6e8c <free_unref_page_prepare+796>:    mov     w2, w23
   0xffff8000086aee1c <free_unref_page+96>:     tst     w0, #0xff
   0xffff8000086af3f8 <__free_pages+292>:       ldp     x19, x20, [sp, #16]
   0xffff80000c1f3214 <init_cma_reserved_pageblock+220>:        Cannot access memory at address 0xffff80000c1f3214
   0xffff80000c20363c <cma_init_reserved_areas+1284>:   Cannot access memory at address 0xffff80000c20363c
   0xffff8000080161d4 <do_one_initcall+176>:    mov     w21, w0
   0xffff80000c1c1b50 <kernel_init_freeable+952>:       Cannot access memory at address 0xffff80000c1c1b50
   0xffff80000acf87dc <kernel_init+36>: bl      0xffff8000081ab100 <async_synchronize_full>
   0xffff800008018d00 <ret_from_fork+16>:       mrs     x28, sp_el0

Link: https://lkml.kernel.org/r/20230725093458.30064-7-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/constants.py.in |    6 
 scripts/gdb/linux/page_owner.py   |  189 ++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py        |    1 
 3 files changed, 196 insertions(+)

--- a/scripts/gdb/linux/constants.py.in~scripts-gdb-page_owner-add-page-owner-support
+++ a/scripts/gdb/linux/constants.py.in
@@ -18,6 +18,7 @@
 #include <linux/irq.h>
 #include <linux/mount.h>
 #include <linux/of_fdt.h>
+#include <linux/page_ext.h>
 #include <linux/radix-tree.h>
 #include <linux/threads.h>
 #include <asm/memory.h>
@@ -94,6 +95,10 @@ if IS_BUILTIN(CONFIG_ARM64):
     LX_GDBPARSED(VA_BITS_MIN)
     LX_GDBPARSED(MODULES_VSIZE)
 
+/* linux/page_ext.h */
+LX_GDBPARSED(PAGE_EXT_OWNER)
+LX_GDBPARSED(PAGE_EXT_OWNER_ALLOCATED)
+
 /* Kernel Configs */
 LX_CONFIG(CONFIG_GENERIC_CLOCKEVENTS)
 LX_CONFIG(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)
@@ -134,3 +139,4 @@ if IS_BUILTIN(CONFIG_NUMA):
     LX_VALUE(CONFIG_NODES_SHIFT)
 LX_CONFIG(CONFIG_DEBUG_VIRTUAL)
 LX_CONFIG(CONFIG_STACKDEPOT)
+LX_CONFIG(CONFIG_PAGE_OWNER)
--- /dev/null
+++ a/scripts/gdb/linux/page_owner.py
@@ -0,0 +1,189 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2023 MediaTek Inc.
+#
+# Authors:
+#  Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
+#
+
+import gdb
+from linux import utils, stackdepot, constants, mm
+
+page_ext_t = utils.CachedType('struct page_ext')
+page_owner_t = utils.CachedType('struct page_owner')
+
+PAGE_OWNER_STACK_DEPTH = 16
+PAGE_EXT_OWNER = constants.LX_PAGE_EXT_OWNER
+PAGE_EXT_INVALID = 0x1
+PAGE_EXT_OWNER_ALLOCATED = constants.LX_PAGE_EXT_OWNER_ALLOCATED
+
+def help():
+    t = """Usage: lx-dump-page-owner [Option]
+    Option:
+        --pfn [Decimal pfn]
+    Example:
+        lx-dump-page-owner --pfn 655360\n"""
+    gdb.write("Unrecognized command\n")
+    raise gdb.GdbError(t)
+
+class DumpPageOwner(gdb.Command):
+    """Dump page owner"""
+
+    min_pfn = None
+    max_pfn = None
+    p_ops = None
+    migrate_reason_names = None
+
+    def __init__(self):
+        super(DumpPageOwner, self).__init__("lx-dump-page-owner", gdb.COMMAND_SUPPORT)
+
+    def invoke(self, args, from_tty):
+        if not constants.LX_CONFIG_PAGE_OWNER:
+            raise gdb.GdbError('CONFIG_PAGE_OWNER does not enable')
+
+        page_owner_inited = gdb.parse_and_eval('page_owner_inited')
+        if page_owner_inited['key']['enabled']['counter'] != 0x1:
+            raise gdb.GdbError('page_owner_inited is not enabled')
+
+        self.p_ops = mm.page_ops().ops
+        self.get_page_owner_info()
+        argv = gdb.string_to_argv(args)
+        if len(argv) == 0:
+              self.read_page_owner()
+        elif len(argv) == 2:
+            if argv[0] == "--pfn":
+                pfn = int(argv[1])
+                self.read_page_owner_by_addr(self.p_ops.pfn_to_page(pfn))
+            else:
+                help()
+        else:
+            help()
+
+    def get_page_owner_info(self):
+        self.min_pfn = int(gdb.parse_and_eval("min_low_pfn"))
+        self.max_pfn = int(gdb.parse_and_eval("max_pfn"))
+        self.page_ext_size = int(gdb.parse_and_eval("page_ext_size"))
+        self.migrate_reason_names = gdb.parse_and_eval('migrate_reason_names')
+
+    def page_ext_invalid(self, page_ext):
+        if page_ext == gdb.Value(0):
+            return True
+        if page_ext.cast(utils.get_ulong_type()) & PAGE_EXT_INVALID == PAGE_EXT_INVALID:
+            return True
+        return False
+
+    def get_entry(self, base, index):
+        return (base.cast(utils.get_ulong_type()) + self.page_ext_size * index).cast(page_ext_t.get_type().pointer())
+
+    def lookup_page_ext(self, page):
+        pfn = self.p_ops.page_to_pfn(page)
+        section = self.p_ops.pfn_to_section(pfn)
+        page_ext = section["page_ext"]
+        if self.page_ext_invalid(page_ext):
+            return gdb.Value(0)
+        return self.get_entry(page_ext, pfn)
+
+    def page_ext_get(self, page):
+        page_ext = self.lookup_page_ext(page)
+        if page_ext != gdb.Value(0):
+            return page_ext
+        else:
+            return gdb.Value(0)
+
+    def get_page_owner(self, page_ext):
+        addr = page_ext.cast(utils.get_ulong_type()) + gdb.parse_and_eval("page_owner_ops")["offset"].cast(utils.get_ulong_type())
+        return addr.cast(page_owner_t.get_type().pointer())
+
+    def read_page_owner_by_addr(self, struct_page_addr):
+        page = gdb.Value(struct_page_addr).cast(utils.get_page_type().pointer())
+        pfn = self.p_ops.page_to_pfn(page)
+
+        if pfn < self.min_pfn or pfn > self.max_pfn or (not self.p_ops.pfn_valid(pfn)):
+            gdb.write("pfn is invalid\n")
+            return
+
+        page = self.p_ops.pfn_to_page(pfn)
+        page_ext = self.page_ext_get(page)
+
+        if page_ext == gdb.Value(0):
+            gdb.write("page_ext is null\n")
+            return
+
+        if not (page_ext['flags'] & (1 << PAGE_EXT_OWNER)):
+            gdb.write("page_owner flag is invalid\n")
+            raise gdb.GdbError('page_owner info is not present (never set?)\n')
+
+        if mm.test_bit(PAGE_EXT_OWNER_ALLOCATED, page_ext['flags'].address):
+            gdb.write('page_owner tracks the page as allocated\n')
+        else:
+            gdb.write('page_owner tracks the page as freed\n')
+
+        if not (page_ext['flags'] & (1 << PAGE_EXT_OWNER_ALLOCATED)):
+            gdb.write("page_owner is not allocated\n")
+
+        try:
+            page_owner = self.get_page_owner(page_ext)
+            gdb.write("Page last allocated via order %d, gfp_mask: 0x%x, pid: %d, tgid: %d (%s), ts %u ns, free_ts %u ns\n" %\
+                    (page_owner["order"], page_owner["gfp_mask"],\
+                    page_owner["pid"], page_owner["tgid"], page_owner["comm"],\
+                    page_owner["ts_nsec"], page_owner["free_ts_nsec"]))
+            gdb.write("PFN: %d, Flags: 0x%x\n" % (pfn, page['flags']))
+            if page_owner["handle"] == 0:
+                gdb.write('page_owner allocation stack trace missing\n')
+            else:
+                stackdepot.stack_depot_print(page_owner["handle"])
+
+            if page_owner["free_handle"] == 0:
+                gdb.write('page_owner free stack trace missing\n')
+            else:
+                gdb.write('page last free stack trace:\n')
+                stackdepot.stack_depot_print(page_owner["free_handle"])
+            if page_owner['last_migrate_reason'] != -1:
+                gdb.write('page has been migrated, last migrate reason: %s\n' % self.migrate_reason_names[page_owner['last_migrate_reason']])
+        except:
+            gdb.write("\n")
+
+    def read_page_owner(self):
+        pfn = self.min_pfn
+
+        # Find a valid PFN or the start of a MAX_ORDER_NR_PAGES area
+        while ((not self.p_ops.pfn_valid(pfn)) and (pfn & (self.p_ops.MAX_ORDER_NR_PAGES - 1))) != 0:
+            pfn += 1
+
+        while pfn < self.max_pfn:
+            #
+            # If the new page is in a new MAX_ORDER_NR_PAGES area,
+            # validate the area as existing, skip it if not
+            #
+            if ((pfn & (self.p_ops.MAX_ORDER_NR_PAGES - 1)) == 0) and (not self.p_ops.pfn_valid(pfn)):
+                pfn += (self.p_ops.MAX_ORDER_NR_PAGES - 1)
+                continue;
+
+            page = self.p_ops.pfn_to_page(pfn)
+            page_ext = self.page_ext_get(page)
+            if page_ext == gdb.Value(0):
+                pfn += 1
+                continue
+
+            if not (page_ext['flags'] & (1 << PAGE_EXT_OWNER)):
+                pfn += 1
+                continue
+            if not (page_ext['flags'] & (1 << PAGE_EXT_OWNER_ALLOCATED)):
+                pfn += 1
+                continue
+
+            try:
+                page_owner = self.get_page_owner(page_ext)
+                gdb.write("Page allocated via order %d, gfp_mask: 0x%x, pid: %d, tgid: %d (%s), ts %u ns, free_ts %u ns\n" %\
+                        (page_owner["order"], page_owner["gfp_mask"],\
+                        page_owner["pid"], page_owner["tgid"], page_owner["comm"],\
+                        page_owner["ts_nsec"], page_owner["free_ts_nsec"]))
+                gdb.write("PFN: %d, Flags: 0x%x\n" % (pfn, page['flags']))
+                stackdepot.stack_depot_print(page_owner["handle"])
+                pfn += (1 << page_owner["order"])
+                continue
+            except:
+                gdb.write("\n")
+            pfn += 1
+
+DumpPageOwner()
--- a/scripts/gdb/vmlinux-gdb.py~scripts-gdb-page_owner-add-page-owner-support
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -46,3 +46,4 @@ else:
     import linux.interrupts
     import linux.mm
     import linux.stackdepot
+    import linux.page_owner
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are

scripts-gdb-symbols-add-specific-ko-module-load-command.patch
scripts-gdb-modules-add-get-module-text-support.patch
scripts-gdb-utils-add-common-type-usage.patch
scripts-gdb-aarch64-add-aarch64-page-operation-helper-commands-and-configs.patch
scripts-gdb-stackdepot-add-stackdepot-support.patch
scripts-gdb-page_owner-add-page-owner-support.patch
scripts-gdb-slab-add-slab-support.patch
scripts-gdb-vmalloc-add-vmallocinfo-support.patch

