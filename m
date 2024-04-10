Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1042F6110
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 20:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712781187; cv=none; b=gb5SsC1YBZPB/H7H9sAQQnPxXcnOQ8CJEC5LPDQvjY2m2mmlBrFLJpLZgh50gFzSk9m9dRju8dG7i1FCPlWY0gtjw6W6JQsx9CQoasqP/WvowoomxtoDoahRjP7Ye+dx969JljMC5cB0b4muilveaFBSIUqOt2h81Ai6a19+Bn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712781187; c=relaxed/simple;
	bh=VJp/ezb6uozBTKo8RZ6+du8alvVewtmnzq47SL/bFsE=;
	h=Date:To:From:Subject:Message-Id; b=fBUlDEyj5AcDhp4to/cuP8z/iWWZHqf8W/OKtmcq9rvFjEVeyvmtyohMgKZv35HnYGNKTF0y1m71eU3/f22Gklha2wSVznFa0fETi7592Kx8rtuHLFkDrcHd1ldwPwC7okZTLKGdCXt7BWMv6AxXUm32+y4NWd3krx8h4vGqG4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bno1Ga3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bno1Ga3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8245EC433F1;
	Wed, 10 Apr 2024 20:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712781186;
	bh=VJp/ezb6uozBTKo8RZ6+du8alvVewtmnzq47SL/bFsE=;
	h=Date:To:From:Subject:From;
	b=Bno1Ga3k0ft9xFqIdSXG2KgPxmfNhRHJ16dkdkygczOf286tNvJ1leY9XLVLDWPBt
	 iGNy4cV5o0p5g5XPUOUNx9TG92Ax718qMaRlfZ+RyhAdzWPo6qvIYtCgYKZYiVaU6Z
	 qkAze5F9X0B5vceeRayx2XrCVB8RQrEAr9dm4AlY=
Date: Wed, 10 Apr 2024 13:33:05 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,yang.lee@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-add-kernel-doc-comments-to-nilfs_do_roll_forward.patch added to mm-nonmm-unstable branch
Message-Id: <20240410203306.8245EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: add kernel-doc comments to nilfs_do_roll_forward()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-add-kernel-doc-comments-to-nilfs_do_roll_forward.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-add-kernel-doc-comments-to-nilfs_do_roll_forward.patch

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
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: nilfs2: add kernel-doc comments to nilfs_do_roll_forward()
Date: Wed, 10 Apr 2024 16:56:27 +0900

Patch series "nilfs2: fix missing kernel-doc comments".

This commit adds kernel-doc style comments with complete parameter
descriptions for the function nilfs_do_roll_forward.

Link: https://lkml.kernel.org/r/20240410075629.3441-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20240410075629.3441-2-konishi.ryusuke@gmail.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/recovery.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/recovery.c~nilfs2-add-kernel-doc-comments-to-nilfs_do_roll_forward
+++ a/fs/nilfs2/recovery.c
@@ -563,6 +563,7 @@ static int nilfs_recover_dsync_blocks(st
  * checkpoint
  * @nilfs: nilfs object
  * @sb: super block instance
+ * @root: NILFS root instance
  * @ri: pointer to a nilfs_recovery_info
  */
 static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

fs-add-kernel-doc-comments-to-fat_parse_long.patch
nilfs2-add-kernel-doc-comments-to-nilfs_do_roll_forward.patch
nilfs2-add-kernel-doc-comments-to-nilfs_btree_convert_and_insert.patch
nilfs2-add-kernel-doc-comments-to-nilfs_remove_all_gcinodes.patch

