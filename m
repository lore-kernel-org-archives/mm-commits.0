From: akpm@linux-foundation.org
Subject: + hugepage-mention-libhugetlbfs-in-doc.patch added to -mm tree
Date: Wed, 14 Aug 2013 13:18:15 -0700
Message-ID: <520be607.1VSNxVQwCRr9wJqU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54586 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932768Ab3HNUSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 16:18:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davidlohr@hp.com

Subject: + hugepage-mention-libhugetlbfs-in-doc.patch added to -mm tree
To: davidlohr@hp.com
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 13:18:15 -0700


The patch titled
     Subject: hugepage: mention libhugetlbfs in doc
has been added to the -mm tree.  Its filename is
     hugepage-mention-libhugetlbfs-in-doc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugepage-mention-libhugetlbfs-in-doc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugepage-mention-libhugetlbfs-in-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
