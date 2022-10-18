Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7022CC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiJRBIt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbiJRBI1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:08:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063048E79D
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:08:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A8EC61326
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836D9C433C1;
        Tue, 18 Oct 2022 01:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666055304;
        bh=zANh6oYbM0+Uj5nJ47TKW3ntY2yGWSeKslZBQQMugRk=;
        h=Date:To:From:Subject:From;
        b=A2k8IK5ignytRf6zPz2fv1DrsMaegfazZ2UR+xuMAVb2ebfHaG88ia7FtJYdjbLbA
         v7XGYZoJFeHQ7RLI5n6+rCOiMfPTwIDlzljhKt2lHIMycARV7/mWL0oxBw5/gRwCZS
         f3znhnuy0nehbId937QH2V9jbJrjjWwH+TKoJWQs=
Date:   Mon, 17 Oct 2022 18:08:23 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shuah@kernel.org,
        rppt@kernel.org, peterx@redhat.com, namit@vmware.com,
        jhubbard@nvidia.com, jgg@nvidia.com, ddutile@redhat.com,
        crecklin@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch added to mm-unstable branch
Message-Id: <20221018010824.836D9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: factor out pagemap_is_populated() into vm_util
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: selftests/vm: factor out pagemap_is_populated() into vm_util
Date: Tue, 27 Sep 2022 13:01:15 +0200

We'll reuse it in the anon_cow test next.

Link: https://lkml.kernel.org/r/20220927110120.106906-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph von Recklinghausen <crecklin@redhat.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/madv_populate.c |    8 --------
 tools/testing/selftests/vm/vm_util.c       |    8 ++++++++
 tools/testing/selftests/vm/vm_util.h       |    1 +
 3 files changed, 9 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/vm/madv_populate.c~selftests-vm-factor-out-pagemap_is_populated-into-vm_util
+++ a/tools/testing/selftests/vm/madv_populate.c
@@ -27,14 +27,6 @@
 
 static size_t pagesize;
 
-static bool pagemap_is_populated(int fd, char *start)
-{
-	uint64_t entry = pagemap_get_entry(fd, start);
-
-	/* Present or swapped. */
-	return entry & 0xc000000000000000ull;
-}
-
 static void sense_support(void)
 {
 	char *addr;
--- a/tools/testing/selftests/vm/vm_util.c~selftests-vm-factor-out-pagemap_is_populated-into-vm_util
+++ a/tools/testing/selftests/vm/vm_util.c
@@ -35,6 +35,14 @@ bool pagemap_is_swapped(int fd, char *st
 	return entry & 0x4000000000000000ull;
 }
 
+bool pagemap_is_populated(int fd, char *start)
+{
+	uint64_t entry = pagemap_get_entry(fd, start);
+
+	/* Present or swapped. */
+	return entry & 0xc000000000000000ull;
+}
+
 void clear_softdirty(void)
 {
 	int ret;
--- a/tools/testing/selftests/vm/vm_util.h~selftests-vm-factor-out-pagemap_is_populated-into-vm_util
+++ a/tools/testing/selftests/vm/vm_util.h
@@ -5,6 +5,7 @@
 uint64_t pagemap_get_entry(int fd, char *start);
 bool pagemap_is_softdirty(int fd, char *start);
 bool pagemap_is_swapped(int fd, char *start);
+bool pagemap_is_populated(int fd, char *start);
 void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
 uint64_t read_pmd_pagesize(void);
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch
selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch
selftests-vm-anon_cow-thp-tests.patch
selftests-vm-anon_cow-hugetlb-tests.patch
selftests-vm-anon_cow-add-liburing-test-cases.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch
selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch

