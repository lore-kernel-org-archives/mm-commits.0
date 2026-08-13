Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3BD3FD132;
	Thu, 13 Aug 2026 22:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660977; cv=none; b=mFlyMkznZljU6UJK8Fy79Wl74h0Aw0PEnetmTZuCb+YBwocqANxv/+2uuXOOzel01ffICRAdI/M8i8od4DOSNgX+syb2bXqXCUe8ZDDRj3envLRwyE6twd7AEjKSziXJmaJXpsfEymMcy8Ebjq5MtCBaq1a/dtBepEiekjuELfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660977; c=relaxed/simple;
	bh=bwYfbvcujMmG/QQgrSmbW/49AsBFEK6bsdLkKmpCpzI=;
	h=Date:To:From:Subject:Message-Id; b=fGI50/Be5tRcV3pEO+xm/8BXClUIBeC8lleeHUzXmD/5WPGsmOHKNm9IiQlKrsnyPQJXLB1gXaxW9ovgbW7keFuv1khuD6p67olthwBsIfY/tdV6AO2sMtcCZw0UeMauhYVI04O0640lWOBMLaP0WZFSwRzinbHhujhjaJSpSwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lTeECoPn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lTeECoPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37371F00A3A;
	Thu, 13 Aug 2026 22:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786660975;
	bh=erAdG3L53+v6wvoHrChG3Zyts/MvH7Qw22D/GiOHLy4=;
	h=Date:To:From:Subject;
	b=lTeECoPn3zHc0tIriLCAcU9zeJPffNTNLKl2B9dImwKnS6ThHu0E5be4UNfx1itxZ
	 FQ87iE5++oCPkSd6Im7fI4v7dBlTIXUqJ0Y9v9MuuMLb8Ie0OudakDORDqyzuK7c4j
	 zvbM5wo9Cgl2gaGb8GQXoZaX3dkLe7pwldwYmsi0=
Date: Thu, 13 Aug 2026 15:42:55 -0700
To: mm-commits@vger.kernel.org,zhanxusheng@xiaomi.com,yi.zhang@huawei.com,tytso@mit.edu,stable@vger.kernel.org,ritesh.list@gmail.com,piaojun@huawei.com,ojaswin@linux.ibm.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jack@suse.cz,heming.zhao@suse.com,gechangwei@live.cn,adilger.kernel@dilger.ca,zhanxusheng1024@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-readdir-position-truncation-on-32-bit-kernels.patch removed from -mm tree
Message-Id: <20260813224255.C37371F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix readdir position truncation on 32-bit kernels
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-readdir-position-truncation-on-32-bit-kernels.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
Subject: ocfs2: fix readdir position truncation on 32-bit kernels
Date: Thu, 6 Aug 2026 10:20:44 +0800

In ocfs2_dir_foreach_blk_el(), the directory cookie position is
rebuilt with

	ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1)) | offset;

`ctx->pos` is loff_t (signed 64-bit), while `sb->s_blocksize` is
unsigned long.  On 32-bit kernels unsigned long is 32-bit, so the mask

	~(sb->s_blocksize - 1)

is computed as a 32-bit unsigned value (e.g. 0xfffff000 for a 4 KiB
block size).  In the AND expression with the 64-bit `ctx->pos`, that
unsigned operand is zero-extended to 64 bits per the usual arithmetic
conversions, yielding 0x00000000fffff000.  The high 32 bits of
`ctx->pos` are silently cleared, even though directory size is
allowed to exceed 4 GiB.

When readdir() crosses the 4 GiB boundary on a 32-bit kernel the
position is reset back into the first 4 GiB block, making the
re-validation path re-enumerate already-returned dirents indefinitely.

This is ocfs2_dir_foreach_blk_el(), the extent-list readdir path taken
for all non-inline directories, so a directory large enough to cross
4 GiB reaches it.

This is the same class of bug that commit 3dce5bb82c97 ("exfat: Fix
bitwise operation having different size") fixed in exfat, and the
fix mirrors the equivalent ext4 fix in this series.  Cast the operand
to loff_t so the mask is 64-bit before the AND:

	ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1)) | offset;

64-bit kernels are unaffected.

Link: https://lore.kernel.org/20260806022044.167962-3-zhanxusheng@xiaomi.com
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/dir.c~ocfs2-fix-readdir-position-truncation-on-32-bit-kernels
+++ a/fs/ocfs2/dir.c
@@ -1959,7 +1959,7 @@ static int ocfs2_dir_foreach_blk_el(stru
 				i += le16_to_cpu(de->rec_len);
 			}
 			offset = i;
-			ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1))
+			ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1))
 				| offset;
 			*f_version = inode_query_iversion(inode);
 		}
_

Patches currently in -mm which might be from zhanxusheng1024@gmail.com are

maple_tree-remove-unused-mas_is_root_limits.patch

