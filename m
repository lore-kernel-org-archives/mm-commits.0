From: akpm@linux-foundation.org
Subject: [folded] proc-update-document-for-proc-softirqs-and-proc-stat-update.patch removed from -mm tree
Date: Wed, 17 Jun 2009 13:05:37 -0700
Message-ID: <200906172005.n5HK5cfA020505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758599AbZFQUF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 16:05:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kobayashi.kk@ncos.nec.co.jp, adobriyan@gmail.com, dada1@cosmosbay.com, h-shimamoto@ct.jp.nec.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     proc-update-document-for-proc-softirqs-and-proc-stat-update
has been removed from the -mm tree.  Its filename was
     proc-update-document-for-proc-softirqs-and-proc-stat-update.patch

This patch was dropped because it was folded into proc-export-statistics-for-softirq-to-proc.patch

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
proc-update-document-for-proc-softirqs-and-proc-stat-update.patch

