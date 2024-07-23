Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C81513D503
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 21:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721770399; cv=none; b=EG4WlIHdRBtCMY2vx72mHusinnQyTbQmnqwbay0AL4Erv5QQpI4mdfRl/n81B0zv5Z06FeDo0FbjOQRcwSKApKOoMqo5M4VelTim4g/QX9fHR9QOC4NYuUYesgvfqgpIdZO7WmJxUGAyTHj7P9q/LeiPv408eC+V5eEyET3s9oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721770399; c=relaxed/simple;
	bh=X+gacsvTVQeqkibzTa1PsO4ofjdFzUU/e1UBAaqc6eU=;
	h=Date:To:From:Subject:Message-Id; b=cskbs0OU6n3FRSqP0HdjzeyKtTOxiY3NnNFEOCt23oYftcSbSs/G/Oz4GFOiJYagiK3Fv+dQXrWoUhfQL9W7t6xLeJFuHXAbbSLtaIrCH8B/j0Ndii1qQ/5ylGrgtU/FQTEdJ83xIivgh9bq3k+XJIBYDXX2UWyNA2VerzDBL5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D/phfkRz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D/phfkRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53F6C4AF09;
	Tue, 23 Jul 2024 21:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721770399;
	bh=X+gacsvTVQeqkibzTa1PsO4ofjdFzUU/e1UBAaqc6eU=;
	h=Date:To:From:Subject:From;
	b=D/phfkRzPf50WtRuumkYLZsD7JVRiEo2TFSmNe9AOGBrR89k5+xKVqrrMpOannB92
	 DAXIDhNnfn1KX96QgPT0wm5paWfmfiamrpfbe18PyaD04zmW+Xv3XFiyeEi867hqQ6
	 KloSnbcufLsTEYM8y9qJe/HuwmDgP42TIHzyiBxs=
Date: Tue, 23 Jul 2024 14:33:18 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-internal-core-vma-manipulation-functions-to-own-file-fix.patch added to mm-unstable branch
Message-Id: <20240723213318.E53F6C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: drop inappropriate includes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-internal-core-vma-manipulation-functions-to-own-file-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-internal-core-vma-manipulation-functions-to-own-file-fix.patch

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
Subject: mm: drop inappropriate includes
Date: Tue, 23 Jul 2024 18:11:48 +0100

As pointed out by SeongJae Park, these includes are not always available to
all architectures and in actual fact are not required to be included here.

Link: https://lkml.kernel.org/r/c1c009dd-1ee3-4615-a8d1-b1971f22a814@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma_internal.h |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/vma_internal.h~mm-move-internal-core-vma-manipulation-functions-to-own-file-fix
+++ a/mm/vma_internal.h
@@ -43,8 +43,6 @@
 #include <linux/userfaultfd_k.h>
 
 #include <asm/current.h>
-#include <asm/page_types.h>
-#include <asm/pgtable_types.h>
 #include <asm/tlb.h>
 
 #include "internal.h"
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch
mm-move-vma_modify-and-helpers-to-internal-header.patch
mm-move-vma_shrink-vma_expand-to-internal-header.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file-fix.patch
maintainers-add-entry-for-new-vma-files.patch
tools-separate-out-shared-radix-tree-components.patch
tools-add-skeleton-code-for-userland-testing-of-vma-logic.patch

