Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1AE4D124
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HvvU9/uo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F246DC433C7;
	Wed, 20 Dec 2023 22:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112572;
	bh=5hgdDQqYnCSlyTgd360MuheoAJrB0kVnxqab53DGsEM=;
	h=Date:To:From:Subject:From;
	b=HvvU9/uo8sDDElXwDuDpBtkw557TQSSlOtWeWImmy+Ais5EcwoXuyNaoUGVslQZaJ
	 4fsFJ1MprH5kFxZIwWFKxS65OtGPU5QdLlcdPs5IR8vvAeTpaF4uf6fBN1cDsZxUsD
	 4hCDUkSHgaxKr4lhtthgReMd/JUUfVVfsgdNBo4E=
Date: Wed, 20 Dec 2023 14:49:31 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,zhangpeng.00@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-avoid-checking-other-gaps-after-getting-the-largest-gap.patch removed from -mm tree
Message-Id: <20231220224931.F246DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: avoid checking other gaps after getting the largest gap
has been removed from the -mm tree.  Its filename was
     maple_tree-avoid-checking-other-gaps-after-getting-the-largest-gap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: avoid checking other gaps after getting the largest gap
Date: Fri, 15 Dec 2023 15:46:32 +0800

The last range stored in maple tree is typically quite large.  By checking
if it exceeds the sum of the remaining ranges in that node, it is possible
to avoid checking all other gaps.

Running the maple tree test suite in user mode almost always results in a
near 100% hit rate for this optimization.

Link: https://lkml.kernel.org/r/20231215074632.82045-1-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/maple_tree.c~maple_tree-avoid-checking-other-gaps-after-getting-the-largest-gap
+++ a/lib/maple_tree.c
@@ -1518,6 +1518,9 @@ static unsigned long mas_leaf_max_gap(st
 		gap = ULONG_MAX - pivots[max_piv];
 		if (gap > max_gap)
 			max_gap = gap;
+
+		if (max_gap > pivots[max_piv] - mas->min)
+			return max_gap;
 	}
 
 	for (; i <= max_piv; i++) {
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


