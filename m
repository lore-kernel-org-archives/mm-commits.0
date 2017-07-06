From: akpm@linux-foundation.org
Subject: [patch 013/108] include/linux/filter.h: use
 linux/set_memory.h
Date: Thu, 06 Jul 2017 15:36:01 -0700
Message-ID: <20170706223601.zxlHEMgZV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34448 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752658AbdGFWgC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:36:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel@iogearbox.net, keescook@chromium.org, labbott@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, torvalds@linux-foundation.org

From: Michael Ellerman <mpe@ellerman.id.au>
Subject: include/linux/filter.h: use linux/set_memory.h

This header always exists, so doesn't require an ifdef around its
inclusion.  When CONFIG_ARCH_HAS_SET_MEMORY=y it includes the asm header,
otherwise it provides empty versions of the set_memory_xx() routines.

Link: http://lkml.kernel.org/r/1498717781-29151-4-git-send-email-mpe@ellerman.id.au
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/filter.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN include/linux/filter.h~bpf-use-linux-set_memoryh include/linux/filter.h
--- a/include/linux/filter.h~bpf-use-linux-set_memoryh
+++ a/include/linux/filter.h
@@ -16,13 +16,10 @@
 #include <linux/sched.h>
 #include <linux/capability.h>
 #include <linux/cryptohash.h>
+#include <linux/set_memory.h>
 
 #include <net/sch_generic.h>
 
-#ifdef CONFIG_ARCH_HAS_SET_MEMORY
-#include <asm/set_memory.h>
-#endif
