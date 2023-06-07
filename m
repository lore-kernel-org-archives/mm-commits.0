Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5A25C77B7A
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 02:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240768AbjFGChq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 22:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbjFGChg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 22:37:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E201731
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 19:37:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEA20639E1
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 02:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C03AC433EF;
        Wed,  7 Jun 2023 02:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686105453;
        bh=wfUJp6mL1t5glcXWipxFER222g1UyNnHhVgP8urxPjA=;
        h=Date:To:From:Subject:From;
        b=ui+gg/wkLnFWxZ8S9atMzJ5UZ6rlwdqJCAGALuz5ILsBAiZLv+svies06oifoyyDU
         8JLf8z1P9tObtCUeqb/9tnq+s8rJOUg4RoGsedwil9aJP4dOXPaa27v832482K6ymD
         gBlcJC71rKY/Ntjd9DxHdfF1j271wTvBkUrZtr1w=
Date:   Tue, 06 Jun 2023 19:37:32 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-move-certain-uffd-routines-from-vm_utilc-to-uffd-commonc.patch added to mm-unstable branch
Message-Id: <20230607023733.2C03AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: move certain uffd*() routines from vm_util.c to uffd-common.c
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-move-certain-uffd-routines-from-vm_utilc-to-uffd-commonc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-move-certain-uffd-routines-from-vm_utilc-to-uffd-commonc.patch

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
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: move certain uffd*() routines from vm_util.c to uffd-common.c
Date: Tue, 6 Jun 2023 00:16:35 -0700

There are only three uffd*() routines that are used outside of the uffd
selftests. Leave these in vm_util.c, where they are available to any mm
selftest program:

    uffd_register()
    uffd_unregister()
    uffd_register_with_ioctls().

A few other uffd*() routines, however, are only used by the uffd-focused
tests found in uffd-stress.c and uffd-unit-tests.c. Move those routines
into uffd-common.c.

Link: https://lkml.kernel.org/r/20230606071637.267103-10-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c |   59 +++++++++++++++++++++
 tools/testing/selftests/mm/uffd-common.h |    5 +
 tools/testing/selftests/mm/vm_util.c     |   59 ---------------------
 tools/testing/selftests/mm/vm_util.h     |    4 -
 4 files changed, 64 insertions(+), 63 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-move-certain-uffd-routines-from-vm_utilc-to-uffd-commonc
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -616,3 +616,62 @@ int copy_page(int ufd, unsigned long off
 {
 	return __copy_page(ufd, offset, false, wp);
 }
+
+int uffd_open_dev(unsigned int flags)
+{
+	int fd, uffd;
+
+	fd = open("/dev/userfaultfd", O_RDWR | O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+	uffd = ioctl(fd, USERFAULTFD_IOC_NEW, flags);
+	close(fd);
+
+	return uffd;
+}
+
+int uffd_open_sys(unsigned int flags)
+{
+#ifdef __NR_userfaultfd
+	return syscall(__NR_userfaultfd, flags);
+#else
+	return -1;
+#endif
+}
+
+int uffd_open(unsigned int flags)
+{
+	int uffd = uffd_open_sys(flags);
+
+	if (uffd < 0)
+		uffd = uffd_open_dev(flags);
+
+	return uffd;
+}
+
+int uffd_get_features(uint64_t *features)
+{
+	struct uffdio_api uffdio_api = { .api = UFFD_API, .features = 0 };
+	/*
+	 * This should by default work in most kernels; the feature list
+	 * will be the same no matter what we pass in here.
+	 */
+	int fd = uffd_open(UFFD_USER_MODE_ONLY);
+
+	if (fd < 0)
+		/* Maybe the kernel is older than user-only mode? */
+		fd = uffd_open(0);
+
+	if (fd < 0)
+		return fd;
+
+	if (ioctl(fd, UFFDIO_API, &uffdio_api)) {
+		close(fd);
+		return -errno;
+	}
+
+	*features = uffdio_api.features;
+	close(fd);
+
+	return 0;
+}
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-move-certain-uffd-routines-from-vm_utilc-to-uffd-commonc
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -110,6 +110,11 @@ int __copy_page(int ufd, unsigned long o
 int copy_page(int ufd, unsigned long offset, bool wp);
 void *uffd_poll_thread(void *arg);
 
+int uffd_open_dev(unsigned int flags);
+int uffd_open_sys(unsigned int flags);
+int uffd_open(unsigned int flags);
+int uffd_get_features(uint64_t *features);
+
 #define TEST_ANON	1
 #define TEST_HUGETLB	2
 #define TEST_SHMEM	3
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-move-certain-uffd-routines-from-vm_utilc-to-uffd-commonc
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -269,62 +269,3 @@ int uffd_unregister(int uffd, void *addr
 
 	return ret;
 }
-
-int uffd_open_dev(unsigned int flags)
-{
-	int fd, uffd;
-
-	fd = open("/dev/userfaultfd", O_RDWR | O_CLOEXEC);
-	if (fd < 0)
-		return fd;
-	uffd = ioctl(fd, USERFAULTFD_IOC_NEW, flags);
-	close(fd);
-
-	return uffd;
-}
-
-int uffd_open_sys(unsigned int flags)
-{
-#ifdef __NR_userfaultfd
-	return syscall(__NR_userfaultfd, flags);
-#else
-	return -1;
-#endif
-}
-
-int uffd_open(unsigned int flags)
-{
-	int uffd = uffd_open_sys(flags);
-
-	if (uffd < 0)
-		uffd = uffd_open_dev(flags);
-
-	return uffd;
-}
-
-int uffd_get_features(uint64_t *features)
-{
-	struct uffdio_api uffdio_api = { .api = UFFD_API, .features = 0 };
-	/*
-	 * This should by default work in most kernels; the feature list
-	 * will be the same no matter what we pass in here.
-	 */
-	int fd = uffd_open(UFFD_USER_MODE_ONLY);
-
-	if (fd < 0)
-		/* Maybe the kernel is older than user-only mode? */
-		fd = uffd_open(0);
-
-	if (fd < 0)
-		return fd;
-
-	if (ioctl(fd, UFFDIO_API, &uffdio_api)) {
-		close(fd);
-		return -errno;
-	}
-
-	*features = uffdio_api.features;
-	close(fd);
-
-	return 0;
-}
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-move-certain-uffd-routines-from-vm_utilc-to-uffd-commonc
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -49,10 +49,6 @@ int detect_hugetlb_page_sizes(size_t siz
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
 int uffd_unregister(int uffd, void *addr, uint64_t len);
-int uffd_open_dev(unsigned int flags);
-int uffd_open_sys(unsigned int flags);
-int uffd_open(unsigned int flags);
-int uffd_get_features(uint64_t *features);
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls);
 
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mm-fix-uffd-stress-unused-function-warning.patch
selftests-mm-fix-unused-variable-warnings-in-hugetlb-madvisec-migrationc.patch
selftests-mm-fix-warning-expression-which-evaluates-to-zero-in-mlock2-testsc.patch
selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts.patch
selftests-mm-gitignore-add-mkdirty-va_high_addr_switch.patch
selftests-mm-fix-two-wformat-security-warnings-in-uffd-builds.patch
selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h.patch
selftests-mm-fix-build-failures-due-to-missing-madv_collapse.patch
selftests-mm-move-certain-uffd-routines-from-vm_utilc-to-uffd-commonc.patch
documentation-kselftest-make-headers-is-a-prerequisite.patch
selftests-error-out-if-kernel-header-files-are-not-yet-built.patch
selftests-error-out-if-kernel-header-files-are-not-yet-built-fix.patch

