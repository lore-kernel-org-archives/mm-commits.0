From: akpm@linux-foundation.org
Subject: [merged] mm-gupc-further-document-vma_permits_fault.patch
 removed from -mm tree
Date: Tue, 02 Jun 2020 14:40:00 -0700
Message-ID: <20200602214000.4IOagRSgD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgFBVkA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:40:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miles.chen@mediatek.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: further document vma_permits_fault()
has been removed from the -mm tree.  Its filename was
     mm-gupc-further-document-vma_permits_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miles Chen <miles.chen@mediatek.com>
Subject: mm/gup.c: further document vma_permits_fault()

Describe the caller's responsibilities when passing
FAULT_FLAG_ALLOW_RETRY.

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
