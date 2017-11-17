From: akpm@linux-foundation.org
Subject: [folded-merged]
 proc-coredump-add-coredumping-flag-to-proc-pid-status-fix.patch removed
 from -mm tree
Date: Fri, 17 Nov 2017 15:11:02 -0800
Message-ID: <5a0f6c86.HrMhxwXmy2lJjkfV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53508 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966109AbdKQXLD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:11:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, koct9i@gmail.com, mingo@kernel.org, oleg@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: document CoreDumping flag in /proc/<pid>/status
has been removed from the -mm tree.  Its filename was
     proc-coredump-add-coredumping-flag-to-proc-pid-status-fix.patch

This patch was dropped because it was folded into proc-coredump-add-coredumping-flag-to-proc-pid-status.patch

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: proc: document CoreDumping flag in /proc/<pid>/status

Add description for the CoreDumping flag in /proc/<pid>/status.

The flag is intended to be used to avoid killing processes
during the generation of the coredump files and avoid getting
corrupted coredump files.

Link: http://lkml.kernel.org/r/20170928135357.GA8470@castle.DHCP.thefacebook.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    3 +++
 1 file changed, 3 insertions(+)

diff -puN Documentation/filesystems/proc.txt~proc-coredump-add-coredumping-flag-to-proc-pid-status-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-coredump-add-coredumping-flag-to-proc-pid-status-fix
+++ a/Documentation/filesystems/proc.txt
@@ -181,6 +181,7 @@ read the file /proc/PID/status:
   VmPTE:        20 kb
   VmSwap:        0 kB
   HugetlbPages:          0 kB
+  CoreDumping:    0
   Threads:        1
   SigQ:   0/28578
   SigPnd: 0000000000000000
@@ -253,6 +254,8 @@ Table 1-2: Contents of the status files
  VmSwap                      amount of swap used by anonymous private data
                              (shmem swap usage is not included)
  HugetlbPages                size of hugetlb memory portions
+ CoreDumping                 process's memory is currently being dumped
+                             (killing the process may lead to a corrupted core)
  Threads                     number of threads
  SigQ                        number of signals queued/max. number for queue
  SigPnd                      bitmap of pending signals for the thread
_

Patches currently in -mm which might be from guro@fb.com are

proc-coredump-add-coredumping-flag-to-proc-pid-status.patch

