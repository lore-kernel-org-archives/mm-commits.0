Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E00A7E6
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560057; cv=none; b=Tb8i8Lk0zIIf7plh0+dgblfrnnpDFwBo8g2EXocrEfZo5k3l2fjFawZWj5bHVfCgocOzD3nF4Aae7Ht2UYUEsv8/BIrfDS5fGbhdjK+9TfPDykuzSHEDu8MVTsO+u8cyMm1yFMVEAL10plzEx8WJvQ0aVkwGGw5Y6xE8dnv/sP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560057; c=relaxed/simple;
	bh=+B/iQCRgT6in491se8sCRWxL60tHRWExshDnJ0gBAdY=;
	h=Date:To:From:Subject:Message-Id; b=g/rymdMp0PEXPehvH75Cl7ix518r+fbu84yJlq/BzUS0AD1AgOi/d5uRz2V+KQu9y9Zw2vZdHVDFM4t3QR5HuQM/KaZ/JJ81eQsWxHZpbRNuK3R+d0pphTPdTcSFcrWNoL3dxiE4Y8HvLUiL/SbO6FJZomAE+tvLgQlf+cIz2gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JB+vTLYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JB+vTLYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B76C43399;
	Thu, 22 Feb 2024 00:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560056;
	bh=+B/iQCRgT6in491se8sCRWxL60tHRWExshDnJ0gBAdY=;
	h=Date:To:From:Subject:From;
	b=JB+vTLYhjjjJ4zKEZMmBNOkCjN3xnp4QrKyXUTKXBPp4+zer7ARg8/2d17uQjPqmS
	 0n4KfCK2OCUWf25aNYR782DSIi9Zz5IXUO/crME6i3nE1muZQb8+H3mWkWwm5TYf/Q
	 E0HCoAOVxDfuX2+ySspnFXKx60FQ3VWQmWCZ92uA=
Date: Wed, 21 Feb 2024 16:00:56 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-comment-describing-mas_node_count_gfp.patch removed from -mm tree
Message-Id: <20240222000056.92B76C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix comment describing mas_node_count_gfp()
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-comment-describing-mas_node_count_gfp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: fix comment describing mas_node_count_gfp()
Date: Tue, 9 Jan 2024 14:31:19 -0800

The function description comment for mas_node_count_gfp() mistakingly
refers to the function as mas_node_count().  Change it to refer to the
correct function.

Link: https://lkml.kernel.org/r/20240109223119.162357-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-comment-describing-mas_node_count_gfp
+++ a/lib/maple_tree.c
@@ -1307,8 +1307,8 @@ static inline void mas_free(struct ma_st
 }
 
 /*
- * mas_node_count() - Check if enough nodes are allocated and request more if
- * there is not enough nodes.
+ * mas_node_count_gfp() - Check if enough nodes are allocated and request more
+ * if there is not enough nodes.
  * @mas: The maple state
  * @count: The number of nodes needed
  * @gfp: the gfp flags
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


