Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02428C7619A
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 20:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjDLUCp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjDLUCm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 16:02:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634406E8A
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 13:02:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 445AD63136
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 20:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C380C433EF;
        Wed, 12 Apr 2023 20:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681329759;
        bh=KKQuXOHi1PeW1B+TBGyLI6YczIQIF52X0Pwt3P4qN3g=;
        h=Date:To:From:Subject:From;
        b=P+qdswsudjNQL2zkXsK4gGjnUFnwsvj7I1q+CYozjbq2++89GfBSdO9eqampr2+od
         DM4zjYRnTjZlJrm48y2M/VelSJ05/MAQ3UCyjuHb6QYlgGUjw0udhyAHQtz4WmcyrX
         zr7LrUoS7tvL4vOwyEPQMNaCeGqPlQO6g8WbdJlk=
Date:   Wed, 12 Apr 2023 13:02:39 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-drop-test_uffdio_zeropage_eexist.patch added to mm-unstable branch
Message-Id: <20230412200239.9C380C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: drop test_uffdio_zeropage_eexist
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-drop-test_uffdio_zeropage_eexist.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-drop-test_uffdio_zeropage_eexist.patch

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
Subject: selftests/mm: drop test_uffdio_zeropage_eexist
Date: Wed, 12 Apr 2023 12:42:38 -0400

The idea was trying to flip this var in the alarm handler from time to
time to test -EEXIST of UFFDIO_ZEROPAGE, but firstly it's only used in the
zeropage test so probably only used once, meanwhile we passed
"retry==false" so it'll never got tested anyway.

Drop both sides so we always test UFFDIO_ZEROPAGE retries if has_zeropage
is set (!hugetlb).

One more thing to do is doing UFFDIO_REGISTER for the alias buffer too,
because otherwise the test won't even pass!  We were just lucky that this
test never really got ran at all.

Link: https://lkml.kernel.org/r/20230412164238.328238-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/userfaultfd.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/mm/userfaultfd.c~selftests-mm-drop-test_uffdio_zeropage_eexist
+++ a/tools/testing/selftests/mm/userfaultfd.c
@@ -88,7 +88,6 @@ static bool test_dev_userfaultfd;
 /* exercise the test_uffdio_*_eexist every ALARM_INTERVAL_SECS */
 #define ALARM_INTERVAL_SECS 10
 static volatile bool test_uffdio_copy_eexist = true;
-static volatile bool test_uffdio_zeropage_eexist = true;
 /* Whether to test uffd write-protection */
 static bool test_uffdio_wp = true;
 /* Whether to test uffd minor faults */
@@ -1114,7 +1113,7 @@ static void retry_uffdio_zeropage(int uf
 	}
 }
 
-static int __uffdio_zeropage(int ufd, unsigned long offset, bool retry)
+static int __uffdio_zeropage(int ufd, unsigned long offset)
 {
 	struct uffdio_zeropage uffdio_zeropage;
 	int ret;
@@ -1138,11 +1137,8 @@ static int __uffdio_zeropage(int ufd, un
 		if (res != page_size) {
 			err("UFFDIO_ZEROPAGE unexpected size");
 		} else {
-			if (test_uffdio_zeropage_eexist && retry) {
-				test_uffdio_zeropage_eexist = false;
-				retry_uffdio_zeropage(ufd, &uffdio_zeropage,
-						      offset);
-			}
+			retry_uffdio_zeropage(ufd, &uffdio_zeropage,
+					      offset);
 			return 1;
 		}
 	} else
@@ -1153,7 +1149,7 @@ static int __uffdio_zeropage(int ufd, un
 
 static int uffdio_zeropage(int ufd, unsigned long offset)
 {
-	return __uffdio_zeropage(ufd, offset, false);
+	return __uffdio_zeropage(ufd, offset);
 }
 
 /* exercise UFFDIO_ZEROPAGE */
@@ -1177,6 +1173,13 @@ static int userfaultfd_zeropage_test(voi
 	assert_expected_ioctls_present(
 		uffdio_register.mode, uffdio_register.ioctls);
 
+	if (area_dst_alias) {
+		/* Needed this to test zeropage-retry on shared memory */
+		uffdio_register.range.start = (unsigned long) area_dst_alias;
+		if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
+			err("register failure");
+	}
+
 	if (uffdio_zeropage(uffd, 0))
 		if (my_bcmp(area_dst, zeropage, page_size))
 			err("zeropage is not zero");
@@ -1763,7 +1766,6 @@ static void sigalrm(int sig)
 	if (sig != SIGALRM)
 		abort();
 	test_uffdio_copy_eexist = true;
-	test_uffdio_zeropage_eexist = true;
 	alarm(ALARM_INTERVAL_SECS);
 }
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch
revert-userfaultfd-dont-fail-on-unrecognized-features.patch
selftests-mm-update-gitignore-with-two-missing-tests.patch
selftests-mm-dump-a-summary-in-run_vmtestssh.patch
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

