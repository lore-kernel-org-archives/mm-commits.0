Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE7B29BD8E
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 23:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766963683; cv=none; b=DhqLXXqpwfjosiW3ZgpihFd8r1ZIhCGR/o6chpA+3zZ3I749QuztUbPftfdcG8ZFhqMw6N8dKbPlrtLd0VAC718QZQqsCJ6AheJnP9Wk1ZEJinG05YyVToOKAAHF0Gf0ho8hZCbtGNCKzllVfudgfpUrqxpsq0VTeSNsxPpifYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766963683; c=relaxed/simple;
	bh=WsjNzId9qUcrB79VeaJW4xp4f+3i361aX0twX6HiVu8=;
	h=Date:To:From:Subject:Message-Id; b=GO7YFis1lqfGa2n23zttndR+cPYPsQdwhH9NeMlt+QVFaN6/eG1qbCSrWEykr1SdMgwTMwj0enjFcT87f9QhsSgSzhYLAg9ap605u9ydjQOJ5dgQFwwMXiBV6maMOv116mavpzwaG7s78p6lkaR7FxYDOaTvKfChaXfkWEP5VG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2et3eD3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2et3eD3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7086DC4CEFB;
	Sun, 28 Dec 2025 23:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766963682;
	bh=WsjNzId9qUcrB79VeaJW4xp4f+3i361aX0twX6HiVu8=;
	h=Date:To:From:Subject:From;
	b=2et3eD3cx48OV41ZAakAjfmj8qRGMT9rspy59E9juRUBwpkSSJLjlN2Zf6YnBWVDR
	 1ktRNfgrm5yJ4T19qb63/DNejSNQ7CZGxaqc782A6mwBtUiU5WCHwaz613Z3+ew02P
	 r0e6eFPUBxfqIDzDCZ+duhtEpfuICn5uICQ6FEOw=
Date: Sun, 28 Dec 2025 15:14:41 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-separate-memfd-support-into-liveupdate_memfd.patch added to mm-hotfixes-unstable branch
Message-Id: <20251228231442.7086DC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: separate memfd support into LIVEUPDATE_MEMFD
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     liveupdate-separate-memfd-support-into-liveupdate_memfd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-separate-memfd-support-into-liveupdate_memfd.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: separate memfd support into LIVEUPDATE_MEMFD
Date: Tue, 23 Dec 2025 15:15:06 -0500

Decouple memfd preservation support from the core Live Update Orchestrator
configuration.

Previously, enabling CONFIG_LIVEUPDATE forced a dependency on CONFIG_SHMEM
and unconditionally compiled memfd_luo.o.  However, Live Update may be
used for purposes that do not require memfd-backed memory preservation.

Introduce CONFIG_LIVEUPDATE_MEMFD to gate memfd_luo.o.  This moves the
SHMEM and MEMFD_CREATE dependencies to the specific feature that needs
them, allowing the base LIVEUPDATE option to be selected independently of
shared memory support.

Link: https://lkml.kernel.org/r/20251223201506.2334991-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/Kconfig |   16 +++++++++++++++-
 mm/Makefile               |    2 +-
 2 files changed, 16 insertions(+), 2 deletions(-)

--- a/kernel/liveupdate/Kconfig~liveupdate-separate-memfd-support-into-liveupdate_memfd
+++ a/kernel/liveupdate/Kconfig
@@ -54,7 +54,6 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
 config LIVEUPDATE
 	bool "Live Update Orchestrator"
 	depends on KEXEC_HANDOVER
-	depends on SHMEM
 	help
 	  Enable the Live Update Orchestrator. Live Update is a mechanism,
 	  typically based on kexec, that allows the kernel to be updated
@@ -73,4 +72,19 @@ config LIVEUPDATE
 
 	  If unsure, say N.
 
+config LIVEUPDATE_MEMFD
+	bool "Live update support for memfd"
+	depends on LIVEUPDATE
+	depends on MEMFD_CREATE
+	depends on SHMEM
+	help
+	  Enable live update support for memfd regions. This allows preserving
+	  memfd-backed memory across kernel live updates.
+
+	  This can be used to back VM memory with memfds, allowing the guest
+	  memory to persist, or for other user workloads needing to preserve
+	  pages.
+
+	  If unsure, say N.
+
 endmenu
--- a/mm/Makefile~liveupdate-separate-memfd-support-into-liveupdate_memfd
+++ a/mm/Makefile
@@ -100,7 +100,7 @@ obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
-obj-$(CONFIG_LIVEUPDATE) += memfd_luo.o
+obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
 ifdef CONFIG_SWAP
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

kho-validate-preserved-memory-map-during-population.patch
liveupdate-separate-memfd-support-into-liveupdate_memfd.patch
list-add-primitives-for-private-list-manipulations.patch
list-add-kunit-test-for-private-list-primitives.patch
liveupdate-luo_file-use-private-list.patch
liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

