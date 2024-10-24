Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E87E1662E8;
	Thu, 24 Oct 2024 06:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750532; cv=none; b=NTF6OF69bNNA9udSQFh7gEm7JN9AcNPV28ukN0GW4BLKa87LKAdaKKz9BDXkMHynnH8KFCj4lagxwENwaLGjG92/XDAPTmPIl+hAm6/XPn3mNQujFlOm5LHu+zXFcrJda5WQ0q6bXAOk7PxMV30kLy1GhGfCedsQv6KIU5lGnb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750532; c=relaxed/simple;
	bh=85qb1s7rPNgvrXY8dUqssgTKdtzmo9eFsV9iDEfuZfw=;
	h=Date:To:From:Subject:Message-Id; b=QnwzIWMryccA5iZ2Am1tiCDk9C8VZyr7JCb/aLPQo9HDpTw7Do+hTuXxl2mn7ViCZxa/4v6rJtB5twGG4r4DvCRV1jY+GumyBtAa6n+ZzZ9q6MS2Cve6l5qMQzeV4noeeiQ01RL8iGD4HIE28IpsIbhn1lURlePQFEJFUlScC5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ReMdW/6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ReMdW/6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A5DC4CEC7;
	Thu, 24 Oct 2024 06:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750531;
	bh=85qb1s7rPNgvrXY8dUqssgTKdtzmo9eFsV9iDEfuZfw=;
	h=Date:To:From:Subject:From;
	b=ReMdW/6ZSN9IhD4iB2Bi7wwRyoAiieIRZun8iboQTuE9XT7H6Vh+RC6JLhCdJ3sJN
	 7tdfgxduFkX/09fYms0BZDO37ZHuMg7gErg4F8af9fJiq1sI3jbiqnnpVpXyEq5IAJ
	 UWlzo9e4IOy34E8mbfrC0WSTsFYpkHSD5d7DVXVI=
Date: Wed, 23 Oct 2024 23:15:31 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-kernel-bug-due-to-missing-clearing-of-checked-flag.patch removed from -mm tree
Message-Id: <20241024061531.A8A5DC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix kernel bug due to missing clearing of checked flag
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-kernel-bug-due-to-missing-clearing-of-checked-flag.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix kernel bug due to missing clearing of checked flag
Date: Fri, 18 Oct 2024 04:33:10 +0900

Syzbot reported that in directory operations after nilfs2 detects
filesystem corruption and degrades to read-only,
__block_write_begin_int(), which is called to prepare block writes, may
fail the BUG_ON check for accesses exceeding the folio/page size,
triggering a kernel bug.

This was found to be because the "checked" flag of a page/folio was not
cleared when it was discarded by nilfs2's own routine, which causes the
sanity check of directory entries to be skipped when the directory
page/folio is reloaded.  So, fix that.

This was necessary when the use of nilfs2's own page discard routine was
applied to more than just metadata files.

Link: https://lkml.kernel.org/r/20241017193359.5051-1-konishi.ryusuke@gmail.com
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d6ca2daf692c7a82f959
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/page.c~nilfs2-fix-kernel-bug-due-to-missing-clearing-of-checked-flag
+++ a/fs/nilfs2/page.c
@@ -400,6 +400,7 @@ void nilfs_clear_folio_dirty(struct foli
 
 	folio_clear_uptodate(folio);
 	folio_clear_mappedtodisk(folio);
+	folio_clear_checked(folio);
 
 	head = folio_buffers(folio);
 	if (head) {
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-potential-deadlock-with-newly-created-symlinks.patch

