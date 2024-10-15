Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4754B173357
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 23:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729033691; cv=none; b=QfzZ7Yo/P8mkegAOAGfLnPjfdfAxDGrtva7S3np5HM0BSI1lmAT5QHQy4LnaB3dJt9c8O7ssrSLkAc1nM1a2WrlH9438kGfwnf+lfqK4hsmG4cf1FXKPo1DfjqHU9jXiOdrjIOQzeghUQxEmeRLTrAP9kjH1DxZafNCO0muhlF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729033691; c=relaxed/simple;
	bh=aRQr4YVVKehCCSc4Kycs3QloP/amGxsAizLa7LWpnuY=;
	h=Date:To:From:Subject:Message-Id; b=N3AoHYSS6YfcJ4ambTP/H23aKcLQuI881c+e/W/Antp47JQtHKGkeXygCtuOgV+jf70ueqPPk38TB69JJ2JNS2XSpEUpkKYlTgxomN2dTGP82iyl3v2MkG045sWe5qj+TT3IWtXIo9OyiuzBC0r2jOe+SfLDMZm1vzxAvhR1GPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YkQIk4kp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YkQIk4kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121D7C4CEC6;
	Tue, 15 Oct 2024 23:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729033691;
	bh=aRQr4YVVKehCCSc4Kycs3QloP/amGxsAizLa7LWpnuY=;
	h=Date:To:From:Subject:From;
	b=YkQIk4kpQ0XlvGH96gJA8YlrwbH56UFX1Kx63tdAqt0vXFLmIcfJ3Dm2NXIV2Q2iw
	 NKndzaw31kwtb/t2cNBi6CgDkVkMS/EUXHYaOFwM0BY8TV07inVda1iQ+VKhdffHNf
	 f5QLZlI1/jENf8Ip5jI6YxUgiJ8uVFuJxmzKhmaE=
Date: Tue, 15 Oct 2024 16:08:10 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-simplify-mas_push_node.patch added to mm-unstable branch
Message-Id: <20241015230811.121D7C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: simplify mas_push_node()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-simplify-mas_push_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-simplify-mas_push_node.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: simplify mas_push_node()
Date: Tue, 15 Oct 2024 12:07:46 +0000

When count is not 0, we know head is valid.  So we can put the assignment
in if (count) instead of checking the head pointer again.

Also count represents current total, we can assign the new total by
increasing the count by one.

Link: https://lkml.kernel.org/r/20241015120746.15850-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/lib/maple_tree.c~maple_tree-simplify-mas_push_node
+++ a/lib/maple_tree.c
@@ -1207,19 +1207,17 @@ static inline void mas_push_node(struct
 
 	reuse->request_count = 0;
 	reuse->node_count = 0;
-	if (count && (head->node_count < MAPLE_ALLOC_SLOTS)) {
-		head->slot[head->node_count++] = reuse;
-		head->total++;
-		goto done;
-	}
-
-	reuse->total = 1;
-	if ((head) && !((unsigned long)head & 0x1)) {
+	if (count) {
+		if (head->node_count < MAPLE_ALLOC_SLOTS) {
+			head->slot[head->node_count++] = reuse;
+			head->total++;
+			goto done;
+		}
 		reuse->slot[0] = head;
 		reuse->node_count = 1;
-		reuse->total += head->total;
 	}
 
+	reuse->total = count + 1;
 	mas->alloc = reuse;
 done:
 	if (requested > 1)
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch
maple_tree-goto-complete-directly-on-a-pivot-of-0.patch
maple_tree-remove-maple_big_nodeparent.patch
maple_tree-memset-maple_big_node-as-a-whole.patch
maple_tree-root-node-could-be-handled-by-p_slot-too.patch
maple_tree-clear-request_count-for-new-allocated-one.patch
maple_tree-total-is-not-changed-for-nomem_one-case.patch
maple_tree-simplify-mas_push_node.patch

