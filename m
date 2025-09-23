Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291972FE581
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 21:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758662468; cv=none; b=NBHhoTzeVFaBL8JUoahvrEKltAXRnhMEomYe6cbuJP4dx69pyKXfIvnevuuFrpESiYWBC7TzbqavzlJirWz+fo/z41AxdHlYmdbjHcjDwShXj0U5QDjZC0mdqzMWCeGNRSzdDCTeqOUXFkxK9HHKasUVzYdTgRioPigLZxiMzw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758662468; c=relaxed/simple;
	bh=4H3bHVLgFwbOhVKb2MFPTTNFn6Pwqko3z4WdNQCVhew=;
	h=Date:To:From:Subject:Message-Id; b=ChGcucPw9XSHCmbYm/kdy4vOdGMiLa3TF9zY5RxOR/O4xUPMQbf6kP+rarWpO8ikMHx6Zwr2kN0R2drGp5+BvY14Hyn9z0OuFmmDa1ttKAWZCARBzPhpdWiStlaVcJTdhPKAbptt6Qht94+plgXR/bEltWGARNYY0lTMiioEWq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HbZo7p2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HbZo7p2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9794CC4CEF5;
	Tue, 23 Sep 2025 21:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758662467;
	bh=4H3bHVLgFwbOhVKb2MFPTTNFn6Pwqko3z4WdNQCVhew=;
	h=Date:To:From:Subject:From;
	b=HbZo7p2P5OwcdPAqgNoJ/YfL1dozaUEUDAIMt5uafGKgCjPHkBXAXOfIBoLkbTyHv
	 LNiKCldSf8+BzPsvAxk7NOJD0JzgsK4gb7JoMkTmg3CfsrvvXpJx5MLhsQmGw+ls6r
	 wyNAm5SOAfMj5mfcmSgcgj2M+X/p+FcX/ta5XTBg=
Date: Tue, 23 Sep 2025 14:21:07 -0700
To: mm-commits@vger.kernel.org,rgoldwyn@suse.de,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-double-free-in-user_cluster_connect.patch added to mm-nonmm-unstable branch
Message-Id: <20250923212107.9794CC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix double free in user_cluster_connect()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-double-free-in-user_cluster_connect.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-double-free-in-user_cluster_connect.patch

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
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: ocfs2: fix double free in user_cluster_connect()
Date: Tue, 23 Sep 2025 14:26:07 +0300

user_cluster_disconnect() frees "conn->cc_private" which is "lc" but then
the error handling frees "lc" a second time.  Set "lc" to NULL on this
path to avoid a double free.

Link: https://lkml.kernel.org/r/aNKDz_7JF7aycZ0k@stanley.mountain
Fixes: c994c2ebdbbc ("ocfs2: use the new DLM operation callbacks while requesting new lockspace")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/stack_user.c~ocfs2-fix-double-free-in-user_cluster_connect
+++ a/fs/ocfs2/stack_user.c
@@ -1011,6 +1011,7 @@ static int user_cluster_connect(struct o
 			printk(KERN_ERR "ocfs2: Could not determine"
 					" locking version\n");
 			user_cluster_disconnect(conn);
+			lc = NULL;
 			goto out;
 		}
 		wait_event(lc->oc_wait, (atomic_read(&lc->oc_this_node) > 0));
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

ocfs2-fix-double-free-in-user_cluster_connect.patch

