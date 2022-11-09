Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E6EC4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiKIBiQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiKIBiN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40D160EA6
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F9CEB81CC8
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AFCC433D6;
        Wed,  9 Nov 2022 01:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957889;
        bh=qjo/buNw0f/3+gtRzTuWr1CY36bPotPsHsRr/wxz/6c=;
        h=Date:To:From:Subject:From;
        b=REFMU5hfBPO77l5xAOLwsf9Dr05j1L+LYpGWtus5NKkgpeVtEslRe3/k8AIIaSarE
         kfOUSLQ6UR2NPHjtMwrkmyEBuf6dH1aDQgR3hAZkh6/Mf492j/BFndrhpt5xao5UqX
         +Y52dZ75tU5wv7YaxyWy9TqjsmgvRStQMZn7+nRA=
Date:   Tue, 08 Nov 2022 17:38:08 -0800
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        axelrasmussen@google.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-drop-mnt-point-for-hugetlb-in-run_vmtestssh.patch removed from -mm tree
Message-Id: <20221109013809.02AFCC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: drop mnt point for hugetlb in run_vmtests.sh
has been removed from the -mm tree.  Its filename was
     selftests-vm-drop-mnt-point-for-hugetlb-in-run_vmtestssh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-always-compile-in-pte-markers.patch
mm-use-pte-markers-for-swap-errors.patch

