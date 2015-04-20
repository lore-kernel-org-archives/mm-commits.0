From: akpm@linux-foundation.org
Subject: [merged]
 docs-add-missing-and-new-proc-pid-status-file-entries-fix-typos.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:21:10 -0700
Message-ID: <553551a6.xuN1f146AhgSn2nv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbbDTTOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nathans@redhat.com, chenhanxiao@cn.fujitsu.com, ebiederm@xmission.com, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: docs: add missing and new /proc/PID/status file entries, fix typos
has been removed from the -mm tree.  Its filename was
     docs-add-missing-and-new-proc-pid-status-file-entries-fix-typos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nathan Scott <nathans@redhat.com>
Subject: docs: add missing and new /proc/PID/status file entries, fix typos

docs: add missing and new /proc/PID/status file entries, fix typos

Signed-off-by: Nathan Scott <nathans@redhat.com>
Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/proc.txt~docs-add-missing-and-new-proc-pid-status-file-entries-fix-typos Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~docs-add-missing-and-new-proc-pid-status-file-entries-fix-typos
+++ a/Documentation/filesystems/proc.txt
@@ -200,12 +200,12 @@ contains details information about the p
 explained in Table 1-4.
 
 (for SMP CONFIG users)
-For making accounting scalable, RSS related information are handled in
-asynchronous manner and the vaule may not be very precise. To see a precise
+For making accounting scalable, RSS related information are handled in an
+asynchronous manner and the value may not be very precise. To see a precise
 snapshot of a moment, you can see /proc/<pid>/smaps file and scan page table.
 It's slow but very precise.
 
-Table 1-2: Contents of the status files (as of 2.6.30-rc7)
+Table 1-2: Contents of the status files (as of 3.20.0)
 ..............................................................................
  Field                       Content
  Name                        filename of the executable
@@ -213,6 +213,7 @@ Table 1-2: Contents of the status files
                              in an uninterruptible wait, Z is zombie,
 			     T is traced or stopped)
  Tgid                        thread group ID
+ Ngid                        NUMA group ID (0 if none)
  Pid                         process id
  PPid                        process id of the parent process
  TracerPid                   PID of process tracing this process (0 if not)
@@ -220,6 +221,10 @@ Table 1-2: Contents of the status files
  Gid                         Real, effective, saved set, and  file system GIDs
  FDSize                      number of file descriptor slots currently allocated
  Groups                      supplementary group list
+ NStgid                      descendant namespace thread group ID hierarchy
+ NSpid                       descendant namespace process ID hierarchy
+ NSpgid                      descendant namespace process group ID hierarchy
+ NSsid                       descendant namespace session ID hierarchy
  VmPeak                      peak virtual memory size
  VmSize                      total program size
  VmLck                       locked memory size
_

Patches currently in -mm which might be from nathans@redhat.com are

origin.patch

