Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6781620767E;
	Thu, 17 Apr 2025 22:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744928134; cv=none; b=nTMCg9UK6u6OFjPML5I07mWcyJI6AjT0wJsAqkSSExcq2y2uoniPa/jyivhtvq/GAMv2gdw95T5qygeCAYWtbC6/7A1h5sa/VboqmjwQW87rPMoXiGbdsMruWVA8DNQzobr0xcvvGE+pWlZ2NQw2yIe9XINtZfi5JdLkZgXtkLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744928134; c=relaxed/simple;
	bh=Kaf2+U88pail4rM0YP+rIBT6GTLHXv2fcY5CYYRuYsI=;
	h=Date:To:From:Subject:Message-Id; b=e6MXwFj8uO6nGpRNJnuca4Oiv4N9IRN+0pZPUQW4MjoZ+9trKl9qsmJxDaUr7V5Jm2cxQBwV1uoNICjj+ylTyMUmgVMG6/gHyc839UGN73uYo8rSM8IxJuz7XTvlh3rn/MmRE3McI3AU3Gmgagfgt0wJeJILuGTCgFqzjZcLQhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2GrrBnUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2GrrBnUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AF1C4CEE4;
	Thu, 17 Apr 2025 22:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744928134;
	bh=Kaf2+U88pail4rM0YP+rIBT6GTLHXv2fcY5CYYRuYsI=;
	h=Date:To:From:Subject:From;
	b=2GrrBnUJbLwu7/hv87dCIZxsQVWV91pQ1CasqEaWSGkAVGnksn4Pg55oBFH+RMAzm
	 qbjxkZ+dtaWzZ2DLcQcDs0sU5tpwPNIwalHQ7NcI/fZ0A7UxyNn/Fa+oga7jacdR+5
	 vq8sb69H2RqaWqjbX/4vMhfMOD7+TKzlFlvccrkQ=
Date: Thu, 17 Apr 2025 15:15:33 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-panic-in-failed-foilio-allocation.patch added to mm-hotfixes-unstable branch
Message-Id: <20250417221534.16AF1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix panic in failed foilio allocation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-panic-in-failed-foilio-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-panic-in-failed-foilio-allocation.patch

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
Date: Thu, 10 Apr 2025 14:56:11 -0500

In commit 7e119cff9d0a ("ocfs2: convert w_pages to w_folios") the chunk
page allocations became order 0 folio allocations.  If an allocation
failed, the folio array entry should be NULL so the error path can skip
the entry.  In the port it is -ENOMEM and the error path panics trying to
free this bad value.

Link: https://lkml.kernel.org/r/150746ad-32ae-415e-bf1d-6dfd195fbb65@oracle.com
Fixes: 7e119cff9d0a ("ocfs2: convert w_pages to w_folios")
Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/aops.c~ocfs2-fix-panic-in-failed-foilio-allocation
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

Patches currently in -mm which might be from mark.tinguely@oracle.com are

ocfs2-fix-panic-in-failed-foilio-allocation.patch
v2-ocfs2-fix-panic-in-failed-foilio-allocation.patch

