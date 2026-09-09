Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D411397
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 02:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788922269; cv=none; b=ZfZQbRG50swYxOF0dI+ETpm73wf0o4LKKDFvbylQjqOQcpvkHqA0Sa1Ic7T34RuSYATkh+CZuT05jwAoKeLoQ2XP8vmGaJlKV1vzyS2xcs72+ZUApVYjGjhsF+P77VQONzZqvCBwlywV3KFwTpql/O7xDWMjI8EvPlgTxSipWuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788922269; c=relaxed/simple;
	bh=sEaCgqz2qdypEN9tSlmPnnHiG1+3dg/KG4n/ApOUuIM=;
	h=Date:To:From:Subject:Message-Id; b=FLlqi3h6F2vMq0cXXM+9T9Sg4QeglRRYzdOAhMYLhDV9tEoBCF3WCkHvP/9jNOHhgkhYb0PxUrKUqOVa9cqmye84spQRYFwdNyW5Sz+mKUJ5fa8FhTf9HAqSNNS1tFORm3WqCGM+2f02FzHIWlhyUQ/b7GUKcXsHvXmJ97bQec8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AzQTotRh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AzQTotRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3551F00A3A;
	Wed,  9 Sep 2026 02:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788922268;
	bh=DvW8RExoht2QqRDLuMMeQHPU0Dju/uDCpP0bD0r1cDM=;
	h=Date:To:From:Subject;
	b=AzQTotRhpmC1wmOQmLvqlYKhbscdig4CXWnxseBBx6DKnoulNGOQGa2I8LwcQrBLv
	 K2virZ0+djVJYjdxefyVDgB2h3aP6dcFUDFp8KqQ1bP39MXNTP+YlxEwIYNiPbbYFC
	 nPIDl+H/DKUbZ+D3k2rgvT3XQUU9KXxhRjJDPmrE=
Date: Tue, 08 Sep 2026 19:51:07 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,qi.zheng@linux.dev,kasong@tencent.com,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-baoquan-and-me-as-mglru-reviewers.patch added to mm-hotfixes-unstable branch
Message-Id: <20260909025108.0D3551F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Baoquan and Baolin as MGLRU reviewers
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-baoquan-and-me-as-mglru-reviewers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-baoquan-and-me-as-mglru-reviewers.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: MAINTAINERS: add Baoquan and Baolin as MGLRU reviewers
Date: Tue, 8 Sep 2026 09:42:12 +0800

Baoquan and I have been contributing MGLRU patches and helping review
MGLRU related patches for some time.  We will continue to follow MGLRU
changes, so we'd like to be CC'd on MGLRU related patches.

Link: https://lore.kernel.org/06e20ef4f603a4ffeafcdbf623ce2936281457bf.1788831480.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Baoquan He <baoquan.he@linux.dev>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-baoquan-and-me-as-mglru-reviewers
+++ a/MAINTAINERS
@@ -17240,6 +17240,8 @@ R:	Barry Song <baohua@kernel.org>
 R:	Axel Rasmussen <axelrasmussen@google.com>
 R:	Yuanchu Xie <yuanchu@google.com>
 R:	Wei Xu <weixugc@google.com>
+R:	Baoquan He <baoquan.he@linux.dev>
+R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

maintainers-add-baoquan-and-me-as-mglru-reviewers.patch

