From: akpm@linux-foundation.org
Subject: [patch 4/6] mm: don't warn when vmalloc() fails due to a fatal
 signal
Date: Thu, 16 Mar 2017 16:40:27 -0700
Message-ID: <58cb226b.1zWVgCs8UFfoDgmW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49580 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752460AbdCQASB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 20:18:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dvyukov@google.com, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mhocko@suse.com

From: Dmitry Vyukov <dvyukov@google.com>
Subject: mm: don't warn when vmalloc() fails due to a fatal signal

When vmalloc() fails it prints a very lengthy message with all the details
about memory consumption assuming that it happened due to OOM.  However,
vmalloc() can also fail due to fatal signal pending.  In such case the
message is quite confusing because it suggests that it is OOM but the
numbers suggest otherwise.  The messages can also pollute console
considerably.

Don't warn when vmalloc() fails due to fatal signal pending.

Link: http://lkml.kernel.org/r/20170313114425.72724-1-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-dont-warn-when-vmalloc-fails-due-to-a-fatal-signal mm/vmalloc.c
--- a/mm/vmalloc.c~mm-dont-warn-when-vmalloc-fails-due-to-a-fatal-signal
+++ a/mm/vmalloc.c
@@ -1683,7 +1683,7 @@ static void *__vmalloc_area_node(struct
 
 		if (fatal_signal_pending(current)) {
 			area->nr_pages = i;
-			goto fail;
+			goto fail_no_warn;
 		}
 
 		if (node == NUMA_NO_NODE)
@@ -1709,6 +1709,7 @@ fail:
 	warn_alloc(gfp_mask, NULL,
 			  "vmalloc: allocation failure, allocated %ld of %ld bytes",
 			  (area->nr_pages*PAGE_SIZE), area->size);
+fail_no_warn:
 	vfree(area->addr);
 	return NULL;
 }
_
