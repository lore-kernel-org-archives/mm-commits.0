Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEDDCC25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 15:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240200AbiHQPqr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 11:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240103AbiHQPqp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 11:46:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B8580B66
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 08:46:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C64961589
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 15:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD52C433C1;
        Wed, 17 Aug 2022 15:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660751203;
        bh=qduiOa0d8rZYV1pBsaQnsyWO8IPGK97k3+kT3TOYWps=;
        h=Date:To:From:Subject:From;
        b=vzapPz7MzlcmEM320BI4QTRSDD0adm/OgSE1sagf4KGQ6q6eid4PImUg9jEURNugN
         RBqYn7936BeihHuaAUFoPCJVj1iuhSf4GeJQ4kIkPTSkbsSUzAswurvjIdT8UQMrmz
         C5uBCspxY4KPEHSjXR9K5dLQ3an2uwJPawZhHh44=
Date:   Wed, 17 Aug 2022 08:46:42 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        osalvador@suse.de, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate-fix-syscall-move_pages-return-value-for-failure.patch added to mm-unstable branch
Message-Id: <20220817154642.DCD52C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate: fix syscall move_pages() return value for failure
has been added to the -mm mm-unstable branch.  Its filename is
     migrate-fix-syscall-move_pages-return-value-for-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate-fix-syscall-move_pages-return-value-for-failure.patch

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
From: Huang Ying <ying.huang@intel.com>
Subject: migrate: fix syscall move_pages() return value for failure
Date: Wed, 17 Aug 2022 16:14:01 +0800

Patch series "migrate_pages(): fix several bugs in error path", v3.

During review the code of migrate_pages() and build a test program for
it.  Several bugs in error path are identified and fixed in this
series.

Most patches are tested via

- Apply error-inject.patch in Linux kernel
- Compile test-migrate.c (with -lnuma)
- Test with test-migrate.sh

error-inject.patch, test-migrate.c, and test-migrate.sh are as below.
It turns out that error injection is an important tool to fix bugs in
error path.


This patch (of 8):

The return value of move_pages() syscall is incorrect when counting
the remaining pages to be migrated.  For example, for the following
test program,

"
 #define _GNU_SOURCE

 #include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
 #include <errno.h>

 #include <fcntl.h>
 #include <sys/uio.h>
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <unistd.h>
 #include <numaif.h>
 #include <numa.h>

 #ifndef MADV_FREE
 #define MADV_FREE	8		/* free pages only if memory pressure */
 #endif

 #define ONE_MB		(1024 * 1024)
 #define MAP_SIZE	(16 * ONE_MB)
 #define THP_SIZE	(2 * ONE_MB)
 #define THP_MASK	(THP_SIZE - 1)

 #define ERR_EXIT_ON(cond, msg)					\
	 do {							\
		 int __cond_in_macro = (cond);			\
		 if (__cond_in_macro)				\
			 error_exit(__cond_in_macro, (msg));	\
	 } while (0)

 void error_msg(int ret, int nr, int *status, const char *msg)
 {
	 int i;

	 fprintf(stderr, "Error: %s, ret : %d, error: %s\n",
		 msg, ret, strerror(errno));

	 if (!nr)
		 return;
	 fprintf(stderr, "status: ");
	 for (i = 0; i < nr; i++)
		 fprintf(stderr, "%d ", status[i]);
	 fprintf(stderr, "\n");
 }

 void error_exit(int ret, const char *msg)
 {
	 error_msg(ret, 0, NULL, msg);
	 exit(1);
 }

 int page_size;

 bool do_vmsplice;
 bool do_thp;

 static int pipe_fds[2];
 void *addr;
 char *pn;
 char *pn1;
 void *pages[2];
 int status[2];

 void prepare()
 {
	 int ret;
	 struct iovec iov;

	 if (addr) {
		 munmap(addr, MAP_SIZE);
		 close(pipe_fds[0]);
		 close(pipe_fds[1]);
	 }

	 ret = pipe(pipe_fds);
	 ERR_EXIT_ON(ret, "pipe");

	 addr = mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE,
		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	 ERR_EXIT_ON(addr == MAP_FAILED, "mmap");
	 if (do_thp) {
		 ret = madvise(addr, MAP_SIZE, MADV_HUGEPAGE);
		 ERR_EXIT_ON(ret, "advise hugepage");
	 }

	 pn = (char *)(((unsigned long)addr + THP_SIZE) & ~THP_MASK);
	 pn1 = pn + THP_SIZE;
	 pages[0] = pn;
	 pages[1] = pn1;
	 *pn = 1;

	 if (do_vmsplice) {
		 iov.iov_base = pn;
		 iov.iov_len = page_size;
		 ret = vmsplice(pipe_fds[1], &iov, 1, 0);
		 ERR_EXIT_ON(ret < 0, "vmsplice");
	 }

	 status[0] = status[1] = 1024;
 }

 void test_migrate()
 {
	 int ret;
	 int nodes[2] = { 1, 1 };
	 pid_t pid = getpid();

	 prepare();
	 ret = move_pages(pid, 1, pages, nodes, status, MPOL_MF_MOVE_ALL);
	 error_msg(ret, 1, status, "move 1 page");

	 prepare();
	 ret = move_pages(pid, 2, pages, nodes, status, MPOL_MF_MOVE_ALL);
	 error_msg(ret, 2, status, "move 2 pages, page 1 not mapped");

	 prepare();
	 *pn1 = 1;
	 ret = move_pages(pid, 2, pages, nodes, status, MPOL_MF_MOVE_ALL);
	 error_msg(ret, 2, status, "move 2 pages");

	 prepare();
	 *pn1 = 1;
	 nodes[1] = 0;
	 ret = move_pages(pid, 2, pages, nodes, status, MPOL_MF_MOVE_ALL);
	 error_msg(ret, 2, status, "move 2 pages, page 1 to node 0");
 }

 int main(int argc, char *argv[])
 {
	 numa_run_on_node(0);
	 page_size = getpagesize();

	 test_migrate();

	 fprintf(stderr, "\nMake page 0 cannot be migrated:\n");
	 do_vmsplice = true;
	 test_migrate();

	 fprintf(stderr, "\nTest THP:\n");
	 do_thp = true;
	 do_vmsplice = false;
	 test_migrate();

	 fprintf(stderr, "\nTHP: make page 0 cannot be migrated:\n");
	 do_vmsplice = true;
	 test_migrate();

	 return 0;
 }
