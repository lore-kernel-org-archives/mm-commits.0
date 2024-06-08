Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3718BEF
	for <mm-commits@vger.kernel.org>; Sat,  8 Jun 2024 02:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717813688; cv=none; b=p3bDTGQ8JFVTi+Zo3A0TP4USVrK6jy/eJE1GZ+uknPCA0pcgE2nJVXYG59qssZHe6ahqGXUeYW9/nKXxDDgNtiE+EK2RdMyPKnouh8CNjCdnyKjbxbh0k2kM+jgjrxP4XEHHqeZTgurOSsZkAxKyHpsm2/+Myvr8OM/Bfi7p8hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717813688; c=relaxed/simple;
	bh=lMxNTyLIU/cZa7r3dPEYaqimzRfEb8bZwZOTpt7g3RM=;
	h=Date:To:From:Subject:Message-Id; b=mN4Algw2Hc9dQsv6cdqtiDXNKBDejJrxIMT0EQb1Q/QTvEJPkYgLTD17G4q616f4kHKJAxt6pSygJeDhIc1c5uWAAAgg+30N7pPNucQHmjymTsA9eK8WijHNiwPr69LQEoe1CcKtL/uCHCcPUJh2VUMN7Wbi1mT43fkhJ6+s7Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tuJpm/Nl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tuJpm/Nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DB3C2BBFC;
	Sat,  8 Jun 2024 02:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717813688;
	bh=lMxNTyLIU/cZa7r3dPEYaqimzRfEb8bZwZOTpt7g3RM=;
	h=Date:To:From:Subject:From;
	b=tuJpm/NlvhKir0emX0RcDGh7iokjZpCr3I+X4zvr5Q/vWOLIx54mGwZUsTIssAg5R
	 pmN1A6Wyctad17AW+DLB1Eqcrcj2A6Lqd4pT+ZQmyy1rxcpkVOy7Ll0rl7TMgDlLOh
	 oTfUizTvOaENiqpstyjorZ/Kgbu1eJOcYrK6mrgA=
Date: Fri, 07 Jun 2024 19:28:07 -0700
To: mm-commits@vger.kernel.org,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-selftests-kvm-mdwe-fixes-to-avoid-requiring-make-headers.patch added to mm-unstable branch
Message-Id: <20240608022808.09DB3C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: kvm, mdwe fixes to avoid requiring "make headers"
has been added to the -mm mm-unstable branch.  Its filename is
     mm-selftests-kvm-mdwe-fixes-to-avoid-requiring-make-headers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-selftests-kvm-mdwe-fixes-to-avoid-requiring-make-headers.patch

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
Date: Fri, 7 Jun 2024 19:10:21 -0700

On Ubuntu 23.04, the kvm and mdwe selftests/mm build fails due to missing
a few items that are found in prctl.h.  Here is an excerpt of the build
failures:

ksm_tests.c:252:13: error: use of undeclared identifier 'PR_SET_MEMORY_MERGE'
...
mdwe_test.c:26:18: error: use of undeclared identifier 'PR_SET_MDWE'
mdwe_test.c:38:18: error: use of undeclared identifier 'PR_GET_MDWE'

Fix these errors by adding the missing items to vm_util.h, and include
vm_util.h from mdwe_test.c.

Link: https://lkml.kernel.org/r/20240608021023.176027-4-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mdwe_test.c |    1 +
 tools/testing/selftests/mm/vm_util.h   |   15 +++++++++++++++
 2 files changed, 16 insertions(+)

--- a/tools/testing/selftests/mm/mdwe_test.c~mm-selftests-kvm-mdwe-fixes-to-avoid-requiring-make-headers
+++ a/tools/testing/selftests/mm/mdwe_test.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 
 #include "../kselftest_harness.h"
+#include "vm_util.h"
 
 #ifndef __aarch64__
 # define PROT_BTI	0
--- a/tools/testing/selftests/mm/vm_util.h~mm-selftests-kvm-mdwe-fixes-to-avoid-requiring-make-headers
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
selftests-mm-fix-vm_utilc-build-failures-add-snapshot-of-fsh.patch
mm-selftests-kvm-mdwe-fixes-to-avoid-requiring-make-headers.patch
selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items.patch
selftests-mm-mseal-self_elf-rename-test_end_check-to-report_test_pass.patch
selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch

