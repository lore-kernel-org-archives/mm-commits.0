From: akpm@linux-foundation.org
Subject: + mm-dont-warn-when-vmalloc-fails-due-to-a-fatal-signal.patch
 added to -mm tree
Date: Mon, 13 Mar 2017 12:34:09 -0700
Message-ID: <58c6f431.HkM4dR0VPfd+QvdR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58498 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753155AbdCMTeL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2017 15:34:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't warn when vmalloc() fails due to a fatal signal
has been added to the -mm tree.  Its filename is
     mm-dont-warn-when-vmalloc-fails-due-to-a-fatal-signal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-warn-when-vmalloc-fails-due-to-a-fatal-signal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-warn-when-vmalloc-fails-due-to-a-fatal-signal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from dvyukov@google.com are

mm-dont-warn-when-vmalloc-fails-due-to-a-fatal-signal.patch

