Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBF3C43217
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiKIBiy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiKIBif (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93A81EAD0
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55A976181B
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDBBC433D6;
        Wed,  9 Nov 2022 01:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957912;
        bh=iUpumFLsQeoa0EuVYk5T8vIFunVT5ux4uSzAL9ZCn3s=;
        h=Date:To:From:Subject:From;
        b=W42w5SmTmv2dXiDOn33FemnCAL2QnOni6oruinx5jYWIaGBjqX+f5oncmLcoquaET
         ziniWy1E5vemGTv4EVRINDS9lzmdNuKp3RhyDWTg60yW3zH3sW1qMj96vBdfbe5azU
         Tt6uI2XMiv4FGguVBv9QvdV3GT6SbcZO326US04o=
Date:   Tue, 08 Nov 2022 17:38:32 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shuah@kernel.org,
        rppt@kernel.org, peterx@redhat.com, namit@vmware.com,
        jhubbard@nvidia.com, jgg@nvidia.com, ddutile@redhat.com,
        crecklin@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch removed from -mm tree
Message-Id: <20221109013832.ABDBBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: factor out pagemap_is_populated() into vm_util
has been removed from the -mm tree.  Its filename was
     selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
mm-mprotect-minor-can_change_pte_writable-cleanups.patch
mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection.patch
mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required.patch
mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite.patch
mm-remove-unused-savedwrite-infrastructure.patch
selftests-vm-anon_cow-add-mprotect-optimization-tests.patch

