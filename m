Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D29EB64DD
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jul 2023 18:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjGYSkI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jul 2023 14:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjGYSkB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2023 14:40:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E54C2129
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 11:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 889E261844
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 18:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC05DC433C7;
        Tue, 25 Jul 2023 18:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690310398;
        bh=FuXeuud9kzpvhyzpkd4ox97RwkQDSyL3gOSR0+PE+xc=;
        h=Date:To:From:Subject:From;
        b=tK8wHXwdb6150QrxTDPTW7c+YcnYXwbc/QUhHr2Hqw60E+Mrk4TGxP3qZeGpJte9I
         NjkcKzMafeXSVpYBAgW6E78d0QqxxbT5BnJbnrTinpD9CWY55YL0KSvAd7X0mxcjXd
         Cevkp/vrjMvAKTzyTfXzJeMyxCWU8ws1BPIxhCzI=
Date:   Tue, 25 Jul 2023 11:39:57 -0700
To:     mm-commits@vger.kernel.org, qun-wei.lin@mediatek.com,
        matthias.bgg@gmail.com, chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-stackdepot-add-stackdepot-support.patch added to mm-nonmm-unstable branch
Message-Id: <20230725183957.DC05DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb/stackdepot: add stackdepot support
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-stackdepot-add-stackdepot-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-stackdepot-add-stackdepot-support.patch

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
Subject: scripts/gdb/stackdepot: add stackdepot support
Date: Tue, 25 Jul 2023 17:34:55 +0800

Add support for printing the backtrace of stackdepot handle.

This is the preparation patch for dumping page_owner,
slabtrace usage.

Link: https://lkml.kernel.org/r/20230725093458.30064-6-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/constants.py.in |    1 
 scripts/gdb/linux/stackdepot.py   |   54 ++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py        |    1 
 3 files changed, 56 insertions(+)

--- a/scripts/gdb/linux/constants.py.in~scripts-gdb-stackdepot-add-stackdepot-support
+++ a/scripts/gdb/linux/constants.py.in
@@ -133,3 +133,4 @@ LX_CONFIG(CONFIG_VMAP_STACK)
 if IS_BUILTIN(CONFIG_NUMA):
     LX_VALUE(CONFIG_NODES_SHIFT)
 LX_CONFIG(CONFIG_DEBUG_VIRTUAL)
+LX_CONFIG(CONFIG_STACKDEPOT)
--- /dev/null
+++ a/scripts/gdb/linux/stackdepot.py
@@ -0,0 +1,54 @@
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
+stack_record_type = utils.CachedType('struct stack_record')
+DEPOT_STACK_ALIGN = 4
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

scripts-gdb-symbols-add-specific-ko-module-load-command.patch
scripts-gdb-modules-add-get-module-text-support.patch
scripts-gdb-utils-add-common-type-usage.patch
scripts-gdb-aarch64-add-aarch64-page-operation-helper-commands-and-configs.patch
scripts-gdb-stackdepot-add-stackdepot-support.patch
scripts-gdb-page_owner-add-page-owner-support.patch
scripts-gdb-slab-add-slab-support.patch
scripts-gdb-vmalloc-add-vmallocinfo-support.patch

