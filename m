Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB87CC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjDRXhq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjDRXgk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C77D315
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6680862EE4
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB070C433EF;
        Tue, 18 Apr 2023 23:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860923;
        bh=2UtNyMGub2BjoI1NqlgOU+bwfG462Y4mmZdKwpC0h/Y=;
        h=Date:To:From:Subject:From;
        b=U5w2RvKuOohTT8keg9/AxszWMh/1ymCtpf1RSJaJDDE2dP9yOQ7pgVxz697+tj1KW
         eWFSW3vWDtz0oLa5ld9PavRTCoocuZCDGdxlJM0C/iTHq6FHLm8JYeYBa4wIksvqre
         ywnOGdDKacG37qp22sCigvHIap7JeEDfMwmCMiXA=
Date:   Tue, 18 Apr 2023 16:35:23 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-uffd_open_devsys.patch removed from -mm tree
Message-Id: <20230418233523.BB070C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: uffd_open_{dev|sys}()
has been removed from the -mm tree.  Its filename was
     selftests-mm-uffd_open_devsys.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: uffd_open_{dev|sys}()
Date: Wed, 12 Apr 2023 12:42:54 -0400

Provide two helpers to open an uffd handle.  Drop the error checks around
SKIPs because it's inside an errexit() anyway, which IMHO doesn't really
help much if the test will not continue.

Link: https://lkml.kernel.org/r/20230412164254.328335-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c |   28 +++------------------
 tools/testing/selftests/mm/vm_util.c     |   24 ++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h     |    2 +
 3 files changed, 31 insertions(+), 23 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-uffd_open_devsys
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -192,34 +192,16 @@ void uffd_stats_report(struct uffd_stats
 	printf("\n");
 }
 
-static int __userfaultfd_open_dev(void)
-{
-	int fd, _uffd;
-
-	fd = open("/dev/userfaultfd", O_RDWR | O_CLOEXEC);
-	if (fd < 0)
-		errexit(KSFT_SKIP, "opening /dev/userfaultfd failed");
-
-	_uffd = ioctl(fd, USERFAULTFD_IOC_NEW, UFFD_FLAGS);
-	if (_uffd < 0)
-		errexit(errno == ENOTTY ? KSFT_SKIP : 1,
-			"creating userfaultfd failed");
-	close(fd);
-	return _uffd;
-}
-
 void userfaultfd_open(uint64_t *features)
 {
 	struct uffdio_api uffdio_api;
 
 	if (test_dev_userfaultfd)
-		uffd = __userfaultfd_open_dev();
-	else {
-		uffd = syscall(__NR_userfaultfd, UFFD_FLAGS);
-		if (uffd < 0)
-			errexit(errno == ENOSYS ? KSFT_SKIP : 1,
-				"creating userfaultfd failed");
-	}
+		uffd = uffd_open_dev(UFFD_FLAGS);
+	else
+		uffd = uffd_open_sys(UFFD_FLAGS);
+	if (uffd < 0)
+		err("uffd open failed (dev=%d)", test_dev_userfaultfd);
 	uffd_flags = fcntl(uffd, F_GETFD, NULL);
 
 	uffdio_api.api = UFFD_API;
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-uffd_open_devsys
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -3,6 +3,8 @@
 #include <fcntl.h>
 #include <sys/ioctl.h>
 #include <linux/userfaultfd.h>
+#include <sys/syscall.h>
+#include <unistd.h>
 #include "../kselftest.h"
 #include "vm_util.h"
 
@@ -230,3 +232,25 @@ int uffd_unregister(int uffd, void *addr
 
 	return ret;
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
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-uffd_open_devsys
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -48,6 +48,8 @@ unsigned long default_huge_page_size(voi
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
 int uffd_unregister(int uffd, void *addr, uint64_t len);
+int uffd_open_dev(unsigned int flags);
+int uffd_open_sys(unsigned int flags);
 
 /*
  * On ppc64 this will only work with radix 2M hugepage size
_

Patches currently in -mm which might be from peterx@redhat.com are

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

