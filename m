From: akpm@linux-foundation.org
Subject: [merged]
 selftests-vm-compaction_test-fix-write-to-restore-nr_hugepages.patch
 removed from -mm tree
Date: Tue, 28 Jun 2016 19:01:41 -0700
Message-ID: <57732c05.6YuksFSVBUVLHtGM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbcF2CBm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:01:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, emunson@akamai.com, shuahkh@osg.samsung.com, sjayaram@akamai.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm/compaction_test: fix write to restore nr_hugepages
has been removed from the -mm tree.  Its filename was
     selftests-vm-compaction_test-fix-write-to-restore-nr_hugepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: selftests/vm/compaction_test: fix write to restore nr_hugepages

The write at the end of the test to restore nr_hugepages to its previous
value is failing.  This is because it is trying to write the number of
bytes in the char array as opposed to the number of bytes in the string.

Link: http://lkml.kernel.org/r/1465331205-3284-1-git-send-email-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Sri Jayaramappa <sjayaram@akamai.com>
Cc: Eric B Munson <emunson@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/compaction_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/vm/compaction_test.c~selftests-vm-compaction_test-fix-write-to-restore-nr_hugepages tools/testing/selftests/vm/compaction_test.c
--- a/tools/testing/selftests/vm/compaction_test.c~selftests-vm-compaction_test-fix-write-to-restore-nr_hugepages
+++ a/tools/testing/selftests/vm/compaction_test.c
@@ -136,7 +136,7 @@ int check_compaction(unsigned long mem_f
 	printf("No of huge pages allocated = %d\n",
 	       (atoi(nr_hugepages)));
 
-	if (write(fd, initial_nr_hugepages, sizeof(initial_nr_hugepages))
+	if (write(fd, initial_nr_hugepages, strlen(initial_nr_hugepages))
 	    != strlen(initial_nr_hugepages)) {
 		perror("Failed to write to /proc/sys/vm/nr_hugepages\n");
 		goto close_fd;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


