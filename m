From: akpm@linux-foundation.org
Subject: [merged] procfs-fix-proc-pid-maps-heap-check.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:39 -0700
Message-ID: <201103250725.p2P7PXlK026034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933909Ab1CYHZk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aaro.koskinen@nokia.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     procfs: fix /proc/<pid>/maps heap check
has been removed from the -mm tree.  Its filename was
     procfs-fix-proc-pid-maps-heap-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs: fix /proc/<pid>/maps heap check
From: Aaro Koskinen <aaro.koskinen@nokia.com>

The current code fails to print the "[heap]" marking if the heap is split
into multiple mappings.

Fix the check so that the marking is displayed in all possible cases:
	1. vma matches exactly the heap
	2. the heap vma is merged e.g. with bss
	3. the heap vma is splitted e.g. due to locked pages

Test cases. In all cases, the process should have mapping(s) with
[heap] marking:

	(1) vma matches exactly the heap

	#include <stdio.h>
	#include <unistd.h>
	#include <sys/types.h>

	int main (void)
	{
		if (sbrk(4096) != (void *)-1) {
			printf("check /proc/%d/maps\n", (int)getpid());
			while (1)
				sleep(1);
		}
		return 0;
	}

	# ./test1
	check /proc/553/maps
	[1] + Stopped                    ./test1
	# cat /proc/553/maps | head -4
	00008000-00009000 r-xp 00000000 01:00 3113640    /test1
	00010000-00011000 rw-p 00000000 01:00 3113640    /test1
	00011000-00012000 rw-p 00000000 00:00 0          [heap]
	4006f000-40070000 rw-p 00000000 00:00 0

	(2) the heap vma is merged

	#include <stdio.h>
	#include <unistd.h>
	#include <sys/types.h>

	char foo[4096] = "foo";
	char bar[4096];

	int main (void)
	{
		if (sbrk(4096) != (void *)-1) {
			printf("check /proc/%d/maps\n", (int)getpid());
			while (1)
				sleep(1);
		}
		return 0;
	}

	# ./test2
	check /proc/556/maps
	[2] + Stopped                    ./test2
	# cat /proc/556/maps | head -4
	00008000-00009000 r-xp 00000000 01:00 3116312    /test2
	00010000-00012000 rw-p 00000000 01:00 3116312    /test2
	00012000-00014000 rw-p 00000000 00:00 0          [heap]
	4004a000-4004b000 rw-p 00000000 00:00 0

	(3) the heap vma is splitted (this fails without the patch)

	#include <stdio.h>
	#include <unistd.h>
	#include <sys/mman.h>
	#include <sys/types.h>

	int main (void)
	{
		if ((sbrk(4096) != (void *)-1) && !mlockall(MCL_FUTURE) &&
		    (sbrk(4096) != (void *)-1)) {
			printf("check /proc/%d/maps\n", (int)getpid());
			while (1)
				sleep(1);
		}
		return 0;
	}

	# ./test3
	check /proc/559/maps
	[1] + Stopped                    ./test3
	# cat /proc/559/maps|head -4
	00008000-00009000 r-xp 00000000 01:00 3119108    /test3
	00010000-00011000 rw-p 00000000 01:00 3119108    /test3
	00011000-00012000 rw-p 00000000 00:00 0          [heap]
	00012000-00013000 rw-p 00000000 00:00 0          [heap]

It looks like the bug has been there forever, and since it only results in
some information missing from a procfile, it does not fulfil the -stable
"critical issue" criteria.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~procfs-fix-proc-pid-maps-heap-check fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-fix-proc-pid-maps-heap-check
+++ a/fs/proc/task_mmu.c
@@ -251,8 +251,8 @@ static void show_map_vma(struct seq_file
 		const char *name = arch_vma_name(vma);
 		if (!name) {
 			if (mm) {
-				if (vma->vm_start <= mm->start_brk &&
-						vma->vm_end >= mm->brk) {
+				if (vma->vm_start <= mm->brk &&
+						vma->vm_end >= mm->start_brk) {
 					name = "[heap]";
 				} else if (vma->vm_start <= mm->start_stack &&
 					   vma->vm_end >= mm->start_stack) {
_

Patches currently in -mm which might be from aaro.koskinen@nokia.com are

origin.patch
linux-next.patch

