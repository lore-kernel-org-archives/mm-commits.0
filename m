Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA6F1B0F0D;
	Tue, 15 Oct 2024 22:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729032993; cv=none; b=EFeXWTWTPvVdgO/7IhY/9TY98Ha0B30UWk6mspOiKXF1Ztb+hSxwGDh3lUZ9TTKUo7LKpHMIoTX0sW2mdXXUDdGca5mdWJM+2ofIBfKVc8OCi21LEwO0Lqcjnl8BuXVKCUdBzA7ANCMkd5aNdflgTWu8XaBOOkpFjfS+ST1lBxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729032993; c=relaxed/simple;
	bh=Tbm2lt1As9uf2UJmjSpP0CI8Xo0A9EX+7llaG9AopAI=;
	h=Date:To:From:Subject:Message-Id; b=iVbLTPRPZhlFfb1bwAVUCRe/aBSfRswsJC/xDXH5K4UGqiRkqHJtKt2qtY9l1WRggLhX5zbbWQb6/LwnAxUadMaoJ8D64bUPH0b9iBTrRKfYdYGB0ja2Y92jdbPZ4L0n6vL9/Dwqtw2rNrpZewgg+iNLExLCs+JZ7VNwJQhViPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JFIzTOpi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JFIzTOpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2F2C4CEC6;
	Tue, 15 Oct 2024 22:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729032992;
	bh=Tbm2lt1As9uf2UJmjSpP0CI8Xo0A9EX+7llaG9AopAI=;
	h=Date:To:From:Subject:From;
	b=JFIzTOpiJ2bR7aduDg/UcWX80W12i/tr2QoWqEHJTcAoZgmJC/31qv0h3GvQeqdU7
	 +G28V0lDbLZ9W/Yf0l53RuR3Wa6MPFAJA6NLJHTIFi9f1LuzUVSTHK4QBmXmGsbvcJ
	 j0aomKjdpcyo4qVes7Eo2cc6gt4KygrHCsXLsBLU=
Date: Tue, 15 Oct 2024 15:56:31 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-kernel-bug-due-to-missing-clearing-of-buffer-delay-flag.patch added to mm-hotfixes-unstable branch
Message-Id: <20241015225632.6D2F2C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix kernel bug due to missing clearing of buffer delay flag
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-kernel-bug-due-to-missing-clearing-of-buffer-delay-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-kernel-bug-due-to-missing-clearing-of-buffer-delay-flag.patch

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix kernel bug due to missing clearing of buffer delay flag
Date: Wed, 16 Oct 2024 06:32:07 +0900

Syzbot reported that after nilfs2 reads a corrupted file system image and
degrades to read-only, the BUG_ON check for the buffer delay flag in
submit_bh_wbc() may fail, causing a kernel bug.

This is because the buffer delay flag is not cleared when clearing the
buffer state flags to discard a page/folio or a buffer head.  So, fix
this.

This became necessary when the use of nilfs2's own page clear routine was
expanded.  This state inconsistency does not occur if the buffer is
written normally by log writing.

Link: https://lkml.kernel.org/r/20241015213300.7114-1-konishi.ryusuke@gmail.com
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+985ada84bf055a575c07@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=985ada84bf055a575c07
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/page.c~nilfs2-fix-kernel-bug-due-to-missing-clearing-of-buffer-delay-flag
+++ a/fs/nilfs2/page.c
@@ -77,7 +77,8 @@ void nilfs_forget_buffer(struct buffer_h
 	const unsigned long clear_bits =
 		(BIT(BH_Uptodate) | BIT(BH_Dirty) | BIT(BH_Mapped) |
 		 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
-		 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected));
+		 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected) |
+		 BIT(BH_Delay));
 
 	lock_buffer(bh);
 	set_mask_bits(&bh->b_state, clear_bits, 0);
@@ -406,7 +407,8 @@ void nilfs_clear_folio_dirty(struct foli
 		const unsigned long clear_bits =
 			(BIT(BH_Uptodate) | BIT(BH_Dirty) | BIT(BH_Mapped) |
 			 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
-			 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected));
+			 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected) |
+			 BIT(BH_Delay));
 
 		bh = head;
 		do {
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-propagate-directory-read-errors-from-nilfs_find_entry.patch
nilfs2-fix-kernel-bug-due-to-missing-clearing-of-buffer-delay-flag.patch

