Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5431018BB85;
	Mon,  2 Sep 2024 22:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725316160; cv=none; b=qE13zNXd9k3OnZTWQvjNJoliLymOh7ue5hTCdUYwxo3MuBN6c8duq0qDIm1tfPIJq3JVbzBqABhdQj+rxod5X3LyCQe5Qx7Knyh7PMX92kioxEp+SLRmsxcr25pDa8uL10J+tkbNaR501HIgrSfNjFiI2oY8wFQJiB7lKH/ObbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725316160; c=relaxed/simple;
	bh=K06Q204xEXick6n74zMcgE+07okpNumZZyb5J4/tAPo=;
	h=Date:To:From:Subject:Message-Id; b=FEJ+eCPOjXXB5ZQ2WwCaQ1ny3SAnWQpRtih82eWXNpGDRRKY5uh1PlQfepkB6tpGgV89hBW04sEB+yV9uZRPZkIAvxtmvRKM+yEpNfkpXB2Wk8mdQGokbd+uG2e9Po1QqYGGX47/xDbnh92lUxby2S5g7aaVt0m8h1BKmO3nOmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wlwFKrAI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wlwFKrAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1919C4CEC2;
	Mon,  2 Sep 2024 22:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725316159;
	bh=K06Q204xEXick6n74zMcgE+07okpNumZZyb5J4/tAPo=;
	h=Date:To:From:Subject:From;
	b=wlwFKrAIUpplEj+T0gtAEmZtpqP2TwHuPhzzkYab1bk0THduWGH82O6vXcM8uCk2/
	 2Y90oyG3Ekgm84RmimN6DLrnWYXy3yI9hCMZkzhpT2Q+EivKZAELEobSgYvrgJFtcm
	 K95ord3GoTpC7VpkY1WpzUjugRPBaLLT9JqJg5FM=
Date: Mon, 02 Sep 2024 15:29:19 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,lizhi.xu@windriver.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-possible-null-ptr-deref-in-ocfs2_set_buffer_uptodate.patch added to mm-hotfixes-unstable branch
Message-Id: <20240902222919.B1919C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix possible null-ptr-deref in ocfs2_set_buffer_uptodate
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-possible-null-ptr-deref-in-ocfs2_set_buffer_uptodate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-possible-null-ptr-deref-in-ocfs2_set_buffer_uptodate.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

ocfs2-remove-unreasonable-unlock-in-ocfs2_read_blocks.patch
ocfs2-fix-possible-null-ptr-deref-in-ocfs2_set_buffer_uptodate.patch

