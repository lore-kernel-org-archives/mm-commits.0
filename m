Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FDDC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 23:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiJRXZd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 19:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJRXZc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 19:25:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC548983F
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 16:25:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19CFFB821A1
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 23:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3575C433D6;
        Tue, 18 Oct 2022 23:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666135527;
        bh=Ta7KL9lRQo24S3eCcLl7VSl+Adns+A9/6b5aQ9oqaqc=;
        h=Date:To:From:Subject:From;
        b=JTuzAGBGckAUhktC8rzCVrcZVIo0hBDCMZlf2mc3HeiHTsxqa4o2yTAwMpM9V69fH
         eInxM1mvDVHjdzNjUiFKXQbnsDwWLQFlwzJQhdkHDM/YCcRIISSCwKhf0oMs9PQ1b2
         A2z1WcG/bsjo8o+VjCs6Tz+YcY5XtOFhMrTHBh+I=
Date:   Tue, 18 Oct 2022 16:25:26 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, npache@redhat.com,
        jsavitz@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-enable-running-select-groups-of-tests.patch added to mm-unstable branch
Message-Id: <20221018232527.B3575C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: enable running select groups of tests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-enable-running-select-groups-of-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-enable-running-select-groups-of-tests.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Joel Savitz <jsavitz@redhat.com>
Subject: selftests/vm: enable running select groups of tests
Date: Tue, 18 Oct 2022 19:12:22 -0400

Our memory management kernel CI testing at Red Hat uses the VM
selftests and we have run into two problems:

First, our LTP tests overlap with the VM selftests.

We want to avoid unhelpful redundancy in our testing practices.

Second, we have observed the current run_vmtests.sh to report overall
failure/ambiguous results in the case that a machine lacks the necessary
hardware to perform one or more of the tests. E.g. ksm tests that
require more than one numa node.

We want to be able to run the vm selftests suitable to particular hardware.

Add the ability to run one or more groups of vm tests via run_vmtests.sh
instead of simply all-or-none in order to solve these problems.

Preserve existing default behavior of running all tests when the script
is invoked with no arguments.

Documentation of test groups is included in the patch as follows:

    # ./run_vmtests.sh [ -h || --help ]

    usage: ./tools/testing/selftests/vm/run_vmtests.sh [ -h | -t "<categories>"]
      -t: specify specific categories to tests to run
      -h: display this message

    The default behavior is to run all tests.

    Alternatively, specific groups tests can be run by passing a string
    to the -t argument containing one or more of the following categories
    separated by spaces:
    - mmap
	    tests for mmap(2)
    - gup_test
	    tests for gup using gup_test interface
    - userfaultfd
	    tests for  userfaultfd(2)
    - compaction
	    a test for the patch "Allow compaction of unevictable pages"
    - mlock
	    tests for mlock(2)
    - mremap
	    tests for mremap(2)
    - hugevm
	    tests for very large virtual address space
    - vmalloc
	    vmalloc smoke tests
    - hmm
	    hmm smoke tests
    - madv_populate
	    test memadvise(2) MADV_POPULATE_{READ,WRITE} options
    - memfd_secret
	    test memfd_secret(2)
    - process_mrelease
	    test process_mrelease(2)
    - ksm
	    ksm tests that do not require >=2 NUMA nodes
    - ksm_numa
	    ksm tests that require >=2 NUMA nodes
    - pkey
	    memory protection key tests
    - soft_dirty
    	    test soft dirty page bit semantics
    - anon_cow
            test anonymous copy-on-write semantics
    example: ./run_vmtests.sh -t "hmm mmap ksm"

Link: https://lkml.kernel.org/r/20221018231222.1884715-1-jsavitz@redhat.com
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Cc: Joel Savitz <jsavitz@redhat.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests.sh |  218 +++++++++++++-------
 1 file changed, 149 insertions(+), 69 deletions(-)

--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-enable-running-select-groups-of-tests
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -1,21 +1,86 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
-#please run as root
+# Please run as root
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
 exitcode=0
 
