Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737301EF091
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676277; cv=none; b=fs9K7G108YFyzoLfcmKCa9xSjQhIF0ZtK2DxS0nWRXspGFLW8mKkUvVBetAlg1oY8SaaB/iRCO7xAyDyMpqcmrDfr/PLFQ08Ult/JPeiz5jreVmgSR2INP8KI9Hc/xSNTiZBS12pbt/A1UC64FjwF76psWte9IGSF/DOEdf0SeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676277; c=relaxed/simple;
	bh=huHNwt4koJNZXea+Mck9UDAYZN3AgsHUh/DqEUpVdvY=;
	h=Date:To:From:Subject:Message-Id; b=T7qNbNMcMYBkw0o7bkW5KeMewgxILeMlSbfcRVqQaKqatGoNyAGCIko/HqX3fXMOvKsu4BBjKAErQk/RGved8mRCotwqn+0x0LQ43LqVYiXqZrTqgxmsdnNSTwfgzLqNbkfsyozHwn/+dVBxmvnjmyXrw+R/OPHdMBQt0mCgREs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=duDO9jYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="duDO9jYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EB8C4CEF1;
	Thu, 20 Nov 2025 22:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676277;
	bh=huHNwt4koJNZXea+Mck9UDAYZN3AgsHUh/DqEUpVdvY=;
	h=Date:To:From:Subject:From;
	b=duDO9jYQ+oPnoJR3v2UM4y/lQ8t+oOpiEYWnKiiWl+GSVmXPHVAEHdXgjyoR1IGPG
	 1c/eV19LKSzRxDMF2Y8BzwZijiGB4ilLjKfcughxq6O8nnrm3IohCefxNzuMysk2Yr
	 bSRBOM2DMwa8WoEX8HMO8d0Z3PDwa0k9+yHLuvUo=
Date: Thu, 20 Nov 2025 14:04:36 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,luizcap@redhat.com,liuye@kylinos.cn,linmiaohe@huawei.com,david@redhat.com,zhangjiao2@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-proc-page-remove-unused-kpmbits.patch removed from -mm tree
Message-Id: <20251120220437.47EB8C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/page: remove unused KPMBITS
has been removed from the -mm tree.  Its filename was
     fs-proc-page-remove-unused-kpmbits.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Subject: fs/proc/page: remove unused KPMBITS
Date: Thu, 6 Nov 2025 09:07:34 +0800

KPMBITS is never referenced in the code. Just remove it.

Link: https://lkml.kernel.org/r/20251106010735.1603-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Ye <liuye@kylinos.cn>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/proc/page.c~fs-proc-page-remove-unused-kpmbits
+++ a/fs/proc/page.c
@@ -20,7 +20,6 @@
 
 #define KPMSIZE sizeof(u64)
 #define KPMMASK (KPMSIZE - 1)
-#define KPMBITS (KPMSIZE * BITS_PER_BYTE)
 
 enum kpage_operation {
 	KPAGE_FLAGS,
_

Patches currently in -mm which might be from zhangjiao2@cmss.chinamobile.com are


