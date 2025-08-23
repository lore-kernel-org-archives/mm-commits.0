Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF08146D45
	for <mm-commits@vger.kernel.org>; Sat, 23 Aug 2025 01:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755913179; cv=none; b=oK+aczaqLJaXFr8wrijiM3VUpg/luLwFYeSWyIo/9a7Nffs6Iy8SO38KKpT6vuwRWbm/rOjM2Q43CgFfcdVdIUQqAFnalRTPSCaX0rbZ5wiNKiNThhtANiPPqSyKSjKfnpszKdSpa4LtzN+fQAyB3wPaaGvlfk+ZK7Z+adCw4EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755913179; c=relaxed/simple;
	bh=n2KGz4qskK/krb7MNUBlxheSRPexEwdisse3VQ34Azg=;
	h=Date:To:From:Subject:Message-Id; b=oVJL/1b2n4aCriHrD9mLZQSvPYUAdeFWb4zt15wEjRrse93wknChcTSfyiRTohIlqPnZZgj1ZtiDQvy0T50rGTEAF81opcJvuiV30fiaej4McC/FsJFAjaDw2muCoLcRaShFp/TlTCzLZW6bQDA32AoAPf6zM9r3kwII+nZHa+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S9UZhNEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S9UZhNEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE8EC4CEED;
	Sat, 23 Aug 2025 01:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755913178;
	bh=n2KGz4qskK/krb7MNUBlxheSRPexEwdisse3VQ34Azg=;
	h=Date:To:From:Subject:From;
	b=S9UZhNEKSl0VtcIfi7LsaiSKSj8FEPiYKveJidL1mfTYd2TvBM3ylprRkEWkmqM+f
	 sBg3krqn4s/TnO9ue+caqLyxwKUxDx3vIpMiDeVH7XBD0Lap7g1jhTeIvr9KyjWWaU
	 x5fsFKxDDBKIrbEUCyMbUpxjwRwPXqUoy0YGaO2o=
Date: Fri, 22 Aug 2025 18:39:37 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,yili@winhong.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-super-block-reserved-field-offset-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20250823013938.2AE8EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix super block reserved field offset comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-super-block-reserved-field-offset-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-super-block-reserved-field-offset-comment.patch

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
From: yili <yili@winhong.com>
Subject: ocfs2: fix super block reserved field offset comment
Date: Thu, 7 Aug 2025 23:57:49 +0800

The offset annotation for s_reserved2 in struct ocfs2_super_block
was incorrect. After the preceding fields:
- s_xattr_inline_size (2 bytes at 0xB8)
- s_reserved0 (2 bytes at 0xBA)
- s_dx_seed[3] (12 bytes at 0xBC)

The actual offset of s_reserved2 is at 0xC8, when calculating from the
start of the structure.

Correct the offset comment from C0 to C8 to reflect the proper location in
the super block structure.

Link: https://lkml.kernel.org/r/20250807155749.164481-1-yili@winhong.com
Signed-off-by: yili <yili@winhong.com>
Reviewed-by: Joel Becker <jlbec@evilplan.org>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-fix-super-block-reserved-field-offset-comment
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -614,7 +614,7 @@ struct ocfs2_super_block {
 	__le16 s_reserved0;
 	__le32 s_dx_seed[3];		/* seed[0-2] for dx dir hash.
 					 * s_uuid_hash serves as seed[3]. */
-/*C0*/  __le64 s_reserved2[15];		/* Fill out superblock */
+/*C8*/  __le64 s_reserved2[15];		/* Fill out superblock */
 /*140*/
 
 	/*
_

Patches currently in -mm which might be from yili@winhong.com are

ocfs2-fix-super-block-reserved-field-offset-comment.patch

