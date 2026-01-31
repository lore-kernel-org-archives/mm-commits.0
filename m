Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073BF38B7BA
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898389; cv=none; b=AuGch6qreIE68A6ISrv9yC/a25noKnER5XhQlpzxd4jRru2Z57GAZK9aHcidk9+VFu9b11VsjwqaXibwVvDIA21GxyHHwQ5VzPVGEFgrn+Qf05iA3s56YeophXwDW6BrYNhbMZYI0hnWCaiFct3wi17Yvhwy1YLTufWLwpO9PfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898389; c=relaxed/simple;
	bh=2vhTi0RbU9R7acvENlWfM7xMtSGsaluDuK6JfrJgp+c=;
	h=Date:To:From:Subject:Message-Id; b=Ra9jOgPv9KMP24hp3uORxgvWHSEYf9YzrJoR7H4rFD/nnqHbjG+FrvNJR2sg5P6Svh+7eCb1+2zr1cFB9gNwJ990U8tjMIxej4RYT2XJteYH6m5xV7oZ7ngUkjtDF445sLdrUnOWo2I3WhrQCV+oNpDUiwpvqnKlKVFsG+1kvpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BP2O2iib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BP2O2iib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1856C4CEF1;
	Sat, 31 Jan 2026 22:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898388;
	bh=2vhTi0RbU9R7acvENlWfM7xMtSGsaluDuK6JfrJgp+c=;
	h=Date:To:From:Subject:From;
	b=BP2O2iibhWFbpdJ2ytTZQtn7DqkfYoaZxKynylWqvdR/WMFWLCuMsir7BEI4Mis3V
	 j8K/S2o750MGuJEL4cgGf4m2jgz8QJC3c2jJ8FWInQpMoCW/qxAmJHp2rv/ia1YOA3
	 oqiCjy0MdyGMoHvHHB0H3AH2EVwSV+aEF4cAVBlQ=
Date: Sat, 31 Jan 2026 14:26:28 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leon@kernel.org,jgg@ziepe.ca,david@kernel.org,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-have-the-harness-run-each-test-category-separately.patch removed from -mm tree
Message-Id: <20260131222628.D1856C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: have the harness run each test category separately
has been removed from the -mm tree.  Its filename was
     selftests-mm-have-the-harness-run-each-test-category-separately.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: have the harness run each test category separately
Date: Fri, 23 Jan 2026 22:39:24 +0000

At present the mm selftests are integrated into the kselftest harness by
having it run run_vmtest.sh and letting it pick it's default set of tests
to invoke, rather than by telling the kselftest framework about each test
program individually as is more standard.  This has some unfortunate
interactions with the kselftest harness:

 - If any of the tests hangs the harness will kill the entire mm
   selftests run rather than just the individual test, meaning no
   further tests get run.
 - The timeout applied by the harness is applied to the whole run rather
   than an individual test which frequently leads to the suite not being
   completed in production testing.

Deploy a crude but effective mitigation for these issues by telling the
kselftest framework to run each of the test categories that run_vmtests.sh
has separately.  Since kselftest really wants to run test programs this is
done by providing a trivial wrapper script for each categorty that invokes
run_vmtest.sh, this is not a thing of great elegence but it is clear and
simple.  Since run_vmtests.sh is doing runtime support detection, scenario
enumeration and setup for many of the tests we can't consistently tell the
framework about the individual test programs.

This has the side effect of reordering the tests, hopefully the testing
is not overly sensitive to this.

