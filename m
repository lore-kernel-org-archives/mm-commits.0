Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1D6446D2
	for <mm-commits@vger.kernel.org>; Thu, 25 Jul 2024 19:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721936363; cv=none; b=kQFshDUmCuHwTzeY051VQQbg+csLkPpkGfCcyLCGlZMFx6tpHN0sD43rtVpItFKFdXJXqbD87Gvqu+PwdBubQfcNe11k/Jg1i7YjjhCFLV0qEd/Ll8uORJCcU/kMpmpVIS21yEgR1F7t0nQznVCWYuQ24MiDZG2JoNQhLWf4/Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721936363; c=relaxed/simple;
	bh=vlxo5T3QUcbx8Srp9oTOzdHfB//lAsMi/gmbCcI42Yo=;
	h=Date:To:From:Subject:Message-Id; b=TXQCSiobNPT3O4KylEBq3CHbpZZZoeCTpVAY4Vn+VTpzgFU7WPT7b53ihHUHYzjfRY4Hh8fz4L9aeANznJGJIOGWaJjsbScG0rs1XwboNKDAdUJ5PuOqsX+BmLaprQh0/Mhlgjhma22goyiiDd8TkluLavw7PdcTfbd10Z+zfQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xHz2JjUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xHz2JjUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51297C116B1;
	Thu, 25 Jul 2024 19:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721936362;
	bh=vlxo5T3QUcbx8Srp9oTOzdHfB//lAsMi/gmbCcI42Yo=;
	h=Date:To:From:Subject:From;
	b=xHz2JjUZXNUKy76lItSwgoF5O/Kv5HjcVkDGff0MC7GBB0EsvVzsGFkB3tZLt1s5V
	 0IBEP/DXtPOIRXffKlvz5KJOvyEAinzn8BVM/y+Arnm6l+lPKYNghbpVKKlUlZxUGH
	 YByf5hw/r9nOCY3eSmyJddiryBl+ENpllCa3xjNA=
Date: Thu, 25 Jul 2024 12:39:21 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-separate-out-shared-radix-tree-components-fix.patch added to mm-unstable branch
Message-Id: <20240725193922.51297C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: fix double header include
has been added to the -mm mm-unstable branch.  Its filename is
     tools-separate-out-shared-radix-tree-components-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-separate-out-shared-radix-tree-components-fix.patch

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
Subject: tools: fix double header include
Date: Thu, 25 Jul 2024 10:47:40 +0100

We already imported the stubbed-out linux/types.h. This has no impact as it
has a header guards but let's clean this up.

Link: https://lkml.kernel.org/r/7aae7eb2-6170-4ed6-bee5-6a0c35294381@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/shared/shared.h |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/shared/shared.h~tools-separate-out-shared-radix-tree-components-fix
+++ a/tools/testing/shared/shared.h
@@ -6,7 +6,6 @@
 #include <linux/bitops.h>
 
 #include <linux/gfp.h>
-#include <linux/types.h>
 #include <linux/rcupdate.h>
 
 #ifndef module_init
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch
mm-move-vma_modify-and-helpers-to-internal-header.patch
mm-move-vma_shrink-vma_expand-to-internal-header.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file-fix.patch
maintainers-add-entry-for-new-vma-files.patch
tools-separate-out-shared-radix-tree-components.patch
tools-separate-out-shared-radix-tree-components-fix.patch
tools-add-skeleton-code-for-userland-testing-of-vma-logic.patch

