Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65CCC6FA83
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiIKXj0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiIKXjY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:39:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC2826556
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 16:39:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FB26B80B54
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 23:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D90C433C1;
        Sun, 11 Sep 2022 23:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662939561;
        bh=2QFUaT9ok6P1NVz3t/D4JoscTqLVjF7UjhWIDZ6Gbj4=;
        h=Date:To:From:Subject:From;
        b=ElT07W/svzhd3HoLz/n23ecJCypbLghaudmN/6O60Z9107KieLEnK9U/imUYWKEiy
         ni+CATEDefsnxXEaNgojRs6gK8AfvvOppep2h1CIlxy/4IXCocuIjZSZJUq5OBt4f8
         Sq2y8f3wEmhn+WQvSX/KqeYVH1SPMkKGaiiCsB/8=
Date:   Sun, 11 Sep 2022 16:39:20 -0700
To:     mm-commits@vger.kernel.org, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, vbabka@suse.cz, surenb@google.com,
        skhan@linuxfoundation.org, shuah@kernel.org, rppt@linux.ibm.com,
        rppt@kernel.org, peterx@redhat.com, namit@vmware.com,
        mike.kravetz@oracle.com, mgorman@techsingularity.net,
        ldv@altlinux.org, jack@suse.cz, hughd@google.com,
        glebfm@altlinux.org, dave.hansen@linux.intel.com, corbet@lwn.net,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd-v7.patch removed from -mm tree
Message-Id: <20220911233920.D5D90C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd: selftests: modify selftest to use /dev/userfaultfd
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd-v7.patch

This patch was dropped because it was folded into userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch

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
userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd-v7.patch
selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch
kselftests-removing-support-of-libhugetlbfs-from-kselftests-fix.patch