Link: https://lkml.kernel.org/r/20260123-selftests-mm-run-suites-separately-v2-1-3e934edacbfa@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile                 |   33 +++++++++-
 tools/testing/selftests/mm/ksft_compaction.sh       |    4 +
 tools/testing/selftests/mm/ksft_cow.sh              |    4 +
 tools/testing/selftests/mm/ksft_gup_test.sh         |    4 +
 tools/testing/selftests/mm/ksft_hmm.sh              |    4 +
 tools/testing/selftests/mm/ksft_hugetlb.sh          |    4 +
 tools/testing/selftests/mm/ksft_hugevm.sh           |    4 +
 tools/testing/selftests/mm/ksft_ksm.sh              |    4 +
 tools/testing/selftests/mm/ksft_ksm_numa.sh         |    4 +
 tools/testing/selftests/mm/ksft_madv_guard.sh       |    4 +
 tools/testing/selftests/mm/ksft_madv_populate.sh    |    4 +
 tools/testing/selftests/mm/ksft_mdwe.sh             |    4 +
 tools/testing/selftests/mm/ksft_memfd_secret.sh     |    4 +
 tools/testing/selftests/mm/ksft_migration.sh        |    4 +
 tools/testing/selftests/mm/ksft_mkdirty.sh          |    4 +
 tools/testing/selftests/mm/ksft_mlock.sh            |    4 +
 tools/testing/selftests/mm/ksft_mmap.sh             |    4 +
 tools/testing/selftests/mm/ksft_mremap.sh           |    4 +
 tools/testing/selftests/mm/ksft_page_frag.sh        |    4 +
 tools/testing/selftests/mm/ksft_pagemap.sh          |    4 +
 tools/testing/selftests/mm/ksft_pfnmap.sh           |    4 +
 tools/testing/selftests/mm/ksft_pkey.sh             |    4 +
 tools/testing/selftests/mm/ksft_process_madv.sh     |    4 +
 tools/testing/selftests/mm/ksft_process_mrelease.sh |    4 +
 tools/testing/selftests/mm/ksft_rmap.sh             |    4 +
 tools/testing/selftests/mm/ksft_soft_dirty.sh       |    4 +
 tools/testing/selftests/mm/ksft_thp.sh              |    4 +
 tools/testing/selftests/mm/ksft_userfaultfd.sh      |    4 +
 tools/testing/selftests/mm/ksft_vma_merge.sh        |    4 +
 tools/testing/selftests/mm/ksft_vmalloc.sh          |    4 +
 tools/testing/selftests/mm/run_vmtests.sh           |    4 +
 31 files changed, 152 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/ksft_compaction.sh a/tools/testing/selftests/mm/ksft_compaction.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_compaction.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t compaction
diff --git a/tools/testing/selftests/mm/ksft_cow.sh a/tools/testing/selftests/mm/ksft_cow.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_cow.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t cow
diff --git a/tools/testing/selftests/mm/ksft_gup_test.sh a/tools/testing/selftests/mm/ksft_gup_test.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_gup_test.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t gup_test
diff --git a/tools/testing/selftests/mm/ksft_hmm.sh a/tools/testing/selftests/mm/ksft_hmm.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_hmm.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t hmm
diff --git a/tools/testing/selftests/mm/ksft_hugetlb.sh a/tools/testing/selftests/mm/ksft_hugetlb.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_hugetlb.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t hugetlb
diff --git a/tools/testing/selftests/mm/ksft_hugevm.sh a/tools/testing/selftests/mm/ksft_hugevm.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_hugevm.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t hugevm
diff --git a/tools/testing/selftests/mm/ksft_ksm_numa.sh a/tools/testing/selftests/mm/ksft_ksm_numa.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_ksm_numa.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t ksm_numa
diff --git a/tools/testing/selftests/mm/ksft_ksm.sh a/tools/testing/selftests/mm/ksft_ksm.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_ksm.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t ksm
diff --git a/tools/testing/selftests/mm/ksft_madv_guard.sh a/tools/testing/selftests/mm/ksft_madv_guard.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_madv_guard.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t madv_guard
diff --git a/tools/testing/selftests/mm/ksft_madv_populate.sh a/tools/testing/selftests/mm/ksft_madv_populate.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_madv_populate.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t madv_populate
diff --git a/tools/testing/selftests/mm/ksft_mdwe.sh a/tools/testing/selftests/mm/ksft_mdwe.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_mdwe.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t mdwe
diff --git a/tools/testing/selftests/mm/ksft_memfd_secret.sh a/tools/testing/selftests/mm/ksft_memfd_secret.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_memfd_secret.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t memfd_secret
diff --git a/tools/testing/selftests/mm/ksft_migration.sh a/tools/testing/selftests/mm/ksft_migration.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_migration.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t migration
diff --git a/tools/testing/selftests/mm/ksft_mkdirty.sh a/tools/testing/selftests/mm/ksft_mkdirty.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_mkdirty.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t mkdirty
diff --git a/tools/testing/selftests/mm/ksft_mlock.sh a/tools/testing/selftests/mm/ksft_mlock.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_mlock.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t mlock
diff --git a/tools/testing/selftests/mm/ksft_mmap.sh a/tools/testing/selftests/mm/ksft_mmap.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_mmap.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t mmap
diff --git a/tools/testing/selftests/mm/ksft_mremap.sh a/tools/testing/selftests/mm/ksft_mremap.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_mremap.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t mremap
diff --git a/tools/testing/selftests/mm/ksft_page_frag.sh a/tools/testing/selftests/mm/ksft_page_frag.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_page_frag.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t page_frag
diff --git a/tools/testing/selftests/mm/ksft_pagemap.sh a/tools/testing/selftests/mm/ksft_pagemap.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_pagemap.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t pagemap
diff --git a/tools/testing/selftests/mm/ksft_pfnmap.sh a/tools/testing/selftests/mm/ksft_pfnmap.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_pfnmap.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t pfnmap
diff --git a/tools/testing/selftests/mm/ksft_pkey.sh a/tools/testing/selftests/mm/ksft_pkey.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_pkey.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t pkey
diff --git a/tools/testing/selftests/mm/ksft_process_madv.sh a/tools/testing/selftests/mm/ksft_process_madv.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_process_madv.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t mmap
diff --git a/tools/testing/selftests/mm/ksft_process_mrelease.sh a/tools/testing/selftests/mm/ksft_process_mrelease.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_process_mrelease.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t process_mrelease
diff --git a/tools/testing/selftests/mm/ksft_rmap.sh a/tools/testing/selftests/mm/ksft_rmap.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_rmap.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t rmap
diff --git a/tools/testing/selftests/mm/ksft_soft_dirty.sh a/tools/testing/selftests/mm/ksft_soft_dirty.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_soft_dirty.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t soft_dirty
diff --git a/tools/testing/selftests/mm/ksft_thp.sh a/tools/testing/selftests/mm/ksft_thp.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_thp.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t thp
diff --git a/tools/testing/selftests/mm/ksft_userfaultfd.sh a/tools/testing/selftests/mm/ksft_userfaultfd.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_userfaultfd.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t userfaultfd
diff --git a/tools/testing/selftests/mm/ksft_vmalloc.sh a/tools/testing/selftests/mm/ksft_vmalloc.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_vmalloc.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t vmalloc
diff --git a/tools/testing/selftests/mm/ksft_vma_merge.sh a/tools/testing/selftests/mm/ksft_vma_merge.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/mm/ksft_vma_merge.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t vma_merge
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-have-the-harness-run-each-test-category-separately
+++ a/tools/testing/selftests/mm/Makefile
@@ -1,6 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for mm selftests
 
