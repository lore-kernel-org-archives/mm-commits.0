Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 194EDC388F9
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 22:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC7612245F
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 22:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603407020;
	bh=QNoT68wqDSA5a7TTcYYO24sjYjT22ybElN6OLOnq6Y8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=E+HT4eoBkYD2I3FbUWvPdbMDeZFZ1/p4XFtSXpc5xpF0SaCbo1GdeglCKqQqP6VlB
	 kEJum+EEC9t8fRf1ier3xWv35Dq1nuQGXx7+kjIEK4gTPN6Wh0aKleU1Cg8nI7f90M
	 oHjDh+QpzPIaXxEMPfq5dLcXuwNkFCJ6KXug54pU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373092AbgJVWuU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 18:50:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S372983AbgJVWuU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 18:50:20 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E3DD223C7;
        Thu, 22 Oct 2020 22:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603407018;
        bh=QNoT68wqDSA5a7TTcYYO24sjYjT22ybElN6OLOnq6Y8=;
        h=Date:From:To:Subject:From;
        b=hz7pXkNlksbEJNbDa/9x6kyRFMBayxhGRXE1D0qLO8DfFstZl1cwkRNeYqLBJE+P8
         FiZDVxztsGskHLvOpurIgJjxYkl7aNcrNuUnp36sqspk9q0H07G5CkvpeM/pn2qhLs
         Vdy7JXtXZGEx30Zid3ySGE5qmWTLJu5Kd9mHQll4=
Date:   Thu, 22 Oct 2020 15:50:18 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org
Subject:  [to-be-updated]
 selftests-vm-rename-run_vmtests-run_vmtestssh.patch removed from -mm tree
Message-ID: <20201022225018.ZBdyXWos5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: rename run_vmtests --> run_vmtests.sh
has been removed from the -mm tree.  Its filename was
     selftests-vm-rename-run_vmtests-run_vmtestssh.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: rename run_vmtests --> run_vmtests.sh

Rename to *.sh, in order to match the conventions of all of the other
items in selftest/vm.

The only reason not to use a .sh suffix a shell script like this, might be
to make it look more like a normal program, but that's not an issue here.

Link: https://lkml.kernel.org/r/20200929212747.251804-4-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile       |    2=20
 tools/testing/selftests/vm/run_vmtests    |  326 --------------------
 tools/testing/selftests/vm/run_vmtests.sh |  326 ++++++++++++++++++++
 3 files changed, 327 insertions(+), 327 deletions(-)

--- a/tools/testing/selftests/vm/Makefile~selftests-vm-rename-run_vmtests-r=
un_vmtestssh
+++ a/tools/testing/selftests/vm/Makefile
@@ -69,7 +69,7 @@ TEST_GEN_FILES +=3D virtual_address_range
 TEST_GEN_FILES +=3D write_to_hugetlbfs
 endif
=20
-TEST_PROGS :=3D run_vmtests
+TEST_PROGS :=3D run_vmtests.sh
=20
 TEST_FILES :=3D test_vmalloc.sh
