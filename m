Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BC5290F
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730696001; cv=none; b=jD5zdmKYTwSr16jA783wzKdjLdB6LdwnoTHi9IXbhgZGxzMRpWPYzlHku8+M4bQmK7byC4nwzmOBnaw8T4C2cyfTZQqd6VoFPADG5cWZYYQtTy2bQEIoYJOJFp/pUA+PMnpr4lv8pxShrNBE6XhH+OOb1Boo9oOkPaCskiY9oD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730696001; c=relaxed/simple;
	bh=hqYOFrdbVMwSmKot2+7gAtJEZ/XfO5E9YnubhAbJe78=;
	h=Date:To:From:Subject:Message-Id; b=PJ0ZWMQ1bZd4TPBMn1bPdNEvRVtg/urC7GHFqFkzXoAW0agSTUX6VI9OjmgzPoj/6Zblnptsxc9RcCPBB8MM/bVTu12Zut6oFfMNCEeOUyPCrkslouSvQaIypfafiqZX7akz7YQMyEe4Uv8i5rcT7o/3dDr3GyjkLQD/gMw2Sz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E+rbIZaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E+rbIZaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015C1C4CECE;
	Mon,  4 Nov 2024 04:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730696000;
	bh=hqYOFrdbVMwSmKot2+7gAtJEZ/XfO5E9YnubhAbJe78=;
	h=Date:To:From:Subject:From;
	b=E+rbIZaJtPod9Zwp8rYXe3nG+PWLoI7PR3QFadxdfztUqlaHXWZ04ux0JIxwS+bMm
	 iOm0gAn84UGeYkkHjsydP4FqvT+TfPmPvGw9IL4QKIXYiM0hvlX9Ut3dBRWa7x5nKu
	 X0rXzWPHwFFH0/HRP/QF03lk+UqKyZLHLkRF5Szw=
Date: Sun, 03 Nov 2024 20:53:19 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix.patch removed from -mm tree
Message-Id: <20241104045320.015C1C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix
has been removed from the -mm tree.  Its filename was
     tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix.patch

This patch was dropped because it was folded into tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch

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

mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook.patch
mm-unconditionally-close-vmas-on-error.patch
mm-refactor-map_deny_write_exec.patch
mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling.patch
mm-resolve-faulty-mmap_region-error-path-behaviour.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-isolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-remove-unnecessary-reset-state-logic-on-merge-new-vma.patch
mm-defer-second-attempt-at-merge-on-mmap.patch
mm-defer-second-attempt-at-merge-on-mmap-fix.patch
mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch
mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch

