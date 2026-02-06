Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8244E313550
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770421696; cv=none; b=TmxfXOWCEa7wBKEQwpzokWrOuVikrN4WLCwtEbdcb2hNHS6ofPhqBS7nXlonjP147M5E1v15I4NLh4fuyudaZSeUmzebnVO9Dl7gG/XaX7a+qdYumIasJTjXVBX3z+AlbWj1Zuk26j6I1Tk7nWFlRjC2udS6wN/mQLPnqVUsdPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770421696; c=relaxed/simple;
	bh=vx+1+AP7c99KsjaM5mHct0qSoQN3/irWOwB4trTz8+I=;
	h=Date:To:From:Subject:Message-Id; b=gsL56Jloh29zeYu8l30qcx1UpnjdxYl3GwPSlYcDvDiqAULXk/nNlLDXTp0yvmD9HQziVGgYFZnD1F755Y4tXuHXsyg7SvelVqS5P28DOgqtbqQhbKwDcWHX2oZkjhHlOiSKknM/luOr+oUq85OXeiZD555xKaD+lQ+aJuVmto0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gsCo9MSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gsCo9MSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADA6C116C6;
	Fri,  6 Feb 2026 23:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770421696;
	bh=vx+1+AP7c99KsjaM5mHct0qSoQN3/irWOwB4trTz8+I=;
	h=Date:To:From:Subject:From;
	b=gsCo9MSlpfnFoOmQ/gWegV9GJBMjkQqtOWnizvJFFzm0yoWg+i/VUXvBD49Woga6S
	 HQ9NgZDf4MJfH8zPgHWLnqYccsl/kEryMHawjGNz2K6SeDent2p+5aX+8zdfgEfknf
	 +9QPW0Xgizo9ZeadjAggqVPOPYLi6ELhMxrdVlNw=
Date: Fri, 06 Feb 2026 15:48:15 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,lirongqing@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-remove-__read_mostly-from-memory_idle_ms_percentiles.patch removed from -mm tree
Message-Id: <20260206234816.5ADA6C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: remove __read_mostly from memory_idle_ms_percentiles
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-__read_mostly-from-memory_idle_ms_percentiles.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li RongQing <lirongqing@baidu.com>
Subject: mm/damon/stat: remove __read_mostly from memory_idle_ms_percentiles
Date: Fri, 30 Jan 2026 03:56:03 -0500

The 'memory_idle_ms_percentiles' array in DAMON_STAT is updated frequently
by the kernel to reflect the latest idle time statistics.  Marking it as
'__read_mostly' is inappropriate for data that is regularly written to, as
it can lead to cache pollution in the read-mostly section.

Remove the '__read_mostly' annotation to accurately reflect the
variable's usage pattern.

Link: https://lkml.kernel.org/r/20260130085603.1814-1-lirongqing@baidu.com
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/stat.c~mm-damon-remove-__read_mostly-from-memory_idle_ms_percentiles
+++ a/mm/damon/stat.c
@@ -34,7 +34,7 @@ module_param(estimated_memory_bandwidth,
 MODULE_PARM_DESC(estimated_memory_bandwidth,
 		"Estimated memory bandwidth usage in bytes per second");
 
-static long memory_idle_ms_percentiles[101] __read_mostly = {0,};
+static long memory_idle_ms_percentiles[101] = {0,};
 module_param_array(memory_idle_ms_percentiles, long, NULL, 0400);
 MODULE_PARM_DESC(memory_idle_ms_percentiles,
 		"Memory idle time percentiles in milliseconds");
_

Patches currently in -mm which might be from lirongqing@baidu.com are


