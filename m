Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27300280A51
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 16:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775234517; cv=none; b=UaoXtxMkT4IFdtJZXXYbRuncDL30O2dRaK4yTOXjnLi4nJkq4aBUdpLgN9jtqT5xk+rkYM3HH6h23jgWTD6u3xmWifiPM67VTF2qA19wr36/ul03zvOPls90XBXY+gxZj2QDua27+lX7OkHxSeew4yA6OPsyEhNZBKqxjbMPfQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775234517; c=relaxed/simple;
	bh=cASG6FAphOWlbW70grouxh4OFTCCQVPUWE1ZYbrKVf0=;
	h=Date:To:From:Subject:Message-Id; b=YCuM4VlEBKR4vg3Odn3gcDbN23DV9FY+Sw1CbeN3l/GEaxukWOeaid8TwXsw/nO/QHD3gQZlAru1+ffn1Tx48NPaO4rmv3+n/04FzvoxaM8+WGUpF+AJ0Hkg1ZTsAz1HiMCiIAoLhIxf8pgjCgNu5fNHvTMFe9w7xPNe27q4XlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gSb4Zvzk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gSb4Zvzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65C9C4CEF7;
	Fri,  3 Apr 2026 16:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775234516;
	bh=cASG6FAphOWlbW70grouxh4OFTCCQVPUWE1ZYbrKVf0=;
	h=Date:To:From:Subject:From;
	b=gSb4Zvzks7yxmPP03+DGyxizK+Vl+i3gQVmSgCtnGAzJu3BPrczNAzoDpSlxZMpRn
	 9fDNlnPg88bVtLlQcLAyB8I3CuaO5xfTQGAEdIWrIowy2vIzLGAnXpFw8mFzlq6Qof
	 0QQtP7TpECGLWyRBCPwtQmXWXJkdKkaiNL3h78E4=
Date: Fri, 03 Apr 2026 09:41:55 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix.patch added to mm-unstable branch
Message-Id: <20260403164156.A65C9C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix
has been added to the -mm mm-unstable branch.  Its filename is
     tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix.patch

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
From: Mike Rapoport <rppt@kernel.org>
Subject: tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix
Date: Fri, 3 Apr 2026 19:08:40 +0300

fix inclusions, to fix handle_uprobe_upon_merged_vma()

Link: https://lkml.kernel.org/r/ac_mCIUQWRAbuH8F@kernel.org
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

tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix.patch
userfaultfd-introduce-mfill_copy_folio_locked-helper.patch
userfaultfd-introduce-struct-mfill_state.patch
userfaultfd-introduce-mfill_establish_pmd-helper.patch
userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma.patch
userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
userfaultfd-move-vma_can_userfault-out-of-line.patch
userfaultfd-introduce-vm_uffd_ops.patch
shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch
userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch

