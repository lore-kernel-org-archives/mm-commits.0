Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875AD14830F
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011002; cv=none; b=u8jstF2XnJynIGD5O3vyLdxIh+8Vh1BqAPRbulJpmqPntfH1w5G4ziI/Y9BJLXXVjERI1bARZmtXKyDVTYCiWcaf31GztZPLFlDsXSff/hd34lZQ6zzkXl36nOyPqgLlxyfGPige9WLyFOL1WqW4MrWtuPIeyRMadNy1dCc1Kl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011002; c=relaxed/simple;
	bh=6gBv+Uuc/th7vnzuxrVQhp+mHTfDb9y4+7PTHNzqHHo=;
	h=Date:To:From:Subject:Message-Id; b=i9qdgyiA64qwUJX/h7jBDNCcV7sKAAaPqvTVZifuO/z5ijW64MSqnAGb7MCjcdC+YrJS3Lf5t79DT8+Y5gInz/XgJh7I36P86wpJRpZSwXq4KKWfAXPE2JZMrD2guGBiCAv364anjjeTBVlH7fZwljb8zvZb/atqhF1qqhtbOCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uv9yHb0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uv9yHb0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7DCC4CEE4;
	Mon, 12 May 2025 00:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011002;
	bh=6gBv+Uuc/th7vnzuxrVQhp+mHTfDb9y4+7PTHNzqHHo=;
	h=Date:To:From:Subject:From;
	b=uv9yHb0U2xnbD0WgFY+DR/UJOHcmkkN6MD70jOGcjXnit9waNOaXvHPj+y9yFQvsg
	 GzSQ2n/Fr+mXWAVdiNmxallbk1EqmLdIr0oRfd9MuaO5SzayXHjZtXFd1rBtvYBf5y
	 yxJdVHomcNNZ02KIOIgsgskL41AI365wKNtF0R/o=
Date: Sun, 11 May 2025 17:50:01 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,ying.huang@linux.alibaba.com,vishal.moola@gmail.com,songmuchun@bytedance.com,pankaj.gupta@amd.com,osalvador@suse.de,anshuman.khandual@arm.com,liusongtang@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-redundant-read_once.patch removed from -mm tree
Message-Id: <20250512005002.5C7DCC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: remove redundant READ_ONCE
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-redundant-read_once.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Songtang Liu <liusongtang@bytedance.com>
Subject: mm: page_alloc: remove redundant READ_ONCE
Date: Wed, 2 Apr 2025 03:41:16 -0400

In the current code, batch is a local variable, and it cannot be
concurrently modified.  It's unnecessary to use READ_ONCE here, so remove
it.

Link: https://lkml.kernel.org/r/CAA=HWd1kn01ym8YuVFuAqK2Ggq3itEGkqX8T6eCXs_C7tiv-Jw@mail.gmail.com
Fixes: 51a755c56dc0 ("mm: tune PCP high automatically")
Signed-off-by: Songtang Liu <liusongtang@bytedance.com>
Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-redundant-read_once
+++ a/mm/page_alloc.c
@@ -2675,7 +2675,7 @@ static void free_frozen_page_commit(stru
 		free_high = (pcp->free_count >= batch &&
 			     (pcp->flags & PCPF_PREV_FREE_HIGH_ORDER) &&
 			     (!(pcp->flags & PCPF_FREE_HIGH_BATCH) ||
-			      pcp->count >= READ_ONCE(batch)));
+			      pcp->count >= batch));
 		pcp->flags |= PCPF_PREV_FREE_HIGH_ORDER;
 	} else if (pcp->flags & PCPF_PREV_FREE_HIGH_ORDER) {
 		pcp->flags &= ~PCPF_PREV_FREE_HIGH_ORDER;
_

Patches currently in -mm which might be from liusongtang@bytedance.com are


