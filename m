Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69309C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjDRXho (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbjDRXgY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE5F83F7
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC82763A0B
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D440C433D2;
        Tue, 18 Apr 2023 23:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860919;
        bh=bYN6Jzt5FH+//iP+2OdUAa1VVQWE9N1qfZVLo+nyjEY=;
        h=Date:To:From:Subject:From;
        b=dzan05xw61K8f9HJFbX71SrctUL0intoWNyyrCJ/GcpaO0LxfElz8kGb7wrItrOP8
         8iomW3TxuGZOQuusvfDzvBmVD5YQHHayMpN8FsU1mqsBGEZyxzoWM/lt04vHvgrR1h
         O7q3G2BkMysTmEBUqytwgXkraARAw/B2bFKa7Fw0=
Date:   Tue, 18 Apr 2023 16:35:18 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-drop-test_uffdio_zeropage_eexist.patch removed from -mm tree
Message-Id: <20230418233519.0D440C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: drop test_uffdio_zeropage_eexist
has been removed from the -mm tree.  Its filename was
     selftests-mm-drop-test_uffdio_zeropage_eexist.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

