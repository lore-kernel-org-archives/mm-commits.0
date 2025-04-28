Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F193342AA6
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 19:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745868639; cv=none; b=A+7bCiS5dL4ysTsJ2wHvL+tvvsZqgtF8dnuiC/NL9Aha8U1RpiBzGW9QpVUf9N3O3qXZK4VJTs7OGH0Ln9rnOjBjXTy72bzX8ZKe/WxJX4aX5FV0PmXypp/WD/Q1Bjah0wq47IKM52JMZhNhZ9RsjWkn0pbPPPXtWNZWzFCJuD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745868639; c=relaxed/simple;
	bh=/F7y8RmArJDmUg0TQvm5XKkOtUB5FzO/nYGyrNWhJy0=;
	h=Date:To:From:Subject:Message-Id; b=aqxKH214OhvyCRAMXFVAglGlo4vsc5W04vo8tA/Xcr4l+GBRJ5+OZwnZK9lB60rGE2bZWj016uIxW0Dd78+/DKbR32lEjS72Mw/CG1V0VZDDZ0s6afXuE3X8/7J9WFoRgbWvoqzZJUE1FaaO1puAo3DGYzhWTM+KYletEUloeuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RRrCBCDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RRrCBCDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDA7C4CEE4;
	Mon, 28 Apr 2025 19:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745868638;
	bh=/F7y8RmArJDmUg0TQvm5XKkOtUB5FzO/nYGyrNWhJy0=;
	h=Date:To:From:Subject:From;
	b=RRrCBCDYvny3h6OvsXEiu9LsZeki8AV3cEASjmKus+oJ5aEsFG0OEtfNdBwGWxkI1
	 l1Hlofu6KUftr78pjBzCZoJFoxDFinRz82i9IGovHRwNZgX4SfcWtU1+wO2gt4icFz
	 lIqg0bViV4X+tBXhnwrCkWH1tNJDjxbUK7MdbtPY=
Date: Mon, 28 Apr 2025 12:30:37 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,vulab@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-add-pointer-check-for-nilfs_direct_propagate.patch added to mm-nonmm-unstable branch
Message-Id: <20250428193038.5BDA7C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: add pointer check for nilfs_direct_propagate()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-add-pointer-check-for-nilfs_direct_propagate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-add-pointer-check-for-nilfs_direct_propagate.patch

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
From: Wentao Liang <vulab@iscas.ac.cn>
Subject: nilfs2: add pointer check for nilfs_direct_propagate()
Date: Tue, 29 Apr 2025 02:37:07 +0900

Patch series "nilfs2: improve sanity checks in dirty state propagation".

This fixes one missed check for block mapping anomalies and one improper
return of an error code during a preparation step for log writing, thereby
improving checking for filesystem corruption on writeback.


This patch (of 2):

In nilfs_direct_propagate(), the printer get from nilfs_direct_get_ptr()
need to be checked to ensure it is not an invalid pointer.

If the pointer value obtained by nilfs_direct_get_ptr() is
NILFS_BMAP_INVALID_PTR, means that the metadata (in this case, i_bmap in
the nilfs_inode_info struct) that should point to the data block at the
buffer head of the argument is corrupted and the data block is orphaned,
meaning that the file system has lost consistency.

Add a value check and return -EINVAL when it is an invalid pointer.

Link: https://lkml.kernel.org/r/20250428173808.6452-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20250428173808.6452-2-konishi.ryusuke@gmail.com
Fixes: 36a580eb489f ("nilfs2: direct block mapping")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/direct.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nilfs2/direct.c~nilfs2-add-pointer-check-for-nilfs_direct_propagate
+++ a/fs/nilfs2/direct.c
@@ -273,6 +273,9 @@ static int nilfs_direct_propagate(struct
 	dat = nilfs_bmap_get_dat(bmap);
 	key = nilfs_bmap_data_get_key(bmap, bh);
 	ptr = nilfs_direct_get_ptr(bmap, key);
+	if (ptr == NILFS_BMAP_INVALID_PTR)
+		return -EINVAL;
+
 	if (!buffer_nilfs_volatile(bh)) {
 		oldreq.pr_entry_nr = ptr;
 		newreq.pr_entry_nr = ptr;
_

Patches currently in -mm which might be from vulab@iscas.ac.cn are

nilfs2-add-pointer-check-for-nilfs_direct_propagate.patch

