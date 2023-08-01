Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF795C0015E
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 19:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjHATjI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 15:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbjHATjH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 15:39:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D53B1FF3
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 12:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0383616D0
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 19:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DFFC433C8;
        Tue,  1 Aug 2023 19:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690918745;
        bh=cSoABLQ9ajLm4azUbmmmMehJk6fb55HmVD8qHo2d0sM=;
        h=Date:To:From:Subject:From;
        b=ZDLBbmf0MPhOM6QL9++CgUenJzdtHRaWPnQHmM4HycvedbGDSwR4ZyrpdszYOF/02
         x/jfmuyhPmj1apZSIk6RZ7YQRpbsw1RDMx9Ku+fNawjRwPlIV3OWMhUwp10h/9OiS6
         6hWFIIJODVDs2svx4Qwr5ULPBag1dTTgK0p5LbNI=
Date:   Tue, 01 Aug 2023 12:39:04 -0700
To:     mm-commits@vger.kernel.org, qun-wei.lin@mediatek.com,
        p.raghav@samsung.com, mcgrof@kernel.org, matthias.bgg@gmail.com,
        kbingham@kernel.org, jan.kiszka@siemens.com,
        chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-lx-lsmod-show-the-wrong-size.patch added to mm-nonmm-unstable branch
Message-Id: <20230801193905.21DFFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix 'lx-lsmod' show the wrong size
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-fix-lx-lsmod-show-the-wrong-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-lx-lsmod-show-the-wrong-size.patch

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
Subject: scripts/gdb: fix 'lx-lsmod' show the wrong size
Date: Mon, 10 Jul 2023 17:28:46 +0800

'lsmod' shows total core layout size, so we need to sum up all the
sections in core layout in gdb scripts.

/ # lsmod
kasan_test 200704 0 - Live 0xffff80007f640000

Before patch:
(gdb) lx-lsmod
Address            Module                  Size  Used by
0xffff80007f640000 kasan_test             36864  0

After patch:
(gdb) lx-lsmod
Address            Module                  Size  Used by
0xffff80007f640000 kasan_test            200704  0

Link: https://lkml.kernel.org/r/20230710092852.31049-1-Kuan-Ying.Lee@mediatek.com
Fixes: b4aff7513df3 ("scripts/gdb: use mem instead of core_layout to get the module address")
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/constants.py.in |    3 +++
 scripts/gdb/linux/modules.py      |   12 +++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/scripts/gdb/linux/constants.py.in~scripts-gdb-fix-lx-lsmod-show-the-wrong-size
+++ a/scripts/gdb/linux/constants.py.in
@@ -64,6 +64,9 @@ LX_GDBPARSED(IRQ_HIDDEN)
 
 /* linux/module.h */
 LX_GDBPARSED(MOD_TEXT)
+LX_GDBPARSED(MOD_DATA)
+LX_GDBPARSED(MOD_RODATA)
+LX_GDBPARSED(MOD_RO_AFTER_INIT)
 
 /* linux/mount.h */
 LX_VALUE(MNT_NOSUID)
--- a/scripts/gdb/linux/modules.py~scripts-gdb-fix-lx-lsmod-show-the-wrong-size
+++ a/scripts/gdb/linux/modules.py
@@ -73,11 +73,17 @@ class LxLsmod(gdb.Command):
                 "        " if utils.get_long_type().sizeof == 8 else ""))
 
         for module in module_list():
-            layout = module['mem'][constants.LX_MOD_TEXT]
+            text = module['mem'][constants.LX_MOD_TEXT]
+            text_addr = str(text['base']).split()[0]
+            total_size = 0
+
+            for i in range(constants.LX_MOD_TEXT, constants.LX_MOD_RO_AFTER_INIT + 1):
+                total_size += module['mem'][i]['size']
+
             gdb.write("{address} {name:<19} {size:>8}  {ref}".format(
-                address=str(layout['base']).split()[0],
+                address=text_addr,
                 name=module['name'].string(),
-                size=str(layout['size']),
+                size=str(total_size),
                 ref=str(module['refcnt']['counter'] - 1)))
 
             t = self._module_use_type.get_type().pointer()
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are

scripts-gdb-fix-lx-lsmod-show-the-wrong-size.patch