-#get huge pagesize and freepages from /proc/meminfo
-while read -r name size unit; do
-	if [ "$name" = "HugePages_Free:" ]; then
-		freepgs="$size"
+usage() {
+	cat <<EOF
+usage: ${BASH_SOURCE[0]:-$0} [ -h | -t "<categories>"]
+  -t: specify specific categories to tests to run
+  -h: display this message
+
+The default behavior is to run all tests.
+
+Alternatively, specific groups tests can be run by passing a string
+to the -t argument containing one or more of the following categories
+separated by spaces:
+- mmap
+	tests for mmap(2)
+- gup_test
+	tests for gup using gup_test interface
+- userfaultfd
+	tests for  userfaultfd(2)
+- compaction
+	a test for the patch "Allow compaction of unevictable pages"
+- mlock
+	tests for mlock(2)
+- mremap
+	tests for mremap(2)
+- hugevm
+	tests for very large virtual address space
+- vmalloc
+	vmalloc smoke tests
+- hmm
+	hmm smoke tests
+- madv_populate
+	test memadvise(2) MADV_POPULATE_{READ,WRITE} options
+- memfd_secret
+	test memfd_secret(2)
+- process_mrelease
+	test process_mrelease(2)
+- ksm
+	ksm tests that do not require >=2 NUMA nodes
+- ksm_numa
+	ksm tests that require >=2 NUMA nodes
+- pkey
+	memory protection key tests
+- soft_dirty
+	test soft dirty page bit semantics
+- anon_cow
+	test anonymous copy-on-write semantics
+example: ./run_vmtests.sh -t "hmm mmap ksm"
+EOF
+	exit 0
+}
+
+
+while getopts "ht:" OPT; do
+	case ${OPT} in
+		"h") usage ;;
+		"t") VM_SELFTEST_ITEMS=${OPTARG} ;;
+	esac
+done
+shift $((OPTIND -1))
+
+# default behavior: run all tests
+VM_SELFTEST_ITEMS=${VM_SELFTEST_ITEMS:-default}
+
+test_selected() {
+	if [ "$VM_SELFTEST_ITEMS" == "default" ]; then
+		# If no VM_SELFTEST_ITEMS are specified, run all tests
+		return 0
 	fi
-	if [ "$name" = "Hugepagesize:" ]; then
-		hpgsize_KB="$size"
+	# If test selected argument is one of the test items
+	if [[ " ${VM_SELFTEST_ITEMS[*]} " =~ " ${1} " ]]; then
+	        return 0
+	else
+	        return 1
 	fi
-done < /proc/meminfo
+}
 
 # Simple hugetlbfs tests have a hardcoded minimum requirement of
 # huge pages totaling 256MB (262144KB) in size.  The userfaultfd
@@ -27,7 +92,17 @@ hpgsize_MB=$((hpgsize_KB / 1024))
 half_ufd_size_MB=$((((nr_cpus * hpgsize_MB + 127) / 128) * 128))
 needmem_KB=$((half_ufd_size_MB * 2 * 1024))
 
-#set proper nr_hugepages
+# get huge pagesize and freepages from /proc/meminfo
+while read -r name size unit; do
+	if [ "$name" = "HugePages_Free:" ]; then
+		freepgs="$size"
+	fi
+	if [ "$name" = "Hugepagesize:" ]; then
+		hpgsize_KB="$size"
+	fi
+done < /proc/meminfo
+
+# set proper nr_hugepages
 if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
 	nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
 	needpgs=$((needmem_KB / hpgsize_KB))
@@ -56,136 +131,141 @@ else
 	exit 1
 fi
 
-#filter 64bit architectures
+# filter 64bit architectures
 ARCH64STR="arm64 ia64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sh64 sparc64 x86_64"
 if [ -z "$ARCH" ]; then
 	ARCH=$(uname -m 2>/dev/null | sed -e 's/aarch64.*/arm64/')
 fi
 VADDR64=0
