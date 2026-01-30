Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3223644D1
	for <mm-commits@vger.kernel.org>; Fri, 30 Jan 2026 17:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769794506; cv=none; b=dm3naHPJ/T8N8T2pOac5M7dMIm7dpAAFbO3pKi7GmIb3mdfxAFGRY8UfVo33HVx8S3RtZmj6A+BgeLzo8qI4m+Y3SqMWA43XMt1ATjyLKrE9FE4xFkQN3aemF2F4H6GVVGNOxFP0ftq/p7A4v+Ug75inpqJvAudF4mVEhUyEaoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769794506; c=relaxed/simple;
	bh=yHyM4rM0Gea1Oo+oX3q3Z0ObBNFadqwUjn6a/fxa9LQ=;
	h=Date:To:From:Subject:Message-Id; b=P0XtVwpPNbNd5d9pPeXZntRxMcp4Y9UUmNSyQDqxJG+8YL3dLMOFBUi8JXeYfiLDf8kQvFCiw+aY9ocXLxu/kCR9zpAJpJ5Bvq394iKt9U2m6qHblnJAmvplBHUUutI5MZ/bIcsG3ek7nJUGtX5132VA4OV0CTpcQmld5h2MXT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rWyJSL8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rWyJSL8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BC3C116C6;
	Fri, 30 Jan 2026 17:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769794505;
	bh=yHyM4rM0Gea1Oo+oX3q3Z0ObBNFadqwUjn6a/fxa9LQ=;
	h=Date:To:From:Subject:From;
	b=rWyJSL8nVjZ+klWnKQzZjAskMFg3FmLX9oBOXIvV2VlL+HDQFwYmedQTRKmTTGUik
	 Qh5a6DF5IaC12b5D6esHmTmYpsBCNqperXig8fDvWMjvptzLV877TFxnV1woj7xLr7
	 Lakcot1vLI9ddxHd0VQNjA1tw2AKYFiS22lppP2g=
Date: Fri, 30 Jan 2026 09:35:05 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,lirongqing@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-remove-__read_mostly-from-memory_idle_ms_percentiles.patch added to mm-new branch
Message-Id: <20260130173505.A7BC3C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: remove __read_mostly from memory_idle_ms_percentiles
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-remove-__read_mostly-from-memory_idle_ms_percentiles.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-remove-__read_mostly-from-memory_idle_ms_percentiles.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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

mm-damon-remove-__read_mostly-from-memory_idle_ms_percentiles.patch

