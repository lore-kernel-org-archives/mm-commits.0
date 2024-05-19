Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF3671B24
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154654; cv=none; b=AkYKLB5Iah5XnjkcwZvsnHEMPYNeXw1Lajqq0TYaikDQgd+rdemXd76dcWaRQFgdNV092NxJTo9PlsX6DCWiwscfFGtKHXqNorNC40UlfXS+pLO4JB4oLctLsvqzmIfX32ZQ/rhduPo4n/GV/wj94w2o7+Rgx3MxKEF3qfKXDZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154654; c=relaxed/simple;
	bh=PE14vmaeCFEKZ4rWSmI1wk3ARw3KQHN8dG88SoJFOKE=;
	h=Date:To:From:Subject:Message-Id; b=VfLick6rxmbbYJdmVkSqzOzAMNWXNKHBnsVt0egicaNeKxu5QmHHwyO0kDYORCH07oX/Dvx+sPx8gSW9fgRcCkeYqe0A20hnhR1UBv4i5hj3iaJPlG1zuIlyDc4bSBikvM8oEuZ7l0C4pUFLoxdHT5J3AIrSSfsD2MxcHen67qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IBhw/ADH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IBhw/ADH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999B4C32781;
	Sun, 19 May 2024 21:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154654;
	bh=PE14vmaeCFEKZ4rWSmI1wk3ARw3KQHN8dG88SoJFOKE=;
	h=Date:To:From:Subject:From;
	b=IBhw/ADHkx+dz3c8CCy7X779LxVQzHQvqg4DbE5f2KYXWs2sUfqvVxC9yAjuDphkI
	 D/5Ju/Ev3WpCshQgFVxDJb5uRlEfbay+El4iqPALLrgR6AliCy+71JviH321iSwFkW
	 lJIOzKwjR+aXL8cGJH5X84hMEUFi61NzHoQ3JaEI=
Date: Sun, 19 May 2024 14:37:34 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-make-block-erasure-safe-in-nilfs_finish_roll_forward.patch removed from -mm tree
Message-Id: <20240519213734.999B4C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: make block erasure safe in nilfs_finish_roll_forward()
has been removed from the -mm tree.  Its filename was
     nilfs2-make-block-erasure-safe-in-nilfs_finish_roll_forward.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: make block erasure safe in nilfs_finish_roll_forward()
Date: Sat, 11 May 2024 09:29:42 +0900

The implementation of writing a zero-fill block in
nilfs_finish_roll_forward() is not safe.  The buffer is being cleared
without acquiring a lock or setting the uptodate flag, so theoretically,
between the time the buffer's data is cleared and the time it is written
back to the block device using sync_dirty_buffer(), that zero data can be
undone by concurrent block device reads.

Since this buffer points to a location that has been read from disk once,
the uptodate flag will most likely remain, but since it was obtained with
__getblk(), that is not guaranteed.  In other words, this is exceptional,
and this function itself is not normally called (only once when mounting
after a specific pattern of unclean shutdown), so it is highly unlikely
that this will actually cause a problem.

Anyway, eliminate this potential race issue by protecting the clearing of
buffer data with a buffer lock and setting the buffer's uptodate flag
within the protected section.

Link: https://lkml.kernel.org/r/20240511002942.9608-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/recovery.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nilfs2/recovery.c~nilfs2-make-block-erasure-safe-in-nilfs_finish_roll_forward
+++ a/fs/nilfs2/recovery.c
@@ -702,8 +702,12 @@ static void nilfs_finish_roll_forward(st
 	if (WARN_ON(!bh))
 		return;  /* should never happen */
 
+	lock_buffer(bh);
 	memset(bh->b_data, 0, bh->b_size);
+	set_buffer_uptodate(bh);
 	set_buffer_dirty(bh);
+	unlock_buffer(bh);
+
 	err = sync_dirty_buffer(bh);
 	if (unlikely(err))
 		nilfs_warn(nilfs->ns_sb,
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


