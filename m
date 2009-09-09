From: akpm@linux-foundation.org
Subject: + proc-document-guest-column-in-proc-stat.patch added to -mm tree
Date: Wed, 09 Sep 2009 16:34:05 -0700
Message-ID: <200909092334.n89NY5hU026043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753602AbZIIXeh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 19:34:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.dumazet@gmail.com


The patch titled
     proc: document `guest' column in /proc/stat
has been added to the -mm tree.  Its filename is
     proc-document-guest-column-in-proc-stat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1048,9 +1048,9 @@ Various pieces   of  information about  
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
@@ -1072,6 +1072,7 @@ second).  The meanings of the columns ar
 - irq: servicing interrupts
 - softirq: servicing softirqs
 - steal: involuntary wait
+- guest: running a guest
 
 The "intr" line gives counts of interrupts  serviced since boot time, for each
 of the  possible system interrupts.   The first  column  is the  total of  all
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

linux-next.patch
proc-document-guest-column-in-proc-stat.patch

