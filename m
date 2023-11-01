Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D182C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348060AbjKATrw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348066AbjKATrp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:47:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418AF123
        for <mm-commits@vger.kernel.org>; Wed,  1 Nov 2023 12:47:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3C7C433C7;
        Wed,  1 Nov 2023 19:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698868056;
        bh=Q9Pnf0VSXpYpspmholAmV4CAtCPYAhR8NBWI+TVvbd0=;
        h=Date:To:From:Subject:From;
        b=tO9HukFROstdWLEVO0mK+hvp+wojbCAAVbI0SyoOI+NVUck4v68Q2cscwpkXEnvd/
         1s06s72QGIwk+4hEe/LOc6DBggR9Ham3qC17AmC+4tUS3WrRl1WWjwVC9icKBowCU1
         8uYhVGQ6yalRMb8gZKrbb9+wXC97lcsXHcblqu0M=
Date:   Wed, 01 Nov 2023 12:47:35 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        mcgrof@kernel.org, kbingham@kernel.org, jan.kiszka@siemens.com,
        da.gomez@samsung.com, cleger@rivosinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-fix-usage-of-mod_text-not-defined-when-config_modules=n.patch removed from -mm tree
Message-Id: <20231101194736.0B3C7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: fix usage of MOD_TEXT not defined when CONFIG_MODULES=n
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-usage-of-mod_text-not-defined-when-config_modules=n.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Clément Léger <cleger@rivosinc.com>
Subject: scripts/gdb: fix usage of MOD_TEXT not defined when CONFIG_MODULES=n
Date: Tue, 31 Oct 2023 13:49:04 +0000

MOD_TEXT is only defined if CONFIG_MODULES=y which lead to loading failure
of the gdb scripts when kernel is built without CONFIG_MODULES=y:

Reading symbols from vmlinux...
Traceback (most recent call last):
  File "/foo/vmlinux-gdb.py", line 25, in <module>
    import linux.constants
  File "/foo/scripts/gdb/linux/constants.py", line 14, in <module>
    LX_MOD_TEXT = gdb.parse_and_eval("MOD_TEXT")
                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
gdb.error: No symbol "MOD_TEXT" in current context.

Add a conditional check on CONFIG_MODULES to fix this error.

Link: https://lkml.kernel.org/r/20231031134848.119391-1-da.gomez@samsung.com
Fixes: b4aff7513df3 ("scripts/gdb: use mem instead of core_layout to get the module address")
Signed-off-by: Clément Léger <cleger@rivosinc.com>
Tested-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/constants.py.in |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/scripts/gdb/linux/constants.py.in~scripts-gdb-fix-usage-of-mod_text-not-defined-when-config_modules=n
+++ a/scripts/gdb/linux/constants.py.in
@@ -66,10 +66,11 @@ LX_GDBPARSED(IRQD_LEVEL)
 LX_GDBPARSED(IRQ_HIDDEN)
 
 /* linux/module.h */
-LX_GDBPARSED(MOD_TEXT)
-LX_GDBPARSED(MOD_DATA)
-LX_GDBPARSED(MOD_RODATA)
-LX_GDBPARSED(MOD_RO_AFTER_INIT)
+if IS_BUILTIN(CONFIG_MODULES):
+    LX_GDBPARSED(MOD_TEXT)
+    LX_GDBPARSED(MOD_DATA)
+    LX_GDBPARSED(MOD_RODATA)
+    LX_GDBPARSED(MOD_RO_AFTER_INIT)
 
 /* linux/mount.h */
 LX_VALUE(MNT_NOSUID)
_

Patches currently in -mm which might be from cleger@rivosinc.com are


