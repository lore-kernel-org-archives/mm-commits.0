Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F1E76026
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 20:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724532058; cv=none; b=rmuG5xGfOz67c5Lzb2DgSPhSDqMpUOLwe5EQKJyQeN0xRsyN/y9B4lOSjnQa5FvJVMS8QnkrGps0eshVDSMmZDk9BjYYD4X1v42y0FbegGvlXZ3sEwr0Ddx8tJ4Ldt9Ry3jpweQWyElRKEMXbJiBRUAH3fAn/Suyuw///PNyp8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724532058; c=relaxed/simple;
	bh=/eT6yCaFSd/VuQa/e7Xyo4O2GPEXGXPUccTusf2mUy4=;
	h=Date:To:From:Subject:Message-Id; b=MyPPoNeOhDZW0dd1gOlwX8wxv9Gc5oAe5FzeGjCmPiUl2bpUioT+dGm1cZE+RHSoMEDJAmR3IbJHVlGUhBt5Q54e+JQSqi30U+pYLet7DP+UP1DyAdfWOif0HOK8DtgiZR8Sedu2ntHvLs0x+0TNKpAIVVHVhj4AFoUkWFBgsUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IiN+2V/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IiN+2V/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0442C32781;
	Sat, 24 Aug 2024 20:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724532057;
	bh=/eT6yCaFSd/VuQa/e7Xyo4O2GPEXGXPUccTusf2mUy4=;
	h=Date:To:From:Subject:From;
	b=IiN+2V/uejQhBMusm58vfhKpT5JONzis18Jl5WZbR/IbOpUCcJB8bIojFLrlZOsdY
	 GG8fDYiS+FK3H85fopIlktyq6Iy72jWGGnoMYzMpmG1jyRK3WS7KoMoVUqcEcfAU2C
	 bnCDX15kQU3l7KSX/tloOQsu1DvQuO5FPL13263g=
Date: Sat, 24 Aug 2024 13:40:57 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct-fix.patch added to mm-unstable branch
Message-Id: <20240824204057.D0442C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: include linux/pgtable.h in vma_internal.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct-fix.patch

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
Subject: mm: include linux/pgtable.h in vma_internal.h
Date: Sat, 24 Aug 2024 20:20:17 +0100

For some arches this is required in order to have access to
USER_PGTABLES_CEILING and FIRST_USER_ADDRESS.

Link: https://lkml.kernel.org/r/da1a6b2c-f792-432f-b99f-51717dcc8d83@lucifer.local
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202408242348.uGvgH9tt-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202408242304.1A1fXTgE-lkp@intel.com/
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma_internal.h |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vma_internal.h~mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct-fix
+++ a/mm/vma_internal.h
@@ -33,6 +33,7 @@
 #include <linux/mutex.h>
 #include <linux/pagemap.h>
 #include <linux/pfn.h>
+#include <linux/pgtable.h>
 #include <linux/rcupdate.h>
 #include <linux/rmap.h>
 #include <linux/rwsem.h>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch
userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix.patch
mm-move-vma_modify-and-helpers-to-internal-header.patch
mm-move-vma_shrink-vma_expand-to-internal-header.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file.patch
maintainers-add-entry-for-new-vma-files.patch
tools-separate-out-shared-radix-tree-components.patch
tools-add-skeleton-code-for-userland-testing-of-vma-logic.patch
mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct-fix.patch
tools-improve-vma-test-makefile.patch
tools-add-vma-merge-tests.patch
mm-introduce-vma_merge_struct-and-abstract-vma_mergevma_modify.patch
mm-remove-duplicated-open-coded-vma-policy-check.patch
mm-abstract-vma_expand-to-use-vma_merge_struct.patch
mm-avoid-using-vma_merge-for-new-vmas.patch
mm-make-vma_prepare-and-friends-static-and-internal-to-vmac.patch
mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch
mm-refactor-vma_merge-into-modify-only-vma_merge_existing_range.patch
mm-rework-vm_ops-close-handling-on-vma-merge.patch

