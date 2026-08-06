Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEF13859D3;
	Thu,  6 Aug 2026 04:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785991328; cv=none; b=CmBBpveqst7URmtr6AULYvyUL2XrKjCCyaHqivPtZZ8/13P0QSNCwN7kxclR95WZzRhazOSI0nL4oug0VV3hRRfp+rK9CbP5uYNfFok6t0SfQLJW2PNTbwze+roS8V+WYdWBTqDG7q9Pk2RXYLignEyGjp5ii1GdMm3Si9DfPFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785991328; c=relaxed/simple;
	bh=Y7M5YdtNZ3sWJSEWtgcDh46A8WCPwtzrK6Se9oQhDsc=;
	h=Date:To:From:Subject:Message-Id; b=Orcfjcs9rkykwnYkLGpxmgXITlIV8HpvFj0YeQNG6LN/jzJ1+ri5CKppo2LwxkbGzThfLZZQgC57nKjjRoxxW/qWdmlpTk707iAXOoO3p+TxOlN+8J0vOMa2ZOQBOd/77Oc2xXqLp+SL6pUSTRCy6VHFUwK+Hv9CHYWVcEcjsho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ARv4ju2R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ARv4ju2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D051F000E9;
	Thu,  6 Aug 2026 04:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785991327;
	bh=i42chIfdzBXgaMCYywklNRZ1hzD+W5u254O4OyRzZO4=;
	h=Date:To:From:Subject;
	b=ARv4ju2RlJf8etNPn8Ro7PaZYwhXWS5ekOvt0eqAwKM4ruaJ9KbH06WD4/JJMJnxa
	 t8YslVaH9fdu6PvJ5fn709l/xzuhuAwjXSiJNlHF2wMKlRVEHGdL6iuDeWXTODIitd
	 5Gkxscri1gNU73AKzRKZ0Sv7hs957kC7WE45kE5M=
Date: Wed, 05 Aug 2026 21:42:06 -0700
To: mm-commits@vger.kernel.org,zhanxusheng@xiaomi.com,yi.zhang@huawei.com,tytso@mit.edu,stable@vger.kernel.org,ritesh.list@gmail.com,piaojun@huawei.com,ojaswin@linux.ibm.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,jack@suse.cz,heming.zhao@suse.com,gechangwei@live.cn,adilger.kernel@dilger.ca,zhanxusheng1024@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-readdir-position-truncation-on-32-bit-kernels.patch added to mm-nonmm-unstable branch
Message-Id: <20260806044207.46D051F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix readdir position truncation on 32-bit kernels
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-readdir-position-truncation-on-32-bit-kernels.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-readdir-position-truncation-on-32-bit-kernels.patch

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
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
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

ocfs2-fix-readdir-position-truncation-on-32-bit-kernels.patch