"

The output of the current kernel is,

"
Error: move 1 page, ret : 0, error: Success
status: 1
Error: move 2 pages, page 1 not mapped, ret : 0, error: Success
status: 1 -14
Error: move 2 pages, ret : 0, error: Success
status: 1 1
Error: move 2 pages, page 1 to node 0, ret : 0, error: Success
status: 1 0

Make page 0 cannot be migrated:
Error: move 1 page, ret : 0, error: Success
status: 1024
Error: move 2 pages, page 1 not mapped, ret : 1, error: Success
status: 1024 -14
Error: move 2 pages, ret : 0, error: Success
status: 1024 1024
Error: move 2 pages, page 1 to node 0, ret : 1, error: Success
status: 1024 1024
"

While the expected output is,

"
Error: move 1 page, ret : 0, error: Success
status: 1
Error: move 2 pages, page 1 not mapped, ret : 0, error: Success
status: 1 -14
Error: move 2 pages, ret : 0, error: Success
status: 1 1
Error: move 2 pages, page 1 to node 0, ret : 0, error: Success
status: 1 0

Make page 0 cannot be migrated:
Error: move 1 page, ret : 1, error: Success
status: 1024
Error: move 2 pages, page 1 not mapped, ret : 1, error: Success
status: 1024 -14
Error: move 2 pages, ret : 1, error: Success
status: 1024 1024
Error: move 2 pages, page 1 to node 0, ret : 2, error: Success
status: 1024 1024
"

Fix this via correcting the remaining pages counting.  With the fix,
the output for the test program as above is expected.

Link: https://lkml.kernel.org/r/20220817081408.513338-1-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20220817081408.513338-2-ying.huang@intel.com
Fixes: 5984fabb6e82 ("mm: move_pages: report the number of non-attempted pages")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~migrate-fix-syscall-move_pages-return-value-for-failure
+++ a/mm/migrate.c
@@ -1751,7 +1751,7 @@ static int move_pages_and_store_status(s
 		 * well.
 		 */
 		if (err > 0)
-			err += nr_pages - i - 1;
+			err += nr_pages - i;
 		return err;
 	}
 	return store_status(status, start, node, i - start);
@@ -1837,8 +1837,12 @@ static int do_pages_move(struct mm_struc
 
 		err = move_pages_and_store_status(mm, current_node, &pagelist,
 				status, start, i, nr_pages);
-		if (err)
+		if (err) {
+			/* We have accounted for page i */
+			if (err > 0)
+				err--;
 			goto out;
+		}
 		current_node = NUMA_NO_NODE;
 	}
 out_flush:
_

Patches currently in -mm which might be from ying.huang@intel.com are

memory-tiering-hot-page-selection-with-hint-page-fault-latency.patch
memory-tiering-rate-limit-numa-migration-throughput.patch
memory-tiering-adjust-hot-threshold-automatically.patch
migrate-fix-syscall-move_pages-return-value-for-failure.patch
migrate_pages-remove-unnecessary-list_safe_reset_next.patch
migrate_pages-fix-thp-failure-counting-for-enomem.patch
migrate_pages-fix-failure-counting-for-thp-subpages-retrying.patch
migrate_pages-fix-failure-counting-for-thp-on-enosys.patch
migrate_pages-fix-failure-counting-for-thp-splitting.patch
migrate_pages-fix-failure-counting-for-retry.patch

