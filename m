From: akpm@linux-foundation.org
Subject: + include-linux-mmh-remove-ifdef-condition.patch added to -mm
 tree
Date: Fri, 07 Feb 2014 14:31:30 -0800
Message-ID: <52f55ec2.OUkPd8rgR3fC8eh3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaBGWbb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Feb 2014 17:31:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, riel@redhat.com, josh@joshtriplett.org, rashika.kheria@gmail.com

Subject: + include-linux-mmh-remove-ifdef-condition.patch added to -mm tree
To: rashika.kheria@gmail.com,josh@joshtriplett.org,riel@redhat.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Fri, 07 Feb 2014 14:31:30 -0800


The patch titled
     Subject: include/linux/mm.h: remove ifdef condition
has been added to the -mm tree.  Its filename is
     include-linux-mmh-remove-ifdef-condition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-mmh-remove-ifdef-condition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-mmh-remove-ifdef-condition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: include/linux/mm.h: remove ifdef condition

The ifdef conditions in include/linux/mm.h presents three cases:

- !defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) && !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID)
There is no actual definition of function but include/linux/mm.h has a
static inline stub defined.

- defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) && !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID)
linux/mm.h does not define a prototype, but mm/page_alloc.c defines
the function.
Hence, compiler reports the following warning:
mm/page_alloc.c:4300:15: warning: no previous prototype for `__early_pfn_to_nid' [-Wmissing-prototypes]

- defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID)
The architecture defines the function, and linux/mm.h has a prototype.

Thus, join the conditions of Case 2 and 3 i.e.  eliminate the ifdef
condition of CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID to eliminate the missing
prototype warning from file mm/page_alloc.c.

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/mm.h~include-linux-mmh-remove-ifdef-condition include/linux/mm.h
--- a/include/linux/mm.h~include-linux-mmh-remove-ifdef-condition
+++ a/include/linux/mm.h
@@ -1650,10 +1650,8 @@ static inline int __early_pfn_to_nid(uns
 #else
 /* please see mm/page_alloc.c */
 extern int __meminit early_pfn_to_nid(unsigned long pfn);
-#ifdef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 /* there is a per-arch backend function. */
 extern int __meminit __early_pfn_to_nid(unsigned long pfn);
-#endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 #endif
 
 extern void set_dma_reserve(unsigned long new_dma_reserve);
_

Patches currently in -mm which might be from rashika.kheria@gmail.com are

mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch

