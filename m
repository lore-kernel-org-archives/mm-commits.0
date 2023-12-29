Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC98713FEB
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VcEok/tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A594C433C7;
	Fri, 29 Dec 2023 20:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880126;
	bh=Y74wEd2UiUpDN3q8HR/kFPhNKE1T6Jnwn1yolRxIvDs=;
	h=Date:To:From:Subject:From;
	b=VcEok/trucHxV2QhXtlj+UqWI9mS1mypxP36i3wZdb2CyDzb+VWbDFxoMaGJ0jdXk
	 hZyjjO+lqvcFsRG364YBLYzecz+ov+fO/fYzhCtLLpFJYXHt+Smvz5ObmP/0OxaW4p
	 kVUD5FF6Jg0Ga8NC3jltpOnPQSWyMyC23rqZabR4=
Date: Fri, 29 Dec 2023 12:02:05 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,sj@kernel.org,tanzirh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-changed-asm-generic-mman-commonh-to-linux-mmanh.patch removed from -mm tree
Message-Id: <20231229200206.7A594C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: change asm-generic/mman-common.h to linux/mman.h
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-changed-asm-generic-mman-commonh-to-linux-mmanh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tanzir Hasan <tanzirh@google.com>
Subject: mm/damon/vaddr: change asm-generic/mman-common.h to linux/mman.h
Date: Thu, 21 Dec 2023 23:11:01 +0000

asm-generic/mman-common.h can be replaced by linux/mman.h and the file
will still build correctly.  It is an asm-generic file which should be
avoided if possible.

Link: https://lkml.kernel.org/r/20231221-asmgenericvaddr-v1-1-742b170c914e@google.com
Fixes: 6dea8add4d28 ("mm/damon/vaddr: support DAMON-based Operation Schemes")
Signed-off-by: Tanzir Hasan <tanzirh@google.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-changed-asm-generic-mman-commonh-to-linux-mmanh
+++ a/mm/damon/vaddr.c
@@ -7,9 +7,9 @@
 
 #define pr_fmt(fmt) "damon-va: " fmt
 
-#include <asm-generic/mman-common.h>
 #include <linux/highmem.h>
 #include <linux/hugetlb.h>
+#include <linux/mman.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
 #include <linux/pagewalk.h>
_

Patches currently in -mm which might be from tanzirh@google.com are

lib-replaced-asm-generic-io-with-linux-io.patch

