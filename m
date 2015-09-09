From: akpm@linux-foundation.org
Subject: [merged]
 documentation-update-libhugetlbfs-location-and-use-for-testing.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:47:26 -0700
Message-ID: <55f08cce.liVpqBtfgxuirskO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbbIITr1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:47:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave@stgolabs.net, joern@logfs.org, n-horiguchi@ah.jp.nec.com, rientjes@google.com, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: update libhugetlbfs location and use for testing
has been removed from the -mm tree.  Its filename was
     documentation-update-libhugetlbfs-location-and-use-for-testing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Documentation: update libhugetlbfs location and use for testing

The URL for libhugetlbfs has changed.  Also, put a stronger emphasis on
using libgugetlbfs for hugetlb regression testing.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hugetlbpage.txt |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN Documentation/vm/hugetlbpage.txt~documentation-update-libhugetlbfs-location-and-use-for-testing Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~documentation-update-libhugetlbfs-location-and-use-for-testing
+++ a/Documentation/vm/hugetlbpage.txt
@@ -329,7 +329,14 @@ Examples
 
 3) hugepage-mmap:  see tools/testing/selftests/vm/hugepage-mmap.c
 
-4) The libhugetlbfs (http://libhugetlbfs.sourceforge.net) library provides a
-   wide range of userspace tools to help with huge page usability, environment
-   setup, and control. Furthermore it provides useful test cases that should be
-   used when modifying code to ensure no regressions are introduced.
+4) The libhugetlbfs (https://github.com/libhugetlbfs/libhugetlbfs) library
+   provides a wide range of userspace tools to help with huge page usability,
+   environment setup, and control.
+
+Kernel development regression testing
+=====================================
+
+The most complete set of hugetlb tests are in the libhugetlbfs repository.
+If you modify any hugetlb related code, use the libhugetlbfs test suite
+to check for regressions.  In addition, if you add any new hugetlb
+functionality, please add appropriate tests to libhugetlbfs.
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


