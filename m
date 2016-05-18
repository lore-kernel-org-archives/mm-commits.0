From: akpm@linux-foundation.org
Subject: + mm-thp-khugepaged-should-scan-when-sleep-value-is-written.patch added to -mm tree
Date: Wed, 18 May 2016 15:13:56 -0700
Message-ID: <573ce924.mqR+PeQg6q5UTngG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbcERWN5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 May 2016 18:13:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: khugepaged should scan when sleep value is written
has been added to the -mm tree.  Its filename is
     mm-thp-khugepaged-should-scan-when-sleep-value-is-written.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-khugepaged-should-scan-when-sleep-value-is-written.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-khugepaged-should-scan-when-sleep-value-is-written.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: khugepaged should scan when sleep value is written

If a large value is written to scan_sleep_millisecs, for example, that
period must lapse before khugepaged will wake up for periodic collapsing.

If this value is tuned to 1 day, for example, and then re-tuned to its
default 10s, khugepaged will still wait for a day before scanning again.

This patch causes khugepaged to wakeup immediately when the value is
changed and then sleep until that value is rewritten or the new value
lapses.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1605181453200.4786@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-khugepaged-should-scan-when-sleep-value-is-written mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-khugepaged-should-scan-when-sleep-value-is-written
+++ a/mm/huge_memory.c
@@ -89,6 +89,7 @@ static unsigned int khugepaged_full_scan
 static unsigned int khugepaged_scan_sleep_millisecs __read_mostly = 10000;
 /* during fragmentation poll the hugepage allocator once every minute */
 static unsigned int khugepaged_alloc_sleep_millisecs __read_mostly = 60000;
+static unsigned long khugepaged_sleep_expire;
 static struct task_struct *khugepaged_thread __read_mostly;
 static DEFINE_MUTEX(khugepaged_mutex);
 static DEFINE_SPINLOCK(khugepaged_mm_lock);
@@ -467,6 +468,7 @@ static ssize_t scan_sleep_millisecs_stor
 		return -EINVAL;
 
 	khugepaged_scan_sleep_millisecs = msecs;
+	khugepaged_sleep_expire = 0;
 	wake_up_interruptible(&khugepaged_wait);
 
 	return count;
@@ -494,6 +496,7 @@ static ssize_t alloc_sleep_millisecs_sto
 		return -EINVAL;
 
 	khugepaged_alloc_sleep_millisecs = msecs;
+	khugepaged_sleep_expire = 0;
 	wake_up_interruptible(&khugepaged_wait);
 
 	return count;
@@ -2791,15 +2794,25 @@ static void khugepaged_do_scan(void)
 		put_page(hpage);
 }
 
+static bool khugepaged_should_wakeup(void)
+{
+	return kthread_should_stop() ||
+	       time_after_eq(jiffies, khugepaged_sleep_expire);
+}
+
 static void khugepaged_wait_work(void)
 {
 	if (khugepaged_has_work()) {
-		if (!khugepaged_scan_sleep_millisecs)
+		const unsigned long scan_sleep_jiffies =
+			msecs_to_jiffies(khugepaged_scan_sleep_millisecs);
+
+		if (!scan_sleep_jiffies)
 			return;
 
+		khugepaged_sleep_expire = jiffies + scan_sleep_jiffies;
 		wait_event_freezable_timeout(khugepaged_wait,
-					     kthread_should_stop(),
-			msecs_to_jiffies(khugepaged_scan_sleep_millisecs));
+					     khugepaged_should_wakeup(),
+					     scan_sleep_jiffies);
 		return;
 	}
 
_

Patches currently in -mm which might be from rientjes@google.com are

mm-hugetlb_cgroup-round-limit_in_bytes-down-to-hugepage-size.patch
mm-thp-khugepaged-should-scan-when-sleep-value-is-written.patch

