Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689DB1E504
	for <mm-commits@vger.kernel.org>; Fri, 15 Dec 2023 19:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jzm9rE6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B380C433C7;
	Fri, 15 Dec 2023 19:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702668193;
	bh=1Ex0+mp7+WDeXgYRxmz+4ddHpGdCEYmMcXfmww1BWMI=;
	h=Date:To:From:Subject:From;
	b=Jzm9rE6zMxbmVZPnTc8xiYA58GrvIkQjfTqUaERMymyskFlSlc9MHap42MoP4KK8N
	 0S4Y4R9runLeBTWJU6Za8Zdtgb0B8eGl7hHulcSLy9HEFryfRqR8YOdCfH35gCI86c
	 qE5vNcpQkUfsMVBddunKpqKccQfa7soyQyIFSB6s=
Date: Fri, 15 Dec 2023 11:23:13 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,zhangpeng.00@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-avoid-checking-other-gaps-after-getting-the-largest-gap.patch added to mm-unstable branch
Message-Id: <20231215192313.9B380C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: avoid checking other gaps after getting the largest gap
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-avoid-checking-other-gaps-after-getting-the-largest-gap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-avoid-checking-other-gaps-after-getting-the-largest-gap.patch

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
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
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

maple_tree-avoid-checking-other-gaps-after-getting-the-largest-gap.patch

