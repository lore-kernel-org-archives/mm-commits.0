Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3FE29E11D
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939996; cv=none; b=SidhqHj0SsjT9oahIp07kP42kAx9do1e0/7bEPJKLfTRPKapUM3MfrfFHdYfR1G3ftc/m1rXF2rk8nMIB65UQh2LHyyoL1Diikf682HqsaMWKR/2u2M5YVvPO/KjGQUOkdD8mymi9SmGu9oQ3o8XroenQhcvlYp+LcyoY+CjmUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939996; c=relaxed/simple;
	bh=+n8Ox4ALGI7jGwp6ne8M+sy28B00aXOfRssUdA4/vcg=;
	h=Date:To:From:Subject:Message-Id; b=utbhKdrVtF9mCwiMqVZC5bANjNqq8ornLYLJNeLM5Bigd6bK0K1aTbWrBUfId6ebkStDo1HWLz7J+dVC1ctS8UW+vkqW4qg2Lh161dMSLo2bkpiPS8xhWXGo9548ggFjgZwQ66ZDJ0GzqH0y6bq+Hem5VmxrEIfa+sIMNfFG6bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DvObBi5P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DvObBi5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D04C4CEF7;
	Thu, 12 Feb 2026 23:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939996;
	bh=+n8Ox4ALGI7jGwp6ne8M+sy28B00aXOfRssUdA4/vcg=;
	h=Date:To:From:Subject:From;
	b=DvObBi5PM2Q/Hj3nGgE6Dv0QBdj2mU08vBwhd9qt7QBhSCYsgV/zy0Cgt2mZ+CEri
	 Q1p4wq/Tv1CGD3/a1T/RhKdK9d9E7aBvXkZn9afZVGPOcMXGKk6Y/Vjb8VKpIjweLJ
	 JhPCffvH37fgYvGoasTKo91t3Ecgq5TsAHc24h9U=
Date: Thu, 12 Feb 2026 15:46:35 -0800
To: mm-commits@vger.kernel.org,wangyang.guo@intel.com,tglx@kernel.org,kees@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-group_cpus-handle-const-qualifier-from-clusters-allocation-type.patch removed from -mm tree
Message-Id: <20260212234635.E2D04C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/group_cpus: handle const qualifier from clusters allocation type
has been removed from the -mm tree.  Its filename was
     lib-group_cpus-handle-const-qualifier-from-clusters-allocation-type.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


