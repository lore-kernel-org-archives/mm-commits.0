Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 266A9C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjDRXhh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbjDRXfx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849C59766
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2095C6387C
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7734AC433D2;
        Tue, 18 Apr 2023 23:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860910;
        bh=3oSCwDuT4JDYZmR7kqPEOIF6b+H6Yt8GgtE9u8cRDa0=;
        h=Date:To:From:Subject:From;
        b=2bbk4xsqicWsf0Stn8mvYS9DAjb8SmyIv4dsBkkVw01paeEr7jaOL0JHTggEo2mb8
         /QnwQlXRyH4ZE+rQoyVSoSvNUy1PLeB1PwV+R3aeg6fQfORihW7Wt1b011y7ns0oQs
         vwQMHBO1sY4/Lucy4jsT11qIK/BNHAMWm8sZ2+3o=
Date:   Tue, 18 Apr 2023 16:35:09 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-dump-a-summary-in-run_vmtestssh.patch removed from -mm tree
Message-Id: <20230418233510.7734AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: dump a summary in run_vmtests.sh
has been removed from the -mm tree.  Its filename was
     selftests-mm-dump-a-summary-in-run_vmtestssh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: dump a summary in run_vmtests.sh
Date: Wed, 12 Apr 2023 12:41:17 -0400

Dump a summary after running whatever test specified.  Useful for human
runners to identify any kind of failures (besides exit code).

Link: https://lkml.kernel.org/r/20230412164117.327720-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-dump-a-summary-in-run_vmtestssh
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -5,6 +5,9 @@
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
+count_pass=0
+count_fail=0
+count_skip=0
 exitcode=0
 
 usage() {
@@ -149,11 +152,14 @@ run_test() {
 		"$@"
 		local ret=$?
 		if [ $ret -eq 0 ]; then
+			count_pass=$(( count_pass + 1 ))
 			echo "[PASS]"
 		elif [ $ret -eq $ksft_skip ]; then
+			count_skip=$(( count_skip + 1 ))
 			echo "[SKIP]"
 			exitcode=$ksft_skip
 		else
+			count_fail=$(( count_fail + 1 ))
 			echo "[FAIL]"
 			exitcode=1
 		fi
@@ -279,4 +285,6 @@ CATEGORY="soft_dirty" run_test ./soft-di
 # COW tests
 CATEGORY="cow" run_test ./cow
 
+echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}"
+
 exit $exitcode
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-mm-merge-utilh-into-vm_utilh.patch
selftests-mm-use-test_gen_progs-where-proper.patch
selftests-mm-link-vm_utilc-always.patch
selftests-mm-merge-default_huge_page_size-into-one.patch
selftests-mm-use-pm_-macros-in-vm_utilsh.patch
selftests-mm-reuse-pagemap_get_entry-in-vm_utilh.patch
selftests-mm-test-uffdio_zeropage-only-when-hugetlb.patch
selftests-mm-drop-test_uffdio_zeropage_eexist.patch
selftests-mm-create-uffd-common.patch
selftests-mm-split-uffd-tests-into-uffd-stress-and-uffd-unit-tests.patch
selftests-mm-uffd_register.patch
selftests-mm-uffd_open_devsys.patch
selftests-mm-uffdio_api-test.patch
selftests-mm-drop-global-mem_fd-in-uffd-tests.patch
selftests-mm-drop-global-hpage_size-in-uffd-tests.patch
selftests-mm-rename-uffd_stats-to-uffd_args.patch
selftests-mm-let-uffd_handle_page_fault-take-wp-parameter.patch
selftests-mm-allow-allocate_area-to-fail-properly.patch
selftests-mm-add-framework-for-uffd-unit-test.patch
selftests-mm-move-uffd-pagemap-test-to-unit-test.patch
selftests-mm-move-uffd-minor-test-to-unit-test.patch
selftests-mm-move-uffd-sig-events-tests-into-uffd-unit-tests.patch
selftests-mm-move-zeropage-test-into-uffd-unit-tests.patch
selftests-mm-workaround-no-way-to-detect-uffd-minor-wp.patch
selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege.patch
selftests-mm-drop-sys-dev-test-in-uffd-stress-test.patch
selftests-mm-add-shmem-private-test-to-uffd-stress.patch
selftests-mm-add-uffdio-register-ioctls-test.patch
mm-hugetlb-fix-uffd-wp-during-fork.patch
mm-hugetlb-fix-uffd-wp-bit-lost-when-unsharing-happens.patch
selftests-mm-add-a-few-options-for-uffd-unit-test.patch
selftests-mm-extend-and-rename-uffd-pagemap-test.patch
selftests-mm-rename-cow_extra_libs-to-iouring_extra_libs.patch
selftests-mm-add-tests-for-ro-pinning-vs-fork.patch

