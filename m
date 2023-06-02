Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5939CC7EE2A
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jun 2023 02:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbjFBCcB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 22:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbjFBCb6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 22:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121AB194
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 19:31:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 911F464BC8
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 02:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A9AC433D2;
        Fri,  2 Jun 2023 02:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685673116;
        bh=UYKMg3y0qvGk0UvTs2D1f3B/BZTeFtFhx1uQ0e8I4dI=;
        h=Date:To:From:Subject:From;
        b=cYjMuqnm+IAyrEt0OI0iO0HaXwva37iReBUzk3KpF4dRFEzsyZDmVe4jQygErfE17
         WqJ0nGhg36fqWi/s6ZoHv14xsoZk3VAQzdVHBddb74f6RNVkD2gZFHou8juzToj0rc
         UmQv/taOJbUnNxSdB30fBNQpcwurx7NGdaahgMGA=
Date:   Thu, 01 Jun 2023 19:31:55 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc.patch added to mm-unstable branch
Message-Id: <20230602023155.E2A9AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: move uffd* routines from vm_util.c to uffd-common.c
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc.patch

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
Subject: selftests/mm: move uffd* routines from vm_util.c to uffd-common.c
Date: Thu, 1 Jun 2023 18:33:56 -0700

This is where they belong, and this makes it cleaner to apply a follow-up
fix to the uffd builds.

Link: https://lkml.kernel.org/r/20230602013358.900637-11-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile               |    7 
 tools/testing/selftests/mm/hugepage-mremap.c      |    2 
 tools/testing/selftests/mm/ksm_functional_tests.c |    2 
 tools/testing/selftests/mm/uffd-common.c          |  105 ++++++++++++
 tools/testing/selftests/mm/uffd-common.h          |   12 +
 tools/testing/selftests/mm/vm_util.c              |  104 -----------
 tools/testing/selftests/mm/vm_util.h              |   10 -
 7 files changed, 122 insertions(+), 120 deletions(-)

--- a/tools/testing/selftests/mm/hugepage-mremap.c~selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc
+++ a/tools/testing/selftests/mm/hugepage-mremap.c
@@ -24,7 +24,7 @@
 #include <sys/ioctl.h>
 #include <string.h>
 #include <stdbool.h>
-#include "vm_util.h"
+#include "uffd-common.h"
 
 #define DEFAULT_LENGTH_MB 10UL
 #define MB_TO_BYTES(x) (x * 1024 * 1024)
--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -22,7 +22,7 @@
 #include <linux/userfaultfd.h>
 
 #include "../kselftest.h"
-#include "vm_util.h"
+#include "uffd-common.h"
 
 #define KiB 1024u
 #define MiB (1024 * KiB)
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc
+++ a/tools/testing/selftests/mm/Makefile
@@ -110,8 +110,11 @@ include ../lib.mk
 
 $(TEST_GEN_PROGS): vm_util.c
 
-$(OUTPUT)/uffd-stress: uffd-common.c
-$(OUTPUT)/uffd-unit-tests: uffd-common.c
+$(OUTPUT)/uffd-stress:          uffd-common.c
+$(OUTPUT)/uffd-unit-tests:      uffd-common.c
+$(OUTPUT)/hugepage-mremap:      uffd-common.c
+$(OUTPUT)/write_to_hugetlbfs:   uffd-common.c
+$(OUTPUT)/ksm_functional_tests: uffd-common.c
 
 ifeq ($(MACHINE),x86_64)
 BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -6,6 +6,7 @@
  */
 
 #include "uffd-common.h"
+#include "vm_util.h"
 
 #define BASE_PMD_ADDR ((void *)(1UL << 30))
 
