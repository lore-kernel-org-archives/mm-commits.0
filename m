Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49771CA0EF1
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 16:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbjILQYJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Sep 2023 12:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236718AbjILQYH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Sep 2023 12:24:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E9210EB
        for <mm-commits@vger.kernel.org>; Tue, 12 Sep 2023 09:24:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5585C433C8;
        Tue, 12 Sep 2023 16:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694535843;
        bh=wX9LaYSvQS7jxybgIbZjEZcTYlruHdIUL2BXedh8xmY=;
        h=Date:To:From:Subject:From;
        b=j/Y5JreMGCdJFwqbfudta0ap7yKKULJbWEWjZZIONS4FzPBNZru0mDO6GNereHiYb
         ch+tnT6MXSHvRpUO++k51HDWX/WlSZOvpcNdr+ze+31wS+uQacTqBFoNI02fe1p89y
         BNik3KAPRD1gxSEaPitnAdb0EFqwY1wHv4hS1VSU=
Date:   Tue, 12 Sep 2023 09:24:03 -0700
To:     mm-commits@vger.kernel.org, qun-wei.lin@mediatek.com,
        matthias.bgg@gmail.com, Kuan-Ying.Lee@mediatek.com,
        kbingham@kernel.org, johannes@sipsolutions.net,
        jan.kiszka@siemens.com, chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-scripts-gdb-symbols-add-specific-ko-module-load-command.patch added to mm-hotfixes-unstable branch
Message-Id: <20230912162403.B5585C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: revert "scripts/gdb/symbols: add specific ko module load command"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-scripts-gdb-symbols-add-specific-ko-module-load-command.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-scripts-gdb-symbols-add-specific-ko-module-load-command.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "scripts/gdb/symbols: add specific ko module load command"
Date: Tue Sep 12 09:19:10 AM PDT 2023

Revert 11f956538c07 ("scripts/gdb/symbols: add specific ko module load
command") due to breakage identified by Johannes Berg in [1].

Fixes: 11f956538c07 ("scripts/gdb/symbols: add specific ko module load command")
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Closes: https://lkml.kernel.org/r/c44b748307a074d0c250002cdcfe209b8cce93c9.camel@sipsolutions.net [1]
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |   23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

--- a/scripts/gdb/linux/symbols.py~revert-scripts-gdb-symbols-add-specific-ko-module-load-command
+++ a/scripts/gdb/linux/symbols.py
@@ -111,12 +111,11 @@ lx-symbols command."""
         return "{textaddr} {sections}".format(
             textaddr=textaddr, sections="".join(args))
 
-    def load_module_symbols(self, module, module_file=None):
+    def load_module_symbols(self, module):
         module_name = module['name'].string()
         module_addr = str(module['mem'][constants.LX_MOD_TEXT]['base']).split()[0]
 
-        if not module_file:
-            module_file = self._get_module_file(module_name)
+        module_file = self._get_module_file(module_name)
         if not module_file and not self.module_files_updated:
             self._update_module_files()
             module_file = self._get_module_file(module_name)
@@ -139,19 +138,6 @@ lx-symbols command."""
         else:
             gdb.write("no module object found for '{0}'\n".format(module_name))
 
-    def load_ko_symbols(self, mod_path):
-        self.loaded_modules = []
-        module_list = modules.module_list()
-
-        for module in module_list:
-            module_name = module['name'].string()
-            module_pattern = ".*/{0}\.ko(?:.debug)?$".format(
-                module_name.replace("_", r"[_\-]"))
-            if re.match(module_pattern, mod_path) and os.path.exists(mod_path):
-                self.load_module_symbols(module, mod_path)
-                return
-        raise gdb.GdbError("%s is not a valid .ko\n" % mod_path)
-
     def load_all_symbols(self):
         gdb.write("loading vmlinux\n")
 
@@ -190,11 +176,6 @@ lx-symbols command."""
         self.module_files = []
         self.module_files_updated = False
 
-        argv = gdb.string_to_argv(arg)
-        if len(argv) == 1:
-            self.load_ko_symbols(argv[0])
-            return
-
         self.load_all_symbols()
 
         if hasattr(gdb, 'Breakpoint'):
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
revert-scripts-gdb-symbols-add-specific-ko-module-load-command.patch

