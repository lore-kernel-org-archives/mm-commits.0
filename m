From: akpm@linux-foundation.org
Subject: + include-linux-highmemh-needs-hardirqh.patch added to -mm tree
Date: Wed, 10 Nov 2010 07:20:01 -0800
Message-ID: <201011101522.oAAFMNii021641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756130Ab0KJPXI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Nov 2010 10:23:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com, a.p.zijlstra@chello.nl


The patch titled
     include/linux/highmem.h needs hardirq.h
has been added to the -mm tree.  Its filename is
     include-linux-highmemh-needs-hardirqh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/highmem.h needs hardirq.h
From: Catalin Marinas <catalin.marinas@arm.com>

Commit 3e4d3af ("mm: stack based kmap_atomic()") introduced the
kmap_atomic_idx_push() function which warns on in_irq() with
CONFIG_DEBUG_HIGHMEM enabled.  This patch includes linux/hardirq.h for the
in_irq definition.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/highmem.h~include-linux-highmemh-needs-hardirqh include/linux/highmem.h
--- a/include/linux/highmem.h~include-linux-highmemh-needs-hardirqh
+++ a/include/linux/highmem.h
@@ -5,6 +5,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/uaccess.h>
+#include <linux/hardirq.h>
 
 #include <asm/cacheflush.h>
 
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

include-linux-highmemh-needs-hardirqh.patch
linux-next.patch

