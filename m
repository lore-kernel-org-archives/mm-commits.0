Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806EC73451
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 00:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763597776; cv=none; b=n5H8VCgugEjgbyea4xUDpKw/d+sXKUqHgUg5AGQOxGq3tFVnI+UQd4xPayV1KqbrWcDiubWDkS0/6Ieb2N3y98irFZE1WT8pGgQZfX+8ylwY36hrwa0X00qymCYCigbJnQt/A41pgth15NxQIt0mzja3pLPssGnHXAEC1o0lasc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763597776; c=relaxed/simple;
	bh=s7GFmz3hbHkd+mrsJz6CdClhKtf1EI7Gvys5WJj9QSY=;
	h=Date:To:From:Subject:Message-Id; b=c6dHFKjGEgPeooqKtfeDftLgjEmIxlrOm5Pe0tdrjqg03AdTEemWT4FduKF+brbeVkml7iRYzo7yOmcBTF482BZmdf8PI/Qz1MLwatlQV9cdelFQREffvecHbEPIx5IzUxQ6zwhtTUw3weh68re5ffiLSO6zYNoHXpLYB6k0Fxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ircZbqDt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ircZbqDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1961BC4CEF5;
	Thu, 20 Nov 2025 00:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763597775;
	bh=s7GFmz3hbHkd+mrsJz6CdClhKtf1EI7Gvys5WJj9QSY=;
	h=Date:To:From:Subject:From;
	b=ircZbqDtRBbVQBqKMwqwRBOdtCh/fCtd+95OnztyZyMaqGN+B+/1Kg6OYo/Z0qPxp
	 2w75YqfATIOkzQr4+qolAh+snDR8NDMIUR8tBuhHDcuyMuF64aMlf/ZwLN2oH//YRK
	 HG3uBtXAaTJPVgmvdzhLsdIUXYkm6UxzXU/f6Oto=
Date: Wed, 19 Nov 2025 16:16:14 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-replace-deprecated-strcpy-with-strscpy.patch added to mm-nonmm-unstable branch
Message-Id: <20251120001615.1961BC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: replace deprecated strcpy with strscpy
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-replace-deprecated-strcpy-with-strscpy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-replace-deprecated-strcpy-with-strscpy.patch

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
Subject: ocfs2: replace deprecated strcpy with strscpy
Date: Tue, 18 Nov 2025 19:53:45 +0100

strcpy() has been deprecated [1] because it performs no bounds checking on
the destination buffer, which can lead to buffer overflows.  Replace it
with the safer strscpy(), and copy directly into '->rf_signature' instead
of using the start of the struct as the destination buffer.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy [1]
Link: https://lkml.kernel.org/r/20251118185345.132411-3-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/refcounttree.c~ocfs2-replace-deprecated-strcpy-with-strscpy
+++ a/fs/ocfs2/refcounttree.c
@@ -34,6 +34,7 @@
 #include <linux/pagevec.h>
 #include <linux/swap.h>
 #include <linux/security.h>
+#include <linux/string.h>
 #include <linux/fsnotify.h>
 #include <linux/quotaops.h>
 #include <linux/namei.h>
@@ -621,7 +622,7 @@ static int ocfs2_create_refcount_tree(st
 	/* Initialize ocfs2_refcount_block. */
 	rb = (struct ocfs2_refcount_block *)new_bh->b_data;
 	memset(rb, 0, inode->i_sb->s_blocksize);
-	strcpy((void *)rb, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
+	strscpy(rb->rf_signature, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
 	rb->rf_suballoc_slot = cpu_to_le16(meta_ac->ac_alloc_slot);
 	rb->rf_suballoc_loc = cpu_to_le64(suballoc_loc);
 	rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);
@@ -1562,7 +1563,7 @@ static int ocfs2_new_leaf_refcount_block
 	/* Initialize ocfs2_refcount_block. */
 	new_rb = (struct ocfs2_refcount_block *)new_bh->b_data;
 	memset(new_rb, 0, sb->s_blocksize);
-	strcpy((void *)new_rb, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
+	strscpy(new_rb->rf_signature, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
 	new_rb->rf_suballoc_slot = cpu_to_le16(meta_ac->ac_alloc_slot);
 	new_rb->rf_suballoc_loc = cpu_to_le64(suballoc_loc);
 	new_rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

ocfs2-replace-deprecated-strcpy-in-ocfs2_create_xattr_block.patch
ocfs2-replace-deprecated-strcpy-with-strscpy.patch

