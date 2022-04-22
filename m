Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D972C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 22:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiDVWa6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 18:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbiDVWaT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 18:30:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB90338274
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 14:56:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F025B83272
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 21:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA2AC385A0;
        Fri, 22 Apr 2022 21:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650664572;
        bh=Yf3Mvz/hub8txMv8Jag8RMHmxwS6PAxUblNaeumU0cc=;
        h=Date:To:From:Subject:From;
        b=qijCXsAVytvZGzeAzIbjlV81MNGZ3v2lYpx1Gy/7BDtXQmHtFyVa3M0jH52ic8qDQ
         lRxsvCMlz9btMc33Wz25r7o+jRBuPlrQ3S5G/YlfR48mQsZyXy8T1+F+/y89I4U8hh
         qAiRPnyD5cBlA9J4BBPiEdC1zj7VeJOfurj5BOCI=
Date:   Fri, 22 Apr 2022 14:56:11 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-refactor-run_vmtestssh-to-reduce-boilerplate.patch added to -mm tree
Message-Id: <20220422215612.3AA2AC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: refactor run_vmtests.sh to reduce boilerplate
has been added to the -mm tree.  Its filename is
     selftests-vm-refactor-run_vmtestssh-to-reduce-boilerplate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-refactor-run_vmtestssh-to-reduce-boilerplate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-refactor-run_vmtestssh-to-reduce-boilerplate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: selftests: vm: refactor run_vmtests.sh to reduce boilerplate

Previously, each test printed out its own header, dealt with its own
return code, etc.  By just putting this standard stuff in a function, we
can delete > 300 lines from the script.

This also makes adding future tests easier. And, it gets rid of various
inconsistencies that already exist:

- Some tests correctly deal with ksft_skip, but others don't.
- Some tests just print the executable name, others print arguments, and
  yet others print some comment in the header.
- Most tests print out a header with two separator lines, but not the
  HMM smoke test or the memfd_secret test, which only print one.
- We had a redundant "exit" at the end, with all the boilerplate it's an
  easy oversight.

Link: https://lkml.kernel.org/r/20220421224928.1848230-1-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests.sh |  509 +++-----------------
 1 file changed, 79 insertions(+), 430 deletions(-)

--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-refactor-run_vmtestssh-to-reduce-boilerplate
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -66,467 +66,116 @@ fi
 VADDR64=0
 echo "$ARCH64STR" | grep $ARCH && VADDR64=1
 
+# Usage: run_test [test binary] [arbitrary test arguments...]
+run_test() {
+	local title="running $*"
+	local sep=$(echo -n "$title" | tr "[:graph:][:space:]" -)
+	printf "%s\n%s\n%s\n" "$sep" "$title" "$sep"
+
+	"$@"
+	local ret=$?
+	if [ $ret -eq 0 ]; then
+		echo "[PASS]"
+	elif [ $ret -eq $ksft_skip ]; then
+		echo "[SKIP]"
+		exitcode=$ksft_skip
+	else
+		echo "[FAIL]"
+		exitcode=1
+	fi
+}
+
 mkdir $mnt
 mount -t hugetlbfs none $mnt
 
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
+run_test ./hugepage-mmap
 
 shmmax=`cat /proc/sys/kernel/shmmax`
 shmall=`cat /proc/sys/kernel/shmall`
 echo 268435456 > /proc/sys/kernel/shmmax
 echo 4194304 > /proc/sys/kernel/shmall
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
+run_test ./hugepage-shm
 echo $shmmax > /proc/sys/kernel/shmmax
 echo $shmall > /proc/sys/kernel/shmall
 
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
-echo "-----------------------"
-echo "running hugepage-mremap"
-echo "-----------------------"
-./hugepage-mremap $mnt/huge_mremap
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
+run_test ./map_hugetlb
+
+run_test ./hugepage-mremap $mnt/huge_mremap
 rm -f $mnt/huge_mremap
 
