From: akpm@linux-foundation.org
Subject: [merged] mm-remove-dead-code-totalram_pages_set.patch
 removed from -mm tree
Date: Fri, 31 Jan 2020 15:19:30 -0800
Message-ID: <20200131231930.49_2aMZpN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXTb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:19:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com


The patch titled
     Subject: include/linux/mm.h: remove dead code totalram_pages_set()
has been removed from the -mm tree.  Its filename was
     mm-remove-dead-code-totalram_pages_set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: include/linux/mm.h: remove dead code totalram_pages_set()

totalram_pages_set() was introduced in commit ca79b0c211af ("mm:
convert totalram_pages and totalhigh_pages variables to atomic"), but
no one uses it.

Link: http://lkml.kernel.org/r/20191218005543.24146-1-richardw.yang@linux.intel.com
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/mm.h~mm-remove-dead-code-totalram_pages_set
+++ a/include/linux/mm.h
@@ -70,11 +70,6 @@ static inline void totalram_pages_add(lo
 	atomic_long_add(count, &_totalram_pages);
 }
 
-static inline void totalram_pages_set(long val)
-{
-	atomic_long_set(&_totalram_pages, val);
-}