-echo "$ARCH64STR" | grep "$ARCH" && VADDR64=1
+echo "$ARCH64STR" | grep "$ARCH" &>/dev/null && VADDR64=1
 
 # Usage: run_test [test binary] [arbitrary test arguments...]
 run_test() {
-	local title="running $*"
-	local sep=$(echo -n "$title" | tr "[:graph:][:space:]" -)
-	printf "%s\n%s\n%s\n" "$sep" "$title" "$sep"
-
-	"$@"
-	local ret=$?
-	if [ $ret -eq 0 ]; then
-		echo "[PASS]"
-	elif [ $ret -eq $ksft_skip ]; then
-		echo "[SKIP]"
-		exitcode=$ksft_skip
-	else
-		echo "[FAIL]"
-		exitcode=1
-	fi
+	if test_selected ${CATEGORY}; then
+		echo "running: $1"
+		local title="running $*"
+		local sep=$(echo -n "$title" | tr "[:graph:][:space:]" -)
+		printf "%s\n%s\n%s\n" "$sep" "$title" "$sep"
+
+		"$@"
+		local ret=$?
+		if [ $ret -eq 0 ]; then
+			echo "[PASS]"
+		elif [ $ret -eq $ksft_skip ]; then
+			echo "[SKIP]"
+			exitcode=$ksft_skip
+		else
+			echo "[FAIL]"
+			exitcode=1
+		fi
+	fi # test_selected
 }
 
-run_test ./hugepage-mmap
+CATEGORY="hugetlb" run_test ./hugepage-mmap
 
 shmmax=$(cat /proc/sys/kernel/shmmax)
 shmall=$(cat /proc/sys/kernel/shmall)
 echo 268435456 > /proc/sys/kernel/shmmax
 echo 4194304 > /proc/sys/kernel/shmall
-run_test ./hugepage-shm
+CATEGORY="hugetlb" run_test ./hugepage-shm
 echo "$shmmax" > /proc/sys/kernel/shmmax
 echo "$shmall" > /proc/sys/kernel/shmall
 
-run_test ./map_hugetlb
-run_test ./hugepage-mremap
-run_test ./hugepage-vmemmap
-run_test ./hugetlb-madvise
-
-echo "NOTE: The above hugetlb tests provide minimal coverage.  Use"
-echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for"
-echo "      hugetlb regression testing."
+CATEGORY="hugetlb" run_test ./map_hugetlb
+CATEGORY="hugetlb" run_test ./hugepage-mremap
+CATEGORY="hugetlb" run_test ./hugepage-vmemmap
+CATEGORY="hugetlb" run_test ./hugetlb-madvise
+
+if test_selected "hugetlb"; then
+	echo "NOTE: These hugetlb tests provide minimal coverage.  Use"
+	echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for"
+	echo "      hugetlb regression testing."
+fi
 
-run_test ./map_fixed_noreplace
+CATEGORY="mmap" run_test ./map_fixed_noreplace
 
 # get_user_pages_fast() benchmark
-run_test ./gup_test -u
+CATEGORY="gup_test" run_test ./gup_test -u
 # pin_user_pages_fast() benchmark
-run_test ./gup_test -a
+CATEGORY="gup_test" run_test ./gup_test -a
 # Dump pages 0, 19, and 4096, using pin_user_pages:
-run_test ./gup_test -ct -F 0x1 0 19 0x1000
+CATEGORY="gup_test" run_test ./gup_test -ct -F 0x1 0 19 0x1000
 
 uffd_mods=("" ":dev")
 for mod in "${uffd_mods[@]}"; do
-	run_test ./userfaultfd anon${mod} 20 16
+	CATEGORY="userfaultfd" run_test ./userfaultfd anon${mod} 20 16
 	# Hugetlb tests require source and destination huge pages. Pass in half
 	# the size ($half_ufd_size_MB), which is used for *each*.
-	run_test ./userfaultfd hugetlb${mod} "$half_ufd_size_MB" 32
-	run_test ./userfaultfd hugetlb_shared${mod} "$half_ufd_size_MB" 32
-	run_test ./userfaultfd shmem${mod} 20 16
+	CATEGORY="userfaultfd" run_test ./userfaultfd hugetlb${mod} "$half_ufd_size_MB" 32
+	CATEGORY="userfaultfd" run_test ./userfaultfd hugetlb_shared${mod} "$half_ufd_size_MB" 32
+	CATEGORY="userfaultfd" run_test ./userfaultfd shmem${mod} 20 16
 done
 
 #cleanup
 echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
 
