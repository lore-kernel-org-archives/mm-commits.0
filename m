From: akpm@linux-foundation.org
Subject: [merged] hugepage-mention-libhugetlbfs-in-doc.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:43:53 -0700
Message-ID: <52321979.85OKz+Fx+ijcLj/S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3ILTnx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davidlohr@hp.com

Subject: [merged] hugepage-mention-libhugetlbfs-in-doc.patch removed from -mm tree
To: davidlohr@hp.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:53 -0700


The patch titled
     Subject: hugepage: mention libhugetlbfs in doc
has been removed from the -mm tree.  Its filename was
     hugepage-mention-libhugetlbfs-in-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: hugepage: mention libhugetlbfs in doc

Explicitly mention/recommend using the libhugetlbfs test cases when
changing related kernel code.  Developers that are unaware of the project
can easily miss this and introduce potential regressions that may or may
not be caught by community review.

Also do some cleanups that make the document visually easier to view at a
first glance.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hugetlbpage.txt |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff -puN Documentation/vm/hugetlbpage.txt~hugepage-mention-libhugetlbfs-in-doc Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~hugepage-mention-libhugetlbfs-in-doc
+++ a/Documentation/vm/hugetlbpage.txt
@@ -165,6 +165,7 @@ which function as described above for th
 
 
 Interaction of Task Memory Policy with Huge Page Allocation/Freeing
+===================================================================
 
 Whether huge pages are allocated and freed via the /proc interface or
 the /sysfs interface using the nr_hugepages_mempolicy attribute, the NUMA
@@ -229,6 +230,7 @@ resulting effect on persistent huge page
    of huge pages over all on-lines nodes with memory.
 
 Per Node Hugepages Attributes
+=============================
 
 A subset of the contents of the root huge page control directory in sysfs,
 described above, will be replicated under each the system device of each
@@ -258,6 +260,7 @@ applied, from which node the huge page a
 
 
 Using Huge Pages
+================
 
 If the user applications are going to request huge pages using mmap system
 call, then it is required that system administrator mount a file system of
@@ -296,20 +299,16 @@ calls, though the mount of filesystem wi
 without MAP_HUGETLB.  For an example of how to use mmap with MAP_HUGETLB see
 map_hugetlb.c.
 
-*******************************************************************
+Examples
+========
 
-/*
- * map_hugetlb: see tools/testing/selftests/vm/map_hugetlb.c
- */
+1) map_hugetlb: see tools/testing/selftests/vm/map_hugetlb.c
 
-*******************************************************************
+2) hugepage-shm:  see tools/testing/selftests/vm/hugepage-shm.c
 
-/*
- * hugepage-shm:  see tools/testing/selftests/vm/hugepage-shm.c
- */
+3) hugepage-mmap:  see tools/testing/selftests/vm/hugepage-mmap.c
 
-*******************************************************************