-echo "------------------------"
-echo "running hugepage-vmemmap"
-echo "------------------------"
-./hugepage-vmemmap
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
-
-echo "-----------------------"
-echo "running hugetlb-madvise"
-echo "-----------------------"
-./hugetlb-madvise $mnt/madvise-test
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
+run_test ./hugepage-vmemmap
+
+run_test ./hugetlb-madvise $mnt/madvise-test
 rm -f $mnt/madvise-test
 
 echo "NOTE: The above hugetlb tests provide minimal coverage.  Use"
 echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for"
 echo "      hugetlb regression testing."
 
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
-echo "------------------------------------------------------"
-echo "running: gup_test -a # pin_user_pages_fast() benchmark"
-echo "------------------------------------------------------"
-./gup_test -a
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
-echo "------------------------------------------------------------"
-echo "# Dump pages 0, 19, and 4096, using pin_user_pages:"
-echo "running: gup_test -ct -F 0x1 0 19 0x1000 # dump_page() test"
-echo "------------------------------------------------------------"
-./gup_test -ct -F 0x1 0 19 0x1000
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
+run_test ./map_fixed_noreplace
+
+# get_user_pages_fast() benchmark
+run_test ./gup_test -u
+# pin_user_pages_fast() benchmark
+run_test ./gup_test -a
+# Dump pages 0, 19, and 4096, using pin_user_pages:
+run_test ./gup_test -ct -F 0x1 0 19 0x1000
+
+run_test ./userfaultfd anon 20 16
 # Test requires source and destination huge pages.  Size of source
 # (half_ufd_size_MB) is passed as argument to test.
-./userfaultfd hugetlb $half_ufd_size_MB 32
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=1
-else
-	echo "[PASS]"
-fi
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
+run_test ./userfaultfd hugetlb $half_ufd_size_MB 32
+run_test ./userfaultfd shmem 20 16
 
 #cleanup
 umount $mnt
 rm -rf $mnt
 echo $nr_hugepgs > /proc/sys/vm/nr_hugepages
 
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
+run_test ./compaction_test
+
+run_test sudo -u nobody ./on-fault-limit
+
+run_test ./map_populate
+
+run_test ./mlock-random-test
+
+run_test ./mlock2-tests
+
+run_test ./mremap_test
+
+run_test ./thuge-gen
 
 if [ $VADDR64 -ne 0 ]; then
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
+	run_test ./virtual_address_range
+
+	# virtual address 128TB switch test
+	run_test ./va_128TBswitch
 fi # VADDR64
 
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
-echo "--------------------------------------------------------"
-echo "running MADV_POPULATE_READ and MADV_POPULATE_WRITE tests"
-echo "--------------------------------------------------------"
-./madv_populate
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
-echo "running memfd_secret test"
-echo "------------------------------------"
-./memfd_secret
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
-echo "-------------------------------------------------------"
-echo "running KSM MADV_MERGEABLE test with 10 identical pages"
-echo "-------------------------------------------------------"
-./ksm_tests -M -p 10
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
-echo "------------------------"
-echo "running KSM unmerge test"
-echo "------------------------"
-./ksm_tests -U
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
-echo "----------------------------------------------------------"
-echo "running KSM test with 10 zero pages and use_zero_pages = 0"
-echo "----------------------------------------------------------"
-./ksm_tests -Z -p 10 -z 0
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
-echo "----------------------------------------------------------"
-echo "running KSM test with 10 zero pages and use_zero_pages = 1"
-echo "----------------------------------------------------------"
-./ksm_tests -Z -p 10 -z 1
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
-echo "-------------------------------------------------------------"
-echo "running KSM test with 2 NUMA nodes and merge_across_nodes = 1"
-echo "-------------------------------------------------------------"
-./ksm_tests -N -m 1
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
-echo "-------------------------------------------------------------"
-echo "running KSM test with 2 NUMA nodes and merge_across_nodes = 0"
-echo "-------------------------------------------------------------"
-./ksm_tests -N -m 0
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
+# vmalloc stability smoke test
+run_test ./test_vmalloc.sh smoke
 
-exit $exitcode
+run_test ./mremap_dontunmap
+
+run_test ./test_hmm.sh smoke
+
+# MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
+run_test ./madv_populate
+
+run_test ./memfd_secret
+
+# KSM MADV_MERGEABLE test with 10 identical pages
+run_test ./ksm_tests -M -p 10
+# KSM unmerge test
+run_test ./ksm_tests -U
+# KSM test with 10 zero pages and use_zero_pages = 0
+run_test ./ksm_tests -Z -p 10 -z 0
+# KSM test with 10 zero pages and use_zero_pages = 1
+run_test ./ksm_tests -Z -p 10 -z 1
+# KSM test with 2 NUMA nodes and merge_across_nodes = 1
+run_test ./ksm_tests -N -m 1
+# KSM test with 2 NUMA nodes and merge_across_nodes = 0
+run_test ./ksm_tests -N -m 0
 
 exit $exitcode
_

Patches currently in -mm which might be from axelrasmussen@google.com are

selftests-vm-refactor-run_vmtestssh-to-reduce-boilerplate.patch
selftests-vm-fix-shellcheck-warnings-in-run_vmtestssh.patch

