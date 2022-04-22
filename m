Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A7BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 22:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbiDVWaQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 18:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbiDVWaG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 18:30:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC587243547
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 14:56:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49341B832C5
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 21:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C683C385A4;
        Fri, 22 Apr 2022 21:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650664574;
        bh=P63A9L9e6tBCmI+3qVEsJI70DVjjq6REYbvQPPAtweI=;
        h=Date:To:From:Subject:From;
        b=ncp5LDPmzvIiNbsLOXbvjJyW5iUpEAnM7M6SIRyBrQP1tyvWgcHTEiH3hp2kMpJNO
         EKhAKebDJ/J4nTlr3jLGpV8e2or+fJ7v/R0ahAbNMmpISvavy4M4MX7JMkfD9AO0nq
         BbohBCHk52X+AjUzubp7gvq6wW/AHl0BV0UMO17I=
Date:   Fri, 22 Apr 2022 14:56:13 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-fix-shellcheck-warnings-in-run_vmtestssh.patch added to -mm tree
Message-Id: <20220422215614.0C683C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: fix shellcheck warnings in run_vmtests.sh
has been added to the -mm tree.  Its filename is
     selftests-vm-fix-shellcheck-warnings-in-run_vmtestssh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-fix-shellcheck-warnings-in-run_vmtestssh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-fix-shellcheck-warnings-in-run_vmtestssh.patch

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

selftests-vm-refactor-run_vmtestssh-to-reduce-boilerplate.patch
selftests-vm-fix-shellcheck-warnings-in-run_vmtestssh.patch

