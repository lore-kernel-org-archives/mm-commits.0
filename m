Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069A7F507
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 09:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244621; cv=none; b=qMBpYO1isNPdXaDMQnfyNukiN/wAhi4grQeQc/rx/MfsamD50jopN1OVX89d9rNSPEBuWxQRBdZwlJDDx62h1T0A+GuldUK4XSK86rS8BHDcd7Xib/7aWf7h2fkY4HWqukMyUhE06skP6A3rfWyIftMlY5B5/xAfIg4KKDHi45I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244621; c=relaxed/simple;
	bh=B5HTCn5tqaOeBpv8a2vWVN8AqY4OBk1KjwS3NgnI6jM=;
	h=Date:To:From:Subject:Message-Id; b=euIzshTjS3Vt5xGHJKkeyMDcbe8rORjo4TnCbHt67mACX7mebNsjZpymNO/naJStK93AgWflFTKtBuVVJ6PIaPWWaCt+wQalG8GU8iSDpXkeUY8pTxYI7gpKvc7B8icsi71oGd2kBfNW8V3N9hpAQx/+zoWoY/4hfh4xhwdcN4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dz1qqdTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dz1qqdTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471D3C19424;
	Wed, 15 Apr 2026 09:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776244620;
	bh=B5HTCn5tqaOeBpv8a2vWVN8AqY4OBk1KjwS3NgnI6jM=;
	h=Date:To:From:Subject:From;
	b=Dz1qqdTqfMjjJfXoxvo6MBc0G/XhKSAQ6MAc9BmrwnMv5ZFebUTW18QqfbwxnXcVa
	 P8vhw2gR9P7FPw8wcvMy11fRWLRvOhGo5+jpTijl7dN5Jyt1dC+u1LAF10o9XW77tm
	 9hOjNIOhToDkpWqDqm7gw21XpZ0uxweTb/WWYZ2c=
Date: Wed, 15 Apr 2026 02:16:56 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-bg_bits-during-freefrag-scan.patch removed from -mm tree
Message-Id: <20260415091700.471D3C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate bg_bits during freefrag scan
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-bg_bits-during-freefrag-scan.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhengYuan Huang <gality369@gmail.com>
Subject: ocfs2: validate bg_bits during freefrag scan
Date: Fri, 10 Apr 2026 11:42:20 +0800

[BUG]
A crafted filesystem can trigger an out-of-bounds bitmap walk when
OCFS2_IOC_INFO is issued with OCFS2_INFO_FL_NON_COHERENT.

BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:68 [inline]
BUG: KASAN: use-after-free in _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
BUG: KASAN: use-after-free in test_bit_le include/asm-generic/bitops/le.h:21 [inline]
BUG: KASAN: use-after-free in ocfs2_info_freefrag_scan_chain fs/ocfs2/ioctl.c:495 [inline]
BUG: KASAN: use-after-free in ocfs2_info_freefrag_scan_bitmap fs/ocfs2/ioctl.c:588 [inline]
BUG: KASAN: use-after-free in ocfs2_info_handle_freefrag fs/ocfs2/ioctl.c:662 [inline]
BUG: KASAN: use-after-free in ocfs2_info_handle_request+0x1c66/0x3370 fs/ocfs2/ioctl.c:754
Read of size 8 at addr ffff888031bce000 by task syz.0.636/1435
Call Trace:
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xbe/0x130 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xd1/0x650 mm/kasan/report.c:482
 kasan_report+0xfb/0x140 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:186 [inline]
 kasan_check_range+0x11c/0x200 mm/kasan/generic.c:200
 __kasan_check_read+0x11/0x20 mm/kasan/shadow.c:31
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
 test_bit_le include/asm-generic/bitops/le.h:21 [inline]
 ocfs2_info_freefrag_scan_chain fs/ocfs2/ioctl.c:495 [inline]
 ocfs2_info_freefrag_scan_bitmap fs/ocfs2/ioctl.c:588 [inline]
 ocfs2_info_handle_freefrag fs/ocfs2/ioctl.c:662 [inline]
 ocfs2_info_handle_request+0x1c66/0x3370 fs/ocfs2/ioctl.c:754
 ocfs2_info_handle+0x18d/0x2a0 fs/ocfs2/ioctl.c:828
 ocfs2_ioctl+0x632/0x6e0 fs/ocfs2/ioctl.c:913
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
 ...

[CAUSE]
ocfs2_info_freefrag_scan_chain() uses on-disk bg_bits directly as the
bitmap scan limit. The coherent path reads group descriptors through
ocfs2_read_group_descriptor(), which validates the descriptor before
use. The non-coherent path uses ocfs2_read_blocks_sync() instead and
skips that validation, so an impossible bg_bits value can drive the
bitmap walk past the end of the block.

[FIX]
Compute the bitmap capacity from the filesystem format with
ocfs2_group_bitmap_size(), report descriptors whose bg_bits exceeds
that limit, and clamp the scan to the computed capacity. This keeps the
freefrag report going while avoiding reads beyond the buffer.

Link: https://lkml.kernel.org/r/20260410034220.3825769-1-gality369@gmail.com
Fixes: d24a10b9f8ed ("Ocfs2: Add a new code 'OCFS2_INFO_FREEFRAG' for o2info ioctl.")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ioctl.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/ioctl.c~ocfs2-validate-bg_bits-during-freefrag-scan
+++ a/fs/ocfs2/ioctl.c
@@ -441,13 +441,16 @@ static int ocfs2_info_freefrag_scan_chai
 	struct buffer_head *bh = NULL;
 	struct ocfs2_group_desc *bg = NULL;
 
-	unsigned int max_bits, num_clusters;
+	unsigned int max_bits, max_bitmap_bits, num_clusters;
 	unsigned int offset = 0, cluster, chunk;
 	unsigned int chunk_free, last_chunksize = 0;
 
 	if (!le32_to_cpu(rec->c_free))
 		goto bail;
 
+	max_bitmap_bits = 8 * ocfs2_group_bitmap_size(osb->sb, 0,
+					      osb->s_feature_incompat);
+
 	do {
 		if (!bg)
 			blkno = le64_to_cpu(rec->c_blkno);
@@ -479,6 +482,19 @@ static int ocfs2_info_freefrag_scan_chai
 			continue;
 
 		max_bits = le16_to_cpu(bg->bg_bits);
+
+		/*
+		 * Non-coherent scans read raw blocks and do not get the
+		 * bg_bits validation from
+		 * ocfs2_read_group_descriptor().
+		 */
+		if (max_bits > max_bitmap_bits) {
+			mlog(ML_ERROR,
+			     "Group desc #%llu has %u bits, max bitmap bits %u\n",
+			     (unsigned long long)blkno, max_bits, max_bitmap_bits);
+			max_bits = max_bitmap_bits;
+		}
+
 		offset = 0;
 
 		for (chunk = 0; chunk < chunks_in_group; chunk++) {
_

Patches currently in -mm which might be from gality369@gmail.com are


