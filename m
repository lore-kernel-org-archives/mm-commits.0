From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch added to
 -mm tree
Date: Sun, 23 Feb 2020 20:08:48 -0800
Message-ID: <20200224040848.n-Q9oNgDQ%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbgBXEIu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 23 Feb 2020 23:08:50 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bgeffon@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes

ERROR: Bad function definition - void mremap_dontunmap_partial_mapping_overwrite() should probably be void mremap_dontunmap_partial_mapping_overwrite(void)
#34: FILE: tools/testing/selftests/vm/mremap_dontunmap.c:228:
+static void mremap_dontunmap_partial_mapping_overwrite()

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#68: FILE: tools/testing/selftests/vm/mremap_dontunmap.c:251:
+	BUG_ON(source_mapping == MAP_FAILED, "mmap");

WARNING: line over 80 characters
#109: FILE: tools/testing/selftests/vm/mremap_dontunmap.c:264:
+		   MREMAP_DONTUNMAP | MREMAP_MAYMOVE | MREMAP_FIXED, dest_mapping);

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#110: FILE: tools/testing/selftests/vm/mremap_dontunmap.c:265:
+	BUG_ON(dest_mapping == MAP_FAILED, "mremap");

WARNING: line over 80 characters
#111: FILE: tools/testing/selftests/vm/mremap_dontunmap.c:266:
+	BUG_ON(dest_mapping != remapped_mapping, "expected to remap to dest_mapping");

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#111: FILE: tools/testing/selftests/vm/mremap_dontunmap.c:266:
+	BUG_ON(dest_mapping != remapped_mapping, "expected to remap to dest_mapping");

WARNING: line over 80 characters
#120: FILE: tools/testing/selftests/vm/mremap_dontunmap.c:272:
+	BUG_ON(check_region_contains_byte(dest_mapping, 5 * page_size, 'a') != 0,

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#120: FILE: tools/testing/selftests/vm/mremap_dontunmap.c:272:
+	BUG_ON(check_region_contains_byte(dest_mapping, 5 * page_size, 'a') != 0,

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#133: FILE: tools/testing/selftests/vm/mremap_dontunmap.c:280:
+	BUG_ON(munmap(dest_mapping, 10 * page_size) == -1,

total: 1 errors, 8 warnings, 126 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/selftest-add-mremap_dontunmap-selftest-v7.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Brian Geffon <bgeffon@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mremap_dontunmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/mremap_dontunmap.c~selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes
+++ a/tools/testing/selftests/vm/mremap_dontunmap.c
@@ -225,7 +225,7 @@ static void mremap_dontunmap_partial_map
 }
 
 // This test validates that we can remap over only a portion of a mapping.
-static void mremap_dontunmap_partial_mapping_overwrite()
+static void mremap_dontunmap_partial_mapping_overwrite(void)
 {
 	/*
 	 *  source mapping:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix.patch
mm.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