+# IMPORTANT: If you add a new test CATEGORY please add a simple wrapper
+# script so kunit knows to run it, and add it to the list below.
+# If you do not YOUR TESTS WILL NOT RUN IN THE CI.
+
 LOCAL_HDRS += $(selfdir)/mm/local_config.h $(top_srcdir)/mm/gup_test.h
 LOCAL_HDRS += $(selfdir)/mm/mseal_helpers.h
 
@@ -139,7 +143,33 @@ TEST_GEN_FILES += va_high_addr_switch
 TEST_GEN_FILES += write_to_hugetlbfs
 endif
 
-TEST_PROGS := run_vmtests.sh
+TEST_PROGS += ksft_compaction.sh
+TEST_PROGS += ksft_cow.sh
+TEST_PROGS += ksft_gup_test.sh
+TEST_PROGS += ksft_hmm.sh
+TEST_PROGS += ksft_hugetlb.sh
+TEST_PROGS += ksft_hugevm.sh
+TEST_PROGS += ksft_ksm.sh
+TEST_PROGS += ksft_ksm_numa.sh
+TEST_PROGS += ksft_madv_guard.sh
+TEST_PROGS += ksft_madv_populate.sh
+TEST_PROGS += ksft_memfd_secret.sh
+TEST_PROGS += ksft_migration.sh
+TEST_PROGS += ksft_mkdirty.sh
+TEST_PROGS += ksft_mlock.sh
+TEST_PROGS += ksft_mmap.sh
+TEST_PROGS += ksft_mremap.sh
+TEST_PROGS += ksft_pagemap.sh
+TEST_PROGS += ksft_pfnmap.sh
+TEST_PROGS += ksft_pkey.sh
+TEST_PROGS += ksft_process_madv.sh
+TEST_PROGS += ksft_process_mrelease.sh
+TEST_PROGS += ksft_rmap.sh
+TEST_PROGS += ksft_soft_dirty.sh
+TEST_PROGS += ksft_thp.sh
+TEST_PROGS += ksft_userfaultfd.sh
+TEST_PROGS += ksft_vma_merge.sh
+TEST_PROGS += ksft_vmalloc.sh
 
 TEST_FILES := test_vmalloc.sh
 TEST_FILES += test_hmm.sh
@@ -147,6 +177,7 @@ TEST_FILES += va_high_addr_switch.sh
 TEST_FILES += charge_reserved_hugetlb.sh
 TEST_FILES += hugetlb_reparenting_test.sh
 TEST_FILES += test_page_frag.sh
+TEST_FILES += run_vmtests.sh
 
 # required by charge_reserved_hugetlb.sh
 TEST_FILES += write_hugetlb_memory.sh
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-have-the-harness-run-each-test-category-separately
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -2,6 +2,10 @@
 # SPDX-License-Identifier: GPL-2.0
 # Please run as root
 
+# IMPORTANT: If you add a new test CATEGORY please add a simple wrapper
+# script so kunit knows to run it, and add it to the list below.
+# If you do not YOUR TESTS WILL NOT RUN IN THE CI.
+
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
_

Patches currently in -mm which might be from broonie@kernel.org are


