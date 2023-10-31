Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD029C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 31 Oct 2023 15:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbjJaPKO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Oct 2023 11:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbjJaPKO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Oct 2023 11:10:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C65D9F
        for <mm-commits@vger.kernel.org>; Tue, 31 Oct 2023 08:10:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1147EC433C8;
        Tue, 31 Oct 2023 15:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698765011;
        bh=NhG4/pn+WAyHidUumJRPcoVfC8ks5A0aXb36U7zxKmE=;
        h=Date:To:From:Subject:From;
        b=HE98HW7dNScCBxHPSthkpCTPK4RUzUJBjlG3ROYSLFAu/NCDqpYSqZH3nm19xl+4A
         AVcSQCPYPdWVx7FKrJZKjf1qcHEfitxUa/+sqiDD98cNRALCIU93HPv+WHVo3Kx9x3
         0mgEe2kv+rDSe641FPdCM5egtapOhXI1ykBoy7/8=
Date:   Tue, 31 Oct 2023 08:10:10 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        mcgrof@kernel.org, kbingham@kernel.org, jan.kiszka@siemens.com,
        da.gomez@samsung.com, cleger@rivosinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-usage-of-mod_text-not-defined-when-config_modules=n.patch added to mm-nonmm-unstable branch
Message-Id: <20231031151011.1147EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix usage of MOD_TEXT not defined when CONFIG_MODULES=n
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-fix-usage-of-mod_text-not-defined-when-config_modules=n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-usage-of-mod_text-not-defined-when-config_modules=n.patch

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

scripts-gdb-fix-usage-of-mod_text-not-defined-when-config_modules=n.patch

