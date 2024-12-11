Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762F51C173C
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 23:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733960140; cv=none; b=dpFyk0bqiLd5otpJnind/50TY12vNr6rmkqP97DwPCPZTGezl6xIV8Q1uExcVL0Ig9Ek/d/wQE4Kw45AE8F6eJ3mTw0Wkyva1i6f569P7UH0GxxzVRIvSA8UpgWLoRNT3lABslYOe4P4alebXgYzieOAuJGyCtq8hqb5N9JdCfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733960140; c=relaxed/simple;
	bh=cnriMf8FnpjasMQkdwbPPIkGD8OC5qNFQIA9EBdAX5M=;
	h=Date:To:From:Subject:Message-Id; b=gPdqqWBu51OYehjfVNEEh5wMRb+h8lOiOEj9AI1xS3tYpczl1IAsozHpqcO9YL2M7m+kfkrTGEd2o9BD0sswhoSNh2qtj89X+SIB+Ao2rK9nKOBvMBqlnzd1W3w90ofrfvLzyv6fUvxJYJFw0kmn1eGBdkUMV6320k3xFIacEGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZlAcJNE8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZlAcJNE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6D8C4CEDE;
	Wed, 11 Dec 2024 23:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733960139;
	bh=cnriMf8FnpjasMQkdwbPPIkGD8OC5qNFQIA9EBdAX5M=;
	h=Date:To:From:Subject:From;
	b=ZlAcJNE8tuKfI8urZo+e2nZSMR2FGE4Yoh3q4d6keMj1kZZuyoPtjBhzS/C9HEkre
	 8GTyPZGd1oA0SGhGs9CTuknzJJ+tUVq7MwVbdPZvvjZUtUAHmmQtzSLOjzJxo1ai54
	 QEKThZqH4/VfRdlsmV/mSEufrokIdeeqwVTJ516k=
Date: Wed, 11 Dec 2024 15:35:39 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,fujunjie1@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mempolicyh-remove-unnecessary-header-file-inclusions-with-no-test-failure.patch removed from -mm tree
Message-Id: <20241211233539.CB6D8C4CEDE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mempolicy.h: remove unnecessary header file inclusions with no test failure
has been removed from the -mm tree.  Its filename was
     mempolicyh-remove-unnecessary-header-file-inclusions-with-no-test-failure.patch

This patch was dropped because it had testing failures

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


