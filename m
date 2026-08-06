Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755DA47F761
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 20:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786048191; cv=none; b=ndUTRVPqTYd5jr9IjDV7a0YLDBsQ+0AI5LB4oUPSppqamm7IIjuDkNDZ299l+LnFALRVGW+5QXkcvyFqWaspRGuZCvS28M2YMAysm68T8pSP14Kk4b/37658EHJTSZpjNwRuxGut66w3VAeNPdpLjaAjWj+w6hm/Op4vhartDC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786048191; c=relaxed/simple;
	bh=kH9iSZ0vU+eyafB3R1C5xKgJ7x/eZoA33Uy5NBvUrf4=;
	h=Date:To:From:Subject:Message-Id; b=hpIztVNY5kzo+5doY+P1iLmtdhcJCpaaoRAVLgA49TCsIF7JOMrZgIY8Y8KOiMPJthODA4aDNRpcmP8Lz6FQhLfsH1pLI3IY4CWoWaKnf+BFPIDnXh9Z76hFdcREEoErfvNqWamQWLf1nmQolOPp8I/Ps9uCjpivyoOH/xnPVIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h+stQfox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h+stQfox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3693E1F000E9;
	Thu,  6 Aug 2026 20:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786048190;
	bh=XEiuc+7hcqHvO18AqRlVdLHt8D3PmgybQ6o4Hc+W3dI=;
	h=Date:To:From:Subject;
	b=h+stQfoxIQmyKf9NFlxXYoaBgz2psOdnh0NP8tjrlot0JMsikqoG6LU6jP3aYVcrn
	 VSiM+tx0dkylHvf3V0S04RC3zQ8bYN8kCx0NMICcIEc5JHujeTI6xa031kZLKsbknF
	 45pA07S5gWO0fGwYsxWOMXp5IoJ+rp5YJsiCvVVE=
Date: Thu, 06 Aug 2026 13:29:49 -0700
To: mm-commits@vger.kernel.org,zhanxusheng@xiaomi.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,zhanxusheng1024@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-bound-check-dir-entries-in-the-readdir-re-validation-scan.patch added to mm-nonmm-unstable branch
Message-Id: <20260806202950.3693E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: bound-check dir entries in the readdir re-validation scan
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-bound-check-dir-entries-in-the-readdir-re-validation-scan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-bound-check-dir-entries-in-the-readdir-re-validation-scan.patch

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
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
Subject: ocfs2: bound-check dir entries in the readdir re-validation scan
Date: Thu, 6 Aug 2026 20:21:33 +0800

When the inode version changed since the last readdir(),
ocfs2_dir_foreach_blk_el() re-scans the directory block from its start to
relocate the current position:

	for (i = 0; i < sb->s_blocksize && i < offset; ) {
		de = (struct ocfs2_dir_entry *)(bh->b_data + i);
		if (le16_to_cpu(de->rec_len) < OCFS2_DIR_REC_LEN(1))
			break;
		i += le16_to_cpu(de->rec_len);
	}

The loop dereferences de->rec_len (at byte offset 8 within the entry)
guarded only by i < sb->s_blocksize.  `offset` is derived from ctx->pos,
which userspace controls via lseek() on the directory fd, so i can reach
the last bytes of the block; reading de->rec_len then reads a few bytes
past the s_blocksize-sized block buffer (an out-of-bounds read).

The main emit loop below already guards this via ocfs2_check_dir_entry(),
which rejects entries too close to the buffer end before touching de. 
Apply the same lower bound to the re-validation scan so that a full
minimal directory entry is known to fit before de is dereferenced.  For a
consistent directory this changes nothing: entries are at least
OCFS2_DIR_REC_LEN(1) bytes, so no valid entry starts in the excluded tail.

Found by the sashiko review tool; fix approach suggested by Joseph Qi.

Link: https://lore.kernel.org/20260806122133.956847-1-zhanxusheng@xiaomi.com
Link: https://sashiko.dev/#/patchset/20260806022044.167962-1-zhanxusheng@xiaomi.com
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/dir.c~ocfs2-bound-check-dir-entries-in-the-readdir-re-validation-scan
+++ a/fs/ocfs2/dir.c
@@ -1945,7 +1945,8 @@ static int ocfs2_dir_foreach_blk_el(stru
 		 * dirent right now.  Scan from the start of the block
 		 * to make sure. */
 		if (!inode_eq_iversion(inode, *f_version)) {
-			for (i = 0; i < sb->s_blocksize && i < offset; ) {
+			for (i = 0; i + OCFS2_DIR_REC_LEN(1) <= sb->s_blocksize &&
+			     i < offset;) {
 				de = (struct ocfs2_dir_entry *) (bh->b_data + i);
 				/* It's too expensive to do a full
 				 * dirent test each time round this
_

Patches currently in -mm which might be from zhanxusheng1024@gmail.com are

maple_tree-remove-unused-mas_is_root_limits.patch
ocfs2-fix-readdir-position-truncation-on-32-bit-kernels.patch
ocfs2-bound-check-dir-entries-in-the-readdir-re-validation-scan.patch

