From: akpm@linux-foundation.org
Subject: [merged]
 fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch removed from
 -mm tree
Date: Fri, 13 Feb 2015 12:21:41 -0800
Message-ID: <54de5cd5.l4w2pxQh+7QWdRD/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbBMUVm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, dave.hansen@intel.com, hannes@cmpxchg.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: proc: task_mmu: show page size in /proc/<pid>/numa_maps
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: fs: proc: task_mmu: show page size in /proc/<pid>/numa_maps

The output of /proc/$pid/numa_maps is in terms of number of pages like
anon=22 or dirty=54.  Here's some output:

7f4680000000 default file=/hugetlb/bigfile anon=50 dirty=50 N0=50
7f7659600000 default file=/anon_hugepage\040(deleted) anon=50 dirty=50 N0=50
7fff8d425000 default stack anon=50 dirty=50 N0=50
Looks like we have a stack and a couple of anonymous hugetlbfs
areas page which both use the same amount of memory.  They don't.

The 'bigfile' uses 1GB pages and takes up ~50GB of space.  The
anon_hugepage uses 2MB pages and takes up ~100MB of space while the stack
uses normal 4k pages.  You can go over to smaps to figure out what the
page size _really_ is with KernelPageSize or MMUPageSize.  But, I think
this is a pretty nasty and counterintuitive interface as it stands.

This patch introduces 'kernelpagesize_kB' line element to
/proc/<pid>/numa_maps report file in order to help identifying the size of
pages that are backing memory areas mapped by a given task.  This is
specially useful to help differentiating between HUGE and GIGANTIC page
backed VMAs.

This patch is based on Dave Hansen's proposal and reviewer's follow-ups
taken from the following dicussion threads:
 * https://lkml.org/lkml/2011/9/21/454
 * https://lkml.org/lkml/2014/12/20/66

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   30 +++++++++++++--------------
 fs/proc/task_mmu.c                 |    2 +
 2 files changed, 17 insertions(+), 15 deletions(-)

diff -puN Documentation/filesystems/proc.txt~fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps
+++ a/Documentation/filesystems/proc.txt
@@ -508,22 +508,22 @@ summarized separated by blank spaces, on
 
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
diff -puN fs/proc/task_mmu.c~fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps
+++ a/fs/proc/task_mmu.c
@@ -1557,6 +1557,8 @@ static int show_numa_map(struct seq_file
 	for_each_node_state(nid, N_MEMORY)
 		if (md->node[nid])
 			seq_printf(m, " N%d=%lu", nid, md->node[nid]);
+
+	seq_printf(m, " kernelpagesize_kB=%lu", vma_kernel_pagesize(vma) >> 10);
 out:
 	seq_putc(m, '\n');
 	m_cache_vma(m, vma);
_

Patches currently in -mm which might be from aquini@redhat.com are

origin.patch

