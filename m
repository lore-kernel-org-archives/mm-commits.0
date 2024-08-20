Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11911487F1
	for <mm-commits@vger.kernel.org>; Tue, 20 Aug 2024 05:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724131298; cv=none; b=gB9XZ9x1ZMlf0SNjQ4+7BY7xgHSSdcUDIfflTX8ork2IohmB4GOfn0/sp/TG+7krAtQyue1fvgB50Ui29RDPIHwFc9jVGvmSvmB2zzEVKLQ/tZdPcCplbx41XQvxkJXHX7H3/GPVm7ej0ga6bJi7VX95+eRzJHOT+8g9JiFxGzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724131298; c=relaxed/simple;
	bh=9mrp2g1L73OInVnismBPNBk/NHGYiqKV4Oagr4KP0rM=;
	h=Date:To:From:Subject:Message-Id; b=WcT/Hls9JCwSmCbMwXH8h2XJJGsmKyYkoMah094tyCySiCDTzJll3yl7TXVcTa6Z3QcgLsyR53idoS5hmmQN8/EjNofRtWhczoX/zrGr0UhOrd2bRYutkgj/8nc6urAHhM5Q8XpkY/l5pgWlAIQBWcRyj6xHmrXr6GfsUeAbYg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QxI8w5pZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QxI8w5pZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420DAC4AF09;
	Tue, 20 Aug 2024 05:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724131298;
	bh=9mrp2g1L73OInVnismBPNBk/NHGYiqKV4Oagr4KP0rM=;
	h=Date:To:From:Subject:From;
	b=QxI8w5pZHkk/L73KQ4hl7gNg+LB4Z32hXXPojViLU/aTR/SFNGTak54B4gWhZaBJK
	 V3eR72cGziiNqDz8FU8Z6FdmcuNBrwJusfT1Zmclw35vdovPG/Uj+8SAMOBWCqQXp1
	 0WKgVY0fvvRaz7XWY76BXRMX5lljhSseJuOdaj7I=
Date: Mon, 19 Aug 2024 22:21:37 -0700
To: mm-commits@vger.kernel.org,zhangshida@kylinos.cn,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-unexpected-zeroing-of-virtual-disk.patch added to mm-nonmm-unstable branch
Message-Id: <20240820052138.420DAC4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix unexpected zeroing of virtual disk
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-unexpected-zeroing-of-virtual-disk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-unexpected-zeroing-of-virtual-disk.patch

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
From: Chi Zhiling <chizhiling@kylinos.cn>
Subject: ocfs2: fix unexpected zeroing of virtual disk
Date: Thu, 15 Aug 2024 17:21:41 +0800

In a guest virtual machine, we found that there is unexpected data zeroing
problem detected occassionly:

XFS (vdb): Mounting V5 Filesystem
XFS (vdb): Ending clean mount
XFS (vdb): Metadata CRC error detected at xfs_refcountbt_read_verify+0x2c/0xf0, xfs_refcountbt block 0x200028
XFS (vdb): Unmount and run xfs_repair
XFS (vdb): First 128 bytes of corrupted metadata buffer:
00000000e0cd2f5e: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000000cafd57f5: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000000d0298d7d: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000000f0698484: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000000adb789a7: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
000000005292b878: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000000885b4700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000000fd4b4df7: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
XFS (vdb): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x200028 len 8 error 74
XFS (vdb): Error -117 recovering leftover CoW allocations.
XFS (vdb): xfs_do_force_shutdown(0x8) called from line 994 of file fs/xfs/xfs_mount.c.  Return address = 000000003a53523a
XFS (vdb): Corruption of in-memory data detected.  Shutting down filesystem
XFS (vdb): Please umount the filesystem and rectify the problem(s)

It turns out that the root cause is from the physical host machine.  More
specifically, it is caused by the ocfs2.

when the page_size is 64k, the block should advance by 16 each time
instead of 1.  This will lead to a wrong mapping from the page to the
disk, which will zero some adjacent part of the disk.

Link: https://lkml.kernel.org/r/20240815092141.1223238-1-chizhiling@163.com
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Suggested-by: Shida Zhang <zhangshida@kylinos.cn>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/aops.c~ocfs2-fix-unexpected-zeroing-of-virtual-disk
+++ a/fs/ocfs2/aops.c
@@ -1187,7 +1187,7 @@ static int ocfs2_write_cluster(struct ad
 
 		/* This is the direct io target page. */
 		if (wc->w_pages[i] == NULL) {
-			p_blkno++;
+			p_blkno += (1 << (PAGE_SHIFT - inode->i_sb->s_blocksize_bits));
 			continue;
 		}
 
_

Patches currently in -mm which might be from chizhiling@kylinos.cn are

ocfs2-fix-unexpected-zeroing-of-virtual-disk.patch

