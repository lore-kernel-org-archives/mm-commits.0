From: akpm@linux-foundation.org
Subject: + fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps-fix.patch added to -mm tree
Date: Fri, 16 Jan 2015 16:06:08 -0800
Message-ID: <54b9a770.XrcalqwK50hBh8X1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbbAQAGJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jan 2015 19:06:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, dave.hansen@linux.intel.com, hannes@cmpxchg.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: proc: task_mmu: bump kernelpagesize_kB to EOL in /proc/pid/numa_maps
has been added to the -mm tree.  Its filename is
     fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: fs: proc: task_mmu: bump kernelpagesize_kB to EOL in /proc/pid/numa_maps

Commit "4dd025c fs: proc: task_mmu: show page size in /proc/<pid>/numa_maps"
(linux-next) introduces 'kernelpagesize_kB' to numa_maps proc interface.
This patch, per Andrew Morton suggestion, switchs 'kernelpagesize_kB' position
to EOL in /proc/<pid>/numa_maps to potentially avoid causing trouble to any
existent parser that expects numa_maps file line previous layout.

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   30 +++++++++++++--------------
 fs/proc/task_mmu.c                 |    4 +--
 2 files changed, 17 insertions(+), 17 deletions(-)

diff -puN Documentation/filesystems/proc.txt~fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps-fix
+++ a/Documentation/filesystems/proc.txt
@@ -507,22 +507,22 @@ summarized separated by blank spaces, on
 
 address   policy    mapping details
 
-00400000 default file=/usr/local/bin/app kernelpagesize_kB=4 mapped=1 active=0 N3=1
-00600000 default file=/usr/local/bin/app kernelpagesize_kB=4 anon=1 dirty=1 N3=1
-3206000000 default file=/lib64/ld-2.12.so kernelpagesize_kB=4 mapped=26 mapmax=6 N0=24 N3=2
-320621f000 default file=/lib64/ld-2.12.so kernelpagesize_kB=4 anon=1 dirty=1 N3=1
-3206220000 default file=/lib64/ld-2.12.so kernelpagesize_kB=4 anon=1 dirty=1 N3=1
-3206221000 default kernelpagesize_kB=4 anon=1 dirty=1 N3=1
-3206800000 default file=/lib64/libc-2.12.so kernelpagesize_kB=4 mapped=59 mapmax=21 active=55 N0=41 N3=18
+00400000 default file=/usr/local/bin/app mapped=1 active=0 N3=1 kernelpagesize_kB=4
+00600000 default file=/usr/local/bin/app anon=1 dirty=1 N3=1 kernelpagesize_kB=4
+3206000000 default file=/lib64/ld-2.12.so mapped=26 mapmax=6 N0=24 N3=2 kernelpagesize_kB=4
+320621f000 default file=/lib64/ld-2.12.so anon=1 dirty=1 N3=1 kernelpagesize_kB=4
+3206220000 default file=/lib64/ld-2.12.so anon=1 dirty=1 N3=1 kernelpagesize_kB=4
+3206221000 default anon=1 dirty=1 N3=1 kernelpagesize_kB=4
+3206800000 default file=/lib64/libc-2.12.so mapped=59 mapmax=21 active=55 N0=41 N3=18 kernelpagesize_kB=4
 320698b000 default file=/lib64/libc-2.12.so
-3206b8a000 default file=/lib64/libc-2.12.so kernelpagesize_kB=4 anon=2 dirty=2 N3=2
-3206b8e000 default file=/lib64/libc-2.12.so kernelpagesize_kB=4 anon=1 dirty=1 N3=1
-3206b8f000 default kernelpagesize_kB=4 anon=3 dirty=3 active=1 N3=3
-7f4dc10a2000 default kernelpagesize_kB=4 anon=3 dirty=3 N3=3
-7f4dc10b4000 default kernelpagesize_kB=4 anon=2 dirty=2 active=1 N3=2
-7f4dc1200000 default file=/anon_hugepage\040(deleted) huge kernelpagesize_kB=2048 anon=1 dirty=1 N3=1
-7fff335f0000 default stack kernelpagesize_kB=4 anon=3 dirty=3 N3=3
-7fff3369d000 default kernelpagesize_kB=4 mapped=1 mapmax=35 active=0 N3=1
+3206b8a000 default file=/lib64/libc-2.12.so anon=2 dirty=2 N3=2 kernelpagesize_kB=4
+3206b8e000 default file=/lib64/libc-2.12.so anon=1 dirty=1 N3=1 kernelpagesize_kB=4
+3206b8f000 default anon=3 dirty=3 active=1 N3=3 kernelpagesize_kB=4
+7f4dc10a2000 default anon=3 dirty=3 N3=3 kernelpagesize_kB=4
+7f4dc10b4000 default anon=2 dirty=2 active=1 N3=2 kernelpagesize_kB=4
+7f4dc1200000 default file=/anon_hugepage\040(deleted) huge anon=1 dirty=1 N3=1 kernelpagesize_kB=2048
+7fff335f0000 default stack anon=3 dirty=3 N3=3 kernelpagesize_kB=4
+7fff3369d000 default mapped=1 mapmax=35 active=0 N3=1 kernelpagesize_kB=4
 
 Where:
 "address" is the starting address for the mapping;
diff -puN fs/proc/task_mmu.c~fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps-fix
+++ a/fs/proc/task_mmu.c
@@ -1536,8 +1536,6 @@ static int show_numa_map(struct seq_file
 	if (!md->pages)
 		goto out;
 
-	seq_printf(m, " kernelpagesize_kB=%lu", vma_kernel_pagesize(vma) >> 10);