-run_test ./compaction_test
+CATEGORY="compaction" run_test ./compaction_test
 
-run_test sudo -u nobody ./on-fault-limit
+CATEGORY="mlock" run_test sudo -u nobody ./on-fault-limit
 
-run_test ./map_populate
+CATEGORY="mmap" run_test ./map_populate
 
-run_test ./mlock-random-test
+CATEGORY="mlock" run_test ./mlock-random-test
 
-run_test ./mlock2-tests
+CATEGORY="mlock" run_test ./mlock2-tests
 
-run_test ./mrelease_test
+CATEGORY="process_mrelease" run_test ./mrelease_test
 
-run_test ./mremap_test
+CATEGORY="mremap" run_test ./mremap_test
 
-run_test ./thuge-gen
+CATEGORY="hugetlb" run_test ./thuge-gen
 
 if [ $VADDR64 -ne 0 ]; then
-	run_test ./virtual_address_range
+	CATEGORY="hugevm" run_test ./virtual_address_range
 
 	# virtual address 128TB switch test
-	run_test ./va_128TBswitch.sh
+	CATEGORY="hugevm" run_test ./va_128TBswitch.sh
 fi # VADDR64
 
 # vmalloc stability smoke test
-run_test ./test_vmalloc.sh smoke
+CATEGORY="vmalloc" run_test ./test_vmalloc.sh smoke
 
-run_test ./mremap_dontunmap
+CATEGORY="mremap" run_test ./mremap_dontunmap
 
-run_test ./test_hmm.sh smoke
+CATEGORY="hmm" run_test ./test_hmm.sh smoke
 
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
-run_test ./madv_populate
+CATEGORY="madv_populate" run_test ./madv_populate
 
-run_test ./memfd_secret
+CATEGORY="memfd_secret" run_test ./memfd_secret
 
 # KSM MADV_MERGEABLE test with 10 identical pages
-run_test ./ksm_tests -M -p 10
+CATEGORY="ksm" run_test ./ksm_tests -M -p 10
 # KSM unmerge test
-run_test ./ksm_tests -U
+CATEGORY="ksm" run_test ./ksm_tests -U
 # KSM test with 10 zero pages and use_zero_pages = 0
-run_test ./ksm_tests -Z -p 10 -z 0
+CATEGORY="ksm" run_test ./ksm_tests -Z -p 10 -z 0
 # KSM test with 10 zero pages and use_zero_pages = 1
-run_test ./ksm_tests -Z -p 10 -z 1
+CATEGORY="ksm" run_test ./ksm_tests -Z -p 10 -z 1
 # KSM test with 2 NUMA nodes and merge_across_nodes = 1
-run_test ./ksm_tests -N -m 1
+CATEGORY="ksm_numa" run_test ./ksm_tests -N -m 1
 # KSM test with 2 NUMA nodes and merge_across_nodes = 0
-run_test ./ksm_tests -N -m 0
+CATEGORY="ksm_numa" run_test ./ksm_tests -N -m 0
 
 # protection_keys tests
 if [ -x ./protection_keys_32 ]
 then
-	run_test ./protection_keys_32
+	CATEGORY="pkey" run_test ./protection_keys_32
 fi
 
 if [ -x ./protection_keys_64 ]
 then
-	run_test ./protection_keys_64
+	CATEGORY="pkey" run_test ./protection_keys_64
 fi
 
-run_test ./soft-dirty
+CATEGORY="soft_dirty" run_test ./soft-dirty
 
 # COW tests for anonymous memory
-run_test ./anon_cow
+CATEGORY="anon_cow" run_test ./anon_cow
 
 exit $exitcode
_

Patches currently in -mm which might be from jsavitz@redhat.com are

selftests-vm-enable-running-select-groups-of-tests.patch

