From: akpm@linux-foundation.org
Subject: - documetation-update-hugetlb-information.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:36:49 -0800
Message-ID: <200712202336.lBKNanj3018828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44208 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758631AbXLTXxq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:53:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, agl@us.ibm.com, david@gibson.dropbear.id.au, haveblue@us.ibm.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     Documentation: update hugetlb information
has been removed from the -mm tree.  Its filename was
     documetation-update-hugetlb-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Documentation: update hugetlb information
From: Nishanth Aravamudan <nacc@us.ibm.com>

The hugetlb documentation has gotten a bit out of sync with the current code. 
Updated the sysctl file to refer to Documentation/vm/hugetlbpage.txt.  Update
that file to contain the current state of affairs (with the newer named sysctl
in place).

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Adam Litke <agl@us.ibm.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt      |   19 +++++++++++++++
 Documentation/vm/hugetlbpage.txt |   35 ++++++++++++++++++++++++-----
 2 files changed, 48 insertions(+), 6 deletions(-)

diff -puN Documentation/sysctl/vm.txt~documetation-update-hugetlb-information Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~documetation-update-hugetlb-information
+++ a/Documentation/sysctl/vm.txt
@@ -34,6 +34,8 @@ Currently, these files are in /proc/sys/
 - oom_kill_allocating_task
 - mmap_min_address
 - numa_zonelist_order
+- nr_hugepages
+- nr_overcommit_hugepages
 
 ==============================================================
 
@@ -305,3 +307,20 @@ will select "node" order in following ca
 
 Otherwise, "zone" order will be selected. Default order is recommended unless
 this is causing problems for your system/application.
+
+==============================================================
+
+nr_hugepages
+
+Change the minimum size of the hugepage pool.
+
+See Documentation/vm/hugetlbpage.txt
+
+==============================================================
+
+nr_overcommit_hugepages
+
+Change the maximum size of the hugepage pool. The maximum is
+nr_hugepages + nr_overcommit_hugepages.
+
+See Documentation/vm/hugetlbpage.txt
diff -puN Documentation/vm/hugetlbpage.txt~documetation-update-hugetlb-information Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~documetation-update-hugetlb-information
+++ a/Documentation/vm/hugetlbpage.txt
@@ -30,9 +30,10 @@ alignment and size of the arguments to t
 The output of "cat /proc/meminfo" will have lines like:
 
 .....
-HugePages_Total: xxx
-HugePages_Free:  yyy
-HugePages_Rsvd:  www
+HugePages_Total: vvv
+HugePages_Free:  www
+HugePages_Rsvd:  xxx
+HugePages_Surp:  yyy
 Hugepagesize:    zzz kB
 
 where:
@@ -42,6 +43,10 @@ allocated.
 HugePages_Rsvd is short for "reserved," and is the number of hugepages
 for which a commitment to allocate from the pool has been made, but no
 allocation has yet been made. It's vaguely analogous to overcommit.
+HugePages_Surp is short for "surplus," and is the number of hugepages in
+the pool above the value in /proc/sys/vm/nr_hugepages. The maximum
+number of surplus hugepages is controlled by
+/proc/sys/vm/nr_overcommit_hugepages.
 
 /proc/filesystems should also show a filesystem of type "hugetlbfs" configured
 in the kernel.
@@ -71,7 +76,25 @@ or failure of allocation depends on the 
 memory that is preset in system at this time.  System administrators may want
 to put this command in one of the local rc init files.  This will enable the
 kernel to request huge pages early in the boot process (when the possibility
-of getting physical contiguous pages is still very high).
+of getting physical contiguous pages is still very high). In either
+case, adminstrators will want to verify the number of hugepages actually
+allocated by checking the sysctl or meminfo.
+
+/proc/sys/vm/nr_overcommit_hugepages indicates how large the pool of
+hugepages can grow, if more hugepages than /proc/sys/vm/nr_hugepages are
+requested by applications. echo'ing any non-zero value into this file
+indicates that the hugetlb subsystem is allowed to try to obtain
+hugepages from the buddy allocator, if the normal pool is exhausted. As
+these surplus hugepages go out of use, they are freed back to the buddy
+allocator.
+
+Caveat: Shrinking the pool via nr_hugepages while a surplus is in effect
+will allow the number of surplus huge pages to exceed the overcommit
+value, as the pool hugepages (which must have been in use for a surplus
+hugepages to be allocated) will become surplus hugepages.  As long as
+this condition holds, however, no more surplus huge pages will be
+allowed on the system until one of the two sysctls are increased
+sufficiently, or the surplus huge pages go out of use and are freed.
 
 If the user applications are going to request hugepages using mmap system
 call, then it is required that system administrator mount a file system of
@@ -94,8 +117,8 @@ provided on command line then no limits 
 options, you can use [G|g]/[M|m]/[K|k] to represent giga/mega/kilo. For
 example, size=2K has the same meaning as size=2048.
 
-read and write system calls are not supported on files that reside on hugetlb
-file systems.
+While read system calls are supported on files that reside on hugetlb
+file systems, write system calls are not.
 
 Regular chown, chgrp, and chmod commands (with right permissions) could be
 used to change the file attributes on hugetlbfs.
_

Patches currently in -mm which might be from nacc@us.ibm.com are

origin.patch
