From: akpm@linux-foundation.org
Subject: - documentation-proc-pid-stat-files.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:45 -0700
Message-ID: <200707162055.l6GKtjLw001959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57329 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760464AbXGPVPr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kees@outflux.net, rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     Documentation: /proc/$pid/stat files
has been removed from the -mm tree.  Its filename was
     documentation-proc-pid-stat-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Documentation: /proc/$pid/stat files
From: Kees Cook <kees@outflux.net>

Documentation for the /proc/$pid/stat file.

Signed-off-by: Kees Cook <kees@outflux.net>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   65 ++++++++++++++++++++++++---
 1 file changed, 58 insertions(+), 7 deletions(-)

diff -puN Documentation/filesystems/proc.txt~documentation-proc-pid-stat-files Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~documentation-proc-pid-stat-files
+++ a/Documentation/filesystems/proc.txt
@@ -171,7 +171,9 @@ read the file /proc/PID/status:
 This shows you nearly the same information you would get if you viewed it with
 the ps  command.  In  fact,  ps  uses  the  proc  file  system  to  obtain its
 information. The  statm  file  contains  more  detailed  information about the
-process memory usage. Its seven fields are explained in Table 1-2.
+process memory usage. Its seven fields are explained in Table 1-2.  The stat
+file contains details information about the process itself.  Its fields are
+explained in Table 1-3.
 
 
 Table 1-2: Contents of the statm files (as of 2.6.8-rc3)
@@ -188,16 +190,65 @@ Table 1-2: Contents of the statm files (
  dt       number of dirty pages			(always 0 on 2.6)
 ..............................................................................
 
+
+Table 1-3: Contents of the stat files (as of 2.6.22-rc3)
+..............................................................................
+ Field          Content
+  pid           process id
+  tcomm         filename of the executable
+  state         state (R is running, S is sleeping, D is sleeping in an
+                uninterruptible wait, Z is zombie, T is traced or stopped)
+  ppid          process id of the parent process
+  pgrp          pgrp of the process
+  sid           session id
+  tty_nr        tty the process uses
+  tty_pgrp      pgrp of the tty
+  flags         task flags
+  min_flt       number of minor faults
+  cmin_flt      number of minor faults with child's
+  maj_flt       number of major faults
+  cmaj_flt      number of major faults with child's
+  utime         user mode jiffies
+  stime         kernel mode jiffies
+  cutime        user mode jiffies with child's
+  cstime        kernel mode jiffies with child's
+  priority      priority level
+  nice          nice level
+  num_threads   number of threads
+  start_time    time the process started after system boot
+  vsize         virtual memory size
+  rss           resident set memory size
+  rsslim        current limit in bytes on the rss
+  start_code    address above which program text can run
+  end_code      address below which program text can run
+  start_stack   address of the start of the stack
+  esp           current value of ESP
+  eip           current value of EIP
+  pending       bitmap of pending signals (obsolete)
+  blocked       bitmap of blocked signals (obsolete)
+  sigign        bitmap of ignored signals (obsolete)
+  sigcatch      bitmap of catched signals (obsolete)
+  wchan         address where process went to sleep
+  0             (place holder)
+  0             (place holder)
+  exit_signal   signal to send to parent thread on exit
+  task_cpu      which CPU the task is scheduled on
+  rt_priority   realtime priority
+  policy        scheduling policy (man sched_setscheduler)
+  blkio_ticks   time spent waiting for block IO
+..............................................................................
+
+
 1.2 Kernel data
 ---------------
 
 Similar to  the  process entries, the kernel data files give information about
 the running kernel. The files used to obtain this information are contained in
-/proc and  are  listed  in Table 1-3. Not all of these will be present in your
+/proc and  are  listed  in Table 1-4. Not all of these will be present in your
 system. It  depends  on the kernel configuration and the loaded modules, which
 files are there, and which are missing.
 
-Table 1-3: Kernel info in /proc 
+Table 1-4: Kernel info in /proc
 ..............................................................................
  File        Content                                           
  apm         Advanced power management info                    
@@ -473,10 +524,10 @@ IDE devices:
 
 More detailed  information  can  be  found  in  the  controller  specific
 subdirectories. These  are  named  ide0,  ide1  and  so  on.  Each  of  these
-directories contains the files shown in table 1-4.
+directories contains the files shown in table 1-5.
 
 
-Table 1-4: IDE controller info in  /proc/ide/ide? 
+Table 1-5: IDE controller info in  /proc/ide/ide?
 ..............................................................................
  File    Content                                 
  channel IDE channel (0 or 1)                    
@@ -486,11 +537,11 @@ Table 1-4: IDE controller info in  /proc
 ..............................................................................
 
 Each device  connected  to  a  controller  has  a separate subdirectory in the
-controllers directory.  The  files  listed in table 1-5 are contained in these
+controllers directory.  The  files  listed in table 1-6 are contained in these
 directories.
 
 
-Table 1-5: IDE device information 
+Table 1-6: IDE device information
 ..............................................................................
  File             Content                                    
  cache            The cache                                  
_

Patches currently in -mm which might be from kees@outflux.net are

origin.patch
