Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BDB221F17
	for <mm-commits@vger.kernel.org>; Tue, 28 Oct 2025 23:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761693682; cv=none; b=ruS6TocaQrF/2WTAm34qnBKCl2O1vUp/V0PTfmgwYbniK0p0CB23nhePOMrBaVS12ZxaTCtwCs4VyjLEfyKN/hBbJhkyooOTWFMEavGUe2Lqwe6+LeEq0qdIE9h5nVOmOhdyenoBFDCyqSQSUE1i2lu9KoLJCkgq47ImbECW5T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761693682; c=relaxed/simple;
	bh=INqNw4IRVkMd5w43l0qPt40Ez645q2FXxrjHhPbttyo=;
	h=Date:To:From:Subject:Message-Id; b=tYs6YyUd7cAVIlUNHzyGIHCdeoEU3EOtM+0L2KAiJUP626wHzXijikiu1FCRhges8HceAjMAkuS2hmG4WNVd7cJtckz7wVMtmheqaSeGWQUgd244uEhp//jEz9kM0lBdH1xRVA+jriw9nc8LjZ8zt3LquPTK22Yk5YYKhWlijYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zRxqVPwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zRxqVPwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83611C4CEE7;
	Tue, 28 Oct 2025 23:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761693682;
	bh=INqNw4IRVkMd5w43l0qPt40Ez645q2FXxrjHhPbttyo=;
	h=Date:To:From:Subject:From;
	b=zRxqVPwu+1Ho4knGdcg3lVD4x2li7ugwnQ9yDujFUp3BA1YNDFit8v/abt6g5HAbA
	 e0DIxZiiU5Nkn+wkyQseWD2e///ga+M7hxuL+mdmcb/+xAVlzi5JNADvpATwfBon+U
	 22con67D+3qXMPaeAjyHDeKumrgkOTdv0tkpcCxM=
Date: Tue, 28 Oct 2025 16:21:21 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-cl_bpc-in-allocator-inodes-to-prevent-divide-by-zero.patch added to mm-nonmm-unstable branch
Message-Id: <20251028232122.83611C4CEE7@smtp.kernel.org>
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
Date: Tue, 28 Oct 2025 09:59:19 +0530

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

Instead of a kernel crash.

Link: https://lore.kernel.org/ocfs2-devel/20251026132625.12348-1-kartikey406@gmail.com/T/#u [v1]
Link: https://lore.kernel.org/all/20251027124131.10002-1-kartikey406@gmail.com/T/ [v2]
Link: https://lkml.kernel.org/r/20251028042919.18704-1-kartikey406@gmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fd8af97c7227fe605d95
Tested-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-validate-cl_bpc-in-allocator-inodes-to-prevent-divide-by-zero
+++ a/fs/ocfs2/inode.c
@@ -1512,6 +1512,21 @@ int ocfs2_validate_inode_block(struct su
 				 le32_to_cpu(di->i_clusters));
 		goto bail;
 	}
+	/* Validate cl_bpc for chain allocator inodes */
+	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
+		struct ocfs2_chain_list *cl = &di->id2.i_chain;
+		u16 cl_bpc = le16_to_cpu(cl->cl_bpc);
+		u16 expected_bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits -
+					 sb->s_blocksize_bits);
+
+		if (cl_bpc != expected_bpc) {
+			rc = ocfs2_error(sb,
+				"Inode %llu has corrupted cl_bpc: ondisk=%u expected=%u\n",
+				(unsigned long long)bh->b_blocknr,
+				cl_bpc, expected_bpc);
+			goto bail;
+		}
+	}
 
 	rc = 0;
 
_

Patches currently in -mm which might be from kartikey406@gmail.com are

ocfs2-validate-cl_bpc-in-allocator-inodes-to-prevent-divide-by-zero.patch

