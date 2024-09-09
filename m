Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775E918C924;
	Mon,  9 Sep 2024 22:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725920193; cv=none; b=hEjhduPIFgwgMylEwPGepbHHb7n3+vaH2fi5OggrepSB60dttgXV6W9GTspYnwRLev/OrDuzxxniMsZ51uhiGhD1shT7109u06CXMKeVWtfkgXKqdEOm5uMcmLiyy/ACm495x9Kt2gvQgJvzfXU17e1o6lRut8GX8X2Ts5o7wbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725920193; c=relaxed/simple;
	bh=m2pEfSkt/1dyqMj8nujPeJXdFCyur+VTEgo1v4DpJtU=;
	h=Date:To:From:Subject:Message-Id; b=GHKMzMI54DhQYkQUn+dFIRjVajMOblqSPZkxIBUeXMFvMDuxy8kpZTkZREYNSc3RYj8UEIsMPeA9+dn/Z05fxkKfT/W/veWlXzJc1w6VyXZUTTTkZRjnsyEQQPFBT25HbRYqZ/P+UlxVgZx9NJIIGsRYgy9kSIs0NoHOM4Y6hnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l5M0thlP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l5M0thlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE663C4CEC5;
	Mon,  9 Sep 2024 22:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725920193;
	bh=m2pEfSkt/1dyqMj8nujPeJXdFCyur+VTEgo1v4DpJtU=;
	h=Date:To:From:Subject:From;
	b=l5M0thlPYHXcnWmId/UhCr0zbyYbX5HadndQiL+t/TiwcLWpe21/qluRlyV3bg8bo
	 jiUus9vN5iqXpmohjfRPclJN/4/QLVDx6886TzrlK6aOEx/7ok8rPzF9VmBqmNmqZP
	 +UlzcGA/QxMWG1UMx8y41IEKXhBRtPfbf6zjvV/8=
Date: Mon, 09 Sep 2024 15:16:32 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,lizhi.xu@windriver.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-fix-possible-null-ptr-deref-in-ocfs2_set_buffer_uptodate.patch removed from -mm tree
Message-Id: <20240909221632.DE663C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix possible null-ptr-deref in ocfs2_set_buffer_uptodate
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-possible-null-ptr-deref-in-ocfs2_set_buffer_uptodate.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lizhi Xu <lizhi.xu@windriver.com>
Subject: ocfs2: fix possible null-ptr-deref in ocfs2_set_buffer_uptodate
Date: Mon, 2 Sep 2024 10:36:36 +0800

When doing cleanup, if flags without OCFS2_BH_READAHEAD, it may trigger
NULL pointer dereference in the following ocfs2_set_buffer_uptodate() if
bh is NULL.

Link: https://lkml.kernel.org/r/20240902023636.1843422-3-joseph.qi@linux.alibaba.com
Fixes: cf76c78595ca ("ocfs2: don't put and assigning null to bh allocated outside")
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Heming Zhao <heming.zhao@suse.com>
Suggested-by: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>	[4.20+]
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/buffer_head_io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/buffer_head_io.c~ocfs2-fix-possible-null-ptr-deref-in-ocfs2_set_buffer_uptodate
+++ a/fs/ocfs2/buffer_head_io.c
@@ -388,7 +388,8 @@ read_failure:
 		/* Always set the buffer in the cache, even if it was
 		 * a forced read, or read-ahead which hasn't yet
 		 * completed. */
-		ocfs2_set_buffer_uptodate(ci, bh);
+		if (bh)
+			ocfs2_set_buffer_uptodate(ci, bh);
 	}
 	ocfs2_metadata_cache_io_unlock(ci);
 
_

Patches currently in -mm which might be from lizhi.xu@windriver.com are


