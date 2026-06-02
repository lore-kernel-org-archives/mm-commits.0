Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE24317162
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 21:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780434130; cv=none; b=YAeaRuMbipqeqkBXh2LDm2WDKjWXI/RRBWXWweoq+ijXsZJuj68fHIse0hJSbJ/rFxwQCwGBtWNaguqYQqr/eHEGTDB1JGpHfAy211ojhKpPAlnJxhe0j7IW2ZF+RVvPyeudiJAcrQh97zx2fYXiG/5SW0m2A0+xyy9hXLmMjr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780434130; c=relaxed/simple;
	bh=dSCzWV1Qb1eXMsFFzTsBOHLBe68WxOshnA88a2C9XpU=;
	h=Date:To:From:Subject:Message-Id; b=I+jOi024Fgr+EL1sf2VGh7ImRqP4MjQEFLjMGaZwpyhSige3l5TyCIIvi5Y6eqko2kzYXp5dGFO721fTLo3454T56nT5Cd939/XyoNRZK66BkHOok2vCzAZkBO0/22Gr4nFS5nFCXD7kieNDFcTaRUvDhGjrdjg/Vy0Y77tzLIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F42nTkuj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F42nTkuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2AF1F00893;
	Tue,  2 Jun 2026 21:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780434128;
	bh=+RhHhz5jNQihw3tIAudlLgH3R1stOXNh+pcTMrQYJKE=;
	h=Date:To:From:Subject;
	b=F42nTkujTSpLRGfbJ7TXWD+l0Vth/jdBsTeeSK2vQFvW/R4+lVdNOzN3Cg5pZN0jZ
	 JIdG4Mub8jjcAhfFprC4BajPm4zMtGEfa3AV8uLih9fU2IgxPn5+5QyooiP31xZLVI
	 j8YoocTyRJtbxCGm98dJbinQqBJQ7ybNT2o+3nao=
Date: Tue, 02 Jun 2026 14:02:08 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,icb@fastmail.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-out-of-bounds-write-in-ocfs2_remove_refcount_extent.patch added to mm-nonmm-unstable branch
Message-Id: <20260602210208.8D2AF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix out-of-bounds write in ocfs2_remove_refcount_extent
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-out-of-bounds-write-in-ocfs2_remove_refcount_extent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-out-of-bounds-write-in-ocfs2_remove_refcount_extent.patch

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
From: Ian Bridges <icb@fastmail.org>
Subject: ocfs2: fix out-of-bounds write in ocfs2_remove_refcount_extent
Date: Mon, 1 Jun 2026 13:44:33 -0500

[BUG]
Unlinking a refcounted file whose refcount tree has leaf blocks
triggers a fortify panic due to an out-of-bounds write.

[CAUSE]
When the last leaf block is removed from a refcount tree,
ocfs2_remove_refcount_extent() converts the root back to leaf mode
with a bulk memset on &rb->rf_records. rf_records sits in an anonymous
union with rf_list. rf_list.l_tree_depth aliases rf_records.rl_count,
and is 0 for a single-level tree. With rl_count equal to 0, the memset
writes past the 16-byte declared size of rf_records, which the fortify
checker catches.

[FIX]
Replace the bulk memset on &rb->rf_records with a correctly-bounded
memset on rl_recs[] alone, after setting rl_count to the correct value.

Link: https://lore.kernel.org/ah3TESOsEO9j_JLU@dev
Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")
Signed-off-by: Ian Bridges <icb@fastmail.org>
Reported-by: syzbot+3ef989aae096b30f1663@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3ef989aae096b30f1663
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/refcounttree.c~ocfs2-fix-out-of-bounds-write-in-ocfs2_remove_refcount_extent
+++ a/fs/ocfs2/refcounttree.c
@@ -2131,10 +2131,15 @@ static int ocfs2_remove_refcount_extent(
 		rb->rf_flags = 0;
 		rb->rf_parent = 0;
 		rb->rf_cpos = 0;
-		memset(&rb->rf_records, 0, sb->s_blocksize -
-		       offsetof(struct ocfs2_refcount_block, rf_records));
+		rb->rf_records.rl_used = 0;
+		rb->rf_records.rl_reserved2 = 0;
+		rb->rf_records.rl_reserved1 = 0;
+		/* rl_count determines the memset size and fortify object size. */
 		rb->rf_records.rl_count =
 				cpu_to_le16(ocfs2_refcount_recs_per_rb(sb));
+		memset(rb->rf_records.rl_recs, 0,
+		       le16_to_cpu(rb->rf_records.rl_count) *
+		       sizeof(*rb->rf_records.rl_recs));
 	}
 
 	ocfs2_journal_dirty(handle, ref_root_bh);
_

Patches currently in -mm which might be from icb@fastmail.org are

ocfs2-fix-out-of-bounds-write-in-ocfs2_remove_refcount_extent.patch

