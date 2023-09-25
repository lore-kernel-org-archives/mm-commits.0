Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C75CE7A96
	for <mm-commits@archiver.kernel.org>; Mon, 25 Sep 2023 15:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjIYPhl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Sep 2023 11:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjIYPhj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2023 11:37:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17832111
        for <mm-commits@vger.kernel.org>; Mon, 25 Sep 2023 08:37:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E1EC433C8;
        Mon, 25 Sep 2023 15:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695656251;
        bh=cqkggYG+03tgK0EBKvuPiCQVcJ+qk6odsl3Pw1CmZnU=;
        h=Date:To:From:Subject:From;
        b=ZERyiKK9zA5vrC5MU9Z9LT5s+Mxd5MsHg9xVSY7uZ1XnP1IxJPwHZNvyTvW4t3Lx7
         1T/j2vGG4E+rTpJTQNoBxn1cPa4ceQnUv1DBmku4Zq/TgXFSGZucTzye0fTtRi8mjd
         GvI4TxjVmNH5pSPivfE5uwW2vJm8qVssm7dTvAXE=
Date:   Mon, 25 Sep 2023 08:37:31 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        willy@infradead.org, viro@zeniv.linux.org.uk, shuah@kernel.org,
        rppt@kernel.org, peterx@redhat.com, ngeoffray@google.com,
        mhocko@suse.com, lokeshgidra@google.com, Liam.Howlett@oracle.com,
        kaleshsingh@google.com, jannh@google.com, hughd@google.com,
        david@redhat.com, brauner@kernel.org, bgeffon@google.com,
        axelrasmussen@google.com, aarcange@redhat.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-uffdio_remap-ioctl-test.patch added to mm-unstable branch
Message-Id: <20230925153731.A4E1EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: add UFFDIO_REMAP ioctl test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-uffdio_remap-ioctl-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-uffdio_remap-ioctl-test.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: selftests/mm: add UFFDIO_REMAP ioctl test
Date: Fri, 22 Sep 2023 18:31:46 -0700

Add a test for new UFFDIO_REMAP ioctl which uses uffd to remaps source
into destination buffer while checking the contents of both after
remapping.  After the operation the content of the destination buffer
should match the original source buffer's content while the source buffer
should be zeroed.

Link: https://lkml.kernel.org/r/20230923013148.1390521-4-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c     |   41 ++++++++++-
 tools/testing/selftests/mm/uffd-common.h     |    1 
 tools/testing/selftests/mm/uffd-unit-tests.c |   62 +++++++++++++++++
 3 files changed, 102 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-add-uffdio_remap-ioctl-test
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -52,6 +52,13 @@ static int anon_allocate_area(void **all
 		*alloc_area = NULL;
 		return -errno;
 	}
+
+	/* Prevent source pages from collapsing into THPs */
+	if (madvise(*alloc_area, nr_pages * page_size, MADV_NOHUGEPAGE)) {
+		*alloc_area = NULL;
+		return -errno;
+	}
+
 	return 0;
 }
 
@@ -484,8 +491,14 @@ void uffd_handle_page_fault(struct uffd_
 		offset = (char *)(unsigned long)msg->arg.pagefault.address - area_dst;
 		offset &= ~(page_size-1);
 
-		if (copy_page(uffd, offset, args->apply_wp))
-			args->missing_faults++;
+		/* UFFD_REMAP is supported for anon non-shared mappings. */
+		if (uffd_test_ops == &anon_uffd_test_ops && !map_shared) {
+			if (remap_page(uffd, offset))
+				args->missing_faults++;
+		} else {
+			if (copy_page(uffd, offset, args->apply_wp))
+				args->missing_faults++;
+		}
 	}
 }
 
@@ -620,6 +633,30 @@ int copy_page(int ufd, unsigned long off
 	return __copy_page(ufd, offset, false, wp);
 }
 
