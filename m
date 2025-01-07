Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160A62594B1
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 03:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736218978; cv=none; b=N+D/mFMUwiR7IOC8LLrAkJyJnmOzW4N8H0AxqAzPwuAibXiEcfPpLVzYsRx/kJO30n72dgxAub3eZzKF3Qq/eUNTyB+KCfAjG5grMfCy7ZQvT4BMacT75CFdLNty0m4rx8Es42QdZf5tfylhJwd0Fs6zc5Y5uREqgeLNyXZk9lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736218978; c=relaxed/simple;
	bh=ICT3AGLh2DIcB87vbSjGOkqtVC2bnuvNpGUfTEhsItE=;
	h=Date:To:From:Subject:Message-Id; b=WdbgGLCQrNEHGnPSO+DQ/ne604wexGsRznYZ/MfP25m22jyBNW+h7uFNt7A4v9ktASOZ5gVvp6hYa1p6iGqOIizpOEPgGZcQPF9bcWaKAUy42AQcpYTV/owQ2e8smlAhF0SGFAxtriuRe7Tf3tcZhsQyDiy+uS5O7MBGQW9Dp3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iiWlHdoC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iiWlHdoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764A3C4CED2;
	Tue,  7 Jan 2025 03:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736218977;
	bh=ICT3AGLh2DIcB87vbSjGOkqtVC2bnuvNpGUfTEhsItE=;
	h=Date:To:From:Subject:From;
	b=iiWlHdoCGwrG6latIXB10hXsOzE5DRnAAwi3EkYIqWfxPaMONnDndvo9gz+BzxGaa
	 cWSyVNjZMj85o0NxPu4atv4Kj9bA1q6PmYrlWOSl5AkA6LZ8JZIgLmhWk2vrUKknzm
	 dygeygGO/HZ1/sM1EhiZynuQHhvKyxSrAZ8ppPF0=
Date: Mon, 06 Jan 2025 19:02:56 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,sunjunchao2870@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-check-el-l_next_free_rec-in-ocfs2_get_clusters_nocache.patch added to mm-nonmm-unstable branch
Message-Id: <20250107030257.764A3C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: check el->l_next_free_rec in ocfs2_get_clusters_nocache
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-check-el-l_next_free_rec-in-ocfs2_get_clusters_nocache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-check-el-l_next_free_rec-in-ocfs2_get_clusters_nocache.patch

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
From: Julian Sun <sunjunchao2870@gmail.com>
Subject: ocfs2: check el->l_next_free_rec in ocfs2_get_clusters_nocache
Date: Mon, 6 Jan 2025 10:34:31 +0800

Recently syzbot reported a use-after-free issue[1].

The root cause of the problem is that the journal inode recorded in this
file system image is corrupted.  The value of
"di->id2.i_list.l_next_free_rec" is 8193, which is greater than the value
of "di->id2.i_list.l_count" (19).

To solve this problem, an additional check should be added within
ocfs2_get_clusters_nocache().  If the check fails, an error will be
returned and the file system will be set to read-only.

[1]: https://lore.kernel.org/all/67577778.050a0220.a30f1.01bc.GAE@google.com/T/

Link: https://lkml.kernel.org/r/20250106023432.1320904-1-sunjunchao2870@gmail.com
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
Reported-by: syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2313dda4dc4885c93578
Tested-by: syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/extent_map.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/ocfs2/extent_map.c~ocfs2-check-el-l_next_free_rec-in-ocfs2_get_clusters_nocache
+++ a/fs/ocfs2/extent_map.c
@@ -435,6 +435,16 @@ static int ocfs2_get_clusters_nocache(st
 		}
 	}
 
+	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
+		ocfs2_error(inode->i_sb,
+			    "Inode %lu has an invalid extent (next_free_rec %u, count %u)\n",
+			    inode->i_ino,
+			    le16_to_cpu(el->l_next_free_rec),
+			    le16_to_cpu(el->l_count));
+		ret = -EROFS;
+		goto out;
+	}
+
 	i = ocfs2_search_extent_list(el, v_cluster);
 	if (i == -1) {
 		/*
_

Patches currently in -mm which might be from sunjunchao2870@gmail.com are

ocfs2-check-el-l_next_free_rec-in-ocfs2_get_clusters_nocache.patch
ocfs2-correct-l_next_free_rec-in-online-check.patch