=20
--- a/tools/testing/selftests/vm/run_vmtests
+++ /dev/null
@@ -1,326 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-#please run as root
-
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=3D4
-
-mnt=3D./huge
-exitcode=3D0
-
-#get huge pagesize and freepages from /proc/meminfo
-while read name size unit; do
-	if [ "$name" =3D "HugePages_Free:" ]; then
-		freepgs=3D$size
-	fi
-	if [ "$name" =3D "Hugepagesize:" ]; then
-		hpgsize_KB=3D$size
-	fi
-done < /proc/meminfo
-
-# Simple hugetlbfs tests have a hardcoded minimum requirement of
-# huge pages totaling 256MB (262144KB) in size.  The userfaultfd
-# hugetlb test requires a minimum of 2 * nr_cpus huge pages.  Take
-# both of these requirements into account and attempt to increase
-# number of huge pages available.
-nr_cpus=3D$(nproc)
-hpgsize_MB=3D$((hpgsize_KB / 1024))
-half_ufd_size_MB=3D$((((nr_cpus * hpgsize_MB + 127) / 128) * 128))
-needmem_KB=3D$((half_ufd_size_MB * 2 * 1024))
-
-#set proper nr_hugepages
-if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
-	nr_hugepgs=3D`cat /proc/sys/vm/nr_hugepages`
-	needpgs=3D$((needmem_KB / hpgsize_KB))
-	tries=3D2
-	while [ $tries -gt 0 ] && [ $freepgs -lt $needpgs ]; do
-		lackpgs=3D$(( $needpgs - $freepgs ))
-		echo 3 > /proc/sys/vm/drop_caches
-		echo $(( $lackpgs + $nr_hugepgs )) > /proc/sys/vm/nr_hugepages
-		if [ $? -ne 0 ]; then
-			echo "Please run this test as root"
-			exit $ksft_skip
-		fi
-		while read name size unit; do
-			if [ "$name" =3D "HugePages_Free:" ]; then
-				freepgs=3D$size
-			fi
-		done < /proc/meminfo
-		tries=3D$((tries - 1))
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
-ARCH64STR=3D"arm64 ia64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sh64 s=
parc64 x86_64"
-if [ -z $ARCH ]; then
-  ARCH=3D`uname -m 2>/dev/null | sed -e 's/aarch64.*/arm64/'`
-fi
-VADDR64=3D0
-echo "$ARCH64STR" | grep $ARCH && VADDR64=3D1
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
-	exitcode=3D1
-else
-	echo "[PASS]"
-fi
-
-shmmax=3D`cat /proc/sys/kernel/shmmax`
-shmall=3D`cat /proc/sys/kernel/shmall`
-echo 268435456 > /proc/sys/kernel/shmmax
-echo 4194304 > /proc/sys/kernel/shmall
-echo "--------------------"
-echo "running hugepage-shm"
-echo "--------------------"
-./hugepage-shm
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=3D1
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
-	exitcode=3D1
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
-	exitcode=3D1
-else
-	echo "[PASS]"
-fi
-
-echo "--------------------------------------------"
-echo "running 'gup_test -U' (normal/slow gup)"
-echo "--------------------------------------------"
-./gup_test -U
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=3D1
-else
-	echo "[PASS]"
-fi
-
-echo "------------------------------------------"
-echo "running gup_test -b (pin_user_pages)"
-echo "------------------------------------------"
-./gup_test -b
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=3D1
-else
-	echo "[PASS]"
-fi
-
-echo "-------------------"
-echo "running userfaultfd"
-echo "-------------------"
-./userfaultfd anon 128 32
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=3D1
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
-	exitcode=3D1
-else
-	echo "[PASS]"
-fi
-rm -f $mnt/ufd_test_file
-
-echo "-------------------------"
-echo "running userfaultfd_shmem"
-echo "-------------------------"
-./userfaultfd shmem 128 32
-if [ $? -ne 0 ]; then
-	echo "[FAIL]"
-	exitcode=3D1
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
-	exitcode=3D1
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
-	exitcode=3D1
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
-	exitcode=3D1
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
-	exitcode=3D1
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
-	exitcode=3D1
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
-	exitcode=3D1
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
-	exitcode=3D1
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
-    exitcode=3D1
-else
-    echo "[PASS]"
-fi
-fi # VADDR64
-
-echo "------------------------------------"
-echo "running vmalloc stability smoke test"
-echo "------------------------------------"
-./test_vmalloc.sh smoke
-ret_val=3D$?
-
-if [ $ret_val -eq 0 ]; then
-	echo "[PASS]"
-elif [ $ret_val -eq $ksft_skip ]; then
-	 echo "[SKIP]"
-	 exitcode=3D$ksft_skip
-else
-	echo "[FAIL]"
-	exitcode=3D1
-fi
-
-echo "------------------------------------"
-echo "running MREMAP_DONTUNMAP smoke test"
-echo "------------------------------------"
-./mremap_dontunmap
-ret_val=3D$?
-
-if [ $ret_val -eq 0 ]; then
-	echo "[PASS]"
-elif [ $ret_val -eq $ksft_skip ]; then
-	 echo "[SKIP]"
-	 exitcode=3D$ksft_skip
-else
-	echo "[FAIL]"
-	exitcode=3D1
-fi
-
-echo "running HMM smoke test"
-echo "------------------------------------"
-./test_hmm.sh smoke
-ret_val=3D$?
-
-if [ $ret_val -eq 0 ]; then
-	echo "[PASS]"
-elif [ $ret_val -eq $ksft_skip ]; then
-	echo "[SKIP]"
-	exitcode=3D$ksft_skip
-else
-	echo "[FAIL]"
-	exitcode=3D1
-fi
-
-exit $exitcode
--- /dev/null
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -0,0 +1,326 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#please run as root
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=3D4
+
+mnt=3D./huge
+exitcode=3D0
+
+#get huge pagesize and freepages from /proc/meminfo
+while read name size unit; do
+	if [ "$name" =3D "HugePages_Free:" ]; then
+		freepgs=3D$size
+	fi
+	if [ "$name" =3D "Hugepagesize:" ]; then
+		hpgsize_KB=3D$size
+	fi
+done < /proc/meminfo
+
+# Simple hugetlbfs tests have a hardcoded minimum requirement of
+# huge pages totaling 256MB (262144KB) in size.  The userfaultfd
+# hugetlb test requires a minimum of 2 * nr_cpus huge pages.  Take
+# both of these requirements into account and attempt to increase
+# number of huge pages available.
+nr_cpus=3D$(nproc)
+hpgsize_MB=3D$((hpgsize_KB / 1024))
+half_ufd_size_MB=3D$((((nr_cpus * hpgsize_MB + 127) / 128) * 128))
+needmem_KB=3D$((half_ufd_size_MB * 2 * 1024))
+
+#set proper nr_hugepages
+if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
+	nr_hugepgs=3D`cat /proc/sys/vm/nr_hugepages`
+	needpgs=3D$((needmem_KB / hpgsize_KB))
+	tries=3D2
+	while [ $tries -gt 0 ] && [ $freepgs -lt $needpgs ]; do
+		lackpgs=3D$(( $needpgs - $freepgs ))
+		echo 3 > /proc/sys/vm/drop_caches
+		echo $(( $lackpgs + $nr_hugepgs )) > /proc/sys/vm/nr_hugepages
+		if [ $? -ne 0 ]; then
+			echo "Please run this test as root"
+			exit $ksft_skip
+		fi
+		while read name size unit; do
+			if [ "$name" =3D "HugePages_Free:" ]; then
+				freepgs=3D$size
+			fi
+		done < /proc/meminfo
+		tries=3D$((tries - 1))
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
+ARCH64STR=3D"arm64 ia64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sh64 s=
parc64 x86_64"
+if [ -z $ARCH ]; then
+  ARCH=3D`uname -m 2>/dev/null | sed -e 's/aarch64.*/arm64/'`
+fi
+VADDR64=3D0
+echo "$ARCH64STR" | grep $ARCH && VADDR64=3D1
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
+	exitcode=3D1
+else
+	echo "[PASS]"
+fi
+
+shmmax=3D`cat /proc/sys/kernel/shmmax`
+shmall=3D`cat /proc/sys/kernel/shmall`
+echo 268435456 > /proc/sys/kernel/shmmax
+echo 4194304 > /proc/sys/kernel/shmall
+echo "--------------------"
+echo "running hugepage-shm"
+echo "--------------------"
+./hugepage-shm
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=3D1
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
+	exitcode=3D1
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
+	exitcode=3D1
+else
+	echo "[PASS]"
+fi
+
+echo "--------------------------------------------"
+echo "running 'gup_test -U' (normal/slow gup)"
+echo "--------------------------------------------"
+./gup_test -U
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=3D1
+else
+	echo "[PASS]"
+fi
+
+echo "------------------------------------------"
+echo "running gup_test -b (pin_user_pages)"
+echo "------------------------------------------"
+./gup_test -b
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=3D1
+else
+	echo "[PASS]"
+fi
+
+echo "-------------------"
+echo "running userfaultfd"
+echo "-------------------"
+./userfaultfd anon 128 32
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=3D1
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
+	exitcode=3D1
+else
+	echo "[PASS]"
+fi
+rm -f $mnt/ufd_test_file
+
+echo "-------------------------"
+echo "running userfaultfd_shmem"
+echo "-------------------------"
+./userfaultfd shmem 128 32
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=3D1
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
+	exitcode=3D1
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
+	exitcode=3D1
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
+	exitcode=3D1
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
+	exitcode=3D1
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
+	exitcode=3D1
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
+	exitcode=3D1
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
+	exitcode=3D1
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
+    exitcode=3D1
+else
+    echo "[PASS]"
+fi
+fi # VADDR64
+
+echo "------------------------------------"
+echo "running vmalloc stability smoke test"
+echo "------------------------------------"
+./test_vmalloc.sh smoke
+ret_val=3D$?
+
+if [ $ret_val -eq 0 ]; then
+	echo "[PASS]"
+elif [ $ret_val -eq $ksft_skip ]; then
+	 echo "[SKIP]"
+	 exitcode=3D$ksft_skip
+else
+	echo "[FAIL]"
+	exitcode=3D1
+fi
+
+echo "------------------------------------"
+echo "running MREMAP_DONTUNMAP smoke test"
+echo "------------------------------------"
+./mremap_dontunmap
+ret_val=3D$?
+
+if [ $ret_val -eq 0 ]; then
+	echo "[PASS]"
+elif [ $ret_val -eq $ksft_skip ]; then
+	 echo "[SKIP]"
+	 exitcode=3D$ksft_skip
+else
+	echo "[FAIL]"
+	exitcode=3D1
+fi
+
+echo "running HMM smoke test"
+echo "------------------------------------"
+./test_hmm.sh smoke
+ret_val=3D$?
+
+if [ $ret_val -eq 0 ]; then
+	echo "[PASS]"
+elif [ $ret_val -eq $ksft_skip ]; then
+	echo "[SKIP]"
+	exitcode=3D$ksft_skip
+else
+	echo "[FAIL]"
+	exitcode=3D1
+fi
+
+exit $exitcode
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


