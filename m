Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174041E487
	for <mm-commits@vger.kernel.org>; Tue, 14 May 2024 18:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715711081; cv=none; b=kLnK/470VuiTnvYrTX77bTyhEvGzOzN0P4bsjFKsjczhAvYQYHPTafLkGGiBoVCAbsOiAHXAnn+vRVPnIH7Ps8HL/RzDTZJReEh+NcxeQl0Xum6B+ho9lXfkvHiEi5kDdIykOy3sHFlCCCWqSiX/4EdBCrXRE/avvlLoj5FI/+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715711081; c=relaxed/simple;
	bh=IE3RdM/+zLuYC2KaXlzF69AtK766YvgerLOZQOJnuA8=;
	h=Date:To:From:Subject:Message-Id; b=XFFmgPzhozNFZBldZ4XXSJvI0sFFkc0jQFbxFaEFBaTC/dPyUoCvHFeNX5suh9rZKdE4k+OGNDBe9fxjR3Nw+UVaML4OpS0GEt/L1arzdBFPWXOJg+CrKeUmiHlFHoHCYEHONbr5Sx9Eb8R6CDvwGK5ahtvpiBtV6jMpQYF0UKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y6z7ncQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y6z7ncQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CA6C2BD10;
	Tue, 14 May 2024 18:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715711080;
	bh=IE3RdM/+zLuYC2KaXlzF69AtK766YvgerLOZQOJnuA8=;
	h=Date:To:From:Subject:From;
	b=y6z7ncQsmX5KdnabHRwVV25yQmvTz5YMkECvZqF6m0Tq1BcYL0wyxOwv/gqRImUCJ
	 kieqhv2LNc3ZF0fM1AX9UVzetUvQVR6y/PQoGA7LVUE2JmEG8iZRouIMKkyMOB6iXJ
	 O0b0/Q09ev/zRzc8l/z2wD5CclNerQyD5ww4E1k0=
Date: Tue, 14 May 2024 11:24:35 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-make-block-erasure-safe-in-nilfs_finish_roll_forward.patch added to mm-nonmm-unstable branch
Message-Id: <20240514182440.D0CA6C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: make block erasure safe in nilfs_finish_roll_forward()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-make-block-erasure-safe-in-nilfs_finish_roll_forward.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-make-block-erasure-safe-in-nilfs_finish_roll_forward.patch

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

nilfs2-make-block-erasure-safe-in-nilfs_finish_roll_forward.patch

