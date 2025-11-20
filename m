Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAA72FB96A
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676303; cv=none; b=A9+GaGSKJw0+N0OqKpssdKNRpr1uwnj+/A9OLMNBZwcTajkFtae5WdzmZnRQnhlcTHp7G0YhSDeVFEXy+2EEPC+8chmpBYYx9b9Ek8PYU/f5bCrTuhSTUXSA+rHN1kwGNrGQ7vtBbi/9MpPc2M61ldLyQJ0jfysHHG6Slrv0LhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676303; c=relaxed/simple;
	bh=/fHb8/AcA/F+3JGAC7IZeMQLzVOMCCBfvrX8wP/yBDQ=;
	h=Date:To:From:Subject:Message-Id; b=jb6PnkEtDEtINf0u6fcsmaDCtyceszJ07xauuZqcGuR/+ILhf+Xp2Ny3955skghA6iCyt2RAoTejhhApOx9K8zwcGqsufLZlyFS2q9Bb8UYM8vo6sPuyibJewC6iYTmtGLtyItji73MJLc7t/WMhuB8YaVdaT7b9/66h+/1HJTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NpxkMpaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NpxkMpaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ACBC4CEF1;
	Thu, 20 Nov 2025 22:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676302;
	bh=/fHb8/AcA/F+3JGAC7IZeMQLzVOMCCBfvrX8wP/yBDQ=;
	h=Date:To:From:Subject:From;
	b=NpxkMpafY14LN4mZrc/0tuAXsQAdprMIq++S+JIHKqh+9uKd85yr7e15gEdWLlced
	 g1wKU1u9bsDAN3JAMH6gzmqitYnspxfLyLpTU0BbFxt8toh43FPdu7kMckN6V4ER4r
	 FN4nHPEf+KceT+iQAiov/5z96sXae0e95kMBG5d0=
Date: Thu, 20 Nov 2025 14:05:02 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-replace-deprecated-strcpy-with-strscpy.patch removed from -mm tree
Message-Id: <20251120220502.D6ACBC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: replace deprecated strcpy with strscpy
has been removed from the -mm tree.  Its filename was
     ocfs2-replace-deprecated-strcpy-with-strscpy.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


