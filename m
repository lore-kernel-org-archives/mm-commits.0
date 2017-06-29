From: akpm@linux-foundation.org
Subject: + module-use-linux-set_memoryh.patch added to -mm tree
Date: Thu, 29 Jun 2017 14:39:10 -0700
Message-ID: <5955737e.+B9NyB+b7WQid2xS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34924 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751896AbdF2VjL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jun 2017 17:39:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpe@ellerman.id.au, daniel@iogearbox.net, keescook@chromium.org, labbott@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/module.c: use linux/set_memory.h
has been added to the -mm tree.  Its filename is
     module-use-linux-set_memoryh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/module-use-linux-set_memoryh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/module-use-linux-set_memoryh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: kernel/module.c: use linux/set_memory.h

This header always exists, so doesn't require an ifdef around its
inclusion.  When CONFIG_ARCH_HAS_SET_MEMORY=y it includes the asm header,
otherwise it provides empty versions of the set_memory_xx() routines.

The usages of set_memory_xx() are still guarded by
CONFIG_STRICT_MODULE_RWX.

Link: http://lkml.kernel.org/r/1498717781-29151-3-git-send-email-mpe@ellerman.id.au
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/module.c~module-use-linux-set_memoryh kernel/module.c
--- a/kernel/module.c~module-use-linux-set_memoryh
+++ a/kernel/module.c
@@ -49,9 +49,7 @@
 #include <linux/rculist.h>
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
-#ifdef CONFIG_STRICT_MODULE_RWX
-#include <asm/set_memory.h>
-#endif
+#include <linux/set_memory.h>
 #include <asm/mmu_context.h>
 #include <linux/license.h>
 #include <asm/sections.h>
_

Patches currently in -mm which might be from mpe@ellerman.id.au are

provide-linux-set_memoryh.patch
pm-hibernate-use-linux-set_memoryh.patch
module-use-linux-set_memoryh.patch
bpf-use-linux-set_memoryh.patch

