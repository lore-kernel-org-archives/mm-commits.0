Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C281BC58
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727381167; cv=none; b=XAWX5NOUfQGPVOETq75TKi+4+NflsvJhxlIfyNJsJPVssITTmiWDVUOS4834LF0hS1XKCcvAFdKJ/A2HicoyqjpDThPHj/dAU4Wz/C/Q4MpulIFE5OKnPhucH72Zw+ReA9ckBIWxNQ1hv3LwbOQYjc4+EwUeCvwGE/Hyh2jGPmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727381167; c=relaxed/simple;
	bh=LnFdKt4L+ZN/rLGU+bB+J3JTPVYIkBVRXYtslH5R9fs=;
	h=Date:To:From:Subject:Message-Id; b=TSwYEte7CGvFdItgBOkbTkKr0Hiztniq2jdb3pRZZypWKnDf3rbdO3w2xJax0Rvn93nP95NgOcWNy72VY/4UVDw9jFBxr5C97T/0yica/R1YDj7vzMS3o5et+fEq7SIwXQHqJrvhwUl/ZRK8DavektoXH0tQNEDYGqAomQKRBj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tZxzpRCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tZxzpRCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DD8C4CEC5;
	Thu, 26 Sep 2024 20:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727381167;
	bh=LnFdKt4L+ZN/rLGU+bB+J3JTPVYIkBVRXYtslH5R9fs=;
	h=Date:To:From:Subject:From;
	b=tZxzpRCTqhTOa3crLjQPnmETyn2CX//DpDN0BN33ZNTB1szyiQnamh2WgmNjYHaY1
	 nXnbTmZleBqVEs29W+xduSToyqPaHEcmAgYkrdydRvvgV6jiQl3BmgURscCnZ1lOpt
	 CJ7xsNpQCnAqFZcar+njmFX4EkJ6LWzAvC/6ZlzI=
Date: Thu, 26 Sep 2024 13:06:05 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,anupnewsmail@gmail.com,tanyaagarwal25699@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-comments-for-better-documentation.patch added to mm-unstable branch
Message-Id: <20240926200607.04DD8C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: fix comments for better documentation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-fix-comments-for-better-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-fix-comments-for-better-documentation.patch

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
From: Tanya Agarwal <tanyaagarwal25699@gmail.com>
Subject: mm/mempolicy: fix comments for better documentation
Date: Fri, 27 Sep 2024 00:05:16 +0530

Fix typo in mempolicy.h and Correct the number of allowed memory policy

Link: https://lkml.kernel.org/r/20240926183516.4034-2-tanyaagarwal25699@gmail.com
Signed-off-by: Tanya Agarwal <tanyaagarwal25699@gmail.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Anup Sharma <anupnewsmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    2 +-
 mm/mempolicy.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mempolicy.h~mm-mempolicy-fix-comments-for-better-documentation
+++ a/include/linux/mempolicy.h
@@ -47,7 +47,7 @@ struct mempolicy {
 	atomic_t refcnt;
 	unsigned short mode; 	/* See MPOL_* above */
 	unsigned short flags;	/* See set_mempolicy() MPOL_F_* above */
-	nodemask_t nodes;	/* interleave/bind/perfer */
+	nodemask_t nodes;	/* interleave/bind/preferred/etc */
 	int home_node;		/* Home node to use for MPOL_BIND and MPOL_PREFERRED_MANY */
 
 	union {
--- a/mm/mempolicy.c~mm-mempolicy-fix-comments-for-better-documentation
+++ a/mm/mempolicy.c
@@ -8,7 +8,7 @@
  * NUMA policy allows the user to give hints in which node(s) memory should
  * be allocated.
  *
- * Support four policies per VMA and per process:
+ * Support six policies per VMA and per process:
  *
  * The VMA policy has priority over the process policy for a page fault.
  *
_

Patches currently in -mm which might be from tanyaagarwal25699@gmail.com are

mm-mempolicy-fix-comments-for-better-documentation.patch

