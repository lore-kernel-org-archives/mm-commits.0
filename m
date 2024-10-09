Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6FD13E3EF
	for <mm-commits@vger.kernel.org>; Wed,  9 Oct 2024 20:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728505996; cv=none; b=f/S6SamGmoFMDizdLu6gdR+EIJpbugsZ7xlYp1R6Uz5Jsyos+pACvcf4nfpCj67OwM5wfXOolEPIj8OTvP7qcUb81BjdhPqsSKPflM+GHJ+XvHIjiHGSjs5dPQotu+hkI3s+jmhPeooYkTEXAXyzvEAXYSk9qtDWRiwlk7g07oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728505996; c=relaxed/simple;
	bh=lizZDbKZuX+njjU/qYkI/QFb1NYm2zMZVkucRNqj1uE=;
	h=Date:To:From:Subject:Message-Id; b=q2cvOgauiCZVG3K8MmJnE8e99KQuXe4A3ZRyYcI5v/fguRDLoXqBTjU5SKvmCQeT39sUK3lLQkYzBoqEoK7E9JBjtIIX5K9Kd2JlVwPUGYjAVZme74OuQGOhZULpx2QKl8bWzSRC/WPHPuOvzl7aqA7LN4VTwi4bbYx6snx/MRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JvZqI58Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JvZqI58Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065E7C4CEC3;
	Wed,  9 Oct 2024 20:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728505996;
	bh=lizZDbKZuX+njjU/qYkI/QFb1NYm2zMZVkucRNqj1uE=;
	h=Date:To:From:Subject:From;
	b=JvZqI58Q0vQTZljarvtCBi89aQq601xr88wiynIdqMPAtsqIsZYOW888/u65wKy14
	 xkoQPsaYd1WjyFNDBesJcKQA8E3IWMbmTq1YXdP+SrdkJIWAfXCyfMYu8+utk9dfSP
	 EitALLXpPQrvlD8rdiJoGa8PBhDRJpLRGSKi746Q=
Date: Wed, 09 Oct 2024 13:33:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-conditionals-to-detect-wr_node_store.patch added to mm-unstable branch
Message-Id: <20241009203316.065E7C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: remove conditionals to detect wr_node_store
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-conditionals-to-detect-wr_node_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-conditionals-to-detect-wr_node_store.patch

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
From: Sidhartha <sidhartha.kumar@oracle.com>
Subject: maple_tree: remove conditionals to detect wr_node_store
Date: Wed, 9 Oct 2024 11:20:07 -0400

In mas_wr_store_type(), we check if new_end < mt_slots[wr_mas->type].  If
this check fails, we know that ,after this, new_end is >= mt_min_slots. 
Checking this again when we detect a wr_node_store later in the function
is reduntant.  Because this check is part of an OR statement, the
statement will always evaluate to true, therefore we can just get rid of
it.

Link: https://lkml.kernel.org/r/20241009152007.2096-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Suggested-by; Wei Yang <richard.weiyang@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-conditionals-to-detect-wr_node_store
+++ a/lib/maple_tree.c
@@ -4252,14 +4252,7 @@ static inline void mas_wr_store_type(str
 		return;
 	}
 
-	if (mte_is_root(mas->node) || (new_end >= mt_min_slots[wr_mas->type]) ||
-		(mas->mas_flags & MA_STATE_BULK)) {
-		mas->store_type = wr_node_store;
-		return;
-	}
-
-	mas->store_type = wr_invalid;
-	MAS_WARN_ON(mas, 1);
+	mas->store_type = wr_node_store;
 }
 
 /**
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-remove-conditionals-to-detect-wr_node_store.patch

