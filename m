From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gupc-further-document-vma_permits_fault.patch added
 to -mm tree
Date: Tue, 14 Apr 2020 21:29:47 -0700
Message-ID: <20200415042947.QzV-D3vO0%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:32984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbgDOE3t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 00:29:49 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miles.chen@mediatek.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: further document vma_permits_fault()
has been added to the -mm tree.  Its filename is
     mm-gupc-further-document-vma_permits_fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gupc-further-document-vma_permits_fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gupc-further-document-vma_permits_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miles Chen <miles.chen@mediatek.com>
Subject: mm/gup.c: further document vma_permits_fault()

Link: http://lkml.kernel.org/r/1586915606.5647.5.camel@mtkswgap22

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-gupc-further-document-vma_permits_fault
+++ a/mm/gup.c
@@ -1176,7 +1176,8 @@ static bool vma_permits_fault(struct vm_
  * @address:	user address
  * @fault_flags:flags to pass down to handle_mm_fault()
  * @unlocked:	did we unlock the mmap_sem while retrying, maybe NULL if caller
- *		does not allow retry
+ *		does not allow retry. If NULL, the caller must guarantee
+ *		that fault_flags does not contain FAULT_FLAG_ALLOW_RETRY.
  *
  * This is meant to be called in the specific scenario where for locking reasons
  * we try to access user memory in atomic context (within a pagefault_disable()
_

Patches currently in -mm which might be from miles.chen@mediatek.com are

mm-gupc-further-document-vma_permits_fault.patch
