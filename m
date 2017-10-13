From: akpm@linux-foundation.org
Subject: [patch 11/18] Revert "vmalloc: back off when the current task is
 killed"
Date: Fri, 13 Oct 2017 15:58:05 -0700
Message-ID: <59e144fd.dhxQDiXaPb0wYCWp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40208 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752984AbdJMW6G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 18:58:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, alan@llwyncelyn.cymru, dvyukov@google.com, hch@lst.de, mhocko@suse.com, stable@vger.kernel.org, vbabka@suse.cz

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Revert "vmalloc: back off when the current task is killed"

This reverts 5d17a73a2ebe ("vmalloc: back off when the current task is
killed") and 171012f56127 ("mm: don't warn when vmalloc() fails due to a
fatal signal").

5d17a73a2ebe ("vmalloc: back off when the current task is killed") made
all vmalloc allocations from a signal-killed task fail.  We have seen
crashes in the tty driver from this, where a killed task exiting tries to
switch back to N_TTY, fails n_tty_open because of the vmalloc failing, and
later crashes when dereferencing tty->disc_data.

Arguably, relying on a vmalloc() call to succeed in order to properly exit
a task is not the most robust way of doing things.  There will be a
follow-up patch to the tty code to fall back to the N_NULL ldisc.

But the justification to make that vmalloc() call fail like this isn't
convincing, either.  The patch mentions an OOM victim exhausting the
memory reserves and thus deadlocking the machine.  But the OOM killer is
only one, improbable source of fatal signals.  It doesn't make sense to
fail allocations preemptively with plenty of memory in most cases.

The patch doesn't mention real-life instances where vmalloc sites would
exhaust memory, which makes it sound more like a theoretical issue to
begin with.  But just in case, the OOM access to memory reserves has been
restricted on the allocator side in cd04ae1e2dc8 ("mm, oom: do not rely on
TIF_MEMDIE for memory reserves access"), which should take care of any
theoretical concerns on that front.

Revert this patch, and the follow-up that suppresses the allocation
warnings when we fail the allocations due to a signal.

Link: http://lkml.kernel.org/r/20171004185906.GB2136@cmpxchg.org
Fixes:  171012f56127 ("mm: don't warn when vmalloc() fails due to a fatal signal")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alan Cox <alan@llwyncelyn.cymru>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN mm/vmalloc.c~revert-vmalloc-back-off-when-the-current-task-is-killed mm/vmalloc.c
--- a/mm/vmalloc.c~revert-vmalloc-back-off-when-the-current-task-is-killed
+++ a/mm/vmalloc.c
@@ -1695,11 +1695,6 @@ static void *__vmalloc_area_node(struct
 	for (i = 0; i < area->nr_pages; i++) {
 		struct page *page;
 
-		if (fatal_signal_pending(current)) {
-			area->nr_pages = i;
-			goto fail_no_warn;
-		}
