Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECD31E51E2
	for <mm-commits@vger.kernel.org>; Mon, 14 Apr 2025 21:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744667517; cv=none; b=XQxsd6KTtqPicU1KSSqAQrc6BCm92ALwBBDBAtCmB6dsDQrR5AvUXirh6U1hX6UOjh0tFaCRkbWJ3FML6j/578GNQ2ZE+wP9B8BZkILnQcQYz0ynD2yDwCGiW81L6Ket8Iws68btMgxc846C3NU+LuD7PWL0d+zpss7MOY+RHxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744667517; c=relaxed/simple;
	bh=TJpt74iv5DTI2CTsupmCzUIGjS2TsdmW092nVnlGkB8=;
	h=Date:To:From:Subject:Message-Id; b=HJfYLE5yYH+7OZlDE9fHSXwWFU4do+zaObjHJmXPIIdXhUhkGMkvo2A3GQ70tE1sBR3nf1G9in5ZiJWJNgMc2yOpFK3MsgeQ56vy2eOKWuIYMO6jEyqp7Qy9wJJJ5D22LP6/S7+INlqYk75b4FJVfTpKHKn3VfiRkQmab8r0EeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OluUtokV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OluUtokV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AE2C4CEE2;
	Mon, 14 Apr 2025 21:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744667517;
	bh=TJpt74iv5DTI2CTsupmCzUIGjS2TsdmW092nVnlGkB8=;
	h=Date:To:From:Subject:From;
	b=OluUtokVsczE7BHa8YgGlYJgbXCAkdnq3BoczGa5sV9EvL3HhPXJNWMIxT05dAqrw
	 6sQAmSldEExYXcoJrq5MXCrlMg5v0bQBvm1c1qplwofPDivO5zKM+v6Cqn8WSErICH
	 ExAbbgA1NsSnOdsxRQTt+GQOHtkKZRlmL85cEl20=
Date: Mon, 14 Apr 2025 14:51:56 -0700
To: mm-commits@vger.kernel.org,agruenba@redhat.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-fix-false-warning-in-inode_to_wb.patch added to mm-new branch
Message-Id: <20250414215157.06AE2C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Date: Sat, 12 Apr 2025 18:39:12 +0200
has been added to the -mm mm-new branch.  Its filename is
     writeback-fix-false-warning-in-inode_to_wb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-fix-false-warning-in-inode_to_wb.patch

This patch will later appear in the mm-new branch at
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

Subject: writeback: Fix false warning in inode_to_wb()
Date: Sat, 12 Apr 2025 18:39:12 +0200

inode_to_wb() is used also for filesystems that don't support cgroup
writeback.  For these filesystems inode->i_wb is stable during the
lifetime of the inode (it points to bdi->wb) and there's no need to hold
locks protecting the inode->i_wb dereference.  Improve the warning in
inode_to_wb() to not trigger for these filesystems.

Link: https://lkml.kernel.org/r/20250412163914.3773459-3-agruenba@redhat.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/backing-dev.h~writeback-fix-false-warning-in-inode_to_wb
+++ a/include/linux/backing-dev.h
@@ -249,6 +249,7 @@ static inline struct bdi_writeback *inod
 {
 #ifdef CONFIG_LOCKDEP
 	WARN_ON_ONCE(debug_locks &&
+		     (inode->i_sb->s_iflags & SB_I_CGROUPWB) &&
 		     (!lockdep_is_held(&inode->i_lock) &&
 		      !lockdep_is_held(&inode->i_mapping->i_pages.xa_lock) &&
 		      !lockdep_is_held(&inode->i_wb->list_lock)));
_

Patches currently in -mm which might be from jack@suse.cz are


