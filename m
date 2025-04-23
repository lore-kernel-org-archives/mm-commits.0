Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190AC1F153A;
	Wed, 23 Apr 2025 00:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745369635; cv=none; b=dbq8jwrpKdjwzWftwopJBtxoY3eVSpYi+ur+mkmPVIqeU0MTR2xV3BeEki2Qz6p7rhfAoYpypb+1VAg3CJWkyf5NzapEh8KCf9VgwQoBMP0vY9Pq0mBwmu2PcKEZmqkuzteCwxW9IZ7amePJhfTnm9AApJtGcY7u/SjHNZi7jJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745369635; c=relaxed/simple;
	bh=h89QorGM6hDJXrR3R1bsEMWXdIGIlO4FBik7S/lJZcY=;
	h=Date:To:From:Subject:Message-Id; b=EtUwaF2kkET4cNpzlJbf2ACP3mYS5YoaWrc+H/7FezoGVEEtFsHPXZrYc2X2MHxRAbcHbgnONyzkACmxRqWIFbVtEr+VE38xEh68Rd3guoi+GKxcwF92DjNknL7U90MrvTi1Si+5rkepeDa3wbCQmV/+NcG3Kyk6u22nWgAxV7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=baiRJ6Uu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="baiRJ6Uu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34665C4CEE9;
	Wed, 23 Apr 2025 00:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745369634;
	bh=h89QorGM6hDJXrR3R1bsEMWXdIGIlO4FBik7S/lJZcY=;
	h=Date:To:From:Subject:From;
	b=baiRJ6UuKOk++GvL65UfJKuBT3QWNBwhbFCzch83mTJzIUorp2iONaxx2BloFyAF9
	 MMCaZfP/CInVPrVkSkYp1S0vN1fF+seXH8ptzHZLdv5zLDf3Ilyan1RUwvgbzqNf3M
	 ugrJtDw9lAHcD+vGLjBHlbhxsMLgZjfSKoDlM2nE=
Date: Tue, 22 Apr 2025 17:53:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,nathan@kernel.org,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + v2-ocfs2-fix-panic-in-failed-foilio-allocation.patch added to mm-hotfixes-unstable branch
Message-Id: <20250423005354.34665C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix panic in failed foilio allocation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     v2-ocfs2-fix-panic-in-failed-foilio-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/v2-ocfs2-fix-panic-in-failed-foilio-allocation.patch

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
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: ocfs2: fix panic in failed foilio allocation
Date: Fri, 11 Apr 2025 11:31:24 -0500

commit 7e119cff9d0a ("ocfs2: convert w_pages to w_folios") and commit
9a5e08652dc4b ("ocfs2: use an array of folios instead of an array of
pages") save -ENOMEM in the folio array upon allocation failure and call
the folio array free code.

The folio array free code expects either valid folio pointers or NULL. 
Finding the -ENOMEM will result in a panic.  Fix by NULLing the error
folio entry.

Link: https://lkml.kernel.org/r/c879a52b-835c-4fa0-902b-8b2e9196dcbd@oracle.com
Fixes: 7e119cff9d0a ("ocfs2: convert w_pages to w_folios")
Fixes: 9a5e08652dc4b ("ocfs2: use an array of folios instead of an array of pages")
Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/alloc.c~v2-ocfs2-fix-panic-in-failed-foilio-allocation
+++ a/fs/ocfs2/alloc.c
@@ -6918,6 +6918,7 @@ static int ocfs2_grab_folios(struct inod
 		if (IS_ERR(folios[numfolios])) {
 			ret = PTR_ERR(folios[numfolios]);
 			mlog_errno(ret);
+			folios[numfolios] = NULL;
 			goto out;
 		}
 
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are

v2-ocfs2-fix-panic-in-failed-foilio-allocation.patch

