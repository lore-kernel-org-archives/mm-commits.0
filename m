Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289691CFBA
	for <mm-commits@vger.kernel.org>; Fri, 17 Apr 2026 05:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776405099; cv=none; b=fIq271ByF/tqdEEA3cSzQBunYu3LcmSFe5RFAHs5P729cN+yHjTkOsRYOi2I9ixlKsq8Tl4HdSG24P6gwMkqz73tynPOIkbvZlVYw90nMzmMmwpG8OcB2wvouABGwo4L+xxuP6Z3QmzJoVc3560UK4AiWXCpFpjONUBVHTdJcEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776405099; c=relaxed/simple;
	bh=dS1PCka0kbuqGxjC/g6hqz1pU7kBoCBOdevOz3ov9B0=;
	h=Date:To:From:Subject:Message-Id; b=Se41LZAEP9VgAhJMfqpBUT2ouiNhJaJ+Ooac1PCl7C4ejDyJWjCyflbbOow/TZgBWpGrUmDdwfq1GHttU0PtnOmZuIchtPw7QzujRAGjMPuTbC+oggs2m46kqTtAcUmwDY9uJg0oQY1LmKcPdMOZXCW4yqa6sV6AvuGjITy2wzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aWAip+50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aWAip+50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA84BC19425;
	Fri, 17 Apr 2026 05:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776405098;
	bh=dS1PCka0kbuqGxjC/g6hqz1pU7kBoCBOdevOz3ov9B0=;
	h=Date:To:From:Subject:From;
	b=aWAip+50S82p7I6zfPIbRcREfe81XArEY4z7i/5DBOxjWUoZwQV78zL9A6BCiWK5J
	 q9bmBatvbyQcC5TgQ/mx9A86GaOC49XmIXfxW1yUggQzZasLfgURU18Q252WIpgBn0
	 Gh+ccRgUU9Qo84wEDeTAZaneoCSF2/9bqPeCOK6I=
Date: Thu, 16 Apr 2026 22:51:34 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix.patch removed from -mm tree
Message-Id: <20260417055137.DA84BC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix.patch

This patch was dropped because it was folded into tools-testing-selftests-add-merge-test-for-partial-msealed-range.patch

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix
Date: Fri, 3 Apr 2026 19:08:40 +0300

fix inclusions, to fix handle_uprobe_upon_merged_vma()

Link: https://lore.kernel.org/ac_mCIUQWRAbuH8F@kernel.org
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix
+++ a/tools/testing/selftests/mm/merge.c
@@ -2,7 +2,6 @@
 
 #define _GNU_SOURCE
 #include "kselftest_harness.h"
-#include <asm-generic/unistd.h>
 #include <linux/prctl.h>
 #include <fcntl.h>
 #include <stdio.h>
_

Patches currently in -mm which might be from rppt@kernel.org are

tools-testing-selftests-add-merge-test-for-partial-msealed-range.patch
userfaultfd-introduce-mfill_copy_folio_locked-helper.patch
userfaultfd-introduce-struct-mfill_state.patch
userfaultfd-introduce-mfill_establish_pmd-helper.patch
userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma.patch
userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
userfaultfd-move-vma_can_userfault-out-of-line.patch
userfaultfd-introduce-vm_uffd_ops.patch
userfaultfd-introduce-vm_uffd_ops-fix.patch
shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch
userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch

