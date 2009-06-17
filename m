From: akpm@linux-foundation.org
Subject: [folded] proc-update-document-for-proc-softirqs-and-proc-stat.patch removed from -mm tree
Date: Wed, 17 Jun 2009 13:05:32 -0700
Message-ID: <200906172005.n5HK5W53020462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754123AbZFQUFu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 16:05:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kobayashi.kk@ncos.nec.co.jp, adobriyan@gmail.com, dada1@cosmosbay.com, h-shimamoto@ct.jp.nec.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     proc: update document for /proc/softirqs and /proc/stat
has been removed from the -mm tree.  Its filename was
     proc-update-document-for-proc-softirqs-and-proc-stat.patch

This patch was dropped because it was folded into proc-export-statistics-for-softirq-to-proc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: update document for /proc/softirqs and /proc/stat
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>

/proc/softirqs and /proc/stat have been changed.
This patch updates proc.txt for these usage.

Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Reviewed-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN Documentation/filesystems/proc.txt~proc-update-document-for-proc-softirqs-and-proc-stat Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-update-document-for-proc-softirqs-and-proc-stat
+++ a/Documentation/filesystems/proc.txt
@@ -283,6 +283,7 @@ Table 1-4: Kernel info in /proc
  rtc         Real time clock                                   
  scsi        SCSI info (see text)                              
  slabinfo    Slab pool info                                    
+ softirqs    softirq usage
  stat        Overall statistics                                
  swaps       Swap space utilization                            
  sys         See chapter 2                                     
@@ -597,6 +598,24 @@ on the kind of area :
 0xffffffffa0017000-0xffffffffa0022000   45056 sys_init_module+0xc27/0x1d00 ...
    pages=10 vmalloc N0=10
 
+..............................................................................
+
+softirqs:
+
+Provides counts of softirq handlers serviced since boot time, for each cpu.
+
+> cat /proc/softirqs
+                CPU0       CPU1       CPU2       CPU3
+HI                 0          0          0          0
+TIMER          27166      27120      27097      27034
+NET_TX             0          0          0         17
+NET_RX            42          0          0         39
+BLOCK              0          0        107       1121
+TASKLET            0          0          0        290
+SCHED          27035      26983      26971      26746
+RCU             1678       1769       2178       2250
+
+
 1.3 IDE devices in /proc/ide
 ----------------------------
 
@@ -883,6 +902,7 @@ since the system first booted.  For a qu
   processes 2915
   procs_running 1
   procs_blocked 0
+  softirq 183433 0 21755 12 39 1137 231 21459 2263
 
 The very first  "cpu" line aggregates the  numbers in all  of the other "cpuN"
 lines.  These numbers identify the amount of time the CPU has spent performing
@@ -918,6 +938,11 @@ CPUs.
 The   "procs_blocked" line gives  the  number of  processes currently blocked,
 waiting for I/O to complete.
 
+The "softirq" line gives counts of softirqs serviced since boot time, for each
+of the possible system softirqs. The first column is the total of all
+softirqs serviced; each subsequent column is the total for that particular
+softirq.
+
 
 1.9 Ext4 file system parameters
 ------------------------------
_

Patches currently in -mm which might be from kobayashi.kk@ncos.nec.co.jp are

softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
proc-update-document-for-proc-softirqs-and-proc-stat-update.patch

