Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1634113FE1
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q1y6Xj1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC22C433C8;
	Fri, 29 Dec 2023 20:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881403;
	bh=E/lCD4XpBsR4zJVGqWY3x6QDEXAtnCMPT5AL2LlYvOg=;
	h=Date:To:From:Subject:From;
	b=Q1y6Xj1AU/R+88/TqY46BaBSkfjet0A/gsmFWBXY5+i6P1c606PT2RQsLzAYRrWTw
	 3dn4+jCc2SF88HWea0VRMVIbqf9EKBD75O2S1J+sfFo/S2nuBAPXKnS1GJ4TYbBVt2
	 iWtoLN18axFvBnFOx6TcEAiyZjiBLP3mx0FzEy9A=
Date: Fri, 29 Dec 2023 12:23:23 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,haokexin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-add-missing-set_freezable-for-freezable-kthread.patch removed from -mm tree
Message-Id: <20231229202323.8FC22C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: add missing set_freezable() for freezable kthread
has been removed from the -mm tree.  Its filename was
     nilfs2-add-missing-set_freezable-for-freezable-kthread.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Hao <haokexin@gmail.com>
Subject: nilfs2: add missing set_freezable() for freezable kthread
Date: Tue, 19 Dec 2023 18:09:18 +0900

The kernel thread function nilfs_segctor_thread() invokes the
try_to_freeze() in its loop.  But all the kernel threads are non-freezable
by default.  So if we want to make a kernel thread to be freezable, we
have to invoke set_freezable() explicitly.

Link: https://lkml.kernel.org/r/20231219090918.2329-1-konishi.ryusuke@gmail.com
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/segment.c~nilfs2-add-missing-set_freezable-for-freezable-kthread
+++ a/fs/nilfs2/segment.c
@@ -2588,6 +2588,7 @@ static int nilfs_segctor_thread(void *ar
 		   "segctord starting. Construction interval = %lu seconds, CP frequency < %lu seconds",
 		   sci->sc_interval / HZ, sci->sc_mjcp_freq / HZ);
 
+	set_freezable();
 	spin_lock(&sci->sc_state_lock);
  loop:
 	for (;;) {
_

Patches currently in -mm which might be from haokexin@gmail.com are


