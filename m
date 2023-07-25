Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C5A1C001DF
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jul 2023 18:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbjGYSjz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jul 2023 14:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjGYSjx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2023 14:39:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50259A3
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 11:39:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2B8061868
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 18:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C14C433C7;
        Tue, 25 Jul 2023 18:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690310391;
        bh=Uj+0/OSRFUkIWsvMuFmzZFr0pzNJ9eAyZmbOeLGJI28=;
        h=Date:To:From:Subject:From;
        b=0cYkMK7ni1aoUuwSV2WTbtIhzafwpQ9Kqz6gX+h2Ed2jOmFCbkSNa+fBfnCAiOts1
         V410Dj51Tf9l+OJibKjcdK7ZWevb++o10MPlBW8mJLO6XLzVady2aWC25YP821ma19
         N9t/QLR9H95XoEBnhiSAGMQN9ykgCiyrzUjBX+r8=
Date:   Tue, 25 Jul 2023 11:39:50 -0700
To:     mm-commits@vger.kernel.org, qun-wei.lin@mediatek.com,
        matthias.bgg@gmail.com, chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-modules-add-get-module-text-support.patch added to mm-nonmm-unstable branch
Message-Id: <20230725183951.46C14C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb/modules: add get module text support
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-modules-add-get-module-text-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-modules-add-get-module-text-support.patch

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
Subject: scripts/gdb/modules: add get module text support
Date: Tue, 25 Jul 2023 17:34:52 +0800

When we get an text address from coredump and we cannot find
this address in vmlinux, it might located in kernel module.

We want to know which kernel module it located in.

This GDB scripts can help us to find the target kernel module.

(gdb) lx-getmod-by-textaddr 0xffff800002d305ac
0xffff800002d305ac is in kasan_test.ko

Link: https://lkml.kernel.org/r/20230725093458.30064-3-Kuan-Ying.Lee@mediatek.com
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
@@ -91,5 +91,35 @@ class LxLsmod(gdb.Command):
 
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

scripts-gdb-symbols-add-specific-ko-module-load-command.patch
scripts-gdb-modules-add-get-module-text-support.patch
scripts-gdb-utils-add-common-type-usage.patch
scripts-gdb-aarch64-add-aarch64-page-operation-helper-commands-and-configs.patch
scripts-gdb-stackdepot-add-stackdepot-support.patch
scripts-gdb-page_owner-add-page-owner-support.patch
scripts-gdb-slab-add-slab-support.patch
scripts-gdb-vmalloc-add-vmallocinfo-support.patch

