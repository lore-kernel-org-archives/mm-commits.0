Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D985B17991
	for <mm-commits@vger.kernel.org>; Thu, 20 Mar 2025 01:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742435325; cv=none; b=S0CoYzzWGwCTZtN9LnzM/WU5ZQPZ4jVSlxP6THHPdGqglzAc8wOfS+NmbRqhAv1NXYFgMbZZ4ZKx6CUmxXnCsuvHix3+mFIM6iwM7IthCtNdq/84mOtkOQxL3orHhRQBPksmusEAgSeKCeh+tWNcl1VzuJrHxdSDVAsRasmj8gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742435325; c=relaxed/simple;
	bh=fbgjrubS4rn+n2BirWXxiwS9SrbfMataDZBlqV9KeQY=;
	h=Date:To:From:Subject:Message-Id; b=HfkWgq+g9Hpx4JMzdeF97AfL9sogieS3be2prlC6291jzLQ2SQvbUXczX5SNtnnQ7VWtOmzNGkh5l1omY1f4DE5HxtVAWsHCSK8YymKwX1siB5icC4muLPdaUrKFPTJwNP0AJKjDrSAGldcb+bpU2nQ5DGbA88X9ejfPAFVkN6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=buqi8qQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="buqi8qQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAA8C4CEE4;
	Thu, 20 Mar 2025 01:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742435325;
	bh=fbgjrubS4rn+n2BirWXxiwS9SrbfMataDZBlqV9KeQY=;
	h=Date:To:From:Subject:From;
	b=buqi8qQAEK/uXCHfh71dd7eRxgLUKpOgZj8SJovvdb1V4hFP2qjZ1hY1a6+CYKZCU
	 +FiGZ0iTY/XmEJebuKrOTKT9ePA2DspYpKyyLMvAMA3ofY8ExE2tLlnzHNTqEho8Xi
	 3ExYDEZtFblRS/vRcz9kmmeweSMsDsVGBcEReR0A=
Date: Wed, 19 Mar 2025 18:48:44 -0700
To: mm-commits@vger.kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-unnecessary-__maybe_unused-in-order_to_pindex.patch added to mm-unstable branch
Message-Id: <20250320014845.4AAA8C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: remove unnecessary __maybe_unused in order_to_pindex()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-unnecessary-__maybe_unused-in-order_to_pindex.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-unnecessary-__maybe_unused-in-order_to_pindex.patch

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
From: Liu Ye <liuye@kylinos.cn>
Subject: mm/page_alloc: remove unnecessary __maybe_unused in order_to_pindex()
Date: Wed, 19 Mar 2025 17:17:26 +0800

The `movable` variable is always used when `CONFIG_TRANSPARENT_HUGEPAGE`
is enabled, so the `__maybe_unused` attribute is not necessary.  This
patch removes it and keeps the variable declaration within the `#ifdef`
block for better clarity.

Link: https://lkml.kernel.org/r/20250319091726.401158-1-liuyerd@163.com
Signed-off-by: Liu Ye<liuye@kylinos.cn>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-unnecessary-__maybe_unused-in-order_to_pindex
+++ a/mm/page_alloc.c
@@ -509,9 +509,9 @@ out:
 
 static inline unsigned int order_to_pindex(int migratetype, int order)
 {
-	bool __maybe_unused movable;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	bool movable;
 	if (order > PAGE_ALLOC_COSTLY_ORDER) {
 		VM_BUG_ON(order != HPAGE_PMD_ORDER);
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-page_alloc-remove-unnecessary-__maybe_unused-in-order_to_pindex.patch

