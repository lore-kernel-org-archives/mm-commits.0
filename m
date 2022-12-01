Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E604CC47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiLAAEL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiLAACd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:02:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F7055AAB
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05D84B81D80
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35DFC433D7;
        Thu,  1 Dec 2022 00:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852875;
        bh=4SqTmUtQP4g8O0kLkXPy2wY3xSY7pLQmN4iVHP7y4jk=;
        h=Date:To:From:Subject:From;
        b=ljh/yspH6WS3vq7cO7lcYy2pt93n07QYBv1n2ZYPrtE37DIgVDBA6jiIo/zc1f7FX
         vpl2lVbgo3cvuHw12vBa7UM8D0nSc/MvQhquZKVDYGuVzgK2VrfIix4aOAeO/390k/
         SzcAFyXkVRH0ZgOdtD/K542Xbnj3ZYXDpzAzQm98=
Date:   Wed, 30 Nov 2022 16:01:14 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
        npiggin@gmail.com, namit@vmware.com, mpe@ellerman.id.au,
        mgorman@techsingularity.net, hughd@google.com, david@fromorbit.com,
        anshuman.khandual@arm.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-anon_cow-add-mprotect-optimization-tests.patch removed from -mm tree
Message-Id: <20221201000115.A35DFC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: anon_cow: add mprotect() optimization tests
has been removed from the -mm tree.  Its filename was
     selftests-vm-anon_cow-add-mprotect-optimization-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests/vm: anon_cow: add mprotect() optimization tests
Date: Tue, 8 Nov 2022 18:46:52 +0100

Let's extend the test to cover the possible mprotect() optimization when
removing write-protection. mprotect() must not allow write-access to a
COW-shared page by accident.

Link: https://lkml.kernel.org/r/20221108174652.198904-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/anon_cow.c |   49 ++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/vm/anon_cow.c~selftests-vm-anon_cow-add-mprotect-optimization-tests
+++ a/tools/testing/selftests/vm/anon_cow.c
@@ -190,7 +190,8 @@ static int child_vmsplice_memcmp_fn(char
 
 typedef int (*child_fn)(char *mem, size_t size, struct comm_pipes *comm_pipes);
 
-static void do_test_cow_in_parent(char *mem, size_t size, child_fn fn)
+static void do_test_cow_in_parent(char *mem, size_t size, bool do_mprotect,
+				  child_fn fn)
 {
 	struct comm_pipes comm_pipes;
 	char buf;
@@ -212,6 +213,22 @@ static void do_test_cow_in_parent(char *
 
 	while (read(comm_pipes.child_ready[0], &buf, 1) != 1)
 		;
+
+	if (do_mprotect) {
+		/*
+		 * mprotect() optimizations might try avoiding
+		 * write-faults by directly mapping pages writable.
+		 */
+		ret = mprotect(mem, size, PROT_READ);
+		ret |= mprotect(mem, size, PROT_READ|PROT_WRITE);
+		if (ret) {
+			ksft_test_result_fail("mprotect() failed\n");
+			write(comm_pipes.parent_ready[1], "0", 1);
+			wait(&ret);
+			goto close_comm_pipes;
+		}
+	}
+
 	/* Modify the page. */
 	memset(mem, 0xff, size);
 	write(comm_pipes.parent_ready[1], "0", 1);
@@ -229,12 +246,22 @@ close_comm_pipes:
 
 static void test_cow_in_parent(char *mem, size_t size)
 {
-	do_test_cow_in_parent(mem, size, child_memcmp_fn);
+	do_test_cow_in_parent(mem, size, false, child_memcmp_fn);
+}
+
+static void test_cow_in_parent_mprotect(char *mem, size_t size)
+{
+	do_test_cow_in_parent(mem, size, true, child_memcmp_fn);
 }
 
 static void test_vmsplice_in_child(char *mem, size_t size)
 {
-	do_test_cow_in_parent(mem, size, child_vmsplice_memcmp_fn);
+	do_test_cow_in_parent(mem, size, false, child_vmsplice_memcmp_fn);
+}
+
+static void test_vmsplice_in_child_mprotect(char *mem, size_t size)
+{
+	do_test_cow_in_parent(mem, size, true, child_vmsplice_memcmp_fn);
 }
 
 static void do_test_vmsplice_in_parent(char *mem, size_t size,
@@ -970,6 +997,14 @@ static const struct test_case test_cases
 		test_cow_in_parent,
 	},
 	/*
+	 * Basic test, but do an additional mprotect(PROT_READ)+
+	 * mprotect(PROT_READ|PROT_WRITE) in the parent before write access.
+	 */
+	{
+		"Basic COW after fork() with mprotect() optimization",
+		test_cow_in_parent_mprotect,
+	},
+	/*
 	 * vmsplice() [R/O GUP] + unmap in the child; modify in the parent. If
 	 * we miss to break COW, the child observes modifications by the parent.
 	 * This is CVE-2020-29374 reported by Jann Horn.
@@ -979,6 +1014,14 @@ static const struct test_case test_cases
 		test_vmsplice_in_child
 	},
 	/*
+	 * vmsplice() test, but do an additional mprotect(PROT_READ)+
+	 * mprotect(PROT_READ|PROT_WRITE) in the parent before write access.
+	 */
+	{
+		"vmsplice() + unmap in child with mprotect() optimization",
+		test_vmsplice_in_child_mprotect
+	},
+	/*
 	 * vmsplice() [R/O GUP] in parent before fork(), unmap in parent after
 	 * fork(); modify in the child. If we miss to break COW, the parent
 	 * observes modifications by the child.
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

