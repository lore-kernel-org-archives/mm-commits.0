Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD200156CA
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 02:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729735269; cv=none; b=AAHPhyTlhRpvToNM+IbJ5UUhcR8wNDA4yCczKDQ2iDZ4fusW4jiIY2UR0UFJkGPU3y+cT6VOENnJAUVROqN2LFWxkfYgx3KQ3dQJYCYbXluemly9jQEVlXdREbLlc9X5rg8l/FBvNdIeoscdSRYlo9i4n0iZDcNk6GoK07nX9wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729735269; c=relaxed/simple;
	bh=NlXoZiuI7ybcXoOUnfSSP7RWAiqMZG9JLYxMAfKRl3M=;
	h=Date:To:From:Subject:Message-Id; b=sMMk6fdxuBx5ewLd2bzM5vY2Z6AgAYzaoh/xy1CsRiixFswkW1B44m9BTLcXPGtWkJpPMkvU8lL5Lr0QVflQ6BPxWhweO8rjYmu8yrow6bOMkQ7tGRaqFJ99mx3SIVKymXWV8RGqZYH4/WErKUuXcd+rnSxzzahl8kXVVfcGv8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RyRY8b5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RyRY8b5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450A3C4CEC6;
	Thu, 24 Oct 2024 02:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729735269;
	bh=NlXoZiuI7ybcXoOUnfSSP7RWAiqMZG9JLYxMAfKRl3M=;
	h=Date:To:From:Subject:From;
	b=RyRY8b5cO7523w5JAftwq3YFwmC2DnFF0C1ZRuVZAS9YAU9KZK8gEu72s6Dxbb6Gz
	 rShLjXefjCVgawzB7UlBtK0WpjrAbfufxAu6fsmHrIMyonYlhA72FNp8Nc8Raqu8Yl
	 hminwmvmM5UtXt+XJioDMhKu+3m6hsOVwyPgRhIs=
Date: Wed, 23 Oct 2024 19:01:08 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix.patch added to mm-unstable branch
Message-Id: <20241024020109.450A3C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix
has been added to the -mm mm-unstable branch.  Its filename is
     tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix
Date: Tue, 22 Oct 2024 15:01:58 +0100

VMA tests are not properly importing the bit-length.h header (the radix
tree tests do appear to be) and we are overwriting that constant.

Link: https://lkml.kernel.org/r/a6183df9-3108-4d59-8128-4fc6c14e22a5@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/shared/shared.mk |    2 +-
 tools/testing/vma/vma.c        |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/shared/shared.mk~tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix
+++ a/tools/testing/shared/shared.mk
@@ -69,7 +69,7 @@ generated/bit-length.h: FORCE
 	@if ! grep -qws CONFIG_$(LONG_BIT)BIT generated/bit-length.h; then   \
 		echo "Generating $@";                                        \
 		echo "#define CONFIG_$(LONG_BIT)BIT 1" > $@;                 \
-		echo "#define CONFIG_PHYS_ADDR_T_$(LONG_BIT)BIT 1" > $@;     \
+		echo "#define CONFIG_PHYS_ADDR_T_$(LONG_BIT)BIT 1" >> $@;    \
 	fi
 
 FORCE: ;
--- a/tools/testing/vma/vma.c~tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix
+++ a/tools/testing/vma/vma.c
@@ -4,6 +4,8 @@
 #include <stdio.h>
 #include <stdlib.h>
 
+#include "generated/bit-length.h"
+
 #include "maple-shared.h"
 #include "vma_internal.h"
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

fork-do-not-invoke-uffd-on-fork-if-error-occurs.patch
fork-only-invoke-khugepaged-ksm-hooks-if-no-error.patch
mm-vma-add-expand-only-vma-merge-mode-and-optimise-do_brk_flags.patch
tools-testing-add-expand-only-mode-vma-test.patch
mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook.patch
mm-unconditionally-close-vmas-on-error.patch
mm-refactor-map_deny_write_exec.patch
mm-resolve-faulty-mmap_region-error-path-behaviour.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-isolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-defer-second-attempt-at-merge-on-mmap.patch
mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch

