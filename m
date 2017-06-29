From: akpm@linux-foundation.org
Subject: + provide-linux-set_memoryh.patch added to -mm tree
Date: Thu, 29 Jun 2017 14:39:06 -0700
Message-ID: <5955737a.GmETiau2qWkcENG9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34906 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751896AbdF2VjH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jun 2017 17:39:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpe@ellerman.id.au, daniel@iogearbox.net, keescook@chromium.org, labbott@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: provide linux/set_memory.h
has been added to the -mm tree.  Its filename is
     provide-linux-set_memoryh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/provide-linux-set_memoryh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/provide-linux-set_memoryh.patch

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
Subject: provide linux/set_memory.h

Currently code that wants to use set_memory_ro() etc, needs to include
asm/set_memory.h, which doesn't exist on all arches.  Some code knows it
only builds on arches which have the header, other code guards the
inclusion with an #ifdef, neither is ideal.

So create linux/set_memory.h.  This always exists, so users don't need an
#ifdef just to include the header.

When CONFIG_ARCH_HAS_SET_MEMORY=y it includes asm/set_memory.h, otherwise
it provides empty non-failing implementations.

Link: http://lkml.kernel.org/r/1498717781-29151-1-git-send-email-mpe@ellerman.id.au
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/set_memory.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN /dev/null include/linux/set_memory.h
--- /dev/null
+++ a/include/linux/set_memory.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright 2017, Michael Ellerman, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation;
+ */
+#ifndef _LINUX_SET_MEMORY_H_
+#define _LINUX_SET_MEMORY_H_
+
+#ifdef CONFIG_ARCH_HAS_SET_MEMORY
+#include <asm/set_memory.h>
+#else
+static inline int set_memory_ro(unsigned long addr, int numpages) { return 0; }
+static inline int set_memory_rw(unsigned long addr, int numpages) { return 0; }
+static inline int set_memory_x(unsigned long addr,  int numpages) { return 0; }
+static inline int set_memory_nx(unsigned long addr, int numpages) { return 0; }
+#endif
+
+#endif /* _LINUX_SET_MEMORY_H_ */
_

Patches currently in -mm which might be from mpe@ellerman.id.au are

provide-linux-set_memoryh.patch
pm-hibernate-use-linux-set_memoryh.patch
module-use-linux-set_memoryh.patch
bpf-use-linux-set_memoryh.patch

