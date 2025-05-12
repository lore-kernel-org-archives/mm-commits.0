Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AD81A725A
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011376; cv=none; b=VQoRUkk6iXq+d1jjzZen9sxqr9FLXVSmgXaeQ8HGYDxg62vlMnZa8sEbM8wKlBbcdu1L34YA8mVttLA4znuwEmRqc0qoRc/I7Iu26jb6Mpg8SRqwpMjzRG1Jb70o+9aRqJLGaMqRmT34JpY5OlLYU6Z83j9OrlI4Yc5YW1dph9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011376; c=relaxed/simple;
	bh=vv35Ll8mDe7QARSnAcjOjLi/QTDgAvvnAZwWCNepP6k=;
	h=Date:To:From:Subject:Message-Id; b=g0V7Q8EX6tySlhZu82GG+uR4f+d7HyHoRy7WnoCcyIfTP6cPlBbrJpshvPQFQ7kRaIYWQShIJWGf/DmQzJu6M4UBt9yeHnwK8wrpZsT1yolgRQ8X6pq5PaEjVd57hdQRoxRTl7JhcS/ss6JkfRUT8/paAsl5926sm10O5re6LmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oCRwM3uA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oCRwM3uA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876EEC4CEE4;
	Mon, 12 May 2025 00:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011376;
	bh=vv35Ll8mDe7QARSnAcjOjLi/QTDgAvvnAZwWCNepP6k=;
	h=Date:To:From:Subject:From;
	b=oCRwM3uAwoSvCgPtIUqucAtQwizY9gvAls9N8WydK514eGeyxk/9bYvzY8YgDbI/G
	 d2Xglyy9teNF+Rcm8Ikja+iYPNznCwsJAEKHUKzr8Xk7cXNWQJyjDs3LtYgpB4jbv0
	 6LCWr8ERfoJ/re2ZfglwlNWqSo1X7Q8g/JxxcwVs=
Date: Sun, 11 May 2025 17:56:16 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jack@suse.cz,gechangwei@live.cn,m.masimov@mt-integration.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-possible-memory-leak-in-ocfs2_finish_quota_recovery.patch removed from -mm tree
Message-Id: <20250512005616.876EEC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix possible memory leak in ocfs2_finish_quota_recovery
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-possible-memory-leak-in-ocfs2_finish_quota_recovery.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Murad Masimov <m.masimov@mt-integration.ru>
Subject: ocfs2: fix possible memory leak in ocfs2_finish_quota_recovery
Date: Wed, 2 Apr 2025 09:56:27 +0300

If ocfs2_finish_quota_recovery() exits due to an error before passing all
rc_list elements to ocfs2_recover_local_quota_file() then it can lead to a
memory leak as rc_list may still contain elements that have to be freed.

Release all memory allocated by ocfs2_add_recovery_chunk() using
ocfs2_free_quota_recovery() instead of kfree().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Link: https://lkml.kernel.org/r/20250402065628.706359-2-m.masimov@mt-integration.ru
Fixes: 2205363dce74 ("ocfs2: Implement quota recovery")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_local.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/quota_local.c~ocfs2-fix-possible-memory-leak-in-ocfs2_finish_quota_recovery
+++ a/fs/ocfs2/quota_local.c
@@ -674,7 +674,7 @@ out_put:
 			break;
 	}
 out:
-	kfree(rec);
+	ocfs2_free_quota_recovery(rec);
 	return status;
 }
 
_

Patches currently in -mm which might be from m.masimov@mt-integration.ru are


