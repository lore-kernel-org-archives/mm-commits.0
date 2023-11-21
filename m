Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA64C61D85
	for <mm-commits@archiver.kernel.org>; Tue, 21 Nov 2023 23:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjKUXMF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Nov 2023 18:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbjKUXMB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2023 18:12:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBA1F9
        for <mm-commits@vger.kernel.org>; Tue, 21 Nov 2023 15:11:57 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD316C433C7;
        Tue, 21 Nov 2023 23:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700608317;
        bh=+dOjwUXulIBuU6IBw1MH3zWAyfozXpQuprv93qvJxuo=;
        h=Date:To:From:Subject:From;
        b=lBcSz66I7055AUoDwppP35KS6lHJgJ4PdERvEnyYDxPDZBwBF/ODzsQWaSPK+deNG
         z9BHMHsKONCWtAgRm4huO6dfEW+JRfZuIa1j3qouSJIcYXA5HLFBnZkeTUWN4RIhHf
         LM3SWaDV4Yl/D/nN0vfvJ8YB+MV6gVxC/FmmsbY8=
Date:   Tue, 21 Nov 2023 15:11:56 -0800
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        willy@infradead.org, viro@zeniv.linux.org.uk, shuah@kernel.org,
        rppt@kernel.org, peterx@redhat.com, ngeoffray@google.com,
        mhocko@suse.com, lokeshgidra@google.com, Liam.Howlett@oracle.com,
        kaleshsingh@google.com, jannh@google.com, hughd@google.com,
        david@redhat.com, brauner@kernel.org, bgeffon@google.com,
        axelrasmussen@google.com, aarcange@redhat.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-call-uffd_test_ctx_clear-at-the-end-of-the-test.patch added to mm-unstable branch
Message-Id: <20231121231156.DD316C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: call uffd_test_ctx_clear at the end of the test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-call-uffd_test_ctx_clear-at-the-end-of-the-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-call-uffd_test_ctx_clear-at-the-end-of-the-test.patch

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
Subject: selftests/mm: call uffd_test_ctx_clear at the end of the test
Date: Tue, 21 Nov 2023 09:16:36 -0800

uffd_test_ctx_clear() is being called from uffd_test_ctx_init() to unmap
areas used in the previous test run.  This approach is problematic because
while unmapping areas uffd_test_ctx_clear() uses page_size and nr_pages
which might differ from one test run to another.  Fix this by calling
uffd_test_ctx_clear() after each test is done.

Link: https://lkml.kernel.org/r/20231121171643.3719880-4-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c     |    4 +---
 tools/testing/selftests/mm/uffd-common.h     |    1 +
 tools/testing/selftests/mm/uffd-stress.c     |    5 ++++-
 tools/testing/selftests/mm/uffd-unit-tests.c |    1 +
 4 files changed, 7 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-call-uffd_test_ctx_clear-at-the-end-of-the-test
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -262,7 +262,7 @@ static inline void munmap_area(void **ar
 	*area = NULL;
 }
 
-static void uffd_test_ctx_clear(void)
+void uffd_test_ctx_clear(void)
 {
 	size_t i;
 
@@ -298,8 +298,6 @@ int uffd_test_ctx_init(uint64_t features
 	unsigned long nr, cpu;
 	int ret;
 
-	uffd_test_ctx_clear();
-
 	ret = uffd_test_ops->allocate_area((void **)&area_src, true);
 	ret |= uffd_test_ops->allocate_area((void **)&area_dst, false);
 	if (ret) {
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-call-uffd_test_ctx_clear-at-the-end-of-the-test
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -105,6 +105,7 @@ extern uffd_test_ops_t *uffd_test_ops;
 
 void uffd_stats_report(struct uffd_args *args, int n_cpus);
 int uffd_test_ctx_init(uint64_t features, const char **errmsg);
+void uffd_test_ctx_clear(void);
 int userfaultfd_open(uint64_t *features);
 int uffd_read_msg(int ufd, struct uffd_msg *msg);
 void wp_range(int ufd, __u64 start, __u64 len, bool wp);
--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-call-uffd_test_ctx_clear-at-the-end-of-the-test
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -323,8 +323,10 @@ static int userfaultfd_stress(void)
 		uffd_stats_reset(args, nr_cpus);
 
 		/* bounce pass */
-		if (stress(args))
+		if (stress(args)) {
+			uffd_test_ctx_clear();
 			return 1;
+		}
 
 		/* Clear all the write protections if there is any */
 		if (test_uffdio_wp)
@@ -354,6 +356,7 @@ static int userfaultfd_stress(void)
 
 		uffd_stats_report(args, nr_cpus);
 	}
+	uffd_test_ctx_clear();
 
 	return 0;
 }
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-call-uffd_test_ctx_clear-at-the-end-of-the-test
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1319,6 +1319,7 @@ int main(int argc, char *argv[])
 				continue;
 			}
 			test->uffd_fn(&args);
+			uffd_test_ctx_clear();
 		}
 	}
 
_

Patches currently in -mm which might be from surenb@google.com are

selftests-mm-call-uffd_test_ctx_clear-at-the-end-of-the-test.patch
selftests-mm-add-uffd_test_case_ops-to-allow-test-case-specific-operations.patch
selftests-mm-add-uffdio_move-ioctl-test.patch

