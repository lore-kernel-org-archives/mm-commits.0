Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1063EBF1D;
	Sun,  1 Feb 2026 00:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905020; cv=none; b=KhJnQHdSjr1g2R7N/FsvNIQdTHBD1dWjxsYu72xOR1KBBVNuB0u4Dop5Sw0dGoWc/e12Gn3Jnlq79WTctyZJ8qTllI+zJJ/oukKYxQ3jm2cw72IDW3q9rRu9a1YtGNcpZIHdYmjFk62A5xwxF2cPfFTD9JW1T1Xfn5ZQJ4/5CPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905020; c=relaxed/simple;
	bh=3j/CgG7yX+aDv5FeHL+HHhNbaPpI4aoBqklLvglNgDU=;
	h=Date:To:From:Subject:Message-Id; b=bUSdcvadoXeaqZs75UlPtUadliwNUYWJsIIMD5iX0A+Ch7ufGeRVMstbEYOh7T01xo6++XJ+LLlTDUcZsfv0ZHC7HTl9UaWeb0VG6rmtZpuasaw8mSMFJZt9pH7w1HHjXOeQKrIV9mWn8bzaLBwSGJtxSf/UT/YiCQYLnj+YPAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ALFtWV7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ALFtWV7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0EAC4CEF1;
	Sun,  1 Feb 2026 00:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905019;
	bh=3j/CgG7yX+aDv5FeHL+HHhNbaPpI4aoBqklLvglNgDU=;
	h=Date:To:From:Subject:From;
	b=ALFtWV7BTId3C3oW4hLqSc3mdxg0ksgvhd+HhNj9JEHMa6bUWlEEuihiCHavFqVCI
	 BHDrGR1h59ltfQP2qFFzK7e+fXBChANiEyuagvyzkPaEp30CDH8I6FF1POIK8+BQCF
	 g6VZPHILfTb2XpdZA6SZyePjGRaJZEaRa7ZiRXzM=
Date: Sat, 31 Jan 2026 16:16:59 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,gechangwei@live.cn,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-reflink-preserve-cleanup-issue.patch removed from -mm tree
Message-Id: <20260201001659.CD0EAC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix reflink preserve cleanup issue
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-reflink-preserve-cleanup-issue.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: <stable@vger.kernel.org>
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


