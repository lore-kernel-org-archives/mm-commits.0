Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7B04F887
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 23:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N54t5HTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98274C433C9;
	Wed, 20 Dec 2023 23:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113421;
	bh=hZ9mI3eQCFK5yEG/LPavNGPbSTpbS8HjYvnXRojpw/o=;
	h=Date:To:From:Subject:From;
	b=N54t5HTooRZpXiV5/f5aEmwgOUwc5/CCE6GAqk6DgbLk6t9kUKsbIDYUaKW4p9gyb
	 aMa3RHaOQUpG35fYzchZ8or7OrpzD3HmFrMjLyy/W43KT9HLD2OD56OH0CL194fZGC
	 XtPXiOfwgjEOGGD6h7NPpa/F4EgehlJ04vWAPGRg=
Date: Wed, 20 Dec 2023 15:03:41 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,haokexin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fork-remove-redundant-task_uninterruptible.patch removed from -mm tree
Message-Id: <20231220230341.98274C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: remove redundant TASK_UNINTERRUPTIBLE
has been removed from the -mm tree.  Its filename was
     fork-remove-redundant-task_uninterruptible.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Hao <haokexin@gmail.com>
Subject: fork: remove redundant TASK_UNINTERRUPTIBLE
Date: Fri, 8 Dec 2023 16:41:15 +0800

TASK_KILLABLE already includes TASK_UNINTERRUPTIBLE, so there is no
need to add a separate TASK_UNINTERRUPTIBLE.

Link: https://lkml.kernel.org/r/20231208084115.1973285-1-haokexin@gmail.com
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c~fork-remove-redundant-task_uninterruptible
+++ a/kernel/fork.c
@@ -1562,7 +1562,7 @@ static void complete_vfork_done(struct t
 static int wait_for_vfork_done(struct task_struct *child,
 				struct completion *vfork)
 {
-	unsigned int state = TASK_UNINTERRUPTIBLE|TASK_KILLABLE|TASK_FREEZABLE;
+	unsigned int state = TASK_KILLABLE|TASK_FREEZABLE;
 	int killed;
 
 	cgroup_enter_frozen();
_

Patches currently in -mm which might be from haokexin@gmail.com are

mm-khugepaged-remove-redundant-try_to_freeze.patch
nilfs2-add-missing-set_freezable-for-freezable-kthread.patch

