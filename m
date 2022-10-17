Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E11E8C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiJQAeS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiJQAeR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:34:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C7A32D9B
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:34:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F50D60E98
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F3BC433C1;
        Mon, 17 Oct 2022 00:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665966853;
        bh=4DR6UnPi0e9p5c2A7qw982Pq+vbXwGTZO6rqV2X2oro=;
        h=Date:To:From:Subject:From;
        b=LWivpbeTLg5H8auw/06HWIs6HQHqa4ZElyvVIrYCxiWS0vXQdA0as7v3p/569QOOV
         3YAY5G9DMfmqTOZ2RWp7o1rZF8RNyGTzVf+k7FtDEdyHmAYfvLjM/Vr/i731Bfnr86
         3/FNJniwNEMpAXCB7oi5NNbIqp4IKAJON0LDt1E8=
Date:   Sun, 16 Oct 2022 17:34:13 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        axelrasmussen@google.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-drop-mnt-point-for-hugetlb-in-run_vmtestssh.patch added to mm-unstable branch
Message-Id: <20221017003413.B0F3BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: drop mnt point for hugetlb in run_vmtests.sh
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-drop-mnt-point-for-hugetlb-in-run_vmtestssh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-drop-mnt-point-for-hugetlb-in-run_vmtestssh.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: selftests/vm: drop mnt point for hugetlb in run_vmtests.sh
Date: Fri, 14 Oct 2022 10:40:15 -0400

After converting all the three relevant testcases (uffd, madvise, mremap)
to use memfd, no test will need the hugetlb mount point anymore.  Drop the
code.

Link: https://lkml.kernel.org/r/20221014144015.94039-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests.sh |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-drop-mnt-point-for-hugetlb-in-run_vmtestssh
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -5,7 +5,6 @@
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
-mnt=./huge
 exitcode=0
 
 #get huge pagesize and freepages from /proc/meminfo
@@ -84,9 +83,6 @@ run_test() {
 	fi
 }
 
-mkdir "$mnt"
-mount -t hugetlbfs none "$mnt"
-
 run_test ./hugepage-mmap
 
 shmmax=$(cat /proc/sys/kernel/shmmax)
@@ -98,14 +94,9 @@ echo "$shmmax" > /proc/sys/kernel/shmmax
 echo "$shmall" > /proc/sys/kernel/shmall
 
 run_test ./map_hugetlb
-
-run_test ./hugepage-mremap "$mnt"/huge_mremap
-rm -f "$mnt"/huge_mremap
-
+run_test ./hugepage-mremap
 run_test ./hugepage-vmemmap
-
-run_test ./hugetlb-madvise "$mnt"/madvise-test
-rm -f "$mnt"/madvise-test
+run_test ./hugetlb-madvise
 
 echo "NOTE: The above hugetlb tests provide minimal coverage.  Use"
 echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for"
@@ -126,14 +117,11 @@ for mod in "${uffd_mods[@]}"; do
 	# Hugetlb tests require source and destination huge pages. Pass in half
 	# the size ($half_ufd_size_MB), which is used for *each*.
 	run_test ./userfaultfd hugetlb${mod} "$half_ufd_size_MB" 32
-	run_test ./userfaultfd hugetlb_shared${mod} "$half_ufd_size_MB" 32 "$mnt"/uffd-test
-	rm -f "$mnt"/uffd-test
+	run_test ./userfaultfd hugetlb_shared${mod} "$half_ufd_size_MB" 32
 	run_test ./userfaultfd shmem${mod} 20 16
 done
 
 #cleanup
-umount "$mnt"
-rm -rf "$mnt"
 echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
 
 run_test ./compaction_test
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-vm-use-memfd-for-uffd-hugetlb-tests.patch
selftests-vm-use-memfd-for-hugetlb-madvise-test.patch
selftests-vm-use-memfd-for-hugepage-mremap-test.patch
selftests-vm-drop-mnt-point-for-hugetlb-in-run_vmtestssh.patch

