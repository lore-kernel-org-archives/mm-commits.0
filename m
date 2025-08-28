Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FE47082D
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 23:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756423272; cv=none; b=LrXX9tZniXwjHKao1TwJS3Tb/jQC/6dUmn02IJTnPnaxJjC/c7dImvDBWDu+YChhEz23dlDquJetBD9WogBVg9vQG2F+1pQI395BXQ0ZCddJgNQkWSB9AhdsnAQdqBEjbpJrBNQp12iAfkxV7GG+58obMK/DqmtLJKFxPMS5Prc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756423272; c=relaxed/simple;
	bh=UD8olvwllVAoulSPkSX353VhUu7umF99r5xYA90BNMA=;
	h=Date:To:From:Subject:Message-Id; b=CTIP/oBTDlLc9G/L5NsYpNDgFiKCnhES93JmmaX6drpOzuSiEMdRWvR07Nx5kOnK6V/dcdOD/g/ngLGV/qx9kGq0luuJ5OIh7j9FVOa+wKYC0FoZEtKaM+2FjOBpODqUo42vlibMo1HnC5iqtMzhVU/Z1iGKmtsnIFnovkCB3M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fb63k5EE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fb63k5EE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6D5C4CEEB;
	Thu, 28 Aug 2025 23:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756423270;
	bh=UD8olvwllVAoulSPkSX353VhUu7umF99r5xYA90BNMA=;
	h=Date:To:From:Subject:From;
	b=Fb63k5EET/qB6TRFxeE5zKGV6xwxIyWVKoZiYlHNVnUx3YZfCfTH2Y5gHRCxLNSoz
	 ML1ASYZ3ZThOoMp3zyp+sn0t00uXPs0BGRCnDxZwjLtS8hq5dH44HMyuIDi5tcAsmi
	 PMoXUHZQMIjynx05D6wv28TzN/aDJW9ntxAKxz40=
Date: Thu, 28 Aug 2025 16:21:10 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-add-suballoc-slot-check-in-ocfs2_validate_inode_block.patch added to mm-nonmm-unstable branch
Message-Id: <20250828232110.CC6D5C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: add suballoc slot check in ocfs2_validate_inode_block()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-add-suballoc-slot-check-in-ocfs2_validate_inode_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-add-suballoc-slot-check-in-ocfs2_validate_inode_block.patch

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

ocfs2-add-suballoc-slot-check-in-ocfs2_validate_inode_block.patch

