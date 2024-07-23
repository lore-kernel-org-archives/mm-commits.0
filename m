Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B6B14287
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 02:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721701268; cv=none; b=DSVwNnDxM3M2hQsOa0N6vOwbwiQRTWkOdxQieFsFvaQ0gIfNJw5nqxCbuumSSTtJeTPqnyNpadNIQ4lX6cKknOCiCQaEkZpq512JlpyQUWy31w8cLLKZbPAp9td//b7wZAJRMUDwvLd6NLhrZo3Mwa4vR32Xm+ruOjOGATcSQ+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721701268; c=relaxed/simple;
	bh=J4Yyfd2EVWQJV7/bgvWi/tLK6oKN5GERcq3ysW1FqKg=;
	h=Date:To:From:Subject:Message-Id; b=cc5zjmkdpzt3OOjF8U2atj4a33Rfp0b4QnBHsHIADvYAxnlH2CdVF71WK1e8VCYhGAckiSCLN4TuEAEuMJde46AkPs3q8GZ/kL94svryuCSUG5J6j1BldLUevqrjcF4ddHYXsF1/4P2HQ05UvRd3w/89VnlsUjLlajXXGHqj2ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xlf5eTw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xlf5eTw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F859C116B1;
	Tue, 23 Jul 2024 02:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721701268;
	bh=J4Yyfd2EVWQJV7/bgvWi/tLK6oKN5GERcq3ysW1FqKg=;
	h=Date:To:From:Subject:From;
	b=Xlf5eTw3CdvjrqS/Sqm+OVz8WVrP+56hNZFLXBB9WJv3uLgH030LnT7UXzK6dXKdA
	 sIAP1zZxR6SKwA8QiXkZ8l58de7I14p6dLiFEEHgxAyn8CdLiXZKdoRCelhhKTIhFo
	 pno5aErcM2xwcIh6BN+pONizoGAY0q5QLIl5jJyg=
Date: Mon, 22 Jul 2024 19:20:52 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,glass.su@suse.com,ghe@suse.com,gechangwei@live.cn,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-the-la-space-leak-when-unmounting-an-ocfs2-volume.patch added to mm-nonmm-unstable branch
Message-Id: <20240723022108.5F859C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix the la space leak when unmounting an ocfs2 volume
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-the-la-space-leak-when-unmounting-an-ocfs2-volume.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-the-la-space-leak-when-unmounting-an-ocfs2-volume.patch

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
From: Heming Zhao <heming.zhao@suse.com>
Subject: ocfs2: fix the la space leak when unmounting an ocfs2 volume
Date: Fri, 19 Jul 2024 19:43:10 +0800

This bug has existed since the initial OCFS2 code.  The code logic in
ocfs2_sync_local_to_main() is wrong, as it ignores the last contiguous
free bits, which causes an OCFS2 volume to lose the last free clusters of
LA window on each umount command.

Link: https://lkml.kernel.org/r/20240719114310.14245-1-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/localalloc.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/fs/ocfs2/localalloc.c~ocfs2-fix-the-la-space-leak-when-unmounting-an-ocfs2-volume
+++ a/fs/ocfs2/localalloc.c
@@ -1002,6 +1002,25 @@ static int ocfs2_sync_local_to_main(stru
 		start = bit_off + 1;
 	}
 
+	/* clear the contiguous bits until the end boundary */
+	if (count) {
+		blkno = la_start_blk +
+			ocfs2_clusters_to_blocks(osb->sb,
+					start - count);
+
+		trace_ocfs2_sync_local_to_main_free(
+				count, start - count,
+				(unsigned long long)la_start_blk,
+				(unsigned long long)blkno);
+
+		status = ocfs2_release_clusters(handle,
+				main_bm_inode,
+				main_bm_bh, blkno,
+				count);
+		if (status < 0)
+			mlog_errno(status);
+	}
+
 bail:
 	if (status)
 		mlog_errno(status);
_

Patches currently in -mm which might be from heming.zhao@suse.com are

ocfs2-fix-the-la-space-leak-when-unmounting-an-ocfs2-volume.patch

