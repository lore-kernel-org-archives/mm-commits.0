Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B21C00528
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 18:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbjHASbb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 14:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjHASb3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 14:31:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A010D269D
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 11:31:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DA2361682
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 18:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D7EC433C8;
        Tue,  1 Aug 2023 18:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690914686;
        bh=OnIevKLkDFB6SW0M/XJleP+aYvUlRzgZauaRLwrewIc=;
        h=Date:To:From:Subject:From;
        b=QvDJ+2mOdFCE285vzFARN7HNT+tofeWb+xBvq84RXksU1goukTUMC4CYY3kmDZ+60
         LpdRb7lI86RIwm2kS3qlfZ/Z5fUEQ5Ja6BmNnLMUASDRxfHNExGQLGVCNeCUnIhL6G
         TPhX8K1gCxJyz36O1vWa3iSBUBxH73T5kMUfYoGI=
Date:   Tue, 01 Aug 2023 11:31:25 -0700
To:     mm-commits@vger.kernel.org, kbingham@kernel.org,
        jan.kiszka@siemens.com, koudai@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-lx-symbols-command-for-arm64-llvm.patch added to mm-nonmm-unstable branch
Message-Id: <20230801183126.71D7EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix lx-symbols command for arm64 LLVM
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-fix-lx-symbols-command-for-arm64-llvm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-lx-symbols-command-for-arm64-llvm.patch

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

scripts-gdb-fix-lx-symbols-command-for-arm64-llvm.patch

