Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794753665;
	b=szwjjCgT7lUgzZUDsk0x2+4L0DexcFrPpztCHivxTQbXMYe1vi0I/msP8CAnuUoFF7xZ
	 lwIni68XmJM6CYDwXamqsFYcjFxUiHIAb75qVSaei32O9d9yndDKmuK5013Ac1iA32Pso
	 O+O6PaPv6aHZ6RpgKF8IFwjIsKUBHV2+SSVigW2hYYNhViOaDP1Rbv2NoFybOrYmxKdy8
	 b/cy2l/ksEWt8rB5QfKAtVb83/kieHTf7vV2XTb1VJDx/gFytOCgM+JXpmF5I48wKsstF
	 fr/9DNnCNVUnUipZlWKfV24pBiBrncdVXiMFpYwe5cex0Bm6MtfyK5ZhCkHFTBZncdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794753665;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=+UhcFGYhPcDppuinw/0i64Xnb54T5h3AWlekp80tohs=;
	b=Sdm7hhKCTizjnA276iVRYeT6z82q22LP8dO3PnwtMVC+ATanWSGrCjFhWmbDm6lcKh7o
	 FWWgnJNi2WgPiu9Q6A8RxKNZW0KFWfb+xRmg/4RDvxrhVvpoUy6hwzbeZF8PpmyOgpo85
	 KE6HmLyzqb44tY0KRJLD2LL7QWV2PYafQ8OLD7aGbY2V2zRf4hlJ1TzT9lwlQyhZYOfta
	 +nQTnXWu73I+t28E+50urP5a7AtY6scJ/I3/7R/QrV4aMcGJp0DZfe8wKPittQ26adXez
	 yePwbE/fPqZWGqk+etV2ZzCH01sT82gjosgPlOoTOq9vuaKtySG0hNCDKw8rZaDpajw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GFC4E1hT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B602606A31D
	for <mm-commits@vger.kernel.org>; Sun, 15 Nov 2026 14:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GFC4E1hT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5806A1F000C4;
	Sun, 15 Nov 2026 14:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794753664;
	bh=+UhcFGYhPcDppuinw/0i64Xnb54T5h3AWlekp80tohs=;
	h=Date:To:From:Subject;
	b=GFC4E1hTo+qiXLw9rkZuhBs2DE27zflPOFslu9oBNeWazSpq0YpS0+I09C9NC7goV
	 jXtAmh0ZG1qt+ZfX5iPML74XUN06c2vqHXu+epl9q3G2zbw02TOQFR6j2pS4bK/1sM
	 nCQia4wY7B79gllMEMNQ6TF+MepNlIrrMXxiG9pI=
Date: Sun, 15 Nov 2026 06:41:03 -0800
To: mm-commits@vger.kernel.org,
	syzbot+3f66416993279938e957@syzkaller.appspotmail.com,mark@fasheh.com,
	joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,
	ngocthang2710.1999@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-dont-reuse-single_depth_nesting-for-unpublished-inode-ip_alloc_sem.patch added to mm-nonmm-unstable branch
Message-Id: <20261115144104.5806A1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: don't reuse SINGLE_DEPTH_NESTING for unpublished inode ip_alloc_sem
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-dont-reuse-single_depth_nesting-for-unpublished-inode-ip_alloc_sem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-dont-reuse-single_depth_nesting-for-unpublished-inode-ip_alloc_sem.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Subject: ocfs2: don't reuse SINGLE_DEPTH_NESTING for unpublished inode ip_alloc_sem
Date: Sun, 15 Nov 2026 17:46:56 +0700

Commit c204bf5ac3ee ("ocfs2: fix deadlock in inline-data truncate
transactions") made ocfs2_xattr_set_handle() take ip_alloc_sem of a
not-yet-published inode inside the create transaction, under subclass
OCFS2_IP_ALLOC_SEM_UNPUBLISHED = 1, so lockdep records:

  sb_internal -> j_trans_barrier -> ip_alloc_sem/1

But subclass 1 is SINGLE_DEPTH_NESTING, which ocfs2_remap_file_range()
already uses for the destination inode, and the remap then starts a
transaction in ocfs2_duplicate_inline_data():

  ip_alloc_sem/1 -> sb_internal

Lockdep merges the two and reports a circular dependency.  It cannot
deadlock, since the unpublished inode is unreachable by anyone else, but
the warning hides real reports.

Give the unpublished subclass its own value past SINGLE_DEPTH_NESTING.

Link: https://lore.kernel.org/20261115104656.210945-1-ngocthang2710.1999@gmail.com
Fixes: c204bf5ac3ee ("ocfs2: fix deadlock in inline-data truncate transactions")
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+3f66416993279938e957@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=3f66416993279938e957
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>

 fs/ocfs2/xattr.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-dont-reuse-single_depth_nesting-for-unpublished-inode-ip_alloc_sem
+++ a/fs/ocfs2/xattr.c
@@ -3867,10 +3867,11 @@ out:
  * ip_alloc_sem there adds a transaction -> ip_alloc_sem order that would
  * form a lockdep cycle with the ip_alloc_sem -> transaction order used
  * elsewhere, if not for this separate subclass.  The inode is unpublished
- * so the acquisition can never contend.
+ * so the acquisition can never contend.  It must not collide with the
+ * SINGLE_DEPTH_NESTING subclass ocfs2_remap_file_range() uses.
  */
 enum {
-	OCFS2_IP_ALLOC_SEM_UNPUBLISHED = 1,
+	OCFS2_IP_ALLOC_SEM_UNPUBLISHED = SINGLE_DEPTH_NESTING + 1,
 };
 
 /*
_

Patches currently in -mm which might be from ngocthang2710.1999@gmail.com are

squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails.patch
ocfs2-dont-reuse-single_depth_nesting-for-unpublished-inode-ip_alloc_sem.patch

