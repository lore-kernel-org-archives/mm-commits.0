Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87E9155733
	for <mm-commits@vger.kernel.org>; Tue, 24 Sep 2024 22:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727215728; cv=none; b=ToAm5TngIG0wM28VKyj1Ghlbvs11XTb4nyT+tmH3LzzPQGFoWz2NnyZI9K6+z13Wthq80uthgDomThUPO1QF5YHFLfNBfoKkUxRtvZymQ7HayrDiOe/Opw4cZBRBk5dxo2o5xmCQ+7i7xsuzw5EehlDGGDVdT4iuiucx86zOo1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727215728; c=relaxed/simple;
	bh=7krdNyWD8gOoadxXKHD3eng325gJTlBs25FsU5HlnYs=;
	h=Date:To:From:Subject:Message-Id; b=FUyKYiXLkFRf3pb3BKkRWu2lpxhmBBm4r8L6c6anu3yrdvTsgwDaH0J6veshZVLURPwUCYmXGyDAgNDpY0GhT4W2ApJ0AGRaMK2al2jTEoF4v8Np8VJz6LgU8WhmrYtujw8zClN52PIlTCqJ9mC9IRzmpgScplVLrGKPNRBbgMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ojQHtMxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ojQHtMxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B8BC4CEC6;
	Tue, 24 Sep 2024 22:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727215727;
	bh=7krdNyWD8gOoadxXKHD3eng325gJTlBs25FsU5HlnYs=;
	h=Date:To:From:Subject:From;
	b=ojQHtMxs9NNuQ2BmYb4ZMKh7nwzjKCl32TMY6cpmZ3cUC5owatpNzyk90v0FbMAaX
	 rOJSW2FuItEqCcYTif5tXC2P0TbWzQdKI/pcT4r1PFbcH01me8m9XoRV+vEtLxph9H
	 UoqxCB6rcpVpuI9lDh8q+gLGQ4QCjbMlMXIYB/f4=
Date: Tue, 24 Sep 2024 15:08:46 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,ghe@suse.com,gechangwei@live.cn,pvmohammedanees2003@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-typo-in-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20240924220847.67B8BC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: Fix typo in comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-typo-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-typo-in-comment.patch

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
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
Subject: ocfs2: Fix typo in comment
Date: Tue, 17 Sep 2024 18:51:56 +0000

Fix "Allcate" -> "Allocate"

Link: https://lkml.kernel.org/r/20240917185156.10580-1-pvmohammedanees2003@gmail.com
Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/alloc.c~ocfs2-fix-typo-in-comment
+++ a/fs/ocfs2/alloc.c
@@ -4767,7 +4767,7 @@ bail:
 }
 
 /*
- * Allcate and add clusters into the extent b-tree.
+ * Allocate and add clusters into the extent b-tree.
  * The new clusters(clusters_to_add) will be inserted at logical_offset.
  * The extent b-tree's root is specified by et, and
  * it is not limited to the file storage. Any extent tree can use this
_

Patches currently in -mm which might be from pvmohammedanees2003@gmail.com are

ocfs2-fix-typo-in-comment.patch

