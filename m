Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB49357D08
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 22:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788648385; cv=none; b=Ym3lcHhHG6wvcqzdc8wcry79LHOUpauBmRc+3Sv+Yc7WfAFtwtkTkkD3WsflB4Gx5MHKg2kR1NmQFaryudrJjXWPYMQ9JqKyB52jzVD6eR9Q7MCUE0d7F/spWcVf/UJmc15syye1FTbxXchEMCAljnnkKmuwDZzPAoZoR1HZsJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788648385; c=relaxed/simple;
	bh=myrgu3l6sQx0iITMKNwqY+IIYUlny9/uM9IqEeWmmlc=;
	h=Date:To:From:Subject:Message-Id; b=cD0EQigJqLBGUC7dB8c7IygIYOvNAWyPHL7Y00sVXV2vIZvfceDyo1S/BNFuI4Wfd5UG/ryDp4Hxw5PIUmEFG4Etq0nfCKZlXR8Vmwreb/ATRrMC284iR0XFibwdrfzeFacxrnY+0xxip6M0/1Aznh757NO6FsFaCdHpbqRFqqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PfD/31z9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PfD/31z9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481631F00A3D;
	Sat,  5 Sep 2026 22:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788648384;
	bh=+UOq76BJzKe94CrraYSlIXPo4pkJ+nm/+VNMHCTwVE8=;
	h=Date:To:From:Subject;
	b=PfD/31z9KaUVq9JSpoEBSLqJD34KY8po9vLbDzskcD74U6gAbUkUC3H1kl87pnEcI
	 9kJkpd8Tfh4EOkk2Xyb38GVzPVEdqj2GSKFA84VUkC9inwO1iTaD32jPhfXjEmmqtd
	 oTtzfpefeVTBCFp+NtqNWEy2/1iBr0GwkdqcZJS8=
Date: Sat, 05 Sep 2026 15:46:23 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-dr_fs_generation-of-dir-index-root-blocks.patch added to mm-nonmm-unstable branch
Message-Id: <20260905224624.481631F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate dr_fs_generation of dir index root blocks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-dr_fs_generation-of-dir-index-root-blocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-dr_fs_generation-of-dir-index-root-blocks.patch

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
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: validate dr_fs_generation of dir index root blocks
Date: Sat, 5 Sep 2026 22:21:43 +0800

ocfs2_validate_dx_root() does not verify dr_fs_generation against the
superblock generation, unlike the extent and xattr block validators which
check h_fs_generation and xb_fs_generation respectively.  The field is
documented as "Must match super block".

Without the check, a stale dir index root block left on the device from
a previously formatted filesystem at the same physical block number can
pass validation as long as its signature, dr_blkno and checksum match.
Its index entries and suballocator information would then be used in
the new filesystem context.

Reject dir index root blocks whose dr_fs_generation does not match the
mounted filesystem, like the extent and xattr block validators do.

Link: https://lore.kernel.org/20260905142144.2869105-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/dir.c~ocfs2-validate-dr_fs_generation-of-dir-index-root-blocks
+++ a/fs/ocfs2/dir.c
@@ -613,6 +613,14 @@ static int ocfs2_validate_dx_root(struct
 		goto bail;
 	}
 
+	if (le32_to_cpu(dx_root->dr_fs_generation) != OCFS2_SB(sb)->fs_generation) {
+		ret = ocfs2_error(sb,
+				  "Dir Index Root # %llu has an invalid dr_fs_generation of #%u\n",
+				  (unsigned long long)bh->b_blocknr,
+				  le32_to_cpu(dx_root->dr_fs_generation));
+		goto bail;
+	}
+
 	/*
 	 * Dir index root blocks are allocated from a per-slot suballocator,
 	 * so the slot must be in range.  Otherwise removing the index passes
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-make-ocfs2_calc_xattr_init-return-void.patch
ocfs2-fix-deadlock-in-inline-data-truncate-transactions.patch
ocfs2-exit-recovery-thread-on-mount-error-path.patch
ocfs2-free-replay-slots-in-ocfs2_recovery_exit.patch
ocfs2-defer-suballocator-block-group-reclaim-to-workqueue.patch
ocfs2-restrict-ocfs2_invalid_slot-suballoc-slot-to-system-inodes.patch
ocfs2-validate-suballoc-bit-during-inode-read.patch
ocfs2-validate-suballoc-slot-and-bit-of-xattr-and-dir-index-blocks.patch
ocfs2-validate-suballoc-slot-and-bit-of-extent-and-refcount-blocks.patch
ocfs2-allow-xattr-bucket-entries-to-span-multiple-blocks.patch
ocfs2-reject-inconsistent-xattr-bucket-during-defrag.patch
ocfs2-skip-uninitialized-lockres-in-ocfs2_mark_lockres_freeing.patch
ocfs2-validate-dr_fs_generation-of-dir-index-root-blocks.patch
ocfs2-validate-dl_blkno-and-dl_fs_generation-of-dir-index-leaf-blocks.patch

