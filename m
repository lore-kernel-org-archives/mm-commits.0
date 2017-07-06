From: akpm@linux-foundation.org
Subject: [patch 011/108] kernel/power/snapshot.c: use
 linux/set_memory.h
Date: Thu, 06 Jul 2017 15:35:55 -0700
Message-ID: <20170706223555.3-UR3-8y4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34424 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752658AbdGFWf4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel@iogearbox.net, keescook@chromium.org, labbott@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, torvalds@linux-foundation.org

From: Michael Ellerman <mpe@ellerman.id.au>
Subject: kernel/power/snapshot.c: use linux/set_memory.h

This header always exists, so doesn't require an ifdef around its
inclusion.  When CONFIG_ARCH_HAS_SET_MEMORY=y it includes the asm header,
otherwise it provides empty versions of the set_memory_xx() routines.

Link: http://lkml.kernel.org/r/1498717781-29151-2-git-send-email-mpe@ellerman.id.au
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Laura Abbott <labbott@redhat.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/snapshot.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/power/snapshot.c~pm-hibernate-use-linux-set_memoryh kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~pm-hibernate-use-linux-set_memoryh
+++ a/kernel/power/snapshot.c
@@ -30,15 +30,13 @@
 #include <linux/slab.h>
 #include <linux/compiler.h>
 #include <linux/ktime.h>
+#include <linux/set_memory.h>
 
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/io.h>
-#ifdef CONFIG_ARCH_HAS_SET_MEMORY
-#include <asm/set_memory.h>
-#endif
 
 #include "power.h"
 
_
