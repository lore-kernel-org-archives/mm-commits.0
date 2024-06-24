Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DC51A0702
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 21:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719265068; cv=none; b=QMaqf+BFxQbgrqUvmKD7I3dYIf56Cg2Vvm5w33oNZFR2Hn8uXVpOAi+pG0l/W6zi8zCKYVqexr4yvo8mxk3Cb0Xl5rQQizPj7LfT/SlXXJgSWF6PTczUjDvnU7F8cH/SbaeCGTWG2ygpR2LNyLLYzCK7DWi8dr6/J275iuDAZNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719265068; c=relaxed/simple;
	bh=jvvBwwo5rKSqKPU1/AXnIEuV5nLkhuBY/Lirvp/Pu4I=;
	h=Date:To:From:Subject:Message-Id; b=Oo3iKjPpmY5qqYKlLKydh3s427IjkPjJ7SqxkpsI8CctUvGbrjArPu8Z1l5Zh/nL71PQfgtM2XLr8WRX76uAILWGRkWO01m8zJjq3MwtRe+XfrIhOfv1U57OJwF01IDaeqrGJvDDkNiyD6hGbGf+rrfO1y8LirQireaJd4ISFCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dp76U2nX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dp76U2nX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7ABCC2BBFC;
	Mon, 24 Jun 2024 21:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719265067;
	bh=jvvBwwo5rKSqKPU1/AXnIEuV5nLkhuBY/Lirvp/Pu4I=;
	h=Date:To:From:Subject:From;
	b=Dp76U2nXaPlmALMdrT+PhQGW4w+GpgSAkz2eQaQUQFFewYzUljafRD/6vCEmWjNxs
	 JzgKdxfD/u4lmBoTtZpXm8ID1Zw6GPngY/p0u+lA2eWHjHbiNWijlmqQmX8hMgUMBx
	 RPsjYqMTxt+ITcFLvUk6T9BK+qJRFnn6dgmdJsys=
Date: Mon, 24 Jun 2024 14:37:47 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rientjes@google.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,fvdl@google.com,corbet@lwn.net,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-userspace-controls-soft-offlining-pages-v5.patch added to mm-unstable branch
Message-Id: <20240624213747.B7ABCC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-failure-userspace-controls-soft-offlining-pages-v5
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-userspace-controls-soft-offlining-pages-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-userspace-controls-soft-offlining-pages-v5.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm-memory-failure-userspace-controls-soft-offlining-pages-v5
Date: Mon, 24 Jun 2024 16:33:46 +0000

update a comment in soft_offline_page()

Link: https://lkml.kernel.org/r/20240624163348.1751454-3-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-userspace-controls-soft-offlining-pages-v5
+++ a/mm/memory-failure.c
@@ -2770,8 +2770,8 @@ static int soft_offline_in_use_page(stru
  * @flags: flags. Same as memory_failure().
  *
  * Returns 0 on success,
- *         -EOPNOTSUPP for hwpoison_filter() filtered the error event,
- *         -EOPNOTSUPP if disabled by /proc/sys/vm/enable_soft_offline,
+ *         -EOPNOTSUPP for hwpoison_filter() filtered the error event, or
+ *         disabled by /proc/sys/vm/enable_soft_offline,
  *         < 0 otherwise negated errno.
  *
  * Soft offline a page, by migration or invalidation,
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-memory-failure-refactor-log-format-in-unpoison_memory.patch
mm-memory-failure-refactor-log-format-in-soft-offline-code.patch
mm-memory-failure-userspace-controls-soft-offlining-pages.patch
mm-memory-failure-userspace-controls-soft-offlining-pages-v5.patch
selftest-mm-test-enable_soft_offline-behaviors.patch
selftest-mm-test-enable_soft_offline-behaviors-v5.patch
docs-mm-add-enable_soft_offline-sysctl.patch

