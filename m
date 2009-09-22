From: akpm@linux-foundation.org
Subject: [merged] proc-document-guest-column-in-proc-stat.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:36:55 -0700
Message-ID: <200909222036.n8MKatXO030816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935AbZIVUhW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:37:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.dumazet@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: document `guest' column in /proc/stat
has been removed from the -mm tree.  Its filename was
     proc-document-guest-column-in-proc-stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: document `guest' column in /proc/stat
From: Eric Dumazet <eric.dumazet@gmail.com>

We added a new column in cpuX lines of /proc/stat, to show the amount of
time spent by a cpu servicing a guest, without updating
Documentation/filesystems/proc.txt

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/proc.txt~proc-document-guest-column-in-proc-stat Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-document-guest-column-in-proc-stat
+++ a/Documentation/filesystems/proc.txt
@@ -1032,9 +1032,9 @@ Various pieces   of  information about  
 since the system first booted.  For a quick look, simply cat the file:
 
   > cat /proc/stat
-  cpu  2255 34 2290 22625563 6290 127 456 0
-  cpu0 1132 34 1441 11311718 3675 127 438 0
-  cpu1 1123 0 849 11313845 2614 0 18 0
+  cpu  2255 34 2290 22625563 6290 127 456 0 0
+  cpu0 1132 34 1441 11311718 3675 127 438 0 0
+  cpu1 1123 0 849 11313845 2614 0 18 0 0
   intr 114930548 113199788 3 0 5 263 0 4 [... lots more numbers ...]
   ctxt 1990473
   btime 1062191376
@@ -1056,6 +1056,7 @@ second).  The meanings of the columns ar
 - irq: servicing interrupts
 - softirq: servicing softirqs
 - steal: involuntary wait
+- guest: running a guest
 
 The "intr" line gives counts of interrupts  serviced since boot time, for each
 of the  possible system interrupts.   The first  column  is the  total of  all
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

origin.patch

