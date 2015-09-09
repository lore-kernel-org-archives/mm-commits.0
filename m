From: akpm@linux-foundation.org
Subject: [merged]
 mm-khugepaged-allow-to-interrupt-allocation-sleep-again.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 12:53:37 -0700
Message-ID: <55f08e41.Ka1moOmHtWcIK+ju%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbbIITxi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, ebru.akagunduz@gmail.com, jkosina@suse.cz, kirill.shutemov@linux.intel.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: allow interruption of allocation sleep again
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-allow-to-interrupt-allocation-sleep-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

This bug is thought to have minimal userspace-visible impact.  Somebody
could set a high alloc_sleep value by mistake, and then try to fix it
back, but khugepaged would keep sleeping until the high value expires.

Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
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


