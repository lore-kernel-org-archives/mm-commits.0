Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CA77F56F
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H8qim55o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3927C433C8;
	Tue, 12 Dec 2023 18:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407555;
	bh=Ls4Pznbe/FlACh+7m+TJDVSvTX84bm1IDSuBcFPv/yg=;
	h=Date:To:From:Subject:From;
	b=H8qim55owkFxR5JdWZeWenaAFEcL/1nqN21bb6bihSaqWp1XS3xNdhDFom7gK5O4z
	 woRO7LRZuZjBN0hibyg12t6lTShX4KjPjq17o2D6ShRz5fALzwbGl0fR31weRMWokp
	 ORmTNX1Wreye6kbc9gRYKUJj1UbHyEr8TBIj5hIE=
Date: Tue, 12 Dec 2023 10:59:15 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,dan.carpenter@linaro.org,zhangpeng.00@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-delete-one-of-the-two-identical-checks.patch removed from -mm tree
Message-Id: <20231212185915.A3927C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: delete one of the two identical checks
has been removed from the -mm tree.  Its filename was
     maple_tree-delete-one-of-the-two-identical-checks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: delete one of the two identical checks
Date: Mon, 20 Nov 2023 15:09:36 +0800

There are two identical checks, delete one of them.

Link: https://lkml.kernel.org/r/20231120070937.35481-5-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-delete-one-of-the-two-identical-checks
+++ a/lib/maple_tree.c
@@ -4117,9 +4117,6 @@ static inline bool mas_wr_append(struct
 	if (mt_in_rcu(mas->tree))
 		return false;
 
-	if (mas->offset != mas->end)
-		return false;
-
 	end = mas->end;
 	if (mas->offset != end)
 		return false;
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


