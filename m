Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3E62AE90
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 04:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733890811; cv=none; b=M0UKXOO9wtLi0EbwHpe+ieIBLfPRTPzaV0K+z8nii0VBrWfTWBj1xZj/i3q3cO6ztXX+xE4xncgGHjNr28pXNVA6BFvwyNS910Qe8x1ObDfCQyCwfObkxKlMtlq0huzS5ediI/wbJ/HhFJkQMJIN3U1Qik/Bmb441Y/0zMP62tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733890811; c=relaxed/simple;
	bh=oBmaeLUSEnJqeVspuAZOSNKbVg4Byuc06Gua0fUxlU0=;
	h=Date:To:From:Subject:Message-Id; b=m6y9DQ41eHgT3dMqicFNBtN+ipWAgNfJjsuXo3Luwk2jmBgJsmDHPn7tdelngAidpfx0S468JJUWVxXRaoJ+AeBHB8eCYFKtT4lSNaRLhLwVcyInlbuSeRZ957ePs54SfEhk8Z9aUuPttw84E8GVq8ZQyPk2SuwraTKtMxxEQFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZX30SxiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZX30SxiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7E5C4CED2;
	Wed, 11 Dec 2024 04:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733890811;
	bh=oBmaeLUSEnJqeVspuAZOSNKbVg4Byuc06Gua0fUxlU0=;
	h=Date:To:From:Subject:From;
	b=ZX30SxiHI/SRaWK2MToMHhm+7y+YQphJ2EwJ0uLdxLa/wZpsJOAWUVGdw2THj5zi7
	 zjY1oZRaqx8QW5N49Q7CpW+V4fPmlMGi74lAbM97TpkVk5hwfAyfD/HeuDnS77mZI6
	 W97lsJZlsk7Y5jzNlDTpY50QjYbPcsedtIO2oitY=
Date: Tue, 10 Dec 2024 20:20:10 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,fujunjie1@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mempolicyh-remove-unnecessary-header-file-inclusions-with-no-test-failure.patch added to mm-unstable branch
Message-Id: <20241211042010.EA7E5C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mempolicy.h: remove unnecessary header file inclusions with no test failure
has been added to the -mm mm-unstable branch.  Its filename is
     mempolicyh-remove-unnecessary-header-file-inclusions-with-no-test-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempolicyh-remove-unnecessary-header-file-inclusions-with-no-test-failure.patch

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
From: Junjie Fu <fujunjie1@qq.com>
Subject: mempolicy.h: remove unnecessary header file inclusions with no test failure
Date: Wed, 11 Dec 2024 12:01:19 +0800

Originally, linux/mempolicy.h included linux/pagemap.h because
vma_migratable() was implemented inline within the
header(linux/mempolicy.h), requiring mapping_gfp_mask() function from
pagemap.h to implement vma_migratable().  Now that vma_migratable() is
only declared in linux/mempolicy.h and its implementation has been moved
to mempolicy.c, the inclusion of linux/pagemap.h in the header is no
longer necessary.

So the linux/pagemap.h in linux/mempolicy.h need to be remove. Since we
used the function of pagemap.h in mempolicy.c, we need to include
linux/pagemap.h in mempolicy.c.

It appears that the modifications have been completed, but there may be
compilation errors during testing.

kunit UM build errors as below:
    $ ./tools/testing/kunit/kunit.py run --kunitconfig ./mm/damon/tests/
    [...]
    fs/aio.c:525:71: error: `FGP_CREAT' undeclared (first use in this function); did you mean `IPC_CREAT'?
      525 |                                             FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
          |                                                                       ^~~~~~~~~
          |                                                                       IPC_CREAT
    fs/aio.c:532:17: error: implicit declaration of function `folio_end_read'; did you mean `folio_test_head'? [-Werror=implicit-function-declaration]
      532 |                 folio_end_read(folio, true);
          |                 ^~~~~~~~~~~~~~
          |                 folio_test_head
    [...]

FGP_CREAT defined in linux/pagemap.h was used in fs/aio.c, and the
function folio_end_read declared in linux/pagemap.h is also used in
fs/aio.c, so fs/aio.c need to include linux/pagemap.h.

Link: https://lkml.kernel.org/r/tencent_C12D22B8989E0314FDE7073D6446186E3C09@qq.com
Signed-off-by: Junjie Fu <fujunjie1@qq.com>
Cc:
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c                  |    1 +
 include/linux/mempolicy.h |    1 -
 mm/mempolicy.c            |    1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

--- a/fs/aio.c~mempolicyh-remove-unnecessary-header-file-inclusions-with-no-test-failure
+++ a/fs/aio.c
@@ -38,6 +38,7 @@
 #include <linux/blkdev.h>
 #include <linux/compat.h>
 #include <linux/migrate.h>
+#include <linux/pagemap.h>
 #include <linux/ramfs.h>
 #include <linux/percpu-refcount.h>
 #include <linux/mount.h>
--- a/include/linux/mempolicy.h~mempolicyh-remove-unnecessary-header-file-inclusions-with-no-test-failure
+++ a/include/linux/mempolicy.h
@@ -12,7 +12,6 @@
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
 #include <linux/nodemask.h>
-#include <linux/pagemap.h>
 #include <uapi/linux/mempolicy.h>
 
 struct mm_struct;
--- a/mm/mempolicy.c~mempolicyh-remove-unnecessary-header-file-inclusions-with-no-test-failure
+++ a/mm/mempolicy.c
@@ -98,6 +98,7 @@
 #include <linux/ptrace.h>
 #include <linux/swap.h>
 #include <linux/seq_file.h>
+#include <linux/pagemap.h>
 #include <linux/proc_fs.h>
 #include <linux/migrate.h>
 #include <linux/ksm.h>
_

Patches currently in -mm which might be from fujunjie1@qq.com are

mempolicyh-remove-unnecessary-header-file-inclusions-with-no-test-failure.patch

