From: akpm@linux-foundation.org
Subject: + mm-khugepaged-allow-to-interrupt-allocation-sleep-again.patch
 added to -mm tree
Date: Mon, 24 Aug 2015 13:30:50 -0700
Message-ID: <55db7efa.ICmvAnmVRe8tsBtU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbbHXUav (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Aug 2015 16:30:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, ebru.akagunduz@gmail.com, jkosina@suse.cz, kirill.shutemov@linux.intel.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: allow interruption of allocation sleep again
has been added to the -mm tree.  Its filename is
     mm-khugepaged-allow-to-interrupt-allocation-sleep-again.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-allow-to-interrupt-allocation-sleep-again.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-allow-to-interrupt-allocation-sleep-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: mm/khugepaged: allow interruption of allocation sleep again

Commit 1dfb059b9438633b0546 ("thp: reduce khugepaged freezing latency")
fixed khugepaged to do not block a system suspend.  But the result is that
it could not get interrupted before the given timeout because the
condition for the wait event is "false".

This patch puts back the original approach but it uses
freezable_schedule_timeout_interruptible() instead of
schedule_timeout_interruptible().  It does the right thing.  I am pretty
sure that the freezable variant was not used in the original fix only
because it was not available at that time.

The regression has been there for ages.  It was not critical.  It just did
the allocation throttling a little bit more aggressively.

I found this problem when converting the kthread to kthread worker API and
trying to understand the code.

Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-khugepaged-allow-to-interrupt-allocation-sleep-again mm/huge_memory.c
--- a/mm/huge_memory.c~mm-khugepaged-allow-to-interrupt-allocation-sleep-again
+++ a/mm/huge_memory.c
@@ -2326,8 +2326,12 @@ static void __collapse_huge_page_copy(pt
 
 static void khugepaged_alloc_sleep(void)
 {
-	wait_event_freezable_timeout(khugepaged_wait, false,
-			msecs_to_jiffies(khugepaged_alloc_sleep_millisecs));
+	DEFINE_WAIT(wait);
+
+	add_wait_queue(&khugepaged_wait, &wait);
+	freezable_schedule_timeout_interruptible(
+		msecs_to_jiffies(khugepaged_alloc_sleep_millisecs));
+	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
 static int khugepaged_node_load[MAX_NUMNODES];
_

Patches currently in -mm which might be from pmladek@suse.com are

mm-khugepaged-allow-to-interrupt-allocation-sleep-again.patch

