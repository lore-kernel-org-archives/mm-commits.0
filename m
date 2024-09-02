Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA0C14F9F8
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248831; cv=none; b=kNDzasU/XXmBz/MCWmb4lmlDDetDWkCbEel7J22PvPdYT/iCEMJeFSWixwnAu6l/ahpZ9irGepbz8jrlLkG3gAS9quzZUtFJAlPzhopNce7dgKesZUngkGRhkaz1kRF5p6kl9m+XKAUI7tOmYqBAfQpX/CFo+3hFK7FyrCvW30E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248831; c=relaxed/simple;
	bh=aJPMuTZDSca5W444mBSF0nRD2jEUteb7n7M+SvkFIDA=;
	h=Date:To:From:Subject:Message-Id; b=if7PYIqQS4+Xg7355bGLwf1O3FLOolaGnV3FHAJxffLpLjyTJv/gLrBE/27ON4+PDas+RXSqlew1IqFxpXYFPmrt18TIyv/dg9Voia7uMM8k6IdVRVhYLN4oA7edbze1LRNLnPKiW8W7rYyD7w8bus6h5lNqAYH7V07d4UqgrMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hZaMK7qM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hZaMK7qM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F42C4CEC2;
	Mon,  2 Sep 2024 03:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248830;
	bh=aJPMuTZDSca5W444mBSF0nRD2jEUteb7n7M+SvkFIDA=;
	h=Date:To:From:Subject:From;
	b=hZaMK7qMayk3peskhkIFgJJa3xKVUsda7R4SnEbILasqWWkWrWGt2BJVe1ic55TH+
	 rBBiev60zprcOMyax8PVi6TW7937V3XG2gfSL1i+Qnw6Z3x+L2/GSeNkfLRfhsJG+R
	 U7eOf2bKWQRksi3WiMi06wJyYZ8ooA2/J20RSa0g=
Date: Sun, 01 Sep 2024 20:47:10 -0700
To: mm-commits@vger.kernel.org,zhangshida@kylinos.cn,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-unexpected-zeroing-of-virtual-disk.patch removed from -mm tree
Message-Id: <20240902034710.D7F42C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix unexpected zeroing of virtual disk
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-unexpected-zeroing-of-virtual-disk.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


