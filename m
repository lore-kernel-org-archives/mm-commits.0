Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B24712B73
	for <mm-commits@vger.kernel.org>; Sat,  7 Sep 2024 02:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725677932; cv=none; b=MDixOXUSUtZXnOvPQ8YQDKoj95b4RKskMbYpsm4HFjhmtivBO9qAZCJTiHjXwP+++LboBl4VyaqDnl8Xg4CAnFsK+FnY27Mn0q4/CrCtM6MXQ+34DJEOQMjDM+J1CCZvYRI9Gpo3OIoxL+aIIv7bH83qApGjDye5/a6nVWFEwNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725677932; c=relaxed/simple;
	bh=omjs6TRHl6DBwj23ekLQA7jajtm1SyPAcNu3zo3ulaE=;
	h=Date:To:From:Subject:Message-Id; b=WyxAizMmq0fX+I37TBwOtXMPqQgafFnoC5xH7gHZW90xqPHc2+zrWlF+g4Wt1TNGoXIy2el4MKQ5VgWsRoqp+eJAKn/Hawm7o7QqzhjT8gpjjmbXEhgfxTZtGT3nqzbOnb2+oLksN5XkRhiFpNvdlBVD9Hq3rxIGKyfT+UIXnys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HWGgCljk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HWGgCljk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADFEC4CEC4;
	Sat,  7 Sep 2024 02:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725677932;
	bh=omjs6TRHl6DBwj23ekLQA7jajtm1SyPAcNu3zo3ulaE=;
	h=Date:To:From:Subject:From;
	b=HWGgCljkl+G/pMUPvfFFYNWBh4apRMzjzLoBBqqRY0n3lazWk7O3gmgi0O2q0pAH2
	 CPajNNnvrlt9mM+knpgH74lBDAin4wB7FJ1Vz6xKP/WdEuPZmwv5SuSoAGyGiasKOX
	 fhTNx3NACRloivX0K03OREx17ccl8UT7PGuWJ7Go=
Date: Fri, 06 Sep 2024 19:58:51 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-mark-three-functions-as-__maybe_unused.patch added to mm-unstable branch
Message-Id: <20240907025852.1ADFEC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: mark three functions as __maybe_unused
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-mark-three-functions-as-__maybe_unused.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-mark-three-functions-as-__maybe_unused.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: mark three functions as __maybe_unused
Date: Fri, 6 Sep 2024 22:15:06 -0400

People keep trying to remove three functions that are going to be used in
a feature that is being developed.  Dropping the functions entirely may
end up with people trying to use the bit for other uses, as people have
tried in the past.

Adding __maybe_unused stops compilers complaining about the unused
functions so they can be silently optimised out of the compiled code and
people won't try to claim the bit for another use.

Link: https://lore.kernel.org/all/20230726080916.17454-2-zhangpeng.00@bytedance.com/
Link: https://lore.kernel.org/all/202408310728.S7EE59BN-lkp@intel.com/
Link: https://lkml.kernel.org/r/20240907021506.4018676-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-mark-three-functions-as-__maybe_unused
+++ a/lib/maple_tree.c
@@ -348,17 +348,17 @@ static inline void *mte_safe_root(const
 	return (void *)((unsigned long)node & ~MAPLE_ROOT_NODE);
 }
 
-static inline void *mte_set_full(const struct maple_enode *node)
+static inline void __maybe_unused *mte_set_full(const struct maple_enode *node)
 {
 	return (void *)((unsigned long)node & ~MAPLE_ENODE_NULL);
 }
 
-static inline void *mte_clear_full(const struct maple_enode *node)
+static inline void __maybe_unused *mte_clear_full(const struct maple_enode *node)
 {
 	return (void *)((unsigned long)node | MAPLE_ENODE_NULL);
 }
 
-static inline bool mte_has_null(const struct maple_enode *node)
+static inline bool __maybe_unused mte_has_null(const struct maple_enode *node)
 {
 	return (unsigned long)node & MAPLE_ENODE_NULL;
 }
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-damon-vaddr-protect-vma-traversal-in-__damon_va_thre_regions-with-rcu-read-lock.patch
maple_tree-mark-three-functions-as-__maybe_unused.patch

