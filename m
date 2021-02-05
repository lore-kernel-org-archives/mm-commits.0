Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 716BDC433DB
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 21:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3008064F91
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 21:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhBEVx0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 16:53:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232862AbhBEVw4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 16:52:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C34FC64F91;
        Fri,  5 Feb 2021 21:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612561934;
        bh=jDEky/rjddP8cEfnomimDYuH16JXlCrm3LcukArjYQw=;
        h=Date:From:To:Subject:From;
        b=z3R9z7NdREHzEOc8rOjtrEl9lLCbL5TPyniMugyqolseH+79Y5htq5XvdGN52/7dE
         1EGNG/0WLBfmACfydLgIZ+uj/AAybxZfEvOS3VT8t6ASNxxj5yiYyuqJ2VmNbtH+OA
         mdLVdn6PQ/Pa29YTsCGH1Syg2m31iIvgNnBkHqQo=
Date:   Fri, 05 Feb 2021 13:52:13 -0800
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, lkp@intel.com, mm-commits@vger.kernel.org,
        rong.a.chen@intel.com
Subject:  +
 selftests-vm-rename-file-run_vmtests-to-run_vmtestssh.patch added to -mm
 tree
Message-ID: <20210205215213.I_YNGJam1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: rename file run_vmtests to run_vmtests.sh
has been added to the -mm tree.  Its filename is
     selftests-vm-rename-file-run_vmtests-to-run_vmtestssh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-rename-file-run_vmtests-to-run_vmtestssh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-rename-file-run_vmtests-to-run_vmtestssh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rong Chen <rong.a.chen@intel.com>
Subject: selftests/vm: rename file run_vmtests to run_vmtests.sh

Commit c2aa8afc36fa has renamed run_vmtests in Makefile, but the file
still uses the old name.

The kernel test robot reported the following issue:

 # selftests: vm: run_vmtests.sh
 # Warning: file run_vmtests.sh is missing!
 not ok 1 selftests: vm: run_vmtests.sh

Link: https://lkml.kernel.org/r/20210205085507.1479894-1-rong.a.chen@intel.com
Fixes: c2aa8afc36fa (selftests/vm: rename run_vmtests --> run_vmtests.sh)
Signed-off-by: Rong Chen <rong.a.chen@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests    |  349 --------------------
 tools/testing/selftests/vm/run_vmtests.sh |  349 ++++++++++++++++++++
 2 files changed, 349 insertions(+), 349 deletions(-)

