Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B2376025
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 00:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763597772; cv=none; b=S7VJLPbfH/VjM1dNCYo0IzeKjTRNFayXNvwkB0EJDUhEBBO8zuIhmoqLG1yfPnsW6AkC3PwHyqho8QQyKHvTA/2UJBm+poZqiOAlP+/HYKnKM0wv78I2kz8BTMJ1WRwTGXqifVVlDQq6CK9LIZvme9isarytcfidcvxZueVQvW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763597772; c=relaxed/simple;
	bh=gPC6cIE6akRjVwnpNFatVlF9GnMKR/kL7N9PGUIMMTM=;
	h=Date:To:From:Subject:Message-Id; b=Z4/9RWFHF843MeBP+LBfuwMhV5MZbgdWPJm8LKOQ0h24uME8kAoaJS2Tav8pQPokWnMT8BlamNJDYdiJKcLeMVVwn4e2eP/XJSu2Z8xOwh23ikiWRa/pNpy9nymkoS1LXosZP4x71nSrGiBjPROEK34qVMLzFmsLXKa62FUAwWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M9NfsjXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M9NfsjXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9917C4CEF5;
	Thu, 20 Nov 2025 00:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763597770;
	bh=gPC6cIE6akRjVwnpNFatVlF9GnMKR/kL7N9PGUIMMTM=;
	h=Date:To:From:Subject:From;
	b=M9NfsjXAYlFX3lQPlqnvdWql8ksNVnHDBqcv24lXJmih+Rv4ERIx7XlGLGUjUXp8T
	 VfEOVCUoONsUiAsSzZGn6tn/P+xyd6ACd8WOY99mY/mytLqi52DEqAsmGNTP/9djjI
	 aJ2zA7zQrLIIn94AyPo0SAND9tZKLKCu/M0xOQ3A=
Date: Wed, 19 Nov 2025 16:16:09 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-replace-deprecated-strcpy-in-ocfs2_create_xattr_block.patch added to mm-nonmm-unstable branch
Message-Id: <20251120001609.E9917C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: replace deprecated strcpy in ocfs2_create_xattr_block
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-replace-deprecated-strcpy-in-ocfs2_create_xattr_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-replace-deprecated-strcpy-in-ocfs2_create_xattr_block.patch

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

ocfs2-replace-deprecated-strcpy-in-ocfs2_create_xattr_block.patch
ocfs2-replace-deprecated-strcpy-with-strscpy.patch

