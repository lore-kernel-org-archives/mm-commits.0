Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFEB314A7B
	for <mm-commits@vger.kernel.org>; Sun,  4 Jan 2026 19:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767553208; cv=none; b=qWxx3G59IWCx0EpB4Lecd4OKfCYzCDQYrENmFL8/bWV0+xMKYyRMTS5hKqfu0ZL1RNkHv8llrPyjAPIsf7BNVkJpeSI6kpOPxsxorFotaJDltbkHIOzcqrEM+PxD/eB7N5pa3f+fAxLp4WX9mrNolm5Uq+E6PZs5jX7Upfyiy0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767553208; c=relaxed/simple;
	bh=u2AKsFDjAMcPymn2ImV+UndYYmmNSKWwaYFfh5PPQeA=;
	h=Date:To:From:Subject:Message-Id; b=ry6R+8daaDlIN9B6D9ydSnAT0y0BcsLSuzTaFJ5FzorTcRfTECi+mNdFjbiTtsfkR4JMgNbKBuPveK2FbowLywMSOWidqFWEqW6C4jSJ0eKtO+KaGm2v22cdznisoZaUm4izgM0VfGZ0Ds1OGDo7kpTj+cR8720F/NcDpgVvPdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ruqsduiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ruqsduiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F52C4CEF7;
	Sun,  4 Jan 2026 19:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767553208;
	bh=u2AKsFDjAMcPymn2ImV+UndYYmmNSKWwaYFfh5PPQeA=;
	h=Date:To:From:Subject:From;
	b=ruqsduiLexU3Oxpk1mhAgVE01JKy+W1t4PutIOIGCRCmcAwfb0ERA57UkEelfLWLP
	 JpBPnRlSWq5Zab8DCG7jb3+4+JCkOeS9ZXmNBWfYPDzXW26W09nWnVk8hQiAOlcKqH
	 yB0tBtslV1gGCUrj/Qv6Cmtnk8AcT83roNxyHlys=
Date: Sun, 04 Jan 2026 11:00:07 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,gechangwei@live.cn,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-reflink-preserve-cleanup-issue.patch added to mm-nonmm-unstable branch
Message-Id: <20260104190007.E5F52C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix reflink preserve cleanup issue
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-reflink-preserve-cleanup-issue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-reflink-preserve-cleanup-issue.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Heming Zhao <heming.zhao@suse.com>
Subject: ocfs2: fix reflink preserve cleanup issue
Date: Wed, 10 Dec 2025 09:57:24 +0800

commit c06c303832ec ("ocfs2: fix xattr array entry __counted_by error")
doesn't handle all cases and the cleanup job for preserved xattr entries
still has bug:
- the 'last' pointer should be shifted by one unit after cleanup
  an array entry.
- current code logic doesn't cleanup the first entry when xh_count is 1.

Note, commit c06c303832ec is also a bug fix for 0fe9b66c65f3.

Link: https://lkml.kernel.org/r/20251210015725.8409-2-heming.zhao@suse.com
Fixes: 0fe9b66c65f3 ("ocfs2: Add preserve to reflink.")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ocfs2/xattr.c~ocfs2-fix-reflink-preserve-cleanup-issue
+++ a/fs/ocfs2/xattr.c
@@ -6395,6 +6395,10 @@ static int ocfs2_reflink_xattr_header(ha
 					(void *)last - (void *)xe);
 				memset(last, 0,
 				       sizeof(struct ocfs2_xattr_entry));
+				last = &new_xh->xh_entries[le16_to_cpu(new_xh->xh_count)] - 1;
+			} else {
+				memset(xe, 0, sizeof(struct ocfs2_xattr_entry));
+				last = NULL;
 			}
 
 			/*
_

Patches currently in -mm which might be from heming.zhao@suse.com are

ocfs2-give-ocfs2-the-ability-to-reclaim-suballocator-free-bg.patch
ocfs2-detect-released-suballocator-bg-for-fh_to_.patch
ocfs2-fix-reflink-preserve-cleanup-issue.patch

