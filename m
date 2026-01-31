Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A875C20CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898306; cv=none; b=DMMze3ZIJLTYK6P58gaOj2OW4uHpSNqI/oWOTFe7BLG2BKutJAY/pOEFhtLGwxCp8XoUQjOCQHoMZUxYDT71+34yTVk4v9YA3/4G92seAtcRE6N9MHklFWsmvJBqSNxqkA2u1TdQ5mr+lPP0YQvbWRRLsi9QWW6Hgdg2AgqQFH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898306; c=relaxed/simple;
	bh=jM40c4NigM6/Kh3SbKoxLlJXuly6J1By03NNFDoYw6E=;
	h=Date:To:From:Subject:Message-Id; b=UJjvjlvVnnxLToi/fmyFcefnU9lspeamP+1neuwEHtQ/wETPoboiaM/QJqUOUhjZWcyQDouj0nSHeqihzbkZMjX+VtP/sLWrzxHn9GW9CamCha3hEJ9ctgMu0up752H/VKx610m+a07+RoztrVuX9T+BmBaq7hFesd/JzN0Dsqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vnYo8zgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vnYo8zgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F014C4CEF1;
	Sat, 31 Jan 2026 22:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898306;
	bh=jM40c4NigM6/Kh3SbKoxLlJXuly6J1By03NNFDoYw6E=;
	h=Date:To:From:Subject:From;
	b=vnYo8zgVjTsqg60t9pK+E9X9PQNTNsG0DHrmYKAgEJRW5scJIeQK6dZimipUFt2JJ
	 klb5yv7o8j+bLACkSdhnjnM5FikAnPdAuhczLKnf3Jm1DI2QunDD+/aGL07CnMBsLZ
	 ZF3o0ORiNle4UkmC6wdkT1n0tMLcov/9gPEaBVRo=
Date: Sat, 31 Jan 2026 14:25:05 -0800
To: mm-commits@vger.kernel.org,Usama.Anjum@arm.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,pabeni@redhat.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,lianux.mm@gmail.com,jhubbard@nvidia.com,jgg@nvidia.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-default-kdir-to-build-directory.patch removed from -mm tree
Message-Id: <20260131222506.7F014C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: default KDIR to build directory
has been removed from the -mm tree.  Its filename was
     selftests-mm-default-kdir-to-build-directory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


