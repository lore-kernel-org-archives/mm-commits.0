From: akpm@linux-foundation.org
Subject: + revert-vmalloc-back-off-when-the-current-task-is-killed.patch
 added to -mm tree
Date: Wed, 04 Oct 2017 15:32:14 -0700
Message-ID: <59d5616e.8aW+ekmDNxKdbnxZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44728 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751171AbdJDWcQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 18:32:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, alan@llwyncelyn.cymru, dvyukov@google.com, hch@lst.de, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "vmalloc: back off when the current task is killed"
has been added to the -mm tree.  Its filename is
     revert-vmalloc-back-off-when-the-current-task-is-killed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-vmalloc-back-off-when-the-current-task-is-killed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-vmalloc-back-off-when-the-current-task-is-killed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alan Cox <alan@llwyncelyn.cymru>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
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
