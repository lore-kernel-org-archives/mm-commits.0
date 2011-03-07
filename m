From: akpm@linux-foundation.org
Subject: + procfs-fix-proc-pid-maps-heap-check.patch added to -mm tree
Date: Mon, 07 Mar 2011 15:08:02 -0800
Message-ID: <201103072308.p27N837A000738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756741Ab1CGXIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 18:08:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aaro.koskinen@nokia.com, kosaki.motohiro@jp.fujitsu.com, stable@kernel.org


The patch titled
     procfs: fix /proc/<pid>/maps heap check
has been added to the -mm tree.  Its filename is
     procfs-fix-proc-pid-maps-heap-check.patch

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

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: <stable@kernel.org>
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

linux-next.patch
procfs-fix-proc-pid-maps-heap-check.patch