+int remap_page(int ufd, unsigned long offset)
+{
+	struct uffdio_remap uffdio_remap;
+
+	if (offset >= nr_pages * page_size)
+		err("unexpected offset %lu\n", offset);
+	uffdio_remap.dst = (unsigned long) area_dst + offset;
+	uffdio_remap.src = (unsigned long) area_src + offset;
+	uffdio_remap.len = page_size;
+	uffdio_remap.mode = UFFDIO_REMAP_MODE_ALLOW_SRC_HOLES;
+	uffdio_remap.remap = 0;
+	if (ioctl(ufd, UFFDIO_REMAP, &uffdio_remap)) {
+		/* real retval in uffdio_remap.remap */
+		if (uffdio_remap.remap != -EEXIST)
+			err("UFFDIO_REMAP error: %"PRId64,
+			    (int64_t)uffdio_remap.remap);
+		wake_range(ufd, uffdio_remap.dst, page_size);
+	} else if (uffdio_remap.remap != page_size) {
+		err("UFFDIO_REMAP error: %"PRId64, (int64_t)uffdio_remap.remap);
+	} else
+		return 1;
+	return 0;
+}
+
 int uffd_open_dev(unsigned int flags)
 {
 	int fd, uffd;
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-add-uffdio_remap-ioctl-test
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -111,6 +111,7 @@ void wp_range(int ufd, __u64 start, __u6
 void uffd_handle_page_fault(struct uffd_msg *msg, struct uffd_args *args);
 int __copy_page(int ufd, unsigned long offset, bool retry, bool wp);
 int copy_page(int ufd, unsigned long offset, bool wp);
+int remap_page(int ufd, unsigned long offset);
 void *uffd_poll_thread(void *arg);
 
 int uffd_open_dev(unsigned int flags);
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-add-uffdio_remap-ioctl-test
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -824,6 +824,10 @@ static void uffd_events_test_common(bool
 	char c;
 	struct uffd_args args = { 0 };
 
+	/* Prevent source pages from being mapped more than once */
+	if (madvise(area_src, nr_pages * page_size, MADV_DONTFORK))
+		err("madvise(MADV_DONTFORK) failed");
+
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 	if (uffd_register(uffd, area_dst, nr_pages * page_size,
 			  true, wp, false))
@@ -1062,6 +1066,58 @@ static void uffd_poison_test(uffd_test_a
 	uffd_test_pass();
 }
 
+static void uffd_remap_test(uffd_test_args_t *targs)
+{
+	unsigned long nr;
+	pthread_t uffd_mon;
+	char c;
+	unsigned long long count;
+	struct uffd_args args = { 0 };
+
+	if (uffd_register(uffd, area_dst, nr_pages * page_size,
+			  true, false, false))
+		err("register failure");
+
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
+		err("uffd_poll_thread create");
+
+	/*
+	 * Read each of the pages back using the UFFD-registered mapping. We
+	 * expect that the first time we touch a page, it will result in a missing
+	 * fault. uffd_poll_thread will resolve the fault by remapping source
+	 * page to destination.
+	 */
+	for (nr = 0; nr < nr_pages; nr++) {
+		/* Check area_src content */
+		count = *area_count(area_src, nr);
+		if (count != count_verify[nr])
+			err("nr %lu source memory invalid %llu %llu\n",
+			    nr, count, count_verify[nr]);
+
+		/* Faulting into area_dst should remap the page */
+		count = *area_count(area_dst, nr);
+		if (count != count_verify[nr])
+			err("nr %lu memory corruption %llu %llu\n",
+			    nr, count, count_verify[nr]);
+
+		/* Re-check area_src content which should be empty */
+		count = *area_count(area_src, nr);
+		if (count != 0)
+			err("nr %lu remap failed %llu %llu\n",
+			    nr, count, count_verify[nr]);
+	}
+
+	if (write(pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join() failed");
+
+	if (args.missing_faults != nr_pages || args.minor_faults != 0)
+		uffd_test_fail("stats check error");
+	else
+		uffd_test_pass();
+}
+
 /*
  * Test the returned uffdio_register.ioctls with different register modes.
  * Note that _UFFDIO_ZEROPAGE is tested separately in the zeropage test.
@@ -1140,6 +1196,12 @@ uffd_test_case_t uffd_tests[] = {
 		.uffd_feature_required = 0,
 	},
 	{
+		.name = "remap",
+		.uffd_fn = uffd_remap_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = 0,
+	},
+	{
 		.name = "wp-fork",
 		.uffd_fn = uffd_wp_fork_test,
 		.mem_targets = MEM_ALL,
_

Patches currently in -mm which might be from surenb@google.com are

mm-lock-vmas-skipped-by-a-failed-queue_pages_range.patch
selftests-mm-add-uffdio_remap-ioctl-test.patch

