Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF94C0015E
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjHLWGP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbjHLWFy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9679D1732
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35AED620D7
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD1DC433C9;
        Sat, 12 Aug 2023 22:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877955;
        bh=bjZglSOgo3ZaRp6aH/fqce5fvQ088TTOl7Ojpn2LnGU=;
        h=Date:To:From:Subject:From;
        b=tV6u4JpV25YV8UKIAumDeviJqBy0QkmYaGfW7sgETaRxsU1gyrUcV7OB7WGEYC21E
         PcnaK2XrIjIezzn2bgcs5r5LpQ9AGqPoJ3du6rSTuelYvtIzIrUP41nEXGruYcbYF1
         /XhqJG46Gr2d5wP2OT5ufcdyPBrMGykeSsgign3s=
Date:   Sat, 12 Aug 2023 15:05:55 -0700
To:     mm-commits@vger.kernel.org, kbingham@kernel.org,
        jan.kiszka@siemens.com, koudai@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-fix-lx-symbols-command-for-arm64-llvm.patch removed from -mm tree
Message-Id: <20230812220555.8AD1DC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: fix lx-symbols command for arm64 LLVM
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-lx-symbols-command-for-arm64-llvm.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Koudai Iwahori <koudai@google.com>
Subject: scripts/gdb: fix lx-symbols command for arm64 LLVM
Date: Tue, 1 Aug 2023 05:10:52 -0700

lx-symbols assumes that module's .text sections is located at
`module->mem[MOD_TEXT].base` and passes it to add-symbol-file command. 
However, .text section follows after .plt section in modules built by LLVM
toolchain for arm64 target.  Symbol addresses are skewed in GDB.

Fix this issue by using the address of .text section stored in
`module->sect_attrs`.

Link: https://lkml.kernel.org/r/20230801121052.2475183-1-koudai@google.com
Signed-off-by: Koudai Iwahori <koudai@google.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/scripts/gdb/linux/symbols.py~scripts-gdb-fix-lx-symbols-command-for-arm64-llvm
+++ a/scripts/gdb/linux/symbols.py
@@ -89,23 +89,27 @@ lx-symbols command."""
                 return name
         return None
 
-    def _section_arguments(self, module):
+    def _section_arguments(self, module, module_addr):
         try:
             sect_attrs = module['sect_attrs'].dereference()
         except gdb.error:
-            return ""
+            return str(module_addr)
+
         attrs = sect_attrs['attrs']
         section_name_to_address = {
             attrs[n]['battr']['attr']['name'].string(): attrs[n]['address']
             for n in range(int(sect_attrs['nsections']))}
+
+        textaddr = section_name_to_address.get(".text", module_addr)
         args = []
         for section_name in [".data", ".data..read_mostly", ".rodata", ".bss",
-                             ".text", ".text.hot", ".text.unlikely"]:
+                             ".text.hot", ".text.unlikely"]:
             address = section_name_to_address.get(section_name)
             if address:
                 args.append(" -s {name} {addr}".format(
                     name=section_name, addr=str(address)))
-        return "".join(args)
+        return "{textaddr} {sections}".format(
+            textaddr=textaddr, sections="".join(args))
 
     def load_module_symbols(self, module):
         module_name = module['name'].string()
@@ -125,10 +129,9 @@ lx-symbols command."""
                 module_addr = hex(int(module_addr, 0) + plt_offset + plt_size)
             gdb.write("loading @{addr}: {filename}\n".format(
                 addr=module_addr, filename=module_file))
-            cmdline = "add-symbol-file {filename} {addr}{sections}".format(
+            cmdline = "add-symbol-file {filename} {sections}".format(
                 filename=module_file,
-                addr=module_addr,
-                sections=self._section_arguments(module))
+                sections=self._section_arguments(module, module_addr))
             gdb.execute(cmdline, to_string=True)
             if module_name not in self.loaded_modules:
                 self.loaded_modules.append(module_name)
_

Patches currently in -mm which might be from koudai@google.com are


