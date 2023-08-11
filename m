Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D72C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbjHKXBb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbjHKXAL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0654359D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47069678C4
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95983C433C8;
        Fri, 11 Aug 2023 23:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794800;
        bh=OMrNlvcit7Rs8aIyLcK0zfdPWEvqkLcQL2HbLl76bSM=;
        h=Date:To:From:Subject:From;
        b=YEF1Zrb8aLQI6Swu9DLn82B84TDxWxDRLazssZIkAgmN0HD5ZHR5w4YYZLP5akRh5
         6E/3ohl8ynbQBQ5vfKlLUiT/iLXlpfYDbmoUy3UIY112l72xDZONS/u08XckSP0Xv1
         ui56+WnI3Q79qymFcZ4WgnOmhIL/tqgj3CfON5rk=
Date:   Fri, 11 Aug 2023 16:00:00 -0700
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
Subject: [merged mm-stable] selftests-mm-add-uffd-unit-test-for-uffdio_poison.patch removed from -mm tree
Message-Id: <20230811230000.95983C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: add uffd unit test for UFFDIO_POISON
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-uffd-unit-test-for-uffdio_poison.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: selftests/mm: add uffd unit test for UFFDIO_POISON
Date: Fri, 7 Jul 2023 14:55:40 -0700

The test is pretty basic, and exercises UFFDIO_POISON straightforwardly. 
We register a region with userfaultfd, in missing fault mode.  For each
fault, we either UFFDIO_COPY a zeroed page (odd pages) or UFFDIO_POISON
(even pages).  We do this mix to test "something like a real use case",
where guest memory would be some mix of poisoned and non-poisoned pages.

We read each page in the region, and assert that the odd pages are zeroed
as expected, and the even pages yield a SIGBUS as expected.

Why UFFDIO_COPY instead of UFFDIO_ZEROPAGE?  Because hugetlb doesn't
support UFFDIO_ZEROPAGE, and we don't want to have special case code.

Link: https://lkml.kernel.org/r/20230707215540.2324998-9-axelrasmussen@google.com
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

 tools/testing/selftests/mm/uffd-unit-tests.c |  117 +++++++++++++++++
 1 file changed, 117 insertions(+)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-add-uffd-unit-test-for-uffdio_poison
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -951,6 +951,117 @@ static void uffd_zeropage_test(uffd_test
 	uffd_test_pass();
 }
 
+static void uffd_register_poison(int uffd, void *addr, uint64_t len)
+{
+	uint64_t ioctls = 0;
+	uint64_t expected = (1 << _UFFDIO_COPY) | (1 << _UFFDIO_POISON);
+
+	if (uffd_register_with_ioctls(uffd, addr, len, true,
+				      false, false, &ioctls))
+		err("poison register fail");
+
+	if ((ioctls & expected) != expected)
+		err("registered area doesn't support COPY and POISON ioctls");
+}
+
+static void do_uffdio_poison(int uffd, unsigned long offset)
+{
+	struct uffdio_poison uffdio_poison = { 0 };
+	int ret;
+	__s64 res;
+
+	uffdio_poison.range.start = (unsigned long) area_dst + offset;
+	uffdio_poison.range.len = page_size;
+	uffdio_poison.mode = 0;
+	ret = ioctl(uffd, UFFDIO_POISON, &uffdio_poison);
+	res = uffdio_poison.updated;
+
+	if (ret)
+		err("UFFDIO_POISON error: %"PRId64, (int64_t)res);
+	else if (res != page_size)
+		err("UFFDIO_POISON unexpected size: %"PRId64, (int64_t)res);
+}
+
+static void uffd_poison_handle_fault(
+	struct uffd_msg *msg, struct uffd_args *args)
+{
+	unsigned long offset;
+
+	if (msg->event != UFFD_EVENT_PAGEFAULT)
+		err("unexpected msg event %u", msg->event);
+
+	if (msg->arg.pagefault.flags &
+	    (UFFD_PAGEFAULT_FLAG_WP | UFFD_PAGEFAULT_FLAG_MINOR))
+		err("unexpected fault type %llu", msg->arg.pagefault.flags);
+
+	offset = (char *)(unsigned long)msg->arg.pagefault.address - area_dst;
+	offset &= ~(page_size-1);
+
+	/* Odd pages -> copy zeroed page; even pages -> poison. */
+	if (offset & page_size)
+		copy_page(uffd, offset, false);
+	else
+		do_uffdio_poison(uffd, offset);
+}
+
+static void uffd_poison_test(uffd_test_args_t *targs)
+{
+	pthread_t uffd_mon;
+	char c;
+	struct uffd_args args = { 0 };
+	struct sigaction act = { 0 };
+	unsigned long nr_sigbus = 0;
+	unsigned long nr;
+
+	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
+
+	uffd_register_poison(uffd, area_dst, nr_pages * page_size);
+	memset(area_src, 0, nr_pages * page_size);
+
+	args.handle_fault = uffd_poison_handle_fault;
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
+		err("uffd_poll_thread create");
+
+	sigbuf = &jbuf;
+	act.sa_sigaction = sighndl;
+	act.sa_flags = SA_SIGINFO;
+	if (sigaction(SIGBUS, &act, 0))
+		err("sigaction");
+
+	for (nr = 0; nr < nr_pages; ++nr) {
+		unsigned long offset = nr * page_size;
+		const char *bytes = (const char *) area_dst + offset;
+		const char *i;
+
+		if (sigsetjmp(*sigbuf, 1)) {
+			/*
+			 * Access below triggered a SIGBUS, which was caught by
+			 * sighndl, which then jumped here. Count this SIGBUS,
+			 * and move on to next page.
+			 */
+			++nr_sigbus;
+			continue;
+		}
+
+		for (i = bytes; i < bytes + page_size; ++i) {
+			if (*i)
+				err("nonzero byte in area_dst (%p) at %p: %u",
+				    area_dst, i, *i);
+		}
+	}
+
+	if (write(pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("pthread_join()");
+
+	if (nr_sigbus != nr_pages / 2)
+		err("expected to receive %lu SIGBUS, actually received %lu",
+		    nr_pages / 2, nr_sigbus);
+
+	uffd_test_pass();
+}
+
 /*
  * Test the returned uffdio_register.ioctls with different register modes.
  * Note that _UFFDIO_ZEROPAGE is tested separately in the zeropage test.
@@ -1126,6 +1237,12 @@ uffd_test_case_t uffd_tests[] = {
 		UFFD_FEATURE_PAGEFAULT_FLAG_WP |
 		UFFD_FEATURE_WP_HUGETLBFS_SHMEM,
 	},
+	{
+		.name = "poison",
+		.uffd_fn = uffd_poison_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_POISON,
+	},
 };
 
 static void usage(const char *prog)
_

Patches currently in -mm which might be from axelrasmussen@google.com are


