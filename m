Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E418296BD1
	for <mm-commits@vger.kernel.org>; Wed, 24 Sep 2025 22:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758752706; cv=none; b=deable9MA+tztjLuEHgLErCDkmbTaoXiNhwqrOZxaojNjeHEXSO18Lr7ETXSga5QAgVCf20T67RlhRnvbjMFL+rqz04x8NmgcVSByFkaPL0ufNv0ZeVFkpRRYN2hEln0SbrjvrxdKQakd/8Tnnl22tyN/wObISg55AcAILJmqhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758752706; c=relaxed/simple;
	bh=0WPcDJlfAPaQs2WTwKcNV2KbObcT5jZNEwI09q6XUx8=;
	h=Date:To:From:Subject:Message-Id; b=AGT6GrBnfgR7t4Dr4uUL5u72/1H0ZrKlbw1LwRnivze91HMGHxPrcYA7ojktnIbW6MsBxcHK2AbsN5zqPd82ZsujMw3iIKr/6HK3HXyRdpDArre/QP7NFC3o3bIvgtHKL33e0sHm/6KbpHmSjrsmgJjoURfw93cEDifAWgr4FqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fDIpOHQ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fDIpOHQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CED5C4CEE7;
	Wed, 24 Sep 2025 22:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758752705;
	bh=0WPcDJlfAPaQs2WTwKcNV2KbObcT5jZNEwI09q6XUx8=;
	h=Date:To:From:Subject:From;
	b=fDIpOHQ9JdtBglVJmzfc9D0sRExCV5Eep1upu7xwD12YJ6K37xoXIR5iMfXm536Pf
	 YUd9xfjk88crPs6xelqtLzKWOKKZLd8iQ2Cfyc5leJyomEq0wuGNYrruU3RXt90SoR
	 Xe5NwO4ZEcB74P75FecfsYKIQGeUnQ5ET9QQBs9g=
Date: Wed, 24 Sep 2025 15:25:05 -0700
To: mm-commits@vger.kernel.org,zhang.run@zte.com.cn,nao.horiguchi@gmail.com,mawupeng1@huawei.com,linmiaohe@huawei.com,hu.shengming@zte.com.cn,david@redhat.com,shengminghu512@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failure-ensure-collect_procs-is-retried-when-unmap-fails.patch removed from -mm tree
Message-Id: <20250924222505.9CED5C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: ensure collect_procs is retried when unmap fails
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-ensure-collect_procs-is-retried-when-unmap-fails.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Shengming Hu <shengminghu512@qq.com>
Subject: mm/memory-failure: ensure collect_procs is retried when unmap fails
Date: Tue, 23 Sep 2025 22:57:09 +0800

In the memory_failure process, if collect_procs is not executed with the
flag set, the to_kill list may be empty.  Even if there are pages that
fail to be unmapped, SIGKILL or SIGBUS cannot be sent to the process via
collect_procs.

This patch fixes the issue by re-executing collect_procs when the to_kill
list is empty and unmap fails.  This collects processes with unmap
failures into the to_kill list, allowing SIGBUS or SIGKILL to terminate
them in subsequent code.

Link: https://lkml.kernel.org/r/tencent_EDEED996FC685E61AADA14A23BCE9CCDAF09@qq.com
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Zhang Run <zhang.run@zte.com.cn>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-ensure-collect_procs-is-retried-when-unmap-fails
+++ a/mm/memory-failure.c
@@ -1600,9 +1600,12 @@ static bool hwpoison_user_mappings(struc
 	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
 
 	unmap_success = !unmap_poisoned_folio(folio, pfn, flags & MF_MUST_KILL);
-	if (!unmap_success)
+	if (!unmap_success) {
 		pr_err("%#lx: failed to unmap page (folio mapcount=%d)\n",
 		       pfn, folio_mapcount(folio));
+		if (list_empty(&tokill))
+			collect_procs(folio, p, &tokill, 1);
+	}
 
 	/*
 	 * try_to_unmap() might put mlocked page in lru cache, so call
_

Patches currently in -mm which might be from shengminghu512@qq.com are


