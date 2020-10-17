Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36841C433E7
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 030D7208E4
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976472;
	bh=n1vh/svw7FuDDIoEWaeCDbN5Sq2hhNt0iDhA/JEvXrM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ELy35831r7nWHVQi0o1asyt4wo7VN4Vj8EGffUZdn90VP3VLvNb1PRvUBMLgkKao7
	 DPGtbFlWx3V/IbTCeiWQ7J9q6EOWNDKX3jOVX27LoYHcL8dPendGrPgMuT6W1fIgVl
	 2Y+2lxGTCeNmNS0nT/qg7GqyYbJFwMzICSTtvgq8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439896AbgJQXOb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:14:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXOb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:14:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADA9920E65;
        Sat, 17 Oct 2020 23:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976469;
        bh=n1vh/svw7FuDDIoEWaeCDbN5Sq2hhNt0iDhA/JEvXrM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pwysd1ueI//i8sSZJQEdt3v4aMIkgsznnzVobaeNOhsarhVRKXljhGlHu9zFkjuiC
         rAbMBH3TENLpEeia/ksPc+ac1hYux/PExX6k5VudJww9tpIBG6c3es+Oahk8px7xDp
         k7Kyw/jpjLutg1DP8ur6Y4ud3H+gcA7If2D9UgSQ=
Date:   Sat, 17 Oct 2020 16:14:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, jglisse@redhat.com,
        jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 17/40] selftests/vm: rename run_vmtests -->
 run_vmtests.sh
Message-ID: <20201017231428.OuSvQ2jzW%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
