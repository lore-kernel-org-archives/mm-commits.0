Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF64C001B0
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjGIAzi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjGIAze (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:55:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC8FE4D
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 17:55:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C8D460B70
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 00:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE9DC433C7;
        Sun,  9 Jul 2023 00:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688864131;
        bh=GkOP19MsuVaY3xOjgNd4X2x4/QsDoTtRLVE5XLO+YQo=;
        h=Date:To:From:Subject:From;
        b=11pbID2x6xL5oy8AyXF/XGzZdWtXDRSBe0vLgsCvClY3L1PfzmeqeamkT7iAk+BNk
         fDgpQpbh5/YY9YVNNTwdSvdoUlR6822ieADmbEEmKA3z50HIbbNQBbEZcLApZWmLDG
         Hv8GMe0VQ3EoCpT8C7iJeNaqHH14YVRDYbHsaQZk=
Date:   Sat, 08 Jul 2023 17:55:31 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        yuzhao@google.com, ying.huang@intel.com,
        wangkefeng.wang@huawei.com, viro@zeniv.linux.org.uk,
        talumbau@google.com, surenb@google.com, suleiman@google.com,
        shuah@kernel.org, ryan.roberts@arm.com, rppt@kernel.org,
        peterx@redhat.com, naoya.horiguchi@nec.com, namit@vmware.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, Liam.Howlett@oracle.com,
        jthoughton@google.com, jiaqiyan@google.com, hughd@google.com,
        heftig@archlinux.org, david@redhat.com, cuigaosheng1@huawei.com,
        corbet@lwn.net, brauner@kernel.org, bgeffon@google.com,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-refactor-uffd_poll_thread-to-allow-custom-fault-handlers.patch added to mm-unstable branch
Message-Id: <20230709005531.ABE9DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: refactor uffd_poll_thread to allow custom fault handlers
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-refactor-uffd_poll_thread-to-allow-custom-fault-handlers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-refactor-uffd_poll_thread-to-allow-custom-fault-handlers.patch

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
Subject: selftests/mm: refactor uffd_poll_thread to allow custom fault handlers
Date: Fri, 7 Jul 2023 14:55:39 -0700

Previously, we had "one fault handler to rule them all", which used
several branches to deal with all of the scenarios required by all of the
various tests.

In upcoming patches, I plan to add a new test, which has its own slightly
different fault handling logic.  Instead of continuing to add cruft to the
existing fault handler, let's allow tests to define custom ones, separate
from other tests.

Link: https://lkml.kernel.org/r/20230707215540.2324998-8-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nadav Amit <namit@vmware.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: T.J. Alumbaugh <talumbau@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c |    5 ++++-
 tools/testing/selftests/mm/uffd-common.h |    3 +++
 tools/testing/selftests/mm/uffd-stress.c |    8 ++++----
 3 files changed, 11 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-refactor-uffd_poll_thread-to-allow-custom-fault-handlers
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -499,6 +499,9 @@ void *uffd_poll_thread(void *arg)
 	int ret;
 	char tmp_chr;
 
+	if (!args->handle_fault)
+		args->handle_fault = uffd_handle_page_fault;
+
 	pollfd[0].fd = uffd;
 	pollfd[0].events = POLLIN;
 	pollfd[1].fd = pipefd[cpu*2];
@@ -527,7 +530,7 @@ void *uffd_poll_thread(void *arg)
 			err("unexpected msg event %u\n", msg.event);
 			break;
 		case UFFD_EVENT_PAGEFAULT:
-			uffd_handle_page_fault(&msg, args);
+			args->handle_fault(&msg, args);
 			break;
 		case UFFD_EVENT_FORK:
 			close(uffd);
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-refactor-uffd_poll_thread-to-allow-custom-fault-handlers
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -77,6 +77,9 @@ struct uffd_args {
 	unsigned long missing_faults;
 	unsigned long wp_faults;
 	unsigned long minor_faults;
+
+	/* A custom fault handler; defaults to uffd_handle_page_fault. */
+	void (*handle_fault)(struct uffd_msg *msg, struct uffd_args *args);
 };
 
 struct uffd_test_ops {
--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-refactor-uffd_poll_thread-to-allow-custom-fault-handlers
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -189,10 +189,8 @@ static int stress(struct uffd_args *args
 				   locking_thread, (void *)cpu))
 			return 1;
 		if (bounces & BOUNCE_POLL) {
-			if (pthread_create(&uffd_threads[cpu], &attr,
-					   uffd_poll_thread,
-					   (void *)&args[cpu]))
-				return 1;
+			if (pthread_create(&uffd_threads[cpu], &attr, uffd_poll_thread, &args[cpu]))
+				err("uffd_poll_thread create");
 		} else {
 			if (pthread_create(&uffd_threads[cpu], &attr,
 					   uffd_read_thread,
@@ -250,6 +248,8 @@ static int userfaultfd_stress(void)
 	struct uffd_args args[nr_cpus];
 	uint64_t mem_size = nr_pages * page_size;
 
+	memset(args, 0, sizeof(struct uffd_args) * nr_cpus);
+
 	if (uffd_test_ctx_init(UFFD_FEATURE_WP_UNPOPULATED, NULL))
 		err("context init failed");
 
_

Patches currently in -mm which might be from axelrasmussen@google.com are

mm-make-pte_marker_swapin_error-more-general.patch
mm-userfaultfd-check-for-start-len-overflow-in-validate_range.patch
mm-userfaultfd-extract-file-size-check-out-into-a-helper.patch
mm-userfaultfd-add-new-uffdio_poison-ioctl.patch
mm-userfaultfd-support-uffdio_poison-for-hugetlbfs.patch
mm-userfaultfd-document-and-enable-new-uffdio_poison-feature.patch
selftests-mm-refactor-uffd_poll_thread-to-allow-custom-fault-handlers.patch
selftests-mm-add-uffd-unit-test-for-uffdio_poison.patch

