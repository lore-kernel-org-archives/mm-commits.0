From: akpm@linux-foundation.org
Subject: - x86_64-fake-numa-for-cpusets-document.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:38:37 -0700
Message-ID: <200703292338.l2TNcbqF015234@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43123 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934386AbXC2Xir (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:38:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, clameter@engr.sgi.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: fake numa for cpusets document
has been removed from the -mm tree.  Its filename was
     x86_64-fake-numa-for-cpusets-document.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: fake numa for cpusets document
From: David Rientjes <rientjes@google.com>

Create a document to explain how to use numa=fake in conjunction with cpusets
for coarse memory resource management.

An attempt to get more awareness and testing for this feature.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/fake-numa-for-cpusets |   66 +++++++++++++++++++
 1 file changed, 66 insertions(+)

diff -puN /dev/null Documentation/x86_64/fake-numa-for-cpusets
--- /dev/null
+++ a/Documentation/x86_64/fake-numa-for-cpusets
@@ -0,0 +1,66 @@
+Using numa=fake and CPUSets for Resource Management
+Written by David Rientjes <rientjes@cs.washington.edu>
+
+This document describes how the numa=fake x86_64 command-line option can be used
+in conjunction with cpusets for coarse memory management.  Using this feature,
+you can create fake NUMA nodes that represent contiguous chunks of memory and
+assign them to cpusets and their attached tasks.  This is a way of limiting the
+amount of system memory that are available to a certain class of tasks.
+
+For more information on the features of cpusets, see Documentation/cpusets.txt.
+There are a number of different configurations you can use for your needs.  For
+more information on the numa=fake command line option and its various ways of
+configuring fake nodes, see Documentation/x86_64/boot-options.txt.
+
+For the purposes of this introduction, we'll assume a very primitive NUMA
+emulation setup of "numa=fake=4*512,".  This will split our system memory into
+four equal chunks of 512M each that we can now use to assign to cpusets.  As
+you become more familiar with using this combination for resource control,
+you'll determine a better setup to minimize the number of nodes you have to deal
+with.
+
+A machine may be split as follows with "numa=fake=4*512," as reported by dmesg:
+
+	Faking node 0 at 0000000000000000-0000000020000000 (512MB)
+	Faking node 1 at 0000000020000000-0000000040000000 (512MB)
+	Faking node 2 at 0000000040000000-0000000060000000 (512MB)
+	Faking node 3 at 0000000060000000-0000000080000000 (512MB)
+	...
+	On node 0 totalpages: 130975
+	On node 1 totalpages: 131072
+	On node 2 totalpages: 131072
+	On node 3 totalpages: 131072
+
+Now following the instructions for mounting the cpusets filesystem from
+Documentation/cpusets.txt, you can assign fake nodes (i.e. contiguous memory
+address spaces) to individual cpusets:
+
+	[root@xroads /]# mkdir exampleset
+	[root@xroads /]# mount -t cpuset none exampleset
+	[root@xroads /]# mkdir exampleset/ddset
+	[root@xroads /]# cd exampleset/ddset
+	[root@xroads /exampleset/ddset]# echo 0-1 > cpus
+	[root@xroads /exampleset/ddset]# echo 0-1 > mems
+
+Now this cpuset, 'ddset', will only allowed access to fake nodes 0 and 1 for
+memory allocations (1G).
+
+You can now assign tasks to these cpusets to limit the memory resources
+available to them according to the fake nodes assigned as mems:
+
+	[root@xroads /exampleset/ddset]# echo $$ > tasks
+	[root@xroads /exampleset/ddset]# dd if=/dev/zero of=tmp bs=1024 count=1G
+	[1] 13425
+
+Notice the difference between the system memory usage as reported by
+/proc/meminfo between the restricted cpuset case above and the unrestricted
+case (i.e. running the same 'dd' command without assigning it to a fake NUMA
+cpuset):
+				Unrestricted	Restricted
+	MemTotal:		3091900 kB	3091900 kB
+	MemFree:		  42113 kB	1513236 kB
+
+This allows for coarse memory management for the tasks you assign to particular
+cpusets.  Since cpusets can form a hierarchy, you can create some pretty
+interesting combinations of use-cases for various classes of tasks for your
+memory management needs.
_

Patches currently in -mm which might be from rientjes@google.com are

i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
smaps-use-ptep_test_and_clear_young.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
