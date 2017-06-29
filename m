From: akpm@linux-foundation.org
Subject: + bpf-use-linux-set_memoryh.patch added to -mm tree
Date: Thu, 29 Jun 2017 14:39:12 -0700
Message-ID: <59557380.NzazNujCFj93fckV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34938 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753095AbdF2VjN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jun 2017 17:39:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpe@ellerman.id.au, daniel@iogearbox.net, keescook@chromium.org, labbott@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/filter.h: use linux/set_memory.h
has been added to the -mm tree.  Its filename is
     bpf-use-linux-set_memoryh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bpf-use-linux-set_memoryh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bpf-use-linux-set_memoryh.patch

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
Subject: include/linux/filter.h: use linux/set_memory.h

This header always exists, so doesn't require an ifdef around its
inclusion.  When CONFIG_ARCH_HAS_SET_MEMORY=y it includes the asm header,
otherwise it provides empty versions of the set_memory_xx() routines.

Link: http://lkml.kernel.org/r/1498717781-29151-4-git-send-email-mpe@ellerman.id.au
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>
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
