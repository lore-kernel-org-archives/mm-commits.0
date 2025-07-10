Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F11A17741;
	Thu, 10 Jul 2025 05:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127166; cv=none; b=StJud9vt3YaOoe3ehi8VxQaNvcVrNnU7m0Or0IuNC5GWFaXAZGLmVMfzZ5OIDqI95qZ0eeoigGr6aqha6mTwoILbUQMeoXy/TvNkv0S9WqUuu34M85fV6GHKqV5m7dDiIjzL6cjDubBmtcnJiaxig/bF7lXLw/EJpnWG0MgvdvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127166; c=relaxed/simple;
	bh=lp9W+29Y+8aqABDM0lNtek8KHfq9WJez5ZwRtWbhbCk=;
	h=Date:To:From:Subject:Message-Id; b=r67H08BZjw5IQ76CaxGVB2UltSRFgUPetpXz/X1QuBrYzQ4NYCN/7QIQ/4ZhtM/AiJr8WMDLXo6+ylHbeCc6kM/Ta1iv8X7ycKeh1flmsiEfGhIC9AH27vOMpM/7EsWuPHcltZYBX5ZvQGz+57nxFlc2tFhl9y3M2cGOqdJWi3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rq5VOF5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rq5VOF5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DF4C4CEE3;
	Thu, 10 Jul 2025 05:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127166;
	bh=lp9W+29Y+8aqABDM0lNtek8KHfq9WJez5ZwRtWbhbCk=;
	h=Date:To:From:Subject:From;
	b=rq5VOF5ldCG5yqVBawquPwWQ+nc66ZqcKsSxacRL7v7wIvv2NWegwTcWO0AA/KIEo
	 zK9FQwfD81JU0OAoJMPPBLGbLPCt8nkc3HUEFjVjymIRzI8X8JY8vkx4Ba/BK0ZyU7
	 utyvaTRah/FH8cDnLczv2UjBEtQspllCNkV2ECWQ=
Date: Wed, 09 Jul 2025 22:59:25 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,lizhi.xu@windriver.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-reset-folio-to-null-when-get-folio-fails.patch removed from -mm tree
Message-Id: <20250710055926.53DF4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: reset folio to NULL when get folio fails
has been removed from the -mm tree.  Its filename was
     ocfs2-reset-folio-to-null-when-get-folio-fails.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lizhi Xu <lizhi.xu@windriver.com>
Subject: ocfs2: reset folio to NULL when get folio fails
Date: Mon, 16 Jun 2025 09:31:40 +0800

The reproducer uses FAULT_INJECTION to make memory allocation fail, which
causes __filemap_get_folio() to fail, when initializing w_folios[i] in
ocfs2_grab_folios_for_write(), it only returns an error code and the value
of w_folios[i] is the error code, which causes
ocfs2_unlock_and_free_folios() to recycle the invalid w_folios[i] when
releasing folios.

Link: https://lkml.kernel.org/r/20250616013140.3602219-1-lizhi.xu@windriver.com
Reported-by: syzbot+c2ea94ae47cd7e3881ec@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c2ea94ae47cd7e3881ec
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/aops.c~ocfs2-reset-folio-to-null-when-get-folio-fails
+++ a/fs/ocfs2/aops.c
@@ -1071,6 +1071,7 @@ static int ocfs2_grab_folios_for_write(s
 			if (IS_ERR(wc->w_folios[i])) {
 				ret = PTR_ERR(wc->w_folios[i]);
 				mlog_errno(ret);
+				wc->w_folios[i] = NULL;
 				goto out;
 			}
 		}
_

Patches currently in -mm which might be from lizhi.xu@windriver.com are


