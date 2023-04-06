Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB313C76196
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 22:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjDFWvt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 18:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbjDFWvr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 18:51:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955FB30FB
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 15:51:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CA1564D81
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 22:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759E5C4339B;
        Thu,  6 Apr 2023 22:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680821505;
        bh=zWTBAA/i7XeCrElpK1+MshhHI0vNlHMdQVe7JP6hqLc=;
        h=Date:To:From:Subject:From;
        b=xQQMfTaLkA8SsO8PnqwSF2SA9X766aVNTMcuB3c3uPvqLiGUODx30OXd8SNfRO0qN
         Ckb/FP//BhWVqfI6a3RaBRfAt/MEJ5+O58BddsxIK6o0iHcBgFfaWRCsoK28dRDGAH
         zL+60ApbfYJzf+scARi1dvyfeUdh85PYz8Rm2Bsg=
Date:   Thu, 06 Apr 2023 15:51:44 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, kbingham@kernel.org,
        john.ogness@linutronix.de, jan.kiszka@siemens.com,
        antonio.borneo@foss.st.com, f.fainelli@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-raise-error-with-reduced-debugging-information.patch added to mm-nonmm-unstable branch
Message-Id: <20230406225145.759E5C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: raise error with reduced debugging information
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-raise-error-with-reduced-debugging-information.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-raise-error-with-reduced-debugging-information.patch

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
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: scripts/gdb: raise error with reduced debugging information
Date: Thu, 6 Apr 2023 14:52:51 -0700

If CONFIG_DEBUG_INFO_REDUCED is enabled in the kernel configuration, we
will typically not be able to load vmlinux-gdb.py and will fail with:

Traceback (most recent call last):
  File "/home/fainelli/work/buildroot/output/arm64/build/linux-custom/vmlinux-gdb.py", line 25, in <module>
    import linux.utils
  File "/home/fainelli/work/buildroot/output/arm64/build/linux-custom/scripts/gdb/linux/utils.py", line 131, in <module>
    atomic_long_counter_offset = atomic_long_type.get_type()['counter'].bitpos
KeyError: 'counter'

Rather be left wondering what is happening only to find out that reduced
debug information is the cause, raise an eror.  This was not typically a
problem until e3c8d33e0d62 ("scripts/gdb: fix 'lx-dmesg' on 32 bits arch")
but it has since then.

Link: https://lkml.kernel.org/r/20230406215252.1580538-1-f.fainelli@gmail.com
Fixes: e3c8d33e0d62 ("scripts/gdb: fix 'lx-dmesg' on 32 bits arch")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Antonio Borneo <antonio.borneo@foss.st.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/constants.py.in |    2 ++
 scripts/gdb/vmlinux-gdb.py        |    5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/scripts/gdb/linux/constants.py.in~scripts-gdb-raise-error-with-reduced-debugging-information
+++ a/scripts/gdb/linux/constants.py.in
@@ -40,6 +40,8 @@
 
 import gdb
 
+LX_CONFIG(CONFIG_DEBUG_INFO_REDUCED)
+
 /* linux/clk-provider.h */
 if IS_BUILTIN(CONFIG_COMMON_CLK):
     LX_GDBPARSED(CLK_GET_RATE_NOCACHE)
--- a/scripts/gdb/vmlinux-gdb.py~scripts-gdb-raise-error-with-reduced-debugging-information
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -22,6 +22,10 @@ except:
     gdb.write("NOTE: gdb 7.2 or later required for Linux helper scripts to "
               "work.\n")
 else:
+    import linux.constants
+    if linux.constants.LX_CONFIG_DEBUG_INFO_REDUCED:
+        raise gdb.GdbError("Reduced debug information will prevent GDB "
+                           "from having complete types.\n")
     import linux.utils
     import linux.symbols
     import linux.modules
@@ -32,7 +36,6 @@ else:
     import linux.lists
     import linux.rbtree
     import linux.proc
-    import linux.constants
     import linux.timerlist
     import linux.clk
     import linux.genpd
_

Patches currently in -mm which might be from f.fainelli@gmail.com are

scripts-gdb-add-a-radix-tree-parser-v2.patch
scripts-gdb-raise-error-with-reduced-debugging-information.patch