@@ -616,3 +617,107 @@ int copy_page(int ufd, unsigned long off
 {
 	return __copy_page(ufd, offset, false, wp);
 }
+
+/* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
+int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
+			      bool miss, bool wp, bool minor, uint64_t *ioctls)
+{
+	struct uffdio_register uffdio_register = { 0 };
+	uint64_t mode = 0;
+	int ret = 0;
+
+	if (miss)
+		mode |= UFFDIO_REGISTER_MODE_MISSING;
+	if (wp)
+		mode |= UFFDIO_REGISTER_MODE_WP;
+	if (minor)
+		mode |= UFFDIO_REGISTER_MODE_MINOR;
+
+	uffdio_register.range.start = (unsigned long)addr;
+	uffdio_register.range.len = len;
+	uffdio_register.mode = mode;
+
+	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) == -1)
+		ret = -errno;
+	else if (ioctls)
+		*ioctls = uffdio_register.ioctls;
+
+	return ret;
+}
+
+int uffd_register(int uffd, void *addr, uint64_t len,
+		  bool miss, bool wp, bool minor)
+{
+	return uffd_register_with_ioctls(uffd, addr, len,
+					 miss, wp, minor, NULL);
+}
+
+int uffd_unregister(int uffd, void *addr, uint64_t len)
+{
+	struct uffdio_range range = { .start = (uintptr_t)addr, .len = len };
+	int ret = 0;
+
+	if (ioctl(uffd, UFFDIO_UNREGISTER, &range) == -1)
+		ret = -errno;
+
+	return ret;
+}
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
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -19,8 +19,6 @@
 #include <signal.h>
 #include <poll.h>
 #include <string.h>
-#include <linux/mman.h>
-#include <sys/mman.h>
 #include <sys/syscall.h>
 #include <sys/ioctl.h>
 #include <sys/wait.h>
@@ -110,6 +108,16 @@ int __copy_page(int ufd, unsigned long o
 int copy_page(int ufd, unsigned long offset, bool wp);
 void *uffd_poll_thread(void *arg);
 
+int uffd_register(int uffd, void *addr, uint64_t len,
+		  bool miss, bool wp, bool minor);
+int uffd_unregister(int uffd, void *addr, uint64_t len);
+int uffd_open_dev(unsigned int flags);
+int uffd_open_sys(unsigned int flags);
+int uffd_open(unsigned int flags);
+int uffd_get_features(uint64_t *features);
+int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
+			      bool miss, bool wp, bool minor, uint64_t *ioctls);
+
 #define TEST_ANON	1
 #define TEST_HUGETLB	2
 #define TEST_SHMEM	3
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -225,110 +225,6 @@ int detect_hugetlb_page_sizes(size_t siz
 	return count;
 }
 
-/* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
-int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
-			      bool miss, bool wp, bool minor, uint64_t *ioctls)
-{
-	struct uffdio_register uffdio_register = { 0 };
-	uint64_t mode = 0;
-	int ret = 0;
-
-	if (miss)
-		mode |= UFFDIO_REGISTER_MODE_MISSING;
-	if (wp)
-		mode |= UFFDIO_REGISTER_MODE_WP;
-	if (minor)
-		mode |= UFFDIO_REGISTER_MODE_MINOR;
-
-	uffdio_register.range.start = (unsigned long)addr;
-	uffdio_register.range.len = len;
-	uffdio_register.mode = mode;
-
-	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) == -1)
-		ret = -errno;
-	else if (ioctls)
-		*ioctls = uffdio_register.ioctls;
-
-	return ret;
-}
-
-int uffd_register(int uffd, void *addr, uint64_t len,
-		  bool miss, bool wp, bool minor)
-{
-	return uffd_register_with_ioctls(uffd, addr, len,
-					 miss, wp, minor, NULL);
-}
-
-int uffd_unregister(int uffd, void *addr, uint64_t len)
-{
-	struct uffdio_range range = { .start = (uintptr_t)addr, .len = len };
-	int ret = 0;
-
-	if (ioctl(uffd, UFFDIO_UNREGISTER, &range) == -1)
-		ret = -errno;
-
-	return ret;
-}
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
-
 unsigned int psize(void)
 {
 	if (!__page_size)
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -34,16 +34,6 @@ int64_t allocate_transhuge(void *ptr, in
 unsigned long default_huge_page_size(void);
 int detect_hugetlb_page_sizes(size_t sizes[], int max);
 
-int uffd_register(int uffd, void *addr, uint64_t len,
-		  bool miss, bool wp, bool minor);
-int uffd_unregister(int uffd, void *addr, uint64_t len);
-int uffd_open_dev(unsigned int flags);
-int uffd_open_sys(unsigned int flags);
-int uffd_open(unsigned int flags);
-int uffd_get_features(uint64_t *features);
-int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
-			      bool miss, bool wp, bool minor, uint64_t *ioctls);
-
 /*
  * On ppc64 this will only work with radix 2M hugepage size
  */
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mm-fix-uffd-stress-unused-function-warning.patch
selftests-mm-fix-unused-variable-warning-in-hugetlb-madvisec.patch
selftests-mm-fix-unused-variable-warning-in-migrationc.patch
selftests-mm-fix-a-char-assignment-in-mlock2-testsc.patch
selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts.patch
selftests-mm-gitignore-add-mkdirty-va_high_addr_switch.patch
selftests-mm-set-wno-format-security-to-avoid-uffd-build-warnings.patch
selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h.patch
selftests-mm-move-psize-pshift-into-vm_utilsc.patch
selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc.patch
selftests-mm-fix-missing-uffdio_continue_mode_wp-and-similar-build-failures.patch
selftests-mm-fix-uffd-unit-testsc-build-failure-due-to-missing-madv_collapse.patch

