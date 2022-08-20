Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C239C28D13
	for <mm-commits@archiver.kernel.org>; Sat, 20 Aug 2022 00:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239441AbiHTAaB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Aug 2022 20:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiHTA36 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Aug 2022 20:29:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09B0B2DA0
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 17:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52BC8B829A0
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 00:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58F4C433C1;
        Sat, 20 Aug 2022 00:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660955395;
        bh=lnAfJ7W7j/M3osN1+cxLgqlXdYGpLz7HPSy/Fe7J6EU=;
        h=Date:To:From:Subject:From;
        b=cLb8upi/RMaKLJ6eBkmp9tWwRCXUccrPvo0rNPbIuJSOQ8FTLaGHD55af491oysbY
         Mk+t9kgCtFZvIG9GuXbd9rQ2DrBk6kEj20GlyyP4OliYUCcee1qqAO++To67YCCBUr
         b+KtJQwxG+2wT4LteleNie7iMgy000TmAoprl75I=
Date:   Fri, 19 Aug 2022 17:29:54 -0700
To:     mm-commits@vger.kernel.org, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, vbabka@suse.cz, surenb@google.com,
        skhan@linuxfoundation.org, shuah@kernel.org, rppt@linux.ibm.com,
        rppt@kernel.org, peterx@redhat.com, namit@vmware.com,
        mike.kravetz@oracle.com, mgorman@techsingularity.net,
        ldv@altlinux.org, jack@suse.cz, hughd@google.com,
        glebfm@altlinux.org, dave.hansen@linux.intel.com, corbet@lwn.net,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd-v7.patch added to mm-unstable branch
Message-Id: <20220820002954.E58F4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftests: modify selftest to use /dev/userfaultfd
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd-v7.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd-v7.patch

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
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd: selftests: modify selftest to use /dev/userfaultfd
Date: Fri, 19 Aug 2022 13:51:59 -0700

modify selftest to exit with KSFT_SKIP *only* when features are
unsupported, exiting with 1 in other error cases, per Mike

Link: https://lkml.kernel.org/r/20220819205201.658693-4-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry V. Levin <ldv@altlinux.org>
Cc: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd-v7
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -402,13 +402,16 @@ static void assert_expected_ioctls_prese
 
 static int __userfaultfd_open_dev(void)
 {
-	int fd, _uffd = -1;
+	int fd, _uffd;
 
 	fd = open("/dev/userfaultfd", O_RDWR | O_CLOEXEC);
 	if (fd < 0)
-		return -1;
+		errexit(KSFT_SKIP, "opening /dev/userfaultfd failed");
 
 	_uffd = ioctl(fd, USERFAULTFD_IOC_NEW, UFFD_FLAGS);
+	if (_uffd < 0)
+		errexit(errno == ENOTTY ? KSFT_SKIP : 1,
+			"creating userfaultfd failed");
 	close(fd);
 	return _uffd;
 }
@@ -419,10 +422,12 @@ static void userfaultfd_open(uint64_t *f
 
 	if (test_dev_userfaultfd)
 		uffd = __userfaultfd_open_dev();
-	else
+	else {
 		uffd = syscall(__NR_userfaultfd, UFFD_FLAGS);
-	if (uffd < 0)
-		errexit(KSFT_SKIP, "creating userfaultfd failed");
+		if (uffd < 0)
+			errexit(errno == ENOSYS ? KSFT_SKIP : 1,
+				"creating userfaultfd failed");
+	}
 	uffd_flags = fcntl(uffd, F_GETFD, NULL);
 
 	uffdio_api.api = UFFD_API;
_

Patches currently in -mm which might be from axelrasmussen@google.com are

selftests-vm-add-hugetlb_shared-userfaultfd-test-to-run_vmtestssh.patch
userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control.patch
userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control-v7.patch
userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch
userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd-v7.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd-v7.patch
selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch

