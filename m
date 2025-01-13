Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6AE25761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742200; cv=none; b=Im/h0NNSr5fHNhAmJ6HqUjzH7Y+7VHA8MINuIvE/IY643yoNNix0JajesllO8d4AOUhXYkZOd6fPVZckD2ZvMjVRQguKRo5Q7elkwCly7GBT7pNbA78/1c3SG8+R5a0bbmizwAreC43OiW6czqofQfqtAnjK2rdSL59NDfc4skI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742200; c=relaxed/simple;
	bh=Engx3oeyDvj0E/wV064SkRaXjOb1a8URdu3SGgwhVn4=;
	h=Date:To:From:Subject:Message-Id; b=CL644cNflUL2sd02sOdstyAlA9I5IlYQJBBRqaXZA3hWTymvonSrymSsiG5bwpTKZA4ra9LoC9WmyAC2JcaTFiAy3VKoqoFAaqUUL+seBoCOU16ZFlEivvB1zwMOokKda69WHSxQHeC5rB3EEtJIv9sww6vq+zlkHyU88akVk2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wvTRlvVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wvTRlvVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2628C4CED6;
	Mon, 13 Jan 2025 04:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742199;
	bh=Engx3oeyDvj0E/wV064SkRaXjOb1a8URdu3SGgwhVn4=;
	h=Date:To:From:Subject:From;
	b=wvTRlvVCeNpLT4xqVcuLjh+KrsaKXL+nqaI/nZyw4dypGC4G6VcGhay+3COsiKeP3
	 s1Qj1bWkAWgxowiV6ulyh2vuM6+/+iiYB0l6zYgScDtkzPsskJYmahKfUjPl4eTlQ0
	 IFvEHh5iu+nL85A3ggqkGmvIEIelAiAj8eXSOQc4=
Date: Sun, 12 Jan 2025 20:23:19 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,danielyangkang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-replace-deprecated-simple_strtol-with-kstrtol.patch removed from -mm tree
Message-Id: <20250113042319.C2628C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: replace deprecated simple_strtol with kstrtol
has been removed from the -mm tree.  Its filename was
     ocfs2-replace-deprecated-simple_strtol-with-kstrtol.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Daniel Yang <danielyangkang@gmail.com>
Subject: ocfs2: replace deprecated simple_strtol with kstrtol
Date: Fri, 15 Nov 2024 00:00:17 -0800

simple_strtol() ignores overflows and has an awkward interface for error
checking.  Replace with the recommended kstrtol function leads to clearer
error checking and safer conversions.

Link: https://lkml.kernel.org/r/20241115080018.5372-1-danielyangkang@gmail.com
Signed-off-by: Daniel Yang <danielyangkang@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-replace-deprecated-simple_strtol-with-kstrtol
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2004, 2005 Oracle.  All rights reserved.
  */
 
+#include "linux/kstrtox.h"
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/jiffies.h>
@@ -1778,8 +1779,8 @@ static ssize_t o2hb_region_dev_store(str
 	if (o2nm_this_node() == O2NM_MAX_NODES)
 		return -EINVAL;
 
-	fd = simple_strtol(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
+	ret = kstrtol(p, 0, &fd);
+	if (ret < 0)
 		return -EINVAL;
 
 	if (fd < 0 || fd >= INT_MAX)
_

Patches currently in -mm which might be from danielyangkang@gmail.com are


