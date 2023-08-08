Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2997BC04A6A
	for <mm-commits@archiver.kernel.org>; Tue,  8 Aug 2023 20:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbjHHUAp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Aug 2023 16:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbjHHUAc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Aug 2023 16:00:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D479B7A0D2
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 11:16:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BB5E629AB
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 18:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B37C433C7;
        Tue,  8 Aug 2023 18:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691518591;
        bh=w65WO8cBJZhMcHMUj7Lee0U2MrR8WK5+zX27wQ5+GR8=;
        h=Date:To:From:Subject:From;
        b=cucHI0Xr+enR4WqTgmJlrOF5dgGtdjfjniZqXBUP8Rfniz8GwB8S497l/3KnKJjQg
         ErT+InSMtjTjyBukiQYdmfsf9356aUK/6QuRSx7WgA0qGbfnyTqTBRk2rAI49Zhm0/
         BF7O5OqbtX6YzLjRY+MiVwhmF19K5AFll049+idY=
Date:   Tue, 08 Aug 2023 11:16:31 -0700
To:     mm-commits@vger.kernel.org, qun-wei.lin@mediatek.com,
        matthias.bgg@gmail.com, chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-symbols-add-specific-ko-module-load-command.patch added to mm-nonmm-unstable branch
Message-Id: <20230808181631.C4B37C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb/symbols: add specific ko module load command
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-symbols-add-specific-ko-module-load-command.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-symbols-add-specific-ko-module-load-command.patch

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
Subject: scripts/gdb/symbols: add specific ko module load command
Date: Tue, 8 Aug 2023 16:30:11 +0800

Patch series "Add GDB memory helper commands", v2.

I've created some GDB commands I think useful when I debug some memory
issues and kernel module issue.

For memory issue, we would like to get slabinfo, slabtrace, page_owner and
vmallocinfo to debug the memory issues.

For module issue, we would like to query kernel module name when we get a
module text address and load module symbol by specific path.

Patch 1-2:
 - Add kernel module related command.
Patch 3-5:
 - Prepares for the memory-related command.
Patch 6-8:
 - Add memory-related commands.


This patch (of 8):

Add lx-symbols <ko_path> command to support add specific
ko module.

Example output like below:
(gdb) lx-symbols mm/kasan/kasan_test.ko
loading @0xffff800002d30000: mm/kasan/kasan_test.ko

Link: https://lkml.kernel.org/r/20230808083020.22254-1-Kuan-Ying.Lee@mediatek.com
Link: https://lkml.kernel.org/r/20230808083020.22254-2-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/scripts/gdb/linux/symbols.py~scripts-gdb-symbols-add-specific-ko-module-load-command
+++ a/scripts/gdb/linux/symbols.py
@@ -111,11 +111,12 @@ lx-symbols command."""
         return "{textaddr} {sections}".format(
             textaddr=textaddr, sections="".join(args))
 
-    def load_module_symbols(self, module):
+    def load_module_symbols(self, module, module_file=None):
         module_name = module['name'].string()
         module_addr = str(module['mem'][constants.LX_MOD_TEXT]['base']).split()[0]
 
-        module_file = self._get_module_file(module_name)
+        if not module_file:
+            module_file = self._get_module_file(module_name)
         if not module_file and not self.module_files_updated:
             self._update_module_files()
             module_file = self._get_module_file(module_name)
@@ -138,6 +139,19 @@ lx-symbols command."""
         else:
             gdb.write("no module object found for '{0}'\n".format(module_name))
 
+    def load_ko_symbols(self, mod_path):
+        self.loaded_modules = []
+        module_list = modules.module_list()
+
+        for module in module_list:
+            module_name = module['name'].string()
+            module_pattern = ".*/{0}\.ko(?:.debug)?$".format(
+                module_name.replace("_", r"[_\-]"))
+            if re.match(module_pattern, mod_path) and os.path.exists(mod_path):
+                self.load_module_symbols(module, mod_path)
+                return
+        raise gdb.GdbError("%s is not a valid .ko\n" % mod_path)
+
     def load_all_symbols(self):
         gdb.write("loading vmlinux\n")
 
@@ -176,6 +190,11 @@ lx-symbols command."""
         self.module_files = []
         self.module_files_updated = False
 
+        argv = gdb.string_to_argv(arg)
+        if len(argv) == 1:
+            self.load_ko_symbols(argv[0])
+            return
+
         self.load_all_symbols()
 
         if hasattr(gdb, 'Breakpoint'):
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are

scripts-gdb-fix-lx-lsmod-show-the-wrong-size.patch
scripts-gdb-symbols-add-specific-ko-module-load-command.patch
scripts-gdb-modules-add-get-module-text-support.patch
scripts-gdb-utils-add-common-type-usage.patch
scripts-gdb-aarch64-add-aarch64-page-operation-helper-commands-and-configs.patch
scripts-gdb-stackdepot-add-stackdepot-support.patch
scripts-gdb-page_owner-add-page-owner-support.patch
scripts-gdb-slab-add-slab-support.patch
scripts-gdb-vmalloc-add-vmallocinfo-support.patch

