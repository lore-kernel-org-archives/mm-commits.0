Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2605C2C9
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732758828; cv=none; b=HjLkNyP7Uh6VuN0oFDQ8NFp+IdZbnkSyLM0p24ftA464cb1wPpu2TkA3M5qynIXW2VtRuVywtKrmw/peOY+uNWU3xCF6gaxfKyXE5I4iPyDj/4cGQO0Kqf4tCFBsPGfXusE2nV9zE+992F+JuS5fF5mneLtls+zjOtaM6++CKXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732758828; c=relaxed/simple;
	bh=Jy6mhEUkESzEatS2HIzkzRt5KZ17KrB/4mI9UtcXHc0=;
	h=Date:To:From:Subject:Message-Id; b=RIA8C5djAVWNprBahn32KxGKRKLasJi6bpM1ScQaxMBPX9QAuEGpUUOFePnUEaG7vYAgDGMLgiFrPMWKdhJFdIS9EZtzqTbKY9bcpBeYSxoFSxsiSrh70J4NxO1EUoxiwQQbBBzAhHRSGEyBMkk0qBd9KHBC9OlJZnrwy8+phTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dcpNqc9a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dcpNqc9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF53C4CECC;
	Thu, 28 Nov 2024 01:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732758828;
	bh=Jy6mhEUkESzEatS2HIzkzRt5KZ17KrB/4mI9UtcXHc0=;
	h=Date:To:From:Subject:From;
	b=dcpNqc9a6fY7EyD2UCLqc6uZK7BBqhCVUoyQ08X7cgdf3SX3XVl5z4Vwd05lLB9Yb
	 JSPTz8yFCvHovgzGaRdZdCK5XXscrobaCcW/tT4K0adD6M1oqV5wifkvoP60RjsKLO
	 EHcTXWe5hOsJhgQFZfK8y2W4BLplThhS0AjuMhaU=
Date: Wed, 27 Nov 2024 17:53:47 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,danielyangkang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-heartbeat-replace-simple_strtoul-with-kstrtoul.patch added to mm-nonmm-unstable branch
Message-Id: <20241128015348.3AF53C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: heartbeat: replace simple_strtoul with kstrtoul
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-heartbeat-replace-simple_strtoul-with-kstrtoul.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-heartbeat-replace-simple_strtoul-with-kstrtoul.patch

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
Subject: ocfs2: heartbeat: replace simple_strtoul with kstrtoul
Date: Sun, 17 Nov 2024 13:52:18 -0800

simple_strtoul() is deprecated due to ignoring overflows and also requires
clunkier error checking.  Replacing with kstrtoul() leads to safer code
and cleaner error checking.

Link: https://lkml.kernel.org/r/20241117215219.4012-1-danielyangkang@gmail.com
Signed-off-by: Daniel Yang <danielyangkang@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-heartbeat-replace-simple_strtoul-with-kstrtoul
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1535,10 +1535,11 @@ static int o2hb_read_block_input(struct
 {
 	unsigned long bytes;
 	char *p = (char *)page;
+	int ret;
 
-	bytes = simple_strtoul(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
-		return -EINVAL;
+	ret = kstrtoul(p, 0, &bytes);
+	if (ret)
+		return ret;
 
 	/* Heartbeat and fs min / max block sizes are the same. */
 	if (bytes > 4096 || bytes < 512)
@@ -1622,13 +1623,14 @@ static ssize_t o2hb_region_blocks_store(
 	struct o2hb_region *reg = to_o2hb_region(item);
 	unsigned long tmp;
 	char *p = (char *)page;
+	int ret;
 
 	if (reg->hr_bdev_file)
 		return -EINVAL;
 
-	tmp = simple_strtoul(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
-		return -EINVAL;
+	ret = kstrtoul(p, 0, &tmp);
+	if (ret)
+		return ret;
 
 	if (tmp > O2NM_MAX_NODES || tmp == 0)
 		return -ERANGE;
@@ -2136,10 +2138,11 @@ static ssize_t o2hb_heartbeat_group_dead
 {
 	unsigned long tmp;
 	char *p = (char *)page;
+	int ret;
 
-	tmp = simple_strtoul(p, &p, 10);
-	if (!p || (*p && (*p != '\n')))
-                return -EINVAL;
+	ret = kstrtoul(p, 10, &tmp);
+	if (ret)
+		return ret;
 
 	/* this will validate ranges for us. */
 	o2hb_dead_threshold_set((unsigned int) tmp);
_

Patches currently in -mm which might be from danielyangkang@gmail.com are

ocfs2-heartbeat-replace-simple_strtoul-with-kstrtoul.patch

