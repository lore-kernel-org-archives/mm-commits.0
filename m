Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720002FD673
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 17:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806491; cv=none; b=SnDBAKK64SuULWshMBahkvGobzcL4HQE0Ki7V77WzrZVYwq853PNOlUV1BD4I2lnLkAN3zMz903mXHBNOjqYqR2Udx7l3cvCPinp5E7N6f/4AoyKfuFAJ+nE5xQu8B0cVrAayigy5V4Lr/LT3yjtCUtzziN6L8vDdTo39xfAPxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806491; c=relaxed/simple;
	bh=W3fQRB9IQRZ2lRM63IBi1dcPiQPPyJAO8O3bCtCFGqY=;
	h=Date:To:From:Subject:Message-Id; b=H/uww8tB+P+9F97GYrLQLd0uBSIMlubxYmXqV/aC3m36ZhgjL4beqX4vWDVREmiOrtiZs7XSiBn664XfrExj+KqTLWG1RobWQiY6+JuJkgUtl2nzMGCCsUE22O5erzYBFCKtLV/BFvg9Sb5FPqm3J/1tlfetXeD0OwWg3XBZa0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yuOVYJu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yuOVYJu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA57C4CEF1;
	Wed,  7 Jan 2026 17:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767806490;
	bh=W3fQRB9IQRZ2lRM63IBi1dcPiQPPyJAO8O3bCtCFGqY=;
	h=Date:To:From:Subject:From;
	b=yuOVYJu8BGBoX2S1ZEIeUXwg2V52W2eztpXh8LSEUO0iswKJUIOqQT02ZqrekxZyI
	 kHsK+V5Bog50O0o/qFYU5ewC8d4ZjkGBtzGOfFkoOEKyXrpBqwiwX/I2DGXWA2cyEK
	 sZnx4EVXXcXAbeKIMz5wEsO2pfSEUnGGkio9U2Bw=
Date: Wed, 07 Jan 2026 09:21:30 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Usama.Anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,pabeni@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,Liam.Howlett@oracle.com,jhubbard@nvidia.com,jgg@nvidia.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-default-kdir-to-build-directory.patch added to mm-new branch
Message-Id: <20260107172130.8FA57C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: default KDIR to build directory
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-default-kdir-to-build-directory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-default-kdir-to-build-directory.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: default KDIR to build directory
Date: Wed, 7 Jan 2026 16:48:35 +0000

Patch series "Various mm kselftests improvements/fixes", v2.

Various improvements/fixes for the mm kselftests:

- Patch 1-3 extend support for more build configurations: out-of-tree
  $KDIR, cross-compilation, etc.

- Patch 4-6 fix issues related to faulting in pages, introducing a new
  helper for that purpose.

- Patch 7 fixes the value returned by pagemap_ioctl (PASS was always
  returned, which explains why the issue fixed in patch 6 went
  unnoticed).

- Patch 8 improves the exit code of pfnmap.

Net results:
- 1 test no longer fails (patch 6)
- 3 tests are no longer skipped (patch 4)
- More accurate return values for whole suites (patch 7, 8)
- Extra tests are more likely to be built (patch 1-3)


This patch (of 8):

KDIR currently defaults to the running kernel's modules directory when
building the page_frag module.  The underlying assumption is that most
users build the kselftests in order to run them against the system they're
built on.

This assumption seems questionable, and there is no guarantee that the
module can actually be built against the running kernel.

Switch the default value of KDIR to the kernel's build directory, i.e. 
$(O) if O= or KBUILD_OUTPUT= is used, and the source directory otherwise. 
This seems like the least surprising option: the test module is built
against the kernel that has been previously built.

Note: we can't use $(top_srcdir) in mm/Makefile because it is only defined
once lib.mk is included.

Link: https://lkml.kernel.org/r/20260107164842.3289559-1-kevin.brodsky@arm.com
Link: https://lkml.kernel.org/r/20260107164842.3289559-2-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile           |    2 +-
 tools/testing/selftests/mm/page_frag/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-default-kdir-to-build-directory
+++ a/tools/testing/selftests/mm/Makefile
@@ -44,7 +44,7 @@ LDLIBS = -lrt -lpthread -lm
 # warnings.
 CFLAGS += -U_FORTIFY_SOURCE
 
-KDIR ?= /lib/modules/$(shell uname -r)/build
+KDIR ?= $(if $(O),$(O),$(realpath ../../../..))
 ifneq (,$(wildcard $(KDIR)/Module.symvers))
 ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))
 TEST_GEN_MODS_DIR := page_frag
--- a/tools/testing/selftests/mm/page_frag/Makefile~selftests-mm-default-kdir-to-build-directory
+++ a/tools/testing/selftests/mm/page_frag/Makefile
@@ -1,5 +1,5 @@
 PAGE_FRAG_TEST_DIR := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
-KDIR ?= /lib/modules/$(shell uname -r)/build
+KDIR ?= $(if $(O),$(O),$(realpath ../../../../..))
 
 ifeq ($(V),1)
 Q =
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

x86-xen-simplify-flush_lazy_mmu.patch
powerpc-mm-implement-arch_flush_lazy_mmu_mode.patch
sparc-mm-implement-arch_flush_lazy_mmu_mode.patch
mm-clarify-lazy_mmu-sleeping-constraints.patch
mm-introduce-config_arch_has_lazy_mmu_mode.patch
mm-introduce-generic-lazy_mmu-helpers.patch
mm-bail-out-of-lazy_mmu_mode_-in-interrupt-context.patch
mm-enable-lazy_mmu-sections-to-nest.patch
arm64-mm-replace-tif_lazy_mmu-with-is_lazy_mmu_mode_active.patch
powerpc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
sparc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
x86-xen-use-lazy_mmu_state-when-context-switching.patch
mm-add-basic-tests-for-lazy_mmu.patch
mm-add-basic-tests-for-lazy_mmu-fix-fix-fix.patch
selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-introduce-helper-to-read-every-page-in-range.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

