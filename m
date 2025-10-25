Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFEF28C840
	for <mm-commits@vger.kernel.org>; Sat, 25 Oct 2025 23:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761436425; cv=none; b=Xh/BRbZdvvq6zUmEqEqJkEEcqBYV36MeVqnSz2npK67pFoTyqLp9AdAZYD+cDnR3fg6luQBY48bj6Q/rRw0wAxJ5HudrKIHFCxmKhXR3veHVzmD4dv4vxWTByQQlAeRdw0s6l4aQIcnlrkXgNuM8BXEWCwtjOniLDmhV2hkBSMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761436425; c=relaxed/simple;
	bh=C2r8SEB/vHXkFr8zmKn4buniXhOmTN1oX0ipbjytP4U=;
	h=Date:To:From:Subject:Message-Id; b=LO1s86GOsbGwvRnuaar8lk3kbvCEEbbXBpQHcNqFkzsR4ryBmJKuFKhuLM1IznmOFuDe8AyvRGzyd0kpQsDJf/xLa2ett+J2MLClXd2uXGo7Z0AInKQoEv2l9UrwKFjrhU++bzdDLXLcqVyEwz4aNjw+sdNV/rW6bcTWpzzln9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gth/BcDX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gth/BcDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C19AC4CEF5;
	Sat, 25 Oct 2025 23:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761436425;
	bh=C2r8SEB/vHXkFr8zmKn4buniXhOmTN1oX0ipbjytP4U=;
	h=Date:To:From:Subject:From;
	b=Gth/BcDXSw5C2ezeoAsv/AYH/XNNYFDQ9Tn0sDXliLmUhiUlSuNIYt+BVKFKj08Oz
	 2qJTm7M+cvcNkHpMWi23veKDR1Nwc5/7B4FFNiI4+yqaicilaJuEDwjF4oMXBp53g7
	 I4OOCLslY5FyD6YUX7YQW3sX88uRsTkKcqtJ8g4M=
Date: Sat, 25 Oct 2025 16:53:44 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-convert-to-host-endian-in-ocfs2_validate_inode_block.patch added to mm-nonmm-unstable branch
Message-Id: <20251025235345.3C19AC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: convert to host endian in ocfs2_validate_inode_block
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-convert-to-host-endian-in-ocfs2_validate_inode_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-convert-to-host-endian-in-ocfs2_validate_inode_block.patch

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
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: convert to host endian in ocfs2_validate_inode_block
Date: Sat, 25 Oct 2025 20:32:18 +0800

Convert to host endian when checking OCFS2_VALID_FL to keep consistent
with other checks.

Link: https://lkml.kernel.org/r/20251025123218.3997866-2-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/inode.c~ocfs2-convert-to-host-endian-in-ocfs2_validate_inode_block
+++ a/fs/ocfs2/inode.c
@@ -1481,7 +1481,7 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
-	if (!(di->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
+	if (!(le32_to_cpu(di->i_flags) & OCFS2_VALID_FL)) {
 		rc = ocfs2_error(sb,
 				 "Invalid dinode #%llu: OCFS2_VALID_FL not set\n",
 				 (unsigned long long)bh->b_blocknr);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-use-correct-endian-in-ocfs2_dinode_has_extents.patch
ocfs2-convert-to-host-endian-in-ocfs2_validate_inode_block.patch

