Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F2C7C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236029AbiEJERF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235991AbiEJEQX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A9A38BE1
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5A0CB81AE7
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71006C385C2;
        Tue, 10 May 2022 04:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155908;
        bh=yH9tLxZZeq074eKFzUdIkJnYXOoAMJqXn8nX+YbD+eU=;
        h=Date:To:From:Subject:From;
        b=aE4K8zDohp66VMPrf3Cr2U7EsMJrFr3So65bvp0XJhpYQQfwjqVzgTplcEQFXLf9G
         XOPL/rmTXgkms0eLeDdH6rYcJf6GgJHGHuYLAK4RHfAqJv4+o8/HidgOCdReyUoJUL
         NgA5p1XvVBM84fFsE1tucuvu63aiu7Lxd9qNSO3g=
Date:   Mon, 09 May 2022 21:11:47 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-fix-shellcheck-warnings-in-run_vmtestssh.patch removed from -mm tree
Message-Id: <20220510041148.71006C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: vm: fix shellcheck warnings in run_vmtests.sh
has been removed from the -mm tree.  Its filename was
     selftests-vm-fix-shellcheck-warnings-in-run_vmtestssh.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: selftests: vm: fix shellcheck warnings in run_vmtests.sh

These might not be issues yet, but they make the script more fragile. 
Also by fixing them we give a better example to future readers, who might
copy/paste or otherwise re-use snippets from our script.

- Use "read -r", since we don't ever want read to be interpreting '\'
  characters as escape sequences...
- Quote variables, to deal with spaces properly.
- Use $() instead of the older and harder-to-nest ``.
- Get rid of superfluous "$" prefixes inside arithmetic $(()).

Link: https://lkml.kernel.org/r/20220421224928.1848230-2-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests.sh |   55 +++++++++-----------
 1 file changed, 27 insertions(+), 28 deletions(-)

--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-fix-shellcheck-warnings-in-run_vmtestssh
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -9,12 +9,12 @@ mnt=./huge
 exitcode=0
 
 #get huge pagesize and freepages from /proc/meminfo
-while read name size unit; do
+while read -r name size unit; do
 	if [ "$name" = "HugePages_Free:" ]; then
-		freepgs=$size
+		freepgs="$size"
 	fi
 	if [ "$name" = "Hugepagesize:" ]; then
-		hpgsize_KB=$size
+		hpgsize_KB="$size"
 	fi
 done < /proc/meminfo
 
@@ -30,27 +30,26 @@ needmem_KB=$((half_ufd_size_MB * 2 * 102
 
 #set proper nr_hugepages
 if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
-	nr_hugepgs=`cat /proc/sys/vm/nr_hugepages`
+	nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
 	needpgs=$((needmem_KB / hpgsize_KB))
 	tries=2
-	while [ $tries -gt 0 ] && [ $freepgs -lt $needpgs ]; do
-		lackpgs=$(( $needpgs - $freepgs ))
+	while [ "$tries" -gt 0 ] && [ "$freepgs" -lt "$needpgs" ]; do
+		lackpgs=$((needpgs - freepgs))
 		echo 3 > /proc/sys/vm/drop_caches
-		echo $(( $lackpgs + $nr_hugepgs )) > /proc/sys/vm/nr_hugepages
-		if [ $? -ne 0 ]; then
+		if ! echo $((lackpgs + nr_hugepgs)) > /proc/sys/vm/nr_hugepages; then
 			echo "Please run this test as root"
 			exit $ksft_skip
 		fi
-		while read name size unit; do
+		while read -r name size unit; do
 			if [ "$name" = "HugePages_Free:" ]; then
 				freepgs=$size
 			fi
 		done < /proc/meminfo
 		tries=$((tries - 1))
 	done
-	if [ $freepgs -lt $needpgs ]; then
+	if [ "$freepgs" -lt "$needpgs" ]; then
 		printf "Not enough huge pages available (%d < %d)\n" \
-		       $freepgs $needpgs
+		       "$freepgs" "$needpgs"
 		exit 1
 	fi
 else
@@ -60,11 +59,11 @@ fi
 
 #filter 64bit architectures
 ARCH64STR="arm64 ia64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sh64 sparc64 x86_64"
-if [ -z $ARCH ]; then
-  ARCH=`uname -m 2>/dev/null | sed -e 's/aarch64.*/arm64/'`
+if [ -z "$ARCH" ]; then
+	ARCH=$(uname -m 2>/dev/null | sed -e 's/aarch64.*/arm64/')
 fi
 VADDR64=0
-echo "$ARCH64STR" | grep $ARCH && VADDR64=1
+echo "$ARCH64STR" | grep "$ARCH" && VADDR64=1
 
 # Usage: run_test [test binary] [arbitrary test arguments...]
 run_test() {
@@ -85,28 +84,28 @@ run_test() {
 	fi
 }
 
-mkdir $mnt
-mount -t hugetlbfs none $mnt
+mkdir "$mnt"
+mount -t hugetlbfs none "$mnt"
 
 run_test ./hugepage-mmap
 
-shmmax=`cat /proc/sys/kernel/shmmax`
-shmall=`cat /proc/sys/kernel/shmall`
+shmmax=$(cat /proc/sys/kernel/shmmax)
+shmall=$(cat /proc/sys/kernel/shmall)
 echo 268435456 > /proc/sys/kernel/shmmax
 echo 4194304 > /proc/sys/kernel/shmall
 run_test ./hugepage-shm
-echo $shmmax > /proc/sys/kernel/shmmax
-echo $shmall > /proc/sys/kernel/shmall
+echo "$shmmax" > /proc/sys/kernel/shmmax
+echo "$shmall" > /proc/sys/kernel/shmall
 
 run_test ./map_hugetlb
 
-run_test ./hugepage-mremap $mnt/huge_mremap
-rm -f $mnt/huge_mremap
+run_test ./hugepage-mremap "$mnt"/huge_mremap
+rm -f "$mnt"/huge_mremap
 
 run_test ./hugepage-vmemmap
 
-run_test ./hugetlb-madvise $mnt/madvise-test
-rm -f $mnt/madvise-test
+run_test ./hugetlb-madvise "$mnt"/madvise-test
+rm -f "$mnt"/madvise-test
 
 echo "NOTE: The above hugetlb tests provide minimal coverage.  Use"
 echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for"
@@ -124,13 +123,13 @@ run_test ./gup_test -ct -F 0x1 0 19 0x10
 run_test ./userfaultfd anon 20 16
 # Test requires source and destination huge pages.  Size of source
 # (half_ufd_size_MB) is passed as argument to test.
-run_test ./userfaultfd hugetlb $half_ufd_size_MB 32
+run_test ./userfaultfd hugetlb "$half_ufd_size_MB" 32
 run_test ./userfaultfd shmem 20 16
 
 #cleanup
-umount $mnt
-rm -rf $mnt
-echo $nr_hugepgs > /proc/sys/vm/nr_hugepages
+umount "$mnt"
+rm -rf "$mnt"
+echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
 
 run_test ./compaction_test
 
_

Patches currently in -mm which might be from axelrasmussen@google.com are


