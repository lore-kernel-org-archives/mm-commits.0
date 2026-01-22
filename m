Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D4D345757
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 18:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769106387; cv=none; b=te9XErlqCmxDahp91H/she5laHeNWVr5K99U/OzxAluITPiufzFwRpm6VTliSbTcFT3qIhwV8loFY2qarUxbBnZhy2jzhhuv68nQQ0HrVDrgolrXDuo6VLoLHecqgb6i2K1dIrTUUhJrl8G0NdcxzktAnWoDWUtgAiQeae+GygA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769106387; c=relaxed/simple;
	bh=nxLQW9ZtoYwLhoSw6jZsM2qqsuoZUlNxKUXI+0QAAqY=;
	h=Date:To:From:Subject:Message-Id; b=F3Y2c3HYHbbcFxntYtBAM3vEclB6hA5uVaj4JNQvIs1T1VMt6ncGOzP/xWhz5MzXWcV6ntRAwSQIiTCB61eE9+uEcSF/IIHJFjb2SAhrLlt1by8We7ybaHINycMe0v2ta57Z5lMwr+8GP9dm0cRmx3VVcZAZEnbO/DSC25sdT6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xOcxEHkI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xOcxEHkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D8BC116C6;
	Thu, 22 Jan 2026 18:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769106385;
	bh=nxLQW9ZtoYwLhoSw6jZsM2qqsuoZUlNxKUXI+0QAAqY=;
	h=Date:To:From:Subject:From;
	b=xOcxEHkImqnCv6xh8zuVZlB/vQLMi1PCIn3z49CtKaowAyejXysp4fCnucx1hPLYj
	 y9swgxbFq6N0IofYXs3flKpwK5owOjiTe3pL0Wq9ILhcGZ6ewpQzB8Lu5SG1nm5S93
	 ZARQ8OSQHG1k+xnLBQX+JeeYIkqDJF0o03oAGgWM=
Date: Thu, 22 Jan 2026 10:26:24 -0800
To: mm-commits@vger.kernel.org,Usama.Anjum@arm.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,pabeni@redhat.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,lianux.mm@gmail.com,jhubbard@nvidia.com,jgg@nvidia.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-flaky-header-check.patch added to mm-unstable branch
Message-Id: <20260122182625.50D8BC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: remove flaky header check
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-remove-flaky-header-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-flaky-header-check.patch

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
Subject: selftests/mm: remove flaky header check
Date: Thu, 22 Jan 2026 17:02:17 +0000

Commit 96ed62ea0298 ("mm: page_frag: fix a compile error when kernel is
not compiled") introduced a check to avoid attempting to build the
page_frag module if <linux/page_frag_cache.h> is missing.

Unfortunately this check only works if KDIR points to /lib/modules/...  or
an in-tree kernel build.  It always fails if KDIR points to an out-of-tree
build (i.e.  when the kernel was built with O=...  make) because only
generated headers are present under $KDIR/include/ in that case.

A recent commit switched KDIR to default to the kernel's build directory,
so that check is no longer justified.

Link: https://lkml.kernel.org/r/20260122170224.4056513-3-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: wang lian <lianux.mm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |    4 ----
 1 file changed, 4 deletions(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-remove-flaky-header-check
+++ a/tools/testing/selftests/mm/Makefile
@@ -46,12 +46,8 @@ CFLAGS += -U_FORTIFY_SOURCE
 
 KDIR ?= $(if $(O),$(O),$(realpath ../../../..))
 ifneq (,$(wildcard $(KDIR)/Module.symvers))
-ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))
 TEST_GEN_MODS_DIR := page_frag
 else
-PAGE_FRAG_WARNING = "missing page_frag_cache.h, please use a newer kernel"
-endif
-else
 PAGE_FRAG_WARNING = "missing Module.symvers, please have the kernel built first"
 endif
 
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

