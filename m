Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EF25228
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 02:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743646730; cv=none; b=UzpZ+fOHsdn1olpl70QPdr1XivKy6EWH+Nz+nkIJ653RWCI12rEIo6dnAKv5d38fWHV+sCpNhBH6tnZZqoV6hdtFurdIkPBJZO+BjcbKhPZ6UZLWk4H1IGRX/zc1/3QZUFzxbUzAMI3lqb2NckfUPbGU/Z/StfJ+OUzBIawhG2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743646730; c=relaxed/simple;
	bh=UHV0BS5RGEvdAl8C0yddoIDVNDhj4Hce2LK1RmfRT6k=;
	h=Date:To:From:Subject:Message-Id; b=R3aMXST6/oKnsKxUKP08n8iwQ1RZ4am5n8PPLckl8RxAEPCMOiVToe7AwGKq8UmSzQ3p8Zan2XZMgqBCQrczZokHyv2b7C3M5ZM5OvLGWmIL/AZN1dgbRqsyuf4IYlelcPFNju9ySIJOp+qgwxmpViAJDuVr89LLBAR6XUAyEJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m13MO1gT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m13MO1gT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B5DC4CEDD;
	Thu,  3 Apr 2025 02:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743646729;
	bh=UHV0BS5RGEvdAl8C0yddoIDVNDhj4Hce2LK1RmfRT6k=;
	h=Date:To:From:Subject:From;
	b=m13MO1gTSKOLQEXbQVUvPf7uqVqL8pIklWILBP3WaYWVY6+AMpBivy1uC3/85ZyE0
	 X1qvD1PG+kGCNNG2ZsGWC8zS4j7r3DadIiLV+GZ1X6mg5vURHIDF6Emyn9nKIA83s0
	 mcOkRecukOZgxkdU3CCYvTGJI2uvaW0BLCmo8nfg=
Date: Wed, 02 Apr 2025 19:18:48 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jack@suse.cz,gechangwei@live.cn,m.masimov@mt-integration.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-possible-memory-leak-in-ocfs2_finish_quota_recovery.patch added to mm-nonmm-unstable branch
Message-Id: <20250403021849.86B5DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix possible memory leak in ocfs2_finish_quota_recovery
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-possible-memory-leak-in-ocfs2_finish_quota_recovery.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-possible-memory-leak-in-ocfs2_finish_quota_recovery.patch

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
@@ -678,7 +678,7 @@ out_put:
 	}
 out:
 	up_read(&sb->s_umount);
-	kfree(rec);
+	ocfs2_free_quota_recovery(rec);
 	return status;
 }
 
_

Patches currently in -mm which might be from m.masimov@mt-integration.ru are

ocfs2-fix-possible-memory-leak-in-ocfs2_finish_quota_recovery.patch

