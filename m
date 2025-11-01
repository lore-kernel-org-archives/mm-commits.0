Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5805C21D3C5
	for <mm-commits@vger.kernel.org>; Sat,  1 Nov 2025 02:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761964693; cv=none; b=swzNRrM/wsHfUc3NEWuA/AkoS3frkwMcVQvlHw9yewJmMXS2CFa5ighsNNSlliq+s+YLzt1duEkeiIGFk8Z2gnSh0kGgeIZlfP0EeT++D2RV4OGjZZ536DbxolL6FusFFL+aqlmhWrBcnvuSgUELeNLpF5Hyl+F3w4AgLBhDNKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761964693; c=relaxed/simple;
	bh=tSkogRD4Bw3cf7TZGsAXQuqJl9AwPVU+wYz2AJ1HIuw=;
	h=Date:To:From:Subject:Message-Id; b=cUKzbDoWBRCQZ/Kka68se15uXJkPN0qQ5DUvU5l5GmxLwqPSa7HwK1IqAhSbnP0vfYJlUtw+v79bTeWsOeX3kJI39HGIuPH01gjQBjbHzN22XvmOr3pTyq2z4EwpodyKB+IXalyR/hYpI6fNgdXdRnz86D+N+rmjcspnTaLy5Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rOSAPEaP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rOSAPEaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C506BC4CEE7;
	Sat,  1 Nov 2025 02:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761964692;
	bh=tSkogRD4Bw3cf7TZGsAXQuqJl9AwPVU+wYz2AJ1HIuw=;
	h=Date:To:From:Subject:From;
	b=rOSAPEaPxxiE4l2aLzXTUnZ5tUvEmdTfEB2cwIxkbT5fNK0q3wnXVJiiegFO7kF5t
	 ibLq+cLVHO++tOuogZaGnzg2f0cykIe5w9aCw3YtPNwAU8p93Pe5zbkLoLqARhdmnL
	 P2GSAWIl6wu4YRrNwFb7MoNm0sJQVtXqY2FP1eB8=
Date: Fri, 31 Oct 2025 19:38:12 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,dmantipov@yandex.ru,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-cl_bpc-in-allocator-inodes-to-prevent-divide-by-zero.patch added to mm-nonmm-unstable branch
Message-Id: <20251101023812.C506BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-cl_bpc-in-allocator-inodes-to-prevent-divide-by-zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-cl_bpc-in-allocator-inodes-to-prevent-divide-by-zero.patch

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
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero
Date: Thu, 30 Oct 2025 18:30:03 +0300

The chain allocator field cl_bpc (blocks per cluster) is read from disk
and used in division operations without validation.  A corrupted
filesystem image with cl_bpc=0 causes a divide-by-zero crash in the
kernel:

  divide error: 0000 [#1] PREEMPT SMP KASAN
  RIP: 0010:ocfs2_bg_discontig_add_extent fs/ocfs2/suballoc.c:335 [inline]
  RIP: 0010:ocfs2_block_group_fill+0x5bd/0xa70 fs/ocfs2/suballoc.c:386
  Call Trace:
   ocfs2_block_group_alloc+0x7e9/0x1330 fs/ocfs2/suballoc.c:703
   ocfs2_reserve_suballoc_bits+0x20a6/0x4640 fs/ocfs2/suballoc.c:834
   ocfs2_reserve_new_inode+0x4f4/0xcc0 fs/ocfs2/suballoc.c:1074
   ocfs2_mknod+0x83c/0x2050 fs/ocfs2/namei.c:306

This patch adds validation in ocfs2_validate_inode_block() to ensure
cl_bpc matches the expected value calculated from the superblock's cluster
size and block size for chain allocator inodes (identified by
OCFS2_CHAIN_FL).

Moving the validation to inode validation time (rather than allocation time)
has several benefits:
- Validates once when the inode is read, rather than on every allocation
- Protects all code paths that use cl_bpc (allocation, resize, etc.)
- Follows the existing pattern of inode validation in OCFS2
- Centralizes validation logic

The validation catches both:
- Zero values that cause divide-by-zero crashes
- Non-zero but incorrect values indicating filesystem corruption or
  mismatched filesystem geometry

With this fix, mounting a corrupted filesystem produces:

  OCFS2: ERROR (device loop0): ocfs2_validate_inode_block: Inode 74
         has corrupted cl_bpc: ondisk=0 expected=16

instead of a kernel crash.

[dmantipov@yandex.ru: combine into the series and tweak the message to fit the commonly used style]
Link: https://lore.kernel.org/ocfs2-devel/20251026132625.12348-1-kartikey406@gmail.com/T/#u [v1]
Link: https://lore.kernel.org/all/20251027124131.10002-1-kartikey406@gmail.com/T/ [v2]
Link: https://lkml.kernel.org/r/20251030153003.1934585-2-dmantipov@yandex.ru
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fd8af97c7227fe605d95
Tested-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-validate-cl_bpc-in-allocator-inodes-to-prevent-divide-by-zero
+++ a/fs/ocfs2/inode.c
@@ -1515,6 +1515,8 @@ int ocfs2_validate_inode_block(struct su
 
 	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
 		struct ocfs2_chain_list *cl = &di->id2.i_chain;
+		u16 bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits -
+				sb->s_blocksize_bits);
 
 		if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb)) {
 			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
@@ -1528,6 +1530,14 @@ int ocfs2_validate_inode_block(struct su
 					 le16_to_cpu(cl->cl_next_free_rec));
 			goto bail;
 		}
+		if (OCFS2_SB(sb)->bitmap_blkno &&
+		    OCFS2_SB(sb)->bitmap_blkno != le64_to_cpu(di->i_blkno) &&
+		    le16_to_cpu(cl->cl_bpc) != bpc) {
+			rc = ocfs2_error(sb, "Invalid dinode %llu: bits per cluster %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(cl->cl_bpc));
+			goto bail;
+		}
 	}
 
 	rc = 0;
_

Patches currently in -mm which might be from kartikey406@gmail.com are

ocfs2-validate-cl_bpc-in-allocator-inodes-to-prevent-divide-by-zero.patch

