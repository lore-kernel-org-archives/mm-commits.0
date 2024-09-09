Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7AF18E362
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925257; cv=none; b=ffmH66QViv1kVuxPhpkw46pXC1Ze7IjNok2HVWbOKW81EwORBNsG50Y2H4prATX8BE4o/iwS+EaN0pOxOmwpoTe/KjNARoX5zvmEkyGiPrXiJHqVrSB1Xz1EDpNESKHDxccQEN7C0/pH889uczjeZPhmP4knUr4nxqDjqkBavys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925257; c=relaxed/simple;
	bh=AEM/d1UYTzWofL3bQA5LR1kAGHpHlomtVfH1ZIYSGbY=;
	h=Date:To:From:Subject:Message-Id; b=RginGoRBty33IuMEZ6S5CuN75AdyY7t0N1Q4QfyZuYMsJdsnnZnfZPG+Cioo8he7q5qKJ34K8etsmO4OOPm1O6CGleIT7wdwobn+wkx2oMzuIbWWu0XhYYv7J3hd1SQ4yOtt/5qTWj6IwVAWSdn8/pLvmZclotsC/a6bALhvbwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nmYy+ZPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nmYy+ZPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A55C4CEC5;
	Mon,  9 Sep 2024 23:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925257;
	bh=AEM/d1UYTzWofL3bQA5LR1kAGHpHlomtVfH1ZIYSGbY=;
	h=Date:To:From:Subject:From;
	b=nmYy+ZPxYpZnrtrMo/9nuircX/ewbXKvC7dDLHjl6kVpd5Lyf10+bsbC3gt5ZK8iK
	 zhRcv7DmZ0V0DB51eh2gHsMwLWlR2N2pdfzoHjvLublfFkExrS+eB+hTDJnpThJ+5A
	 lKWOt0JE4zXWc2N5KCgLTfh8CkzqxsFtZFqolu/g=
Date: Mon, 09 Sep 2024 16:40:57 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-comment-typo-on-ma_flag-of-allocation-tree.patch removed from -mm tree
Message-Id: <20240909234057.94A55C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix comment typo on ma_flag of allocation tree
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-comment-typo-on-ma_flag-of-allocation-tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: fix comment typo on ma_flag of allocation tree
Date: Fri, 9 Aug 2024 02:01:15 +0000

The maple tree flag of allocation tree is MT_FLAGS_ALLOC_RANGE.

Just correct it.

Link: https://lkml.kernel.org/r/20240809020115.31575-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-fix-comment-typo-on-ma_flag-of-allocation-tree
+++ a/include/linux/maple_tree.h
@@ -52,9 +52,9 @@
  * bit in the node type.  This is possible by using bit 1 to indicate if bit 2
  * is part of the type or the slot.
  *
- * Once the type is decided, the decision of an allocation range type or a range
- * type is done by examining the immutable tree flag for the MAPLE_ALLOC_RANGE
- * flag.
+ * Once the type is decided, the decision of an allocation range type or a
+ * range type is done by examining the immutable tree flag for the
+ * MT_FLAGS_ALLOC_RANGE flag.
  *
  *  Node types:
  *   0x??1 = Root
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


