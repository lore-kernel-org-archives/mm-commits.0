From: akpm@linux-foundation.org
Subject: + fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch
 added to -mm tree
Date: Mon, 05 Jan 2015 13:35:06 -0800
Message-ID: <54ab038a.9caBxnB+pBAqZVl3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbbAEVfH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2015 16:35:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, dave.hansen@intel.com, hannes@cmpxchg.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: proc: task_mmu: show page size in /proc/<pid>/numa_maps
has been added to the -mm tree.  Its filename is
     fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch

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
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps
+++ a/fs/proc/task_mmu.c
@@ -1548,6 +1548,8 @@ static int show_numa_map(struct seq_file
 	if (!md->pages)
 		goto out;
 
+	seq_printf(m, " kernelpagesize_kB=%lu", vma_kernel_pagesize(vma) >> 10);
+
 	if (md->anon)
 		seq_printf(m, " anon=%lu", md->anon);
 
_

Patches currently in -mm which might be from aquini@redhat.com are

fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch

