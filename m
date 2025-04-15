Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0786849C
	for <mm-commits@vger.kernel.org>; Tue, 15 Apr 2025 00:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744675674; cv=none; b=e168ns0SZNBn+HspKbE1JTMPfby4oU8GhvQtws0Kinc6VJTPEqJsrud0DGZ2tRfvTPE1eTVOdFjhKNV+ikAGBNW8G3X9zIpKitk1lx4yMrktWgcVglkGW9MmR9Zmm8vpybqNKrn6anaDuiLuHk6axXNunw0s+0JI7ogKiN9RMXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744675674; c=relaxed/simple;
	bh=l7bI6JMTs9PjKF52TK30o8cGwPtujR5t4LxvNya8RBo=;
	h=Date:To:From:Subject:Message-Id; b=M/qu2XvYvg0PvMYqk5ADfJTvIVnGGpMuewz6jD5PTQI5nKk7OKqwYuxJ5Wz2saCjz8JDJsl+mbauuTRpS7jtFNjwy+G+jvD9aT2/Ap0a5sgXJ1lCMM559JhJ6i8GHWms0y57af1A0pJ4a0olhbu+l3JaK4ZhJy076DISiP+ueEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o77h8rBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o77h8rBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E8BC4CEEA;
	Tue, 15 Apr 2025 00:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744675674;
	bh=l7bI6JMTs9PjKF52TK30o8cGwPtujR5t4LxvNya8RBo=;
	h=Date:To:From:Subject:From;
	b=o77h8rBqaSU/ZF7Asbkx7eQ/m2zO96ejHbQxcOvMscQMWdtJohiQyNlPyv0Jifnen
	 0wp+3MOcR6J/XQTX2KkchCdwayPzvepc1RB93mWAvxZUFzAfU1Vx79jZpdMEMg9X0w
	 PFY1DJq39D4F1X0wSEwltL9hkb8fHmyw6tPKOurk=
Date: Mon, 14 Apr 2025 17:07:53 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-simplify-return-statement-in-ocfs2_filecheck_attr_store.patch added to mm-nonmm-unstable branch
Message-Id: <20250415000754.41E8BC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: simplify return statement in ocfs2_filecheck_attr_store()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-simplify-return-statement-in-ocfs2_filecheck_attr_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-simplify-return-statement-in-ocfs2_filecheck_attr_store.patch

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: ocfs2: simplify return statement in ocfs2_filecheck_attr_store()
Date: Tue,  8 Apr 2025 12:34:07 +0200

Don't negate 'ret' and simplify the return statement.

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/filecheck.c~ocfs2-simplify-return-statement-in-ocfs2_filecheck_attr_store
+++ a/fs/ocfs2/filecheck.c
@@ -505,5 +505,5 @@ static ssize_t ocfs2_filecheck_attr_stor
 		ocfs2_filecheck_handle_entry(ent, entry);
 
 exit:
-	return (!ret ? count : ret);
+	return ret ?: count;
 }
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

ocfs2-simplify-return-statement-in-ocfs2_filecheck_attr_store.patch

