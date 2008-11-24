From: akpm@linux-foundation.org
Subject: + proc-update-document-for-proc-softirqs-and-proc-stat.patch added to -mm tree
Date: Mon, 24 Nov 2008 14:04:24 -0800
Message-ID: <200811242204.mAOM4PXa013045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057AbYKXWEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 17:04:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kobayashi.kk@ncos.nec.co.jp, adobriyan@gmail.com, dada1@cosmosbay.com, h-shimamoto@ct.jp.nec.com, mingo@elte.hu


The patch titled
     proc: update document for /proc/softirqs and /proc/stat
has been added to the -mm tree.  Its filename is
     proc-update-document-for-proc-softirqs-and-proc-stat.patch

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
Subject: proc: update document for /proc/softirqs and /proc/stat
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>

/proc/softirqs and /proc/stat have been changed.
This patch updates proc.txt for these usage.

Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Reviewed-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
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
@@ -290,6 +290,7 @@ Table 1-4: Kernel info in /proc
  rtc         Real time clock                                   
  scsi        SCSI info (see text)                              
  slabinfo    Slab pool info                                    
+ softirqs    softirq usage
  stat        Overall statistics                                
  swaps       Swap space utilization                            
  sys         See chapter 2                                     
@@ -604,6 +605,24 @@ on the kind of area :
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
 
@@ -890,6 +909,7 @@ since the system first booted.  For a qu
   processes 2915
   procs_running 1
   procs_blocked 0
+  softirq 183433 0 21755 12 39 1137 231 21459 2263
 
 The very first  "cpu" line aggregates the  numbers in all  of the other "cpuN"
 lines.  These numbers identify the amount of time the CPU has spent performing
@@ -925,6 +945,11 @@ CPUs.
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

