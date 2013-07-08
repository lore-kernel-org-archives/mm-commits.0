From: akpm@linux-foundation.org
Subject: [merged] selftests-exit-1-on-failure.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:22 -0700
Message-ID: <51db14f2.PFBG1n+L7KTbIYVa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab3GHThW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joern@logfs.org

Subject: [merged] selftests-exit-1-on-failure.patch removed from -mm tree
To: joern@logfs.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:22 -0700


The patch titled
     Subject: selftests: exit 1 on failure
has been removed from the -mm tree.  Its filename was
     selftests-exit-1-on-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joern Engel <joern@logfs.org>
Subject: selftests: exit 1 on failure

In case this ever gets scripted, it should return 0 on success and 1 on
failure.  Parsing the output should be left to meatbags.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile    |    2 +-
 tools/testing/selftests/vm/run_vmtests |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN tools/testing/selftests/vm/Makefile~selftests-exit-1-on-failure tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~selftests-exit-1-on-failure
+++ a/tools/testing/selftests/vm/Makefile
@@ -8,7 +8,7 @@ all: hugepage-mmap hugepage-shm  map_hug
 	$(CC) $(CFLAGS) -o $@ $^
 
 run_tests: all
-	@/bin/sh ./run_vmtests || echo "vmtests: [FAIL]"
+	@/bin/sh ./run_vmtests || (echo "vmtests: [FAIL]"; exit 1)
 
 clean:
 	$(RM) hugepage-mmap hugepage-shm  map_hugetlb
diff -puN tools/testing/selftests/vm/run_vmtests~selftests-exit-1-on-failure tools/testing/selftests/vm/run_vmtests
--- a/tools/testing/selftests/vm/run_vmtests~selftests-exit-1-on-failure
+++ a/tools/testing/selftests/vm/run_vmtests
@@ -4,6 +4,7 @@
 #we need 256M, below is the size in kB
 needmem=262144
 mnt=./huge
+exitcode=0
 
 #get pagesize and freepages from /proc/meminfo
 while read name size unit; do
@@ -41,6 +42,7 @@ echo "--------------------"
 ./hugepage-mmap
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
+	exitcode=1
 else
 	echo "[PASS]"
 fi
@@ -55,6 +57,7 @@ echo "--------------------"
 ./hugepage-shm
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
+	exitcode=1
 else
 	echo "[PASS]"
 fi
@@ -67,6 +70,7 @@ echo "--------------------"
 ./map_hugetlb
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
+	exitcode=1
 else
 	echo "[PASS]"
 fi
@@ -75,3 +79,4 @@ fi
 umount $mnt
 rm -rf $mnt
 echo $nr_hugepgs > /proc/sys/vm/nr_hugepages
+exit $exitcode
_

Patches currently in -mm which might be from joern@logfs.org are

origin.patch
linux-next.patch
mmap-allow-map_hugetlb-for-hugetlbfs-files-v2.patch

