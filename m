From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 057/128] mm/gup.c: further document
 vma_permits_fault()
Date: Tue, 02 Jun 2020 13:13:17 -0700
Message-ID: <20200602201317.k8maBD23t%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726223AbgFBUNT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:13:19 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, miles.chen@mediatek.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
