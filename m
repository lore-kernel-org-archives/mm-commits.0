Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B331581EE
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742197; cv=none; b=VoTuTpDFFU/JZuCc4yNLD1L91fUIJP/kYlFePVzpimTDRcfPwnyI3BJxu0Ud4WVXFqr7o2QswbT/GAMp0612Lnjw3MIfYhFDUrgwLLt8SV7hWPMoslfhaBLhBieZU9ShJTNxBrsUpSae/lSQDyhf/LGP07piXmA/mUyVnErGH8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742197; c=relaxed/simple;
	bh=mVSEllEcGvt5TSq+lXUEBEUeL+Rh2ysFc06vySmfbHs=;
	h=Date:To:From:Subject:Message-Id; b=qdURIMtALzddEq2oPqDOazU8kzhRSuZcfUUtzgIxwpO0pru7K5PiUoJYbBleWmHx9EOCvo+dPXKrN66wYQKTUTU3t1f9a+PHQagx5bb+Vlz16CAT/0SQxxhCP5QFAFs+r0CYUhUZ5/AtIfznn9tyzQel67sGlD2M+tdIt9Q+bt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UQp22jrl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UQp22jrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27A2C4CED6;
	Mon, 13 Jan 2025 04:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742197;
	bh=mVSEllEcGvt5TSq+lXUEBEUeL+Rh2ysFc06vySmfbHs=;
	h=Date:To:From:Subject:From;
	b=UQp22jrlTpWWjyCLrVxWZJIbfTCmgmILpHFas5v+vSbnaTymeAdDhrH+w+/jCMRQN
	 3DKc1Zq8NsjbFuwlrwDcTZVdOv+7XdKntN2tKv1zAO++h8SGwpdRN+x2PjhhpHDMZ2
	 qC1hCOHY6Y50hXwO2c/czw0c+nXRoWEAJidPFxM8=
Date: Sun, 12 Jan 2025 20:23:16 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,danielyangkang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-heartbeat-replace-simple_strtoul-with-kstrtoul.patch removed from -mm tree
Message-Id: <20250113042316.E27A2C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: heartbeat: replace simple_strtoul with kstrtoul
has been removed from the -mm tree.  Its filename was
     ocfs2-heartbeat-replace-simple_strtoul-with-kstrtoul.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


