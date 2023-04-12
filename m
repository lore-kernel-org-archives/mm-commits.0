Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98490C7619A
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 20:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjDLUCm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjDLUCg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 16:02:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AF34ED8
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 13:02:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11549638BE
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 20:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C13EC4339B;
        Wed, 12 Apr 2023 20:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681329753;
        bh=Avra066I13eidh0fvpOf7oyQrsD4rkT6AQbO+dB0Mrs=;
        h=Date:To:From:Subject:From;
        b=vyWU+cj7hHhFZs+pKA5v45PZWN1/Zgs0Vz5QboEHxWGhag87m4HercX5hNn1K21wF
         I2DRFUOwoj5BQ/D00qAid/ZDFR+qWUfUz3GEpN8wnNfpZBmcu18uA9DF/i8HSuwr1z
         NAvgn3XZKNJAD2HyDlj51U3O2sifmeZccSM4WJac=
Date:   Wed, 12 Apr 2023 13:02:32 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-use-pm_-macros-in-vm_utilsh.patch added to mm-unstable branch
Message-Id: <20230412200233.6C13EC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: use PM_* macros in vm_utils.h
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-use-pm_-macros-in-vm_utilsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-use-pm_-macros-in-vm_utilsh.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: use PM_* macros in vm_utils.h
Date: Wed, 12 Apr 2023 12:42:27 -0400

We've got the macros in uffd-stress.c, move it over and use it in
vm_util.h.

Link: https://lkml.kernel.org/r/20230412164227.328145-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/userfaultfd.c |    8 --------
 tools/testing/selftests/mm/vm_util.c     |   16 ++++------------
 tools/testing/selftests/mm/vm_util.h     |    8 ++++++++
 3 files changed, 12 insertions(+), 20 deletions(-)

--- a/tools/testing/selftests/mm/userfaultfd.c~selftests-mm-use-pm_-macros-in-vm_utilsh
+++ a/tools/testing/selftests/mm/userfaultfd.c
@@ -1389,14 +1389,6 @@ static int userfaultfd_minor_test(void)
 	return stats.missing_faults != 0 || stats.minor_faults != nr_pages;
 }
 
-#define BIT_ULL(nr)                   (1ULL << (nr))
-#define PM_SOFT_DIRTY                 BIT_ULL(55)
-#define PM_MMAP_EXCLUSIVE             BIT_ULL(56)
-#define PM_UFFD_WP                    BIT_ULL(57)
-#define PM_FILE                       BIT_ULL(61)
-#define PM_SWAP                       BIT_ULL(62)
-#define PM_PRESENT                    BIT_ULL(63)
-
 static int pagemap_open(void)
 {
 	int fd = open("/proc/self/pagemap", O_RDONLY);
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-use-pm_-macros-in-vm_utilsh
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -25,25 +25,17 @@ uint64_t pagemap_get_entry(int fd, char
 
 bool pagemap_is_softdirty(int fd, char *start)
 {
-	uint64_t entry = pagemap_get_entry(fd, start);
-
-	// Check if dirty bit (55th bit) is set
-	return entry & 0x0080000000000000ull;
+	return pagemap_get_entry(fd, start) & PM_SOFT_DIRTY;
 }
 
 bool pagemap_is_swapped(int fd, char *start)
 {
-	uint64_t entry = pagemap_get_entry(fd, start);
-
-	return entry & 0x4000000000000000ull;
+	return pagemap_get_entry(fd, start) & PM_SWAP;
 }
 
 bool pagemap_is_populated(int fd, char *start)
 {
-	uint64_t entry = pagemap_get_entry(fd, start);
-
-	/* Present or swapped. */
-	return entry & 0xc000000000000000ull;
+	return pagemap_get_entry(fd, start) & (PM_PRESENT | PM_SWAP);
 }
 
 unsigned long pagemap_get_pfn(int fd, char *start)
@@ -51,7 +43,7 @@ unsigned long pagemap_get_pfn(int fd, ch
 	uint64_t entry = pagemap_get_entry(fd, start);
 
 	/* If present (63th bit), PFN is at bit 0 -- 54. */
-	if (entry & 0x8000000000000000ull)
+	if (entry & PM_PRESENT)
 		return entry & 0x007fffffffffffffull;
 	return -1ul;
 }
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-use-pm_-macros-in-vm_utilsh
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -6,6 +6,14 @@
 #include <string.h> /* ffsl() */
 #include <unistd.h> /* _SC_PAGESIZE */
 
+#define BIT_ULL(nr)                   (1ULL << (nr))
+#define PM_SOFT_DIRTY                 BIT_ULL(55)
+#define PM_MMAP_EXCLUSIVE             BIT_ULL(56)
+#define PM_UFFD_WP                    BIT_ULL(57)
+#define PM_FILE                       BIT_ULL(61)
+#define PM_SWAP                       BIT_ULL(62)
+#define PM_PRESENT                    BIT_ULL(63)
+
 extern unsigned int __page_size;
 extern unsigned int __page_shift;
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch
revert-userfaultfd-dont-fail-on-unrecognized-features.patch
selftests-mm-update-gitignore-with-two-missing-tests.patch
selftests-mm-dump-a-summary-in-run_vmtestssh.patch
selftests-mm-merge-utilh-into-vm_utilh.patch
selftests-mm-use-test_gen_progs-where-proper.patch
selftests-mm-link-vm_utilc-always.patch
selftests-mm-merge-default_huge_page_size-into-one.patch
selftests-mm-use-pm_-macros-in-vm_utilsh.patch
selftests-mm-reuse-pagemap_get_entry-in-vm_utilh.patch
selftests-mm-test-uffdio_zeropage-only-when-hugetlb.patch
selftests-mm-drop-test_uffdio_zeropage_eexist.patch
selftests-mm-create-uffd-common.patch
selftests-mm-split-uffd-tests-into-uffd-stress-and-uffd-unit-tests.patch
selftests-mm-uffd_register.patch
selftests-mm-uffd_open_devsys.patch
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

