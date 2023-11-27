Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053F0C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 18:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjK0St4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 13:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjK0Sty (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 13:49:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3F4D4C
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 10:50:00 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC0DC433C8;
        Mon, 27 Nov 2023 18:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701111000;
        bh=0Pmvs3nhFaQlLKGQxy5zzTne7je7EpAYJvEcCuxCu7k=;
        h=Date:To:From:Subject:From;
        b=jXXMp/eKhs8eTt4EbPzrDr2CqXIXhyCtWVvj5fOLVQHVtjaNRGJSfZ4BFdCT2u8wA
         sY8v0HnivXcdzgLFhQe9n7swtshif2DVenOirkdgi3Dxdt3hx+Fku4LJP7Oo3H/SyU
         Qfu4la6EPoEllm3ZVTOqDZAnaEqs4iPIr1piWs7w=
Date:   Mon, 27 Nov 2023 10:49:59 -0800
To:     mm-commits@vger.kernel.org, qun-wei.lin@mediatek.com,
        oleg@redhat.com, matthias.bgg@gmail.com,
        chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com, andreyknvl@google.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-remove-exception-handling-and-refine-print-format.patch added to mm-nonmm-unstable branch
Message-Id: <20231127185000.1AC0DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: remove exception handling and refine print format
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-remove-exception-handling-and-refine-print-format.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-remove-exception-handling-and-refine-print-format.patch

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
Subject: scripts/gdb: remove exception handling and refine print format
Date: Mon, 27 Nov 2023 15:04:03 +0800

1. When we crash on a page, we want to check what happened on this
   page instead of skipping this page by try-except block.  Thus, removing
   the try-except block.

2. Remove redundant comma and print the task name properly.

Link: https://lkml.kernel.org/r/20231127070404.4192-4-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/page_owner.py |   60 +++++++++++++-----------------
 scripts/gdb/linux/slab.py       |    3 -
 2 files changed, 27 insertions(+), 36 deletions(-)

--- a/scripts/gdb/linux/page_owner.py~scripts-gdb-remove-exception-handling-and-refine-print-format
+++ a/scripts/gdb/linux/page_owner.py
@@ -122,27 +122,24 @@ class DumpPageOwner(gdb.Command):
         if not (page_ext['flags'] & (1 << PAGE_EXT_OWNER_ALLOCATED)):
             gdb.write("page_owner is not allocated\n")
 
-        try:
-            page_owner = self.get_page_owner(page_ext)
-            gdb.write("Page last allocated via order %d, gfp_mask: 0x%x, pid: %d, tgid: %d (%s), ts %u ns, free_ts %u ns\n" %\
-                    (page_owner["order"], page_owner["gfp_mask"],\
-                    page_owner["pid"], page_owner["tgid"], page_owner["comm"],\
-                    page_owner["ts_nsec"], page_owner["free_ts_nsec"]))
-            gdb.write("PFN: %d, Flags: 0x%x\n" % (pfn, page['flags']))
-            if page_owner["handle"] == 0:
-                gdb.write('page_owner allocation stack trace missing\n')
-            else:
-                stackdepot.stack_depot_print(page_owner["handle"])
-
-            if page_owner["free_handle"] == 0:
-                gdb.write('page_owner free stack trace missing\n')
-            else:
-                gdb.write('page last free stack trace:\n')
-                stackdepot.stack_depot_print(page_owner["free_handle"])
-            if page_owner['last_migrate_reason'] != -1:
-                gdb.write('page has been migrated, last migrate reason: %s\n' % self.migrate_reason_names[page_owner['last_migrate_reason']])
-        except:
-            gdb.write("\n")
+        page_owner = self.get_page_owner(page_ext)
+        gdb.write("Page last allocated via order %d, gfp_mask: 0x%x, pid: %d, tgid: %d (%s), ts %u ns, free_ts %u ns\n" %\
+                (page_owner["order"], page_owner["gfp_mask"],\
+                page_owner["pid"], page_owner["tgid"], page_owner["comm"].string(),\
+                page_owner["ts_nsec"], page_owner["free_ts_nsec"]))
+        gdb.write("PFN: %d, Flags: 0x%x\n" % (pfn, page['flags']))
+        if page_owner["handle"] == 0:
+            gdb.write('page_owner allocation stack trace missing\n')
+        else:
+            stackdepot.stack_depot_print(page_owner["handle"])
+
+        if page_owner["free_handle"] == 0:
+            gdb.write('page_owner free stack trace missing\n')
+        else:
+            gdb.write('page last free stack trace:\n')
+            stackdepot.stack_depot_print(page_owner["free_handle"])
+        if page_owner['last_migrate_reason'] != -1:
+            gdb.write('page has been migrated, last migrate reason: %s\n' % self.migrate_reason_names[page_owner['last_migrate_reason']])
 
     def read_page_owner(self):
         pfn = self.min_pfn
@@ -173,18 +170,13 @@ class DumpPageOwner(gdb.Command):
                 pfn += 1
                 continue
 
-            try:
-                page_owner = self.get_page_owner(page_ext)
-                gdb.write("Page allocated via order %d, gfp_mask: 0x%x, pid: %d, tgid: %d (%s), ts %u ns, free_ts %u ns\n" %\
-                        (page_owner["order"], page_owner["gfp_mask"],\
-                        page_owner["pid"], page_owner["tgid"], page_owner["comm"],\
-                        page_owner["ts_nsec"], page_owner["free_ts_nsec"]))
-                gdb.write("PFN: %d, Flags: 0x%x\n" % (pfn, page['flags']))
-                stackdepot.stack_depot_print(page_owner["handle"])
-                pfn += (1 << page_owner["order"])
-                continue
-            except:
-                gdb.write("\n")
-            pfn += 1
+            page_owner = self.get_page_owner(page_ext)
+            gdb.write("Page allocated via order %d, gfp_mask: 0x%x, pid: %d, tgid: %d (%s), ts %u ns, free_ts %u ns\n" %\
+                    (page_owner["order"], page_owner["gfp_mask"],\
+                    page_owner["pid"], page_owner["tgid"], page_owner["comm"].string(),\
+                    page_owner["ts_nsec"], page_owner["free_ts_nsec"]))
+            gdb.write("PFN: %d, Flags: 0x%x\n" % (pfn, page['flags']))
+            stackdepot.stack_depot_print(page_owner["handle"])
+            pfn += (1 << page_owner["order"])
 
 DumpPageOwner()
--- a/scripts/gdb/linux/slab.py~scripts-gdb-remove-exception-handling-and-refine-print-format
+++ a/scripts/gdb/linux/slab.py
@@ -228,8 +228,7 @@ def slabtrace(alloc, cache_name):
             nr_cpu = gdb.parse_and_eval('__num_online_cpus')['counter']
             if nr_cpu > 1:
                 gdb.write(" cpus=")
-                for i in loc['cpus']:
-                    gdb.write("%d," % i)
+                gdb.write(','.join(str(cpu) for cpu in loc['cpus']))
         gdb.write("\n")
         if constants.LX_CONFIG_STACKDEPOT:
             if loc['handle']:
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are

scripts-gdb-tasks-fix-lx-ps-command-error.patch
scripts-gdb-stackdepot-rename-pool_index_cached-to-pools_num.patch
scripts-gdb-remove-exception-handling-and-refine-print-format.patch

