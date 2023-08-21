Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E94DBEE49A8
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjHUUrJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjHUUrI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:47:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F41B10D
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:46:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E220464AFC
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF3CC433C7;
        Mon, 21 Aug 2023 20:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650818;
        bh=N/6BBlnqJwntOsWNaDmimIrC1mQJxXxNiSeK0EwxasQ=;
        h=Date:To:From:Subject:From;
        b=hXFiorI0JVBT65TaH+y2J4ZuZtMHYGYXmImrzx3uDeDyPZXPDKVOTzI5LlnPL44Pz
         IZ9AD6gXm4yoaxjEvuSKDf4FUU0vyuIH45g2g52ITyiM1AD3e2jjBlskVnznNRDGEM
         F7SAvkLncmQOuqVW56rPSqovyxlxDfeC9NB8QXpo=
Date:   Mon, 21 Aug 2023 13:46:57 -0700
To:     mm-commits@vger.kernel.org, qun-wei.lin@mediatek.com,
        matthias.bgg@gmail.com, chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-modules-add-get-module-text-support.patch removed from -mm tree
Message-Id: <20230821204658.3EF3CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb/modules: add get module text support
has been removed from the -mm tree.  Its filename was
     scripts-gdb-modules-add-get-module-text-support.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: scripts/gdb/modules: add get module text support
Date: Tue, 8 Aug 2023 16:30:12 +0800

When we get an text address from coredump and we cannot find
this address in vmlinux, it might located in kernel module.

We want to know which kernel module it located in.

This GDB scripts can help us to find the target kernel module.

(gdb) lx-getmod-by-textaddr 0xffff800002d305ac
0xffff800002d305ac is in kasan_test.ko

Link: https://lkml.kernel.org/r/20230808083020.22254-3-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/modules.py |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

--- a/scripts/gdb/linux/modules.py~scripts-gdb-modules-add-get-module-text-support
+++ a/scripts/gdb/linux/modules.py
@@ -97,5 +97,35 @@ class LxLsmod(gdb.Command):
 
             gdb.write("\n")
 
-
 LxLsmod()
+
+def help():
+    t = """Usage: lx-getmod-by-textaddr [Heximal Address]
+    Example: lx-getmod-by-textaddr 0xffff800002d305ac\n"""
+    gdb.write("Unrecognized command\n")
+    raise gdb.GdbError(t)
+
+class LxFindTextAddrinMod(gdb.Command):
+    '''Look up loaded kernel module by text address.'''
+
+    def __init__(self):
+        super(LxFindTextAddrinMod, self).__init__('lx-getmod-by-textaddr', gdb.COMMAND_SUPPORT)
+
+    def invoke(self, arg, from_tty):
+        args = gdb.string_to_argv(arg)
+
+        if len(args) != 1:
+            help()
+
+        addr = gdb.Value(int(args[0], 16)).cast(utils.get_ulong_type())
+        for mod in module_list():
+            mod_text_start = mod['mem'][constants.LX_MOD_TEXT]['base']
+            mod_text_end = mod_text_start + mod['mem'][constants.LX_MOD_TEXT]['size'].cast(utils.get_ulong_type())
+
+            if addr >= mod_text_start and addr < mod_text_end:
+                s = "0x%x" % addr + " is in " + mod['name'].string() + ".ko\n"
+                gdb.write(s)
+                return
+        gdb.write("0x%x is not in any module text section\n" % addr)
+
+LxFindTextAddrinMod()
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are


