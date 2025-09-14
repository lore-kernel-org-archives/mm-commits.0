Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CCE33987
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810127; cv=none; b=LmROs8pGefc7ILGNTZJet+OnVzV/LzB3p1OBivBPzgKoPiAsia2N5j1YuDX0YxYwgAfxISLFXebhZXt3jyHSgjJILLPtcCB77q09IS/CZ51TKhYraki2UWO69BjzJ3LLRrPySkb8/R/4/11f9GHdTM6Gkr8epqyLHEtuqxvcdZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810127; c=relaxed/simple;
	bh=zPgXzkenFz9YeYCq2TAasg1C/Dzml+aERPWqWuJ/fVE=;
	h=Date:To:From:Subject:Message-Id; b=id9WttpFd5bA44qBMUEs6DrbtMli4xgJXZvrfLLOTWFh9jbYMFVOhcAR0vGugnc/zNxAFNLLylWFxAxXKDnGwwffceFx0aKdhKQtnK8JSAL5QwUAp75XITDhYEpkpFC4jRecJ6rzQbsZXHtSmwHeKUYQVc62FFiNbbykHNAs6BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZQwF3MXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZQwF3MXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79B0C4CEEB;
	Sun, 14 Sep 2025 00:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810126;
	bh=zPgXzkenFz9YeYCq2TAasg1C/Dzml+aERPWqWuJ/fVE=;
	h=Date:To:From:Subject:From;
	b=ZQwF3MXCG1jFSvwNdJ8GsM99haEAZSLCu9334AWYaeYKaE4s4Oh5SG6EuhS4OTQF3
	 pb3LxuYEDDXUCfdKOO8PMkdyn7KK0AE4uvoQH8Xmb7jG8ZIyImJXnMueQojE7jATXu
	 +O8iOP9UhGzvF7GdqP4UuOClor0OeCZy9V/S9+eQ=
Date: Sat, 13 Sep 2025 17:35:26 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-remove-unnecessary-null-check-in-ocfs2_grab_folios.patch removed from -mm tree
Message-Id: <20250914003526.B79B0C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: remove unnecessary NULL check in ocfs2_grab_folios()
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-unnecessary-null-check-in-ocfs2_grab_folios.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: ocfs2: remove unnecessary NULL check in ocfs2_grab_folios()
Date: Tue, 19 Aug 2025 12:41:51 +0300

Smatch complains that checking "folios" for NULL doesn't make sense
because it has already been dereferenced at this point.  Really passing a
NULL "folios" pointer to ocfs2_grab_folios() doesn't make sense, and
fortunately none of the callers do that.  Delete the unnecessary NULL
check.

Link: https://lkml.kernel.org/r/aKRG39hyvDJcN2G7@stanley.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-remove-unnecessary-null-check-in-ocfs2_grab_folios
+++ a/fs/ocfs2/alloc.c
@@ -6928,8 +6928,7 @@ static int ocfs2_grab_folios(struct inod
 
 out:
 	if (ret != 0) {
-		if (folios)
-			ocfs2_unlock_and_free_folios(folios, numfolios);
+		ocfs2_unlock_and_free_folios(folios, numfolios);
 		numfolios = 0;
 	}
 
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are


