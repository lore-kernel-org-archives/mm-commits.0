From: akpm@linux-foundation.org
Subject: + treewide-decouple-cacheflushh-and-set_memoryh-fix.patch added
 to -mm tree
Date: Tue, 18 Apr 2017 14:37:45 -0700
Message-ID: <58f68729.KYm3MCHsVhPCBpPD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37680 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754942AbdDRVhq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2017 17:37:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes/x86: merge fix for set_memory.h decoupling
has been added to the -mm tree.  Its filename is
     treewide-decouple-cacheflushh-and-set_memoryh-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/treewide-decouple-cacheflushh-and-set_memoryh-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/treewide-decouple-cacheflushh-and-set_memoryh-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: kprobes/x86: merge fix for set_memory.h decoupling

Link: http://lkml.kernel.org/r/20170418180903.10300fd3@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kprobes/core.c |    1 +
 arch/x86/kernel/kprobes/opt.c  |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/x86/kernel/kprobes/core.c~treewide-decouple-cacheflushh-and-set_memoryh-fix arch/x86/kernel/kprobes/core.c
--- a/arch/x86/kernel/kprobes/core.c~treewide-decouple-cacheflushh-and-set_memoryh-fix
+++ a/arch/x86/kernel/kprobes/core.c
@@ -61,6 +61,7 @@
 #include <asm/alternative.h>
 #include <asm/insn.h>
 #include <asm/debugreg.h>
+#include <asm/set_memory.h>
 
 #include "common.h"
 
diff -puN arch/x86/kernel/kprobes/opt.c~treewide-decouple-cacheflushh-and-set_memoryh-fix arch/x86/kernel/kprobes/opt.c
--- a/arch/x86/kernel/kprobes/opt.c~treewide-decouple-cacheflushh-and-set_memoryh-fix
+++ a/arch/x86/kernel/kprobes/opt.c
@@ -37,6 +37,7 @@
 #include <asm/alternative.h>
 #include <asm/insn.h>
 #include <asm/debugreg.h>
+#include <asm/set_memory.h>
 
 #include "common.h"
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-introduce-kvalloc-helpers-fix.patch
treewide-decouple-cacheflushh-and-set_memoryh-fix.patch

