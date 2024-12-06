Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963D32F855;
	Fri,  6 Dec 2024 01:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733448506; cv=none; b=Do7b4RhnfmQ23J/BlbBhl8eCKm8zBY5+4meYjldwcZhQI+haiMjo9Hztx3E82LVwRIqpovokYyr3B2HN0TwdDCR/P3cyflZMlbB57Pfuf3LwWooAUGT50uUZB5OxjVXi7VM7rS5y/vB+yOJj3VtryUJ8mdhZ/y8QnGjvS9zeKeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733448506; c=relaxed/simple;
	bh=xENKWS2oymTpwxQjt6dXyUEsg96pQkIkKY4sgO4dE6M=;
	h=Date:To:From:Subject:Message-Id; b=oltjZCw3qEPwXoM+RM0ylfwABWAmen7MiqZbB3ECMReWReOpbEef2P6nhaWpCZo+Z/31UQ5+y+qSvsUeV0cXd85RgFtWOxdwUu8PIRbhi11B/Ekyqo5nHAxuHd3lEH9DFZJn6GsttgOAQugn3JIeONIZPHq2A7XJRexBkuXEsz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j233DFMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j233DFMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F44C4CED6;
	Fri,  6 Dec 2024 01:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733448506;
	bh=xENKWS2oymTpwxQjt6dXyUEsg96pQkIkKY4sgO4dE6M=;
	h=Date:To:From:Subject:From;
	b=j233DFMWEtTC2ZaAz7FuynD1oxhsqR5aaxlGRif5v0snCS9Qv6865rRo2RKQXwi1+
	 q9wyXP50IlbIpk9CaWMSMzam6TXR/ZytwDqMih5W0lZIObnJeme1mdQ0yEaryYxKC+
	 kJx9OiHkpkXvmBuuRfjHvyaBZ9s3st05bVvgL76I=
Date: Thu, 05 Dec 2024 17:28:25 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-revert-ocfs2-fix-the-la-space-leak-when-unmounting-an-ocfs2-volume.patch added to mm-hotfixes-unstable branch
Message-Id: <20241206012826.17F44C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: revert "ocfs2: fix the la space leak when unmounting an ocfs2 volume"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-revert-ocfs2-fix-the-la-space-leak-when-unmounting-an-ocfs2-volume.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-revert-ocfs2-fix-the-la-space-leak-when-unmounting-an-ocfs2-volume.patch

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
From: Heming Zhao <heming.zhao@suse.com>
Subject: ocfs2: revert "ocfs2: fix the la space leak when unmounting an ocfs2 volume"
Date: Thu, 5 Dec 2024 18:48:32 +0800

Patch series "Revert ocfs2 commit dfe6c5692fb5 and provide a new fix".

SUSE QA team detected a mistake in my commit dfe6c5692fb5 ("ocfs2: fix the
la space leak when unmounting an ocfs2 volume").  I am very sorry for my
error.  (If my eyes are correct) From the mailling list mails, this patch
shouldn't be applied to 4.19 5.4 5.10 5.15 6.1 6.6, and these branches
should perform a revert operation.

Reason for revert:
In commit dfe6c5692fb5, I mistakenly wrote: "This bug has existed since
the initial OCFS2 code.".  The statement is wrong.  The correct
introduction commit is 30dd3478c3cd.  IOW, if the branch doesn't include
30dd3478c3cd, dfe6c5692fb5 should also not be included.


This reverts commit dfe6c5692fb5 ("ocfs2: fix the la space leak when
unmounting an ocfs2 volume").

In commit dfe6c5692fb5, the commit log "This bug has existed since the
initial OCFS2 code." is wrong.  The correct introduction commit is
30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()").

The influence of commit dfe6c5692fb5 is that it provides a correct fix for
the latest kernel.  however, it shouldn't be pushed to stable branches. 
Let's use this commit to revert all branches that include dfe6c5692fb5 and
use a new fix method to fix commit 30dd3478c3cd.

Link: https://lkml.kernel.org/r/20241205104835.18223-1-heming.zhao@suse.com
Link: https://lkml.kernel.org/r/20241205104835.18223-2-heming.zhao@suse.com
Fixes: dfe6c5692fb5 ("ocfs2: fix the la space leak when unmounting an ocfs2 volume")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/localalloc.c |   19 -------------------
 1 file changed, 19 deletions(-)

--- a/fs/ocfs2/localalloc.c~ocfs2-revert-ocfs2-fix-the-la-space-leak-when-unmounting-an-ocfs2-volume
+++ a/fs/ocfs2/localalloc.c
@@ -1002,25 +1002,6 @@ static int ocfs2_sync_local_to_main(stru
 		start = bit_off + 1;
 	}
 
-	/* clear the contiguous bits until the end boundary */
-	if (count) {
-		blkno = la_start_blk +
-			ocfs2_clusters_to_blocks(osb->sb,
-					start - count);
-
-		trace_ocfs2_sync_local_to_main_free(
-				count, start - count,
-				(unsigned long long)la_start_blk,
-				(unsigned long long)blkno);
-
-		status = ocfs2_release_clusters(handle,
-				main_bm_inode,
-				main_bm_bh, blkno,
-				count);
-		if (status < 0)
-			mlog_errno(status);
-	}
-
 bail:
 	if (status)
 		mlog_errno(status);
_

Patches currently in -mm which might be from heming.zhao@suse.com are

ocfs2-revert-ocfs2-fix-the-la-space-leak-when-unmounting-an-ocfs2-volume.patch
ocfs2-fix-the-space-leak-in-la-when-releasing-la.patch

