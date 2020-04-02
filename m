From: akpm@linux-foundation.org
Subject: [folded-merged]
 selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch removed
 from -mm tree
Date: Wed, 01 Apr 2020 20:31:46 -0700
Message-ID: <20200402033146.8eMwnvGIn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387407AbgDBDbs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 23:31:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bgeffon@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch

This patch was dropped because it was folded into selftest-add-mremap_dontunmap-selftest.patch

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

selftest-add-mremap_dontunmap-selftest.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
