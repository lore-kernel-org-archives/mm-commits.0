Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682691CEAD2;
	Tue, 22 Oct 2024 23:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729639572; cv=none; b=LfUM03bCmL3IH/NreY1zLRrm0AbNKFbU+IZXDY2Tn/Tkvky0WjlIEmm5MBy/Ke82suKQFlHRoxLgvc4o5VPppnfF1GU9v+djYXgeDuQ7rF0jcSv0T/oBNClt6NapyKN8mWDqmeyZ8+RsIeuJryisil5H9j7AlojAK2geVS1VdUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729639572; c=relaxed/simple;
	bh=Q74S25P1VTOCvOa3o8RrdWMg8H+qhCnEJQ9U1yKa38E=;
	h=Date:To:From:Subject:Message-Id; b=u6snJv2ZGtYyogP871VwLq9rkrR0E2i7UsBiEaMKc6KI4lp7OmIJxvXJXIU8j2LoKbHEGBi0r19qmWegcI+bbdKcslNZoYIiQjc81iCNdPfVKab8JUs+2QnAV5VeZZOk2CkXY3dd7FmkNSXg6hl4L0VbAH/QMySggJciXy3+1DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ROH/QEaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ROH/QEaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCDFC4CEC3;
	Tue, 22 Oct 2024 23:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729639572;
	bh=Q74S25P1VTOCvOa3o8RrdWMg8H+qhCnEJQ9U1yKa38E=;
	h=Date:To:From:Subject:From;
	b=ROH/QEaUcYgrVktldutVVtsn7PGqMY+I3K1F+ls7mb4aKvhUnw6lrmkU4dVneyUT1
	 sYwUIM9Fedk0xLdLeHq9szFQk3uWIt2F1rPa3CM4rPi6yW7E+UkayZZuXP6pkEOWSf
	 Gw3dyG9EZeT8+99dAtls7ORFTTD1bBY3Dj2vjHso=
Date: Tue, 22 Oct 2024 16:26:11 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] nilfs2-fix-kernel-bug-due-to-missing-clearing-of-buffer-delay-flag.patch removed from -mm tree
Message-Id: <20241022232611.DDCDFC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix kernel bug due to missing clearing of buffer delay flag
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-kernel-bug-due-to-missing-clearing-of-buffer-delay-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

nilfs2-fix-kernel-bug-due-to-missing-clearing-of-checked-flag.patch

