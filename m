Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FC4C2C9
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732759035; cv=none; b=itkK8CeaOre5ehRhQQ5LADojRjHq409CXgK65Sh1loVNlCOWdsPGUw3DjcbXAwxyMjSXo20nfjMwFss3uNhbDbJlQfj6jGpQI5ZJBZw731pEUXSYgRZR3quDsn31JQI6F6+cnrSTRCOYLvZLbX9m/FYSIXQcGJ/rBK0wE6qvdzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732759035; c=relaxed/simple;
	bh=2TUyV3ooyXILlXufVAGt3W9RuQlMoEoLKweBsjWTrQc=;
	h=Date:To:From:Subject:Message-Id; b=gtYblVAOgN+5/EAzIgn0uYTvJrtDJmKKtR4UNAwGjCY635VlrkXEWtdQuR9SIwAOCZq5Lq/6zd6Rve1FcK/2yQ10uSyrJt2nt0YjtTQOX6WW2tl39NO8PZv1ng5oo6oCpzeHpCneLTuH1gqIAJ6SPgWpmVlIObqGnAUNAiN0hCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WMqPOHD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WMqPOHD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C2EC4CECC;
	Thu, 28 Nov 2024 01:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732759035;
	bh=2TUyV3ooyXILlXufVAGt3W9RuQlMoEoLKweBsjWTrQc=;
	h=Date:To:From:Subject:From;
	b=WMqPOHD3eUyzplqYh9Ud6ioWtWPeLdd7TmXdgKkTCBwJaJ1jn8xAA/wM49iz47nVI
	 TeP19YA0V8ja8xLerXq6NIe5SQ7eIenbLog51liDzTgXVzGIZ7EIiq6acpX1jYaqez
	 i6+qHlsr/U6NkjqDRnHQ4t9ygkKsOA1qsq6rYS6w=
Date: Wed, 27 Nov 2024 17:57:14 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,danielyangkang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-replace-deprecated-simple_strtol-with-kstrtol.patch added to mm-nonmm-unstable branch
Message-Id: <20241128015715.35C2EC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: replace deprecated simple_strtol with kstrtol
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-replace-deprecated-simple_strtol-with-kstrtol.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-replace-deprecated-simple_strtol-with-kstrtol.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

ocfs2-heartbeat-replace-simple_strtoul-with-kstrtoul.patch
ocfs2-replace-deprecated-simple_strtol-with-kstrtol.patch

