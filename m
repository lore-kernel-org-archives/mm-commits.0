Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F62F184540
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810151; cv=none; b=td4yepUqBkYBALC3LAhLr/Nm5svTWSzHKKkhRQYeEsou9gDQWOxk+5wrYbXiqGYCBBml5dr1fz0BdASQg+PTKXZ3GoPxA0ME3P0gfq9JJwiEROWZ3KxHtooWx9J0iHESO0yU5yRZMFFPai61+vhRwHVPSN89yyRI4E9Xq8DeE3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810151; c=relaxed/simple;
	bh=n94E8vkQPK9cQctLkiB5aA28r1X4hyy+Ox+HL+CfFng=;
	h=Date:To:From:Subject:Message-Id; b=D+ZCovBt/DcwyBiHL7xCuwnDIZ81JXaB51wv97muABuw6shfj6C0sPtofyCrTxqqQGZBT+n9jQ+hocbl1lCijBIl5rcjtTZMWUEI6JC/t3LBIlpoGkOM6aje8rsxOk4A0uskHEuCmoKOaK4ssrcWtsH2WlfHMtlZFKqE1tRVomw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NPP+ixt1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NPP+ixt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD50C4CEEB;
	Sun, 14 Sep 2025 00:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810151;
	bh=n94E8vkQPK9cQctLkiB5aA28r1X4hyy+Ox+HL+CfFng=;
	h=Date:To:From:Subject:From;
	b=NPP+ixt1EqA0MVI51qbUQ8aEQqs91xwFyVK3ri2Du07PNgZoK/d0TEiMWZRaHrxJv
	 swKld5Y8aiBkHy6kX0jcVOwTxGfecwu5zhDURiZjjPi7o6a8+99Rx4Li/MNGmPKjUI
	 0VWICt1UFK5TlvvP0+jbKFvIWMlLZYdRUDnuJk5A=
Date: Sat, 13 Sep 2025 17:35:50 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-add-suballoc-slot-check-in-ocfs2_validate_inode_block.patch removed from -mm tree
Message-Id: <20250914003551.3DD50C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: add suballoc slot check in ocfs2_validate_inode_block()
has been removed from the -mm tree.  Its filename was
     ocfs2-add-suballoc-slot-check-in-ocfs2_validate_inode_block.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: add suballoc slot check in ocfs2_validate_inode_block()
Date: Tue, 26 Aug 2025 12:51:06 +0300

In 'ocfs2_validate_inode_block()', add suballoc slot check similar to one
in 'ocfs2_get_suballoc_slot_bit()', thus preventing an out-of-bounds
accesses for 'local_system_inodes' in 'get_local_system_inode()'.

Most likely this fixes
https://syzkaller.appspot.com/bug?extid=a77d690840e60bc2ddd8 as well.

Link: https://lkml.kernel.org/r/20250826095106.666980-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+900962ac9bf1860033f2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=900962ac9bf1860033f2
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-add-suballoc-slot-check-in-ocfs2_validate_inode_block
+++ a/fs/ocfs2/inode.c
@@ -1495,6 +1495,14 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	if (le16_to_cpu(di->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
+	    (u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc slot %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_suballoc_slot));
+		goto bail;
+	}
+
 	rc = 0;
 
 bail:
_

Patches currently in -mm which might be from dmantipov@yandex.ru are


