Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2B563C
	for <mm-commits@vger.kernel.org>; Mon, 25 Nov 2024 04:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732509501; cv=none; b=U5TKbbgup178mDLkAsAM9o9IIPVAR3Vn+mGCToTOfEhzd4LA0uWCuBrjDLv55JAxpVqwQdrtLMJrON6c/ny+wvI7mWwleXu4yBXyfHo3eX6EFvF/kPrYxnJBazqGyxQh4J0ZWyNpQ17Spw7JZgC4sgvqIOkJ/GYwUezY2iEoTkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732509501; c=relaxed/simple;
	bh=3rPRneOXrjO8n4TIDM+qlwsIWZfeQ+Erfun7ng5+MlU=;
	h=Date:To:From:Subject:Message-Id; b=ZtnuppMFtRvxpaCCUps+vk1AWe8MZdMSHv2/JUGqNeLcCv39AXudX798dKlyUSIPRWy4KEQr8xvnr76fsERkS5J8f9bj98BZh4xZHSdKWHqwqRiSF1wryMvXexWEuX44MV0+mmZey4qW3GDVOXoUTpgdzVvpWw2562uYh+gwy14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Iz/o/BbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Iz/o/BbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C213C4CECE;
	Mon, 25 Nov 2024 04:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732509499;
	bh=3rPRneOXrjO8n4TIDM+qlwsIWZfeQ+Erfun7ng5+MlU=;
	h=Date:To:From:Subject:From;
	b=Iz/o/BbPjHwJAMxTfYs5CSaJyQdGKWyleNjLzHPXEnGkwWjSlAknqPRyH+71Ys+4O
	 VPow8G8DR6nroy/E9QpAskGgenWQUpDtBhcjsUscXU9w3KYosuavg0AiGlVMchtk5D
	 n9HvaCguOliLfKEDe4fPM4hCiKnCy3I5UBNxKjN4=
Date: Sun, 24 Nov 2024 20:38:09 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-mas_next_slot-directly.patch added to mm-unstable branch
Message-Id: <20241125043817.9C213C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: use mas_next_slot() directly
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-use-mas_next_slot-directly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-mas_next_slot-directly.patch

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
Subject: maple_tree: use mas_next_slot() directly
Date: Mon, 25 Nov 2024 02:41:56 +0000

The loop condition makes sure (mas.last < max), so we can directly use
mas_next_slot() here.

Since no other use of mas_next_entry(), it is removed.

Link: https://lkml.kernel.org/r/20241125024156.26093-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-mas_next_slot-directly
+++ a/lib/maple_tree.c
@@ -4745,29 +4745,6 @@ again:
 }
 
 /*
- * mas_next_entry() - Internal function to get the next entry.
- * @mas: The maple state
- * @limit: The maximum range start.
- *
- * Set the @mas->node to the next entry and the range_start to
- * the beginning value for the entry.  Does not check beyond @limit.
- * Sets @mas->index and @mas->last to the range, Does not update @mas->index and
- * @mas->last on overflow.
- * Restarts on dead nodes.
- *
- * Return: the next entry or %NULL.
- */
-static inline void *mas_next_entry(struct ma_state *mas, unsigned long limit)
-{
-	if (mas->last >= limit) {
-		mas->status = ma_overflow;
-		return NULL;
-	}
-
-	return mas_next_slot(mas, limit, false);
-}
-
-/*
  * mas_rev_awalk() - Internal function.  Reverse allocation walk.  Find the
  * highest gap address of a given size in a given node and descend.
  * @mas: The maple state
@@ -6937,7 +6914,7 @@ retry:
 		goto unlock;
 
 	while (mas_is_active(&mas) && (mas.last < max)) {
-		entry = mas_next_entry(&mas, max);
+		entry = mas_next_slot(&mas, max, false);
 		if (likely(entry && !xa_is_zero(entry)))
 			break;
 	}
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-use-mas_next_slot-directly.patch

