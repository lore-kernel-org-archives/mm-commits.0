Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEB05A7AA
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247755; cv=none; b=hXQfyzlFf5bpeHd5Tpdye7C7fXz/oh8CvxLdHjMg21XmvSVYqJkPpUFh4bwYUiB6jQncgUEOJ0KwTXgGyvrw+NSWz+XkP8N1SLMDclVFY19BMdqaZUzJKZfMUBWN1jXU6JNK3iVz4AukoSt2uhkR7oFvC675Q54B0CWkjL3xZQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247755; c=relaxed/simple;
	bh=iOjm6gaxqAwace3afSb0yzGpbTkJ9XV2MlPrZnORMs8=;
	h=Date:To:From:Subject:Message-Id; b=U8CmCSLwwT/OXJ1PfMIo8NFPY71j5wv1v4GU4cEi3JFYKTiwe0FXBp7DAk9SmBUPfQBDaCFPjgU8HAgxU5T1DWmAVGAcf6SiZAmSM6AbnmQlsbddOb/yi95+o3/bJGgkojFyjVvCI4uaji/FZk5fNwKq7lBXcZuxX1Q/cUUFnZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EM8/+hOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EM8/+hOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27A3C4CEC2;
	Mon,  2 Sep 2024 03:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247755;
	bh=iOjm6gaxqAwace3afSb0yzGpbTkJ9XV2MlPrZnORMs8=;
	h=Date:To:From:Subject:From;
	b=EM8/+hOqAe62XuC8DK9BumCuUz96doO3Xgm0wUBuvLZZV9pVaF+cupGu9ZdoA7XgG
	 VzU/VTzmN9B11YLTSLzRKOqEPCEn+y1aJU8JhUPSLlfFWgYYUjDBEtEjWmtQoqjzyG
	 vkn8yj2zlyzBh4ahN+Cp+LrSi0OJZcSjrfW0f90Y=
Date: Sun, 01 Sep 2024 20:29:15 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,abaci@linux.alibaba.com,yang.lee@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-duplicated-include-in-vma_internalh.patch removed from -mm tree
Message-Id: <20240902032915.A27A3C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove duplicated include in vma_internal.h
has been removed from the -mm tree.  Its filename was
     mm-remove-duplicated-include-in-vma_internalh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: mm: remove duplicated include in vma_internal.h
Date: Fri, 2 Aug 2024 14:02:16 +0800

The header files linux/bug.h is included twice in vma_internal.h, so one
inclusion of each can be removed.

Link: https://lkml.kernel.org/r/20240802060216.24591-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9636
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma_internal.h |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vma_internal.h~mm-remove-duplicated-include-in-vma_internalh
+++ a/mm/vma_internal.h
@@ -12,7 +12,6 @@
 #include <linux/backing-dev.h>
 #include <linux/bitops.h>
 #include <linux/bug.h>
-#include <linux/bug.h>
 #include <linux/cacheflush.h>
 #include <linux/err.h>
 #include <linux/file.h>
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are


