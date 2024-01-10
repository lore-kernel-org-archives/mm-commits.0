Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284384691
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 04:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FE/WNJ4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9456DC433C7;
	Wed, 10 Jan 2024 04:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704859701;
	bh=rFDnToLtYql+G/jtGEwNsJjgbze47jMviwOsriremyA=;
	h=Date:To:From:Subject:From;
	b=FE/WNJ4jGGT/iVsNCzEBHWi4ZPg3c2GSQvYsHUrFmEjtr0TwCWnMAVP4mEZvp6cRG
	 Kf2kgAybo+RHCT/2G6FKu7oxISvKBwEE9Rhc0hLfybU8m5aHEc6mEhqiDKc13+9SVV
	 f2Jo+fgFGwcSaeXf0aozlqbfBRHju48Z+e5pGzVw=
Date: Tue, 09 Jan 2024 20:08:20 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-comment-describing-mas_node_count_gfp.patch added to mm-unstable branch
Message-Id: <20240110040821.9456DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix comment describing mas_node_count_gfp()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-comment-describing-mas_node_count_gfp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-comment-describing-mas_node_count_gfp.patch

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

maple_tree-fix-comment-describing-mas_node_count_gfp.patch

