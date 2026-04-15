Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8022330D4C
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 09:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244562; cv=none; b=NnUE2qhWfe9ng8a0yNpbwklWvz4M0cbLA5NRJqBCB8E8lrSm/TOhuwd3aLE/EI2RmjvRWmrovIy0k5xIsaWpZDJT2Vw7mpzK6M6iwQj4IVDOdpo7MnItOYI7WmhXL6EXGoFUzsws9DDvVmZ5uurhWBmxRKSCIFbs23fHkD0BsYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244562; c=relaxed/simple;
	bh=FovA4bOQm6B2DIQYiFM4qYUc3a7gEYF51U0HM0MmPao=;
	h=Date:To:From:Subject:Message-Id; b=Z1bWtOX64p2bIMtbsjWSrjDSGxBjroXIANhGvRF5bDFmQwNV/8EWseAcwv5lXF5p7k+cKk4ANvB/k0U4DWA+ZyvMt7LpWrLAPILONBUOOga/NJCC2H9XHo2jjbfVSapo7ITOAOy5Fm5l63KtQfQ6KwYNFIaDORC7LQ0S/1TMMjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ym9akg4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ym9akg4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76C4C19424;
	Wed, 15 Apr 2026 09:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776244562;
	bh=FovA4bOQm6B2DIQYiFM4qYUc3a7gEYF51U0HM0MmPao=;
	h=Date:To:From:Subject:From;
	b=ym9akg4lqTfJB+mGSZOKMzzwXm9BVDri5PvmFuU8slUoGttoMbw+t158VPO2hn3Aa
	 rpvO3vDsg8X7O5sSNdyaGvWpFdUM5lEb7sKAFBw0mY+EHezWurd5y8YviHPQlKP2QY
	 o3NIKtyNQPljTJ3pES32TYoEMo47U905v2GZIdN0=
Date: Wed, 15 Apr 2026 02:15:58 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-bg_list-extent-bounds-in-discontig-groups.patch removed from -mm tree
Message-Id: <20260415091601.C76C4C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate bg_list extent bounds in discontig groups
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-bg_list-extent-bounds-in-discontig-groups.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhengYuan Huang <gality369@gmail.com>
Subject: ocfs2: validate bg_list extent bounds in discontig groups
Date: Wed, 1 Apr 2026 10:16:22 +0800

[BUG]
Running ocfs2 on a corrupted image with a discontiguous block
group whose bg_list.l_next_free_rec is set to an excessively
large value triggers a KASAN use-after-free crash:

BUG: KASAN: use-after-free in ocfs2_bg_discontig_fix_by_rec fs/ocfs2/suballoc.c:1678 [inline]
BUG: KASAN: use-after-free in ocfs2_bg_discontig_fix_result+0x4a4/0x560 fs/ocfs2/suballoc.c:1715
Read of size 4 at addr ffff88801a85f000 by task syz.0.115/552

Call Trace:
 ...
 __asan_report_load4_noabort+0x14/0x30 mm/kasan/report_generic.c:380
 ocfs2_bg_discontig_fix_by_rec fs/ocfs2/suballoc.c:1678 [inline]
 ocfs2_bg_discontig_fix_result+0x4a4/0x560 fs/ocfs2/suballoc.c:1715
 ocfs2_search_one_group fs/ocfs2/suballoc.c:1752 [inline]
 ocfs2_claim_suballoc_bits+0x13c3/0x1cd0 fs/ocfs2/suballoc.c:1984
 ocfs2_claim_new_inode+0x2e7/0x8a0 fs/ocfs2/suballoc.c:2292
 ocfs2_mknod_locked.constprop.0+0x121/0x2a0 fs/ocfs2/namei.c:637
 ocfs2_mknod+0xc71/0x2400 fs/ocfs2/namei.c:384
 ocfs2_create+0x158/0x390 fs/ocfs2/namei.c:676
 lookup_open.isra.0+0x10a1/0x1460 fs/namei.c:3796
 open_last_lookups fs/namei.c:3895 [inline]
 path_openat+0x11fe/0x2ce0 fs/namei.c:4131
 do_filp_open+0x1f6/0x430 fs/namei.c:4161
 do_sys_openat2+0x117/0x1c0 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_openat fs/open.c:1468 [inline]
 ...

[CAUSE]
ocfs2_bg_discontig_fix_result() iterates over bg->bg_list.l_recs[]
using l_next_free_rec as the upper bound without any sanity check:

  for (i = 0; i < le16_to_cpu(bg->bg_list.l_next_free_rec); i++) {
          rec = &bg->bg_list.l_recs[i];

l_next_free_rec is read directly from the on-disk group descriptor and
is trusted blindly. On a 4 KiB block device, bg_list.l_recs[] can hold
at most 235 entries (ocfs2_extent_recs_per_gd(sb)). A corrupted or
crafted filesystem image can set l_next_free_rec to an arbitrarily
large value, causing the loop to index past the end of the group
descriptor buffer_head data page and into an adjacent freed page.

[FIX]
Validate discontiguous bg_list.l_count against
ocfs2_extent_recs_per_gd(sb), then reject l_next_free_rec values that
exceed l_count. This keeps the on-disk extent list self-consistent and
matches how the rest of ocfs2 uses l_count as the extent-list bound.

Link: https://lkml.kernel.org/r/20260401021622.3560952-1-gality369@gmail.com
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/fs/ocfs2/suballoc.c~ocfs2-validate-bg_list-extent-bounds-in-discontig-groups
+++ a/fs/ocfs2/suballoc.c
@@ -197,6 +197,31 @@ static int ocfs2_validate_gd_self(struct
 			 8 * le16_to_cpu(gd->bg_size));
 	}
 
+	/*
+	 * For discontiguous block groups, validate the on-disk extent list
+	 * against the maximum number of extent records that can physically
+	 * fit in a single block.
+	 */
+	if (ocfs2_gd_is_discontig(gd)) {
+		u16 max_recs = ocfs2_extent_recs_per_gd(sb);
+		u16 l_count = le16_to_cpu(gd->bg_list.l_count);
+		u16 l_next_free_rec = le16_to_cpu(gd->bg_list.l_next_free_rec);
+
+		if (l_count != max_recs) {
+			do_error("Group descriptor #%llu bad discontig l_count %u expected %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 l_count,
+				 max_recs);
+		}
+
+		if (l_next_free_rec > l_count) {
+			do_error("Group descriptor #%llu bad discontig l_next_free_rec %u max %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 l_next_free_rec,
+				 l_count);
+		}
+	}
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from gality369@gmail.com are