--- a/tools/testing/selftests/vm/run_vmtests
+++ /dev/null
@@ -1,349 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-#please run as root
-
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-
-mnt=./huge
-exitcode=0
-
-#get huge pagesize and freepages from /proc/meminfo
-while read name size unit; do
-	if [ "$name" = "HugePages_Free:" ]; then
-		freepgs=$size
-	fi
-	if [ "$name" = "Hugepagesize:" ]; then
-		hpgsize_KB=$size
-	fi
-done < /proc/meminfo
-
-# Simple hugetlbfs tests have a hardcoded minimum requirement of
-# huge pages totaling 256MB (262144KB) in size.  The userfaultfd
-# hugetlb test requires a minimum of 2 * nr_cpus huge pages.  Take
-# both of these requirements into account and attempt to increase
-# number of huge pages available.
-nr_cpus=$(nproc)
-hpgsize_MB=$((hpgsize_KB / 1024))
-half_ufd_size_MB=$((((nr_cpus * hpgsize_MB + 127) / 128) * 128))
-needmem_KB=$((half_ufd_size_MB * 2 * 1024))
-
-#set proper nr_hugepages
-if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
-	nr_hugepgs=`cat /proc/sys/vm/nr_hugepages`
-	needpgs=$((needmem_KB / hpgsize_KB))
-	tries=2
-	while [ $tries -gt 0 ] && [ $freepgs -lt $needpgs ]; do
-		lackpgs=$(( $needpgs - $freepgs ))
-		echo 3 > /proc/sys/vm/drop_caches
-		echo $(( $lackpgs + $nr_hugepgs )) > /proc/sys/vm/nr_hugepages
-		if [ $? -ne 0 ]; then
-			echo "Please run this test as root"
-			exit $ksft_skip
-		fi
-		while read name size unit; do
-			if [ "$name" = "HugePages_Free:" ]; then
-				freepgs=$size
-			fi
-		done < /proc/meminfo
-		tries=$((tries - 1))
-	done
-	if [ $freepgs -lt $needpgs ]; then
-		printf "Not enough huge pages available (%d < %d)\n" \
-		       $freepgs $needpgs
-		exit 1
-	fi
-else
-	echo "no hugetlbfs support in kernel?"
-	exit 1
-fi
-
-#filter 64bit architectures
-ARCH64STR="arm64 ia64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sh64 sparc64 x86_64"
-if [ -z $ARCH ]; then
-  ARCH=`uname -m 2>/dev/null | sed -e 's/aarch64.*/arm64/'`
-fi
-VADDR64=0
-echo "$ARCH64STR" | grep $ARCH && VADDR64=1
-
-mkdir $mnt
-mount -t hugetlbfs none $mnt
-
-echo "---------------------"
-echo "running hugepage-mmap"
-echo "---------------------"
-./hugepage-mmap
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-
-shmmax=`cat /proc/sys/kernel/shmmax`
-shmall=`cat /proc/sys/kernel/shmall`
-echo 268435456 > /proc/sys/kernel/shmmax
-echo 4194304 > /proc/sys/kernel/shmall
-echo "--------------------"
-echo "running hugepage-shm"
-echo "--------------------"
-./hugepage-shm
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-echo $shmmax > /proc/sys/kernel/shmmax
-echo $shmall > /proc/sys/kernel/shmall
-
-echo "-------------------"
-echo "running map_hugetlb"
-echo "-------------------"
-./map_hugetlb
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-
-echo "NOTE: The above hugetlb tests provide minimal coverage.  Use"
-echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for"
-echo "      hugetlb regression testing."
-
-echo "---------------------------"
-echo "running map_fixed_noreplace"
-echo "---------------------------"
-./map_fixed_noreplace
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-
-echo "------------------------------------------------------"
-echo "running: gup_test -u # get_user_pages_fast() benchmark"
-echo "------------------------------------------------------"
-./gup_test -u
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-
-echo "------------------------------------------------------"
-echo "running: gup_test -a # pin_user_pages_fast() benchmark"
-echo "------------------------------------------------------"
-./gup_test -a
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-
-echo "------------------------------------------------------------"
-echo "# Dump pages 0, 19, and 4096, using pin_user_pages:"
-echo "running: gup_test -ct -F 0x1 0 19 0x1000 # dump_page() test"
-echo "------------------------------------------------------------"
-./gup_test -ct -F 0x1 0 19 0x1000
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-
-echo "-------------------"
-echo "running userfaultfd"
-echo "-------------------"
-./userfaultfd anon 20 16
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-
-echo "---------------------------"
-echo "running userfaultfd_hugetlb"
-echo "---------------------------"
-# Test requires source and destination huge pages.  Size of source
-# (half_ufd_size_MB) is passed as argument to test.
-./userfaultfd hugetlb $half_ufd_size_MB 32 $mnt/ufd_test_file
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-rm -f $mnt/ufd_test_file
-
-echo "-------------------------"
-echo "running userfaultfd_shmem"
-echo "-------------------------"
-./userfaultfd shmem 20 16
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-
-#cleanup
-umount $mnt
-rm -rf $mnt
-echo $nr_hugepgs > /proc/sys/vm/nr_hugepages
-
-echo "-----------------------"
-echo "running compaction_test"
-echo "-----------------------"
-./compaction_test
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-
-echo "----------------------"
-echo "running on-fault-limit"
-echo "----------------------"
-sudo -u nobody ./on-fault-limit
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-
-echo "--------------------"
-echo "running map_populate"
-echo "--------------------"
-./map_populate
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-
-echo "-------------------------"
-echo "running mlock-random-test"
-echo "-------------------------"
-./mlock-random-test
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-
-echo "--------------------"
-echo "running mlock2-tests"
-echo "--------------------"
-./mlock2-tests
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-
-echo "-------------------"
-echo "running mremap_test"
-echo "-------------------"
-./mremap_test
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-
-echo "-----------------"
-echo "running thuge-gen"
-echo "-----------------"
-./thuge-gen
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-
-if [ $VADDR64 -ne 0 ]; then
-echo "-----------------------------"
-echo "running virtual_address_range"
-echo "-----------------------------"
-./virtual_address_range
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-
-echo "-----------------------------"
-echo "running virtual address 128TB switch test"
-echo "-----------------------------"
-./va_128TBswitch
-if [ $? -ne 0 ]; then
-    echo "[FAIL]"
-    exitcode=1
-else
-    echo "[PASS]"
-fi
-fi # VADDR64
-
-echo "------------------------------------"
-echo "running vmalloc stability smoke test"
-echo "------------------------------------"
-./test_vmalloc.sh smoke
-ret_val=$?
-
-if [ $ret_val -eq 0 ]; then
-	echo "[PASS]"
-elif [ $ret_val -eq $ksft_skip ]; then
-	 echo "[SKIP]"
-	 exitcode=$ksft_skip
-else
-	echo "[FAIL]"
-	exitcode=1
-fi
-
-echo "------------------------------------"
-echo "running MREMAP_DONTUNMAP smoke test"
-echo "------------------------------------"
-./mremap_dontunmap
-ret_val=$?
-
-if [ $ret_val -eq 0 ]; then
-	echo "[PASS]"
-elif [ $ret_val -eq $ksft_skip ]; then
-	 echo "[SKIP]"
-	 exitcode=$ksft_skip
-else
-	echo "[FAIL]"
-	exitcode=1
-fi
-
-echo "running HMM smoke test"
-echo "------------------------------------"
-./test_hmm.sh smoke
-ret_val=$?
-
-if [ $ret_val -eq 0 ]; then
-	echo "[PASS]"
-elif [ $ret_val -eq $ksft_skip ]; then
-	echo "[SKIP]"
-	exitcode=$ksft_skip
-else
-	echo "[FAIL]"
-	exitcode=1
-fi
-
-exit $exitcode
--- /dev/null
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -0,0 +1,349 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#please run as root
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+mnt=./huge
+exitcode=0
+
+#get huge pagesize and freepages from /proc/meminfo
+while read name size unit; do
+	if [ "$name" = "HugePages_Free:" ]; then
+		freepgs=$size
+	fi
+	if [ "$name" = "Hugepagesize:" ]; then
+		hpgsize_KB=$size
+	fi
+done < /proc/meminfo
+
+# Simple hugetlbfs tests have a hardcoded minimum requirement of
+# huge pages totaling 256MB (262144KB) in size.  The userfaultfd
+# hugetlb test requires a minimum of 2 * nr_cpus huge pages.  Take
+# both of these requirements into account and attempt to increase
+# number of huge pages available.
+nr_cpus=$(nproc)
+hpgsize_MB=$((hpgsize_KB / 1024))
+half_ufd_size_MB=$((((nr_cpus * hpgsize_MB + 127) / 128) * 128))
+needmem_KB=$((half_ufd_size_MB * 2 * 1024))
+
+#set proper nr_hugepages
+if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
+	nr_hugepgs=`cat /proc/sys/vm/nr_hugepages`
+	needpgs=$((needmem_KB / hpgsize_KB))
+	tries=2
+	while [ $tries -gt 0 ] && [ $freepgs -lt $needpgs ]; do
+		lackpgs=$(( $needpgs - $freepgs ))
+		echo 3 > /proc/sys/vm/drop_caches
+		echo $(( $lackpgs + $nr_hugepgs )) > /proc/sys/vm/nr_hugepages
+		if [ $? -ne 0 ]; then
+			echo "Please run this test as root"
+			exit $ksft_skip
+		fi
+		while read name size unit; do
+			if [ "$name" = "HugePages_Free:" ]; then
+				freepgs=$size
+			fi
+		done < /proc/meminfo
+		tries=$((tries - 1))
+	done
+	if [ $freepgs -lt $needpgs ]; then
+		printf "Not enough huge pages available (%d < %d)\n" \
+		       $freepgs $needpgs
+		exit 1
+	fi
+else
+	echo "no hugetlbfs support in kernel?"
+	exit 1
+fi
+
+#filter 64bit architectures
+ARCH64STR="arm64 ia64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sh64 sparc64 x86_64"
+if [ -z $ARCH ]; then
+  ARCH=`uname -m 2>/dev/null | sed -e 's/aarch64.*/arm64/'`
+fi
+VADDR64=0
+echo "$ARCH64STR" | grep $ARCH && VADDR64=1
+
+mkdir $mnt
+mount -t hugetlbfs none $mnt
+
+echo "---------------------"
+echo "running hugepage-mmap"
+echo "---------------------"
+./hugepage-mmap
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
+shmmax=`cat /proc/sys/kernel/shmmax`
+shmall=`cat /proc/sys/kernel/shmall`
+echo 268435456 > /proc/sys/kernel/shmmax
+echo 4194304 > /proc/sys/kernel/shmall
+echo "--------------------"
+echo "running hugepage-shm"
+echo "--------------------"
+./hugepage-shm
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+echo $shmmax > /proc/sys/kernel/shmmax
+echo $shmall > /proc/sys/kernel/shmall
+
+echo "-------------------"
+echo "running map_hugetlb"
+echo "-------------------"
+./map_hugetlb
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
+echo "NOTE: The above hugetlb tests provide minimal coverage.  Use"
+echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for"
+echo "      hugetlb regression testing."
+
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
+echo "------------------------------------------------------"
+echo "running: gup_test -u # get_user_pages_fast() benchmark"
+echo "------------------------------------------------------"
+./gup_test -u
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
+echo "------------------------------------------------------"
+echo "running: gup_test -a # pin_user_pages_fast() benchmark"
+echo "------------------------------------------------------"
+./gup_test -a
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
+echo "------------------------------------------------------------"
+echo "# Dump pages 0, 19, and 4096, using pin_user_pages:"
+echo "running: gup_test -ct -F 0x1 0 19 0x1000 # dump_page() test"
+echo "------------------------------------------------------------"
+./gup_test -ct -F 0x1 0 19 0x1000
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
+echo "-------------------"
+echo "running userfaultfd"
+echo "-------------------"
+./userfaultfd anon 20 16
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
+echo "---------------------------"
+echo "running userfaultfd_hugetlb"
+echo "---------------------------"
+# Test requires source and destination huge pages.  Size of source
+# (half_ufd_size_MB) is passed as argument to test.
+./userfaultfd hugetlb $half_ufd_size_MB 32 $mnt/ufd_test_file
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+rm -f $mnt/ufd_test_file
+
+echo "-------------------------"
+echo "running userfaultfd_shmem"
+echo "-------------------------"
+./userfaultfd shmem 20 16
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
+#cleanup
+umount $mnt
+rm -rf $mnt
+echo $nr_hugepgs > /proc/sys/vm/nr_hugepages
+
+echo "-----------------------"
+echo "running compaction_test"
+echo "-----------------------"
+./compaction_test
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
+echo "----------------------"
+echo "running on-fault-limit"
+echo "----------------------"
+sudo -u nobody ./on-fault-limit
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
+echo "--------------------"
+echo "running map_populate"
+echo "--------------------"
+./map_populate
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
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
+echo "--------------------"
+echo "running mlock2-tests"
+echo "--------------------"
+./mlock2-tests
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
+echo "-------------------"
+echo "running mremap_test"
+echo "-------------------"
+./mremap_test
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
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
+else
+	echo "[PASS]"
+fi
+
+if [ $VADDR64 -ne 0 ]; then
+echo "-----------------------------"
+echo "running virtual_address_range"
+echo "-----------------------------"
+./virtual_address_range
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
+echo "-----------------------------"
+echo "running virtual address 128TB switch test"
+echo "-----------------------------"
+./va_128TBswitch
+if [ $? -ne 0 ]; then
+    echo "[FAIL]"
+    exitcode=1
+else
+    echo "[PASS]"
+fi
+fi # VADDR64
+
+echo "------------------------------------"
+echo "running vmalloc stability smoke test"
+echo "------------------------------------"
+./test_vmalloc.sh smoke
+ret_val=$?
+
+if [ $ret_val -eq 0 ]; then
+	echo "[PASS]"
+elif [ $ret_val -eq $ksft_skip ]; then
+	 echo "[SKIP]"
+	 exitcode=$ksft_skip
+else
+	echo "[FAIL]"
+	exitcode=1
+fi
+
+echo "------------------------------------"
+echo "running MREMAP_DONTUNMAP smoke test"
+echo "------------------------------------"
+./mremap_dontunmap
+ret_val=$?
+
+if [ $ret_val -eq 0 ]; then
+	echo "[PASS]"
+elif [ $ret_val -eq $ksft_skip ]; then
+	 echo "[SKIP]"
+	 exitcode=$ksft_skip
+else
+	echo "[FAIL]"
+	exitcode=1
+fi
+
+echo "running HMM smoke test"
+echo "------------------------------------"
+./test_hmm.sh smoke
+ret_val=$?
+
+if [ $ret_val -eq 0 ]; then
+	echo "[PASS]"
+elif [ $ret_val -eq $ksft_skip ]; then
+	echo "[SKIP]"
+	exitcode=$ksft_skip
+else
+	echo "[FAIL]"
+	exitcode=1
+fi
+
+exit $exitcode
_

Patches currently in -mm which might be from rong.a.chen@intel.com are

selftests-vm-rename-file-run_vmtests-to-run_vmtestssh.patch

