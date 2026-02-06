Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBD72E54AA
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 22:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770417386; cv=none; b=aznq8qhPFMondX4qOUGItNq3NISpK5WNNW6RM065v6RFaomDO67a+O0ECjme2YZYpCpwbkO2ydNrnFnwKRecNvoDhCqdk6065z8Swfy95X1b9sbJ9KMNWVmgSOj8pivcxQ0LKJnwIVVGcDeIFze7SA02xL5NilOPYUg4xDwjSB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770417386; c=relaxed/simple;
	bh=g7q67ZxvrLwZmlS+zCGn6NoTSsJmhVcsWLSuhh4fzfo=;
	h=Date:To:From:Subject:Message-Id; b=Y20CVKm9UV38z88yyDbYnPKtUeIHnjvxu0hNFrYfola2HLoEF/yCsJCQpcUsipijtyGCzYMaSd8MxVM8ift3d86QhG1coUePypynhSKnjXv4gN5isf1YAOEAiTwS4HY1dWcnrWjsHzsiDf12YhtYMIhExYL/gmOMbB2bLHHB7J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lGpVbvW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lGpVbvW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AFAC16AAE;
	Fri,  6 Feb 2026 22:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770417385;
	bh=g7q67ZxvrLwZmlS+zCGn6NoTSsJmhVcsWLSuhh4fzfo=;
	h=Date:To:From:Subject:From;
	b=lGpVbvW5XWyKdl+ps7NQ047jiJpxwHdOM7aN4j46niC1H9a52p8THSkTqKCvDOnfy
	 gFQwa8giDIPa89Ujzv7WR/FgBzkecVeoZ2UOxJgGtxNHCIWTZq5oiCDPNtcyG3UoFU
	 f5XxmXze25kW2gmjzQ5cESg2WjnKSJWqBSxRRkxA=
Date: Fri, 06 Feb 2026 14:36:24 -0800
To: mm-commits@vger.kernel.org,wangyang.guo@intel.com,tglx@kernel.org,kees@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-group_cpus-handle-const-qualifier-from-clusters-allocation-type.patch added to mm-nonmm-unstable branch
Message-Id: <20260206223625.72AFAC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/group_cpus: handle const qualifier from clusters allocation type
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-group_cpus-handle-const-qualifier-from-clusters-allocation-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-group_cpus-handle-const-qualifier-from-clusters-allocation-type.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Kees Cook <kees@kernel.org>
Subject: lib/group_cpus: handle const qualifier from clusters allocation type
Date: Fri, 6 Feb 2026 14:20:13 -0800

In preparation for making the kmalloc family of allocators type aware, we
need to make sure that the returned type from the allocation matches the
type of the variable being assigned.  (Before, the allocator would always
return "void *", which can be implicitly cast to any pointer type.)

The assigned type is "const struct cpumask **", but the returned type,
while matching, is not const qualified.  To get them exactly matching,
just use the dereferenced pointer for the sizeof().

Link: https://lkml.kernel.org/r/20260206222010.work.349-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Cc: Wangyang Guo <wangyang.guo@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/group_cpus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/group_cpus.c~lib-group_cpus-handle-const-qualifier-from-clusters-allocation-type
+++ a/lib/group_cpus.c
@@ -320,7 +320,7 @@ static int alloc_cluster_groups(unsigned
 		goto no_cluster;
 
 	/* Allocate memory based on cluster number. */
-	clusters = kcalloc(ncluster, sizeof(struct cpumask *), GFP_KERNEL);
+	clusters = kcalloc(ncluster, sizeof(*clusters), GFP_KERNEL);
 	if (!clusters)
 		goto no_cluster;
 	cluster_groups = kcalloc(ncluster, sizeof(struct node_groups), GFP_KERNEL);
_

Patches currently in -mm which might be from kees@kernel.org are

lib-group_cpus-handle-const-qualifier-from-clusters-allocation-type.patch

