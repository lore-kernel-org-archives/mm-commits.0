From: akpm@linux-foundation.org
Subject: [patch 03/41] selftests/vm/compaction_test: fix write to restore
 nr_hugepages
Date: Fri, 24 Jun 2016 14:48:40 -0700
Message-ID: <576daab8.pNXka9rrMPcwbiN7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbcFXVsl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:48:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mike.kravetz@oracle.com, emunson@akamai.com, shuahkh@osg.samsung.com, sjayaram@akamai.com

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
