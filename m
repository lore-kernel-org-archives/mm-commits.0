From: akpm@linux-foundation.org
Subject: + proc-update-document-for-proc-softirqs-and-proc-stat-update.patch added to -mm tree
Date: Mon, 15 Jun 2009 09:19:48 -0700
Message-ID: <200906151619.n5FGJmJH008975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbZFOQUK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 12:20:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kobayashi.kk@ncos.nec.co.jp, adobriyan@gmail.com, dada1@cosmosbay.com, h-shimamoto@ct.jp.nec.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu


The patch titled
     proc-update-document-for-proc-softirqs-and-proc-stat-update
has been added to the -mm tree.  Its filename is
     proc-update-document-for-proc-softirqs-and-proc-stat-update.patch

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
Subject: proc-update-document-for-proc-softirqs-and-proc-stat-update
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>

> >
> > It's dangerous and a bit of a hassle for me to hang onto incomplete
> > patches.  But if I drop them, they can just get forgotten about
> > altogether.  Please let's respond to reviewer comments promptly?

Thank you so much for your advice.
I just fixed the above point in the previous patch.

Similarly, here is update patch for documentation.

Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN Documentation/filesystems/proc.txt~proc-update-document-for-proc-softirqs-and-proc-stat-update Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-update-document-for-proc-softirqs-and-proc-stat-update
+++ a/Documentation/filesystems/proc.txt
@@ -606,14 +606,15 @@ Provides counts of softirq handlers serv
 
 > cat /proc/softirqs
                 CPU0       CPU1       CPU2       CPU3
-HI                 0          0          0          0
-TIMER          27166      27120      27097      27034
-NET_TX             0          0          0         17
-NET_RX            42          0          0         39
-BLOCK              0          0        107       1121
-TASKLET            0          0          0        290
-SCHED          27035      26983      26971      26746
-RCU             1678       1769       2178       2250
+      HI:          0          0          0          0
+   TIMER:      27166      27120      27097      27034
+  NET_TX:          0          0          0         17
+  NET_RX:         42          0          0         39
+   BLOCK:          0          0        107       1121
+ TASKLET:          0          0          0        290
+   SCHED:      27035      26983      26971      26746
+ HRTIMER:          0          0          0          0
+     RCU:       1678       1769       2178       2250
 
 
 1.3 IDE devices in /proc/ide
_

Patches currently in -mm which might be from kobayashi.kk@ncos.nec.co.jp are

softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-update.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
proc-update-document-for-proc-softirqs-and-proc-stat-update.patch

