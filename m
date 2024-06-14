Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2A612EBE3
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 04:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718340904; cv=none; b=EcsXlgsj2G9jal6g17QJkZ78KuYI4e5u6F5xZ86Q4t8XGFNB9DhdqlzX/9ve8SBGXHdItnV2K/hoiEsYTLxK9EaQH76Gx0Wba4j6+icbMN90J/twYlCJxK/aAIrML0J3IFKEFMZJxxisCRHsMpVG81YbP8EqaD/qDzZYXz9Sz6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718340904; c=relaxed/simple;
	bh=Q0cqfwY15vx+b8splke12vn7hD5TDderDNaxPIjJ58g=;
	h=Date:To:From:Subject:Message-Id; b=G8L0WJHX04viyxQ9Qu7E0Hctr4ujXINHo3ZchGDRFF5YD7BdmK/LcqJLIeDKv0yUxhVkTbMOOMyacxjcgXcnXpBys8VDCWn0tpeVBe8O4n2schDu7NKMFFdF6zVhrungzpamjz7nmtqZRVywCaKSsDw5mApSJx3u+E/BmjbAp8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xqeCj7T8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xqeCj7T8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC88C2BD10;
	Fri, 14 Jun 2024 04:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718340903;
	bh=Q0cqfwY15vx+b8splke12vn7hD5TDderDNaxPIjJ58g=;
	h=Date:To:From:Subject:From;
	b=xqeCj7T8dEtmvt0xKpMA3/vPUb9jjnwRkA4k9ugTn6o5rkP0OQRxQOIr57RNtP+V7
	 /DD6894pKdEY4j9L3iUSiGG66bzxPZ04M8SK2Ef8oSm414WyE4ieER6EIfOUDYyDv1
	 +zdW1IFAVS1GHhgcrmwep65a1qhIblNlhjr5zXI8=
Date: Thu, 13 Jun 2024 21:55:03 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,peterx@redhat.com,Liam.Howlett@oracle.com,kent.overstreet@linux.dev,kees@kernel.org,jeffxu@chromium.org,david@redhat.com,dalias@libc.org,brauner@kernel.org,axelrasmussen@google.com,avagin@google.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-kvm-mdwe-fixes-to-avoid-requiring-make-headers.patch added to mm-unstable branch
Message-Id: <20240614045503.9BC88C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: kvm, mdwe fixes to avoid requiring "make headers"
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-kvm-mdwe-fixes-to-avoid-requiring-make-headers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-kvm-mdwe-fixes-to-avoid-requiring-make-headers.patch

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
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: kvm, mdwe fixes to avoid requiring "make headers"
Date: Thu, 13 Jun 2024 19:30:08 -0700

On Ubuntu 23.04, the kvm and mdwe selftests/mm build fails due to missing
a few items that are found in prctl.h.  Here is an excerpt of the build
failures:

ksm_tests.c:252:13: error: use of undeclared identifier 'PR_SET_MEMORY_MERGE'
...
mdwe_test.c:26:18: error: use of undeclared identifier 'PR_SET_MDWE'
mdwe_test.c:38:18: error: use of undeclared identifier 'PR_GET_MDWE'

Fix these errors by adding the missing items to vm_util.h, and include
vm_util.h from mdwe_test.c.

Link: https://lkml.kernel.org/r/20240614023009.221547-6-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mdwe_test.c |    1 +
 tools/testing/selftests/mm/vm_util.h   |   15 +++++++++++++++
 2 files changed, 16 insertions(+)

--- a/tools/testing/selftests/mm/mdwe_test.c~selftests-mm-kvm-mdwe-fixes-to-avoid-requiring-make-headers
+++ a/tools/testing/selftests/mm/mdwe_test.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 
 #include "../kselftest_harness.h"
+#include "vm_util.h"
 
 #ifndef __aarch64__
 # define PROT_BTI	0
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-kvm-mdwe-fixes-to-avoid-requiring-make-headers
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -61,3 +61,18 @@ unsigned long get_free_hugepages(void);
 
 #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
 #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
+
+#ifndef PR_SET_MEMORY_MERGE
+#define PR_SET_MEMORY_MERGE		67
+#endif
+
+#ifndef PR_GET_MEMORY_MERGE
+#define PR_GET_MEMORY_MERGE		68
+#endif
+
+#ifndef PR_SET_MDWE
+#define PR_SET_MDWE			65
+#define PR_MDWE_REFUSE_EXEC_GAIN	(1UL << 0)
+#define PR_MDWE_NO_INHERIT		(1UL << 1)
+#define PR_GET_MDWE			66
+#endif
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mm-mseal-self_elf-fix-missing-__nr_mseal.patch
selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items.patch
selftests-mm-mseal-self_elf-rename-test_end_check-to-report_test_pass.patch
selftests-mm-fix-vm_utilc-build-failures-add-snapshot-of-fsh.patch
selftests-mm-kvm-mdwe-fixes-to-avoid-requiring-make-headers.patch
selftests-mm-remove-local-__nr_-definitions.patch
selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch

