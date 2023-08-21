Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 267AFEE49A8
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbjHUUrQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjHUUrJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:47:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A402B133
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:47:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAFA364B6E
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08161C433C8;
        Mon, 21 Aug 2023 20:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650822;
        bh=5pUAq10ukis+KPCg88P183A9HmiNuzFCPvBONwTbjZY=;
        h=Date:To:From:Subject:From;
        b=zMdTvhbA/MgKaHq31JFQeLmVq8kyt5BiONnOwTjlNdXMbmjx26xEbq1oL/wIA44EB
         s8LkSBgP5Ml2I4vvzA1mzjEO1GywYvKf2h6ZUj3xvTNf1J1V/U7/j9qiEglz7cG6EY
         FPIlHbeQDrZps6XbwnCkSbqQsZnTzc5wjN4MyHNs=
Date:   Mon, 21 Aug 2023 13:47:01 -0700
To:     mm-commits@vger.kernel.org, qun-wei.lin@mediatek.com,
        matthias.bgg@gmail.com, chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-stackdepot-add-stackdepot-support.patch removed from -mm tree
Message-Id: <20230821204702.08161C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb/stackdepot: add stackdepot support
has been removed from the -mm tree.  Its filename was
     scripts-gdb-stackdepot-add-stackdepot-support.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: scripts/gdb/stackdepot: add stackdepot support
Date: Tue, 8 Aug 2023 16:30:15 +0800

Add support for printing the backtrace of stackdepot handle.

This is the preparation patch for dumping page_owner,
slabtrace usage.

Link: https://lkml.kernel.org/r/20230808083020.22254-6-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/constants.py.in |    1 
 scripts/gdb/linux/stackdepot.py   |   55 ++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py        |    1 
 3 files changed, 57 insertions(+)

--- a/scripts/gdb/linux/constants.py.in~scripts-gdb-stackdepot-add-stackdepot-support
+++ a/scripts/gdb/linux/constants.py.in
@@ -128,3 +128,4 @@ LX_CONFIG(CONFIG_VMAP_STACK)
 if IS_BUILTIN(CONFIG_NUMA):
     LX_VALUE(CONFIG_NODES_SHIFT)
 LX_CONFIG(CONFIG_DEBUG_VIRTUAL)
+LX_CONFIG(CONFIG_STACKDEPOT)
--- /dev/null
+++ a/scripts/gdb/linux/stackdepot.py
@@ -0,0 +1,55 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2023 MediaTek Inc.
+#
+# Authors:
+#  Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
+#
+
+import gdb
+from linux import utils, constants
+
+if constants.LX_CONFIG_STACKDEPOT:
+    stack_record_type = utils.CachedType('struct stack_record')
+    DEPOT_STACK_ALIGN = 4
+
+def stack_depot_fetch(handle):
+    global DEPOT_STACK_ALIGN
+    global stack_record_type
+
+    stack_depot_disabled = gdb.parse_and_eval('stack_depot_disabled')
+
+    if stack_depot_disabled:
+        raise gdb.GdbError("stack_depot_disabled\n")
+
+    handle_parts_t = gdb.lookup_type("union handle_parts")
+    parts = handle.cast(handle_parts_t)
+    offset = parts['offset'] << DEPOT_STACK_ALIGN
+    pool_index_cached = gdb.parse_and_eval('pool_index')
+
+    if parts['pool_index'] > pool_index_cached:
+        gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (parts['pool_index'], pool_index_cached, handle))
+        return gdb.Value(0), 0
+
+    stack_pools = gdb.parse_and_eval('stack_pools')
+
+    try:
+        pool = stack_pools[parts['pool_index']]
+        stack = (pool + gdb.Value(offset).cast(utils.get_size_t_type())).cast(stack_record_type.get_type().pointer())
+        size = int(stack['size'].cast(utils.get_ulong_type()))
+        return stack['entries'], size
+    except Exception as e:
+        gdb.write("%s\n" % e)
+        return gdb.Value(0), 0
+
+def stack_depot_print(handle):
+    if not constants.LX_CONFIG_STACKDEPOT:
+        raise gdb.GdbError("CONFIG_STACKDEPOT is not enabled")
+
+    entries, nr_entries = stack_depot_fetch(handle)
+    if nr_entries > 0:
+        for i in range(0, nr_entries):
+            try:
+                gdb.execute("x /i 0x%x" % (int(entries[i])))
+            except Exception as e:
+                gdb.write("%s\n" % e)
--- a/scripts/gdb/vmlinux-gdb.py~scripts-gdb-stackdepot-add-stackdepot-support
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -45,3 +45,4 @@ else:
     import linux.radixtree
     import linux.interrupts
     import linux.mm
+    import linux.stackdepot
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are


