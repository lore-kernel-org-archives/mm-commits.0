Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE4317583
	for <mm-commits@vger.kernel.org>; Sun, 23 Feb 2025 03:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740279631; cv=none; b=mM64NLvmKVY63mS4pn2KR7HEO4a839DE18qREfbIyOgikUZn6O5+TF0fSBkXbwWvzLsJOBX/gdY/6WTELHVwTmxe6aY4/57CUj6BeWvVkarPoxXxA5Depl11fUYe3qT9rZO6JzR8xBHmXqTmTU0s1Ee+EIleuQ37Wk5AR4g/P5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740279631; c=relaxed/simple;
	bh=fsKH+o45HvUY9hDIR59mf/I+PZc0ZEo8idYflTRirEk=;
	h=Date:To:From:Subject:Message-Id; b=KaYo7MT4cF2VcHnaPCG1vQ/DpFuYbb+71aXwqqX3iWfJ1+aXQ4/i5wx8VHbeJ33C/2WX02BY8MkwRoig3pVi7SaDEb5QhfJ9yhDr65lo6yMqNAF4lb3wCHuonod6eXQqgCx1f2jFKL2OHfXfkOQkDiHzH5woLWw2F5dy1YGpWGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YxgQzkjQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YxgQzkjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6B5C4CEE4;
	Sun, 23 Feb 2025 03:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740279630;
	bh=fsKH+o45HvUY9hDIR59mf/I+PZc0ZEo8idYflTRirEk=;
	h=Date:To:From:Subject:From;
	b=YxgQzkjQPc+CN5VAwgfgujWFGcy+/VKigvQBL3gZgQSDJ1jodAuoBNNK0XllvdBzx
	 upysNNnX9fwlBCZ8r5MIn+Suqachw+bGG84xtDA+3B5KHM8tvQpIls492nYF6zN9pF
	 3xuQM5LZw5DVkIAug0l8ArP0Hddf24ApPzKCKo64=
Date: Sat, 22 Feb 2025 19:00:30 -0800
To: mm-commits@vger.kernel.org,quic_zijuhu@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rhashtable-remove-needless-return-in-three-void-apis.patch added to mm-nonmm-unstable branch
Message-Id: <20250223030030.8A6B5C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rhashtable: remove needless return in three void APIs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rhashtable-remove-needless-return-in-three-void-apis.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rhashtable-remove-needless-return-in-three-void-apis.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Zijun Hu <quic_zijuhu@quicinc.com>
Subject: rhashtable: remove needless return in three void APIs
Date: Fri, 21 Feb 2025 05:02:21 -0800

Remove needless 'return' in the following void APIs:

 rhltable_walk_enter()
 rhltable_free_and_destroy()
 rhltable_destroy()

Since both the API and callee involved are void functions.

Link: https://lkml.kernel.org/r/20250221-rmv_return-v1-16-cc8dff275827@quicinc.com
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rhashtable.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/rhashtable.h~rhashtable-remove-needless-return-in-three-void-apis
+++ a/include/linux/rhashtable.h
@@ -1259,7 +1259,7 @@ static inline int rhashtable_replace_fas
 static inline void rhltable_walk_enter(struct rhltable *hlt,
 				       struct rhashtable_iter *iter)
 {
-	return rhashtable_walk_enter(&hlt->ht, iter);
+	rhashtable_walk_enter(&hlt->ht, iter);
 }
 
 /**
@@ -1275,12 +1275,12 @@ static inline void rhltable_free_and_des
 							     void *arg),
 					     void *arg)
 {
-	return rhashtable_free_and_destroy(&hlt->ht, free_fn, arg);
+	rhashtable_free_and_destroy(&hlt->ht, free_fn, arg);
 }
 
 static inline void rhltable_destroy(struct rhltable *hlt)
 {
-	return rhltable_free_and_destroy(hlt, NULL, NULL);
+	rhltable_free_and_destroy(hlt, NULL, NULL);
 }
 
 #endif /* _LINUX_RHASHTABLE_H */
_

Patches currently in -mm which might be from quic_zijuhu@quicinc.com are

rhashtable-remove-needless-return-in-three-void-apis.patch
cpu-remove-needless-return-in-void-api-suspend_enable_secondary_cpus.patch
mm-mmu_gather-remove-needless-return-in-void-api-tlb_remove_page.patch

