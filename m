From: akpm@linux-foundation.org
Subject: [patch 06/15] selftests/vm: add missed tests in run_vmtests
Date: Thu, 20 Feb 2020 20:04:06 -0800
Message-ID: <20200221040406.1TcNd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729371AbgBUEEI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Feb 2020 23:04:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: urezki@gmail.com, shuah@kernel.org, mhiramat@kernel.org, sjpark@amazon.de, akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org

From: SeongJae Park <sjpark@amazon.de>
Subject: selftests/vm: add missed tests in run_vmtests

The commits introducing 'mlock-random-test'[1], 'map_fiex_noreplace'[2],
and 'thuge-gen'[3] have not added those in the 'run_vmtests' script and
thus the 'run_tests' command of kselftests doesn't run those.  This commit
adds those in the script.

'gup_benchmark' and 'transhuge-stress' are also not included in the
'run_vmtests', but this commit does not add those because those are for
performance measurement rather than pass/fail tests.

[1] commit 26b4224d9961 ("selftests: expanding more mlock selftest")
[2] commit 91cbacc34512 ("tools/testing/selftests/vm/map_fixed_noreplace.c: add test for MAP_FIXED_NOREPLACE")
[3] commit fcc1f2d5dd34 ("selftests: add a test program for variable huge page sizes in mmap/shmget")

Link: http://lkml.kernel.org/r/20200206085144.29126-1-sj38.park@gmail.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests |   33 +++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/tools/testing/selftests/vm/run_vmtests~selftests-vm-add-missed-tests-in-run_vmtests
+++ a/tools/testing/selftests/vm/run_vmtests
@@ -112,6 +112,17 @@ echo "NOTE: The above hugetlb tests prov
 echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for"
 echo "      hugetlb regression testing."
 
+echo "---------------------------"
+echo "running map_fixed_noreplace"
+echo "---------------------------"
+./map_fixed_noreplace
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
 echo "-------------------"
 echo "running userfaultfd"
 echo "-------------------"
@@ -186,6 +197,17 @@ else
 	echo "[PASS]"
 fi
 
+echo "-------------------------"
+echo "running mlock-random-test"
+echo "-------------------------"
+./mlock-random-test
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
 echo "--------------------"
 echo "running mlock2-tests"
 echo "--------------------"
@@ -193,6 +215,17 @@ echo "--------------------"
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
 	exitcode=1
+else
+	echo "[PASS]"
+fi
+
+echo "-----------------"
+echo "running thuge-gen"
+echo "-----------------"
+./thuge-gen
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
 else
 	echo "[PASS]"
 fi
_
