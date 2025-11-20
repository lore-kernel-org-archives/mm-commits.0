Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A092FB96A
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676302; cv=none; b=uffgt992Fx6GLxNuUTde0XwlAp5OLNsvXLY7jYw7xnLmjn1EbYBWkwxX/HEiBIwLIop01yuQJI41w3p0NEr8saQHOZAD9Bbd/Jb4mkfHXzi+xgK0ic0hsB3UBVIKJ6LRtQ5jshKjqrPN8fNGvw6gkMGuB60GRb/GT1ypeG98/4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676302; c=relaxed/simple;
	bh=mjBYAVHuMOf5xd+RlWslUIE5NTPLr57Abk1NTB9XnBI=;
	h=Date:To:From:Subject:Message-Id; b=MhvifnwfbMMliMDw5EbvFz5dqlTtyipKTRN/UvmJrnhA5kZb3r69QLJGzIAQ7M+Yj4cQRpeFPJnaFCNb/CqRoQzSK4pnjWI9tOoMshrV/N9CSDnBA47iF4qZeRvJ/xDVc+QuRqvzM0vJaCOyCUovMKMsCUZUXMeiMDxk5waeTuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ezZv2iw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ezZv2iw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE177C4CEF1;
	Thu, 20 Nov 2025 22:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676302;
	bh=mjBYAVHuMOf5xd+RlWslUIE5NTPLr57Abk1NTB9XnBI=;
	h=Date:To:From:Subject:From;
	b=ezZv2iw6FfmiQP5EKsHO007zejwffaArGudlP7IkmxbCN+kxTo4zJwjOAbEjgIGcQ
	 LCCSS3lvUTg5iXtvuEA5qgzgGxdthegcxv6mwtkWfW0ZZ26j2QFxF7flh+K0EDMiG9
	 mGsptCByID9/Ofe7rj1uZ4hU+MPTJKvW5Y8uZmO4=
Date: Thu, 20 Nov 2025 14:05:01 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-replace-deprecated-strcpy-in-ocfs2_create_xattr_block.patch removed from -mm tree
Message-Id: <20251120220501.DE177C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: replace deprecated strcpy in ocfs2_create_xattr_block
has been removed from the -mm tree.  Its filename was
     ocfs2-replace-deprecated-strcpy-in-ocfs2_create_xattr_block.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: ocfs2: replace deprecated strcpy in ocfs2_create_xattr_block
Date: Tue, 18 Nov 2025 19:53:44 +0100

strcpy() has been deprecated [1] because it performs no bounds checking on
the destination buffer, which can lead to buffer overflows.  Replace it
with the safer strscpy(), and copy directly into '->xb_signature' instead
of using the start of the struct as the destination buffer.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy [1]
Link: https://lkml.kernel.org/r/20251118185345.132411-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/xattr.c~ocfs2-replace-deprecated-strcpy-in-ocfs2_create_xattr_block
+++ a/fs/ocfs2/xattr.c
@@ -2908,7 +2908,7 @@ static int ocfs2_create_xattr_block(stru
 	/* Initialize ocfs2_xattr_block */
 	xblk = (struct ocfs2_xattr_block *)new_bh->b_data;
 	memset(xblk, 0, inode->i_sb->s_blocksize);
-	strcpy((void *)xblk, OCFS2_XATTR_BLOCK_SIGNATURE);
+	strscpy(xblk->xb_signature, OCFS2_XATTR_BLOCK_SIGNATURE);
 	xblk->xb_suballoc_slot = cpu_to_le16(ctxt->meta_ac->ac_alloc_slot);
 	xblk->xb_suballoc_loc = cpu_to_le64(suballoc_loc);
 	xblk->xb_suballoc_bit = cpu_to_le16(suballoc_bit_start);
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are


