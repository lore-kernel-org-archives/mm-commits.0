Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A78135D60E
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 18:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769106384; cv=none; b=HXZNxLinPq+5DAwgnYwaspJPI/QvLHr5gx2vjeSQSw81m0YlVXI+ZBZyOxZf/g5EPkr8LwX6a+dPn96edx0hqpbRwIxYpBDxtguRpMQ6QaA0SNIy2RaUb7aPgvV1QAMfLFER3AVIwva8zD7jJRmZbft7bp102Ftv9O8wZcuE4lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769106384; c=relaxed/simple;
	bh=2U3Z7Xn4nGJDJKzM57PEv9DTb3L4YEj+5h5kFhchL0U=;
	h=Date:To:From:Subject:Message-Id; b=i4BguF1I4UiGW2FBcrY650lFs0tjU+bmmZMBTylW3qwTS1WsMh1Gb2Ju9xya4yMVv1XZ2qe1Qcjlb/lSu6XBkVi/AOXBk1bCAi697KsWFTxkTEmm+QeRQn26LXqYoRuogAOMn77Mn0byuY5m8wU5HLXMPcd/Fm5Vrao5gLGAO8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wiLR+J86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wiLR+J86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BD1C116C6;
	Thu, 22 Jan 2026 18:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769106382;
	bh=2U3Z7Xn4nGJDJKzM57PEv9DTb3L4YEj+5h5kFhchL0U=;
	h=Date:To:From:Subject:From;
	b=wiLR+J867an7JXPpcSebzt31LoIPk7bzbJLKzbsSrNun2w7XkDvSbDGZnhtCYxxmW
	 O7u3no/KbYtWnXPO/6inUHmkoOKuBs+YH+CvsxxM969o02Ie+wAKRRc4s3p7Mh5Ulk
	 XfyZ3RN5qRdoWSNAUWIeNTtz3sU3z8J8CIoOAx+Q=
Date: Thu, 22 Jan 2026 10:26:22 -0800
To: mm-commits@vger.kernel.org,Usama.Anjum@arm.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,pabeni@redhat.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,lianux.mm@gmail.com,jhubbard@nvidia.com,jgg@nvidia.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-default-kdir-to-build-directory.patch added to mm-unstable branch
Message-Id: <20260122182622.B0BD1C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: default KDIR to build directory
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-default-kdir-to-build-directory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-default-kdir-to-build-directory.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Thu, 22 Jan 2026 17:02:16 +0000

Patch series "Various mm kselftests improvements/fixes", v3.

Various improvements/fixes for the mm kselftests:

- Patch 1-3 extend support for more build configurations: out-of-tree
  $KDIR, cross-compilation, etc.

- Patch 4-7 fix issues related to faulting in pages, introducing a new
  helper for that purpose.

- Patch 8 fixes the value returned by pagemap_ioctl (PASS was always
  returned, which explains why the issue fixed in patch 6 went
  unnoticed).

- Patch 9 improves the exit code of pfnmap.

Net results:
- 1 test no longer fails (patch 7)
- 3 tests are no longer skipped (patch 4)
- More accurate return values for whole suites (patch 8, 9)
- Extra tests are more likely to be built (patch 1-3)


This patch (of 9):

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

Link: https://lkml.kernel.org/r/20260122170224.4056513-1-kevin.brodsky@arm.com
Link: https://lkml.kernel.org/r/20260122170224.4056513-2-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: wang lian <lianux.mm@gmail.com>
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

sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests.patch
selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-check-that-force_read-succeeded.patch
selftests-mm-introduce-helper-to-read-every-page.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

