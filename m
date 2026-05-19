Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C873EA96D;
	Tue, 19 May 2026 17:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779212716; cv=none; b=QOQQj8m1+T5UVmRGf3ApZAgopf6KPsA1N9HAmaY79YHTvENV1/bM2kwBQe9l6zcWEgPYa+WiY8GCV2dl1wPQaRhr7WpwjXP7ffVDCEEe8ogsd0l7kenNOcJJl5NfrRrjvWfP2zkFvr4zZewkx8AOkclatbOE6HWnGrApO3jo7Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779212716; c=relaxed/simple;
	bh=By6wmNdWkSXZ2lU25eN5K4Fud2I3rTrNI+YdOHXdyRE=;
	h=Date:To:From:Subject:Message-Id; b=jhiC2s71QQoItIL1myp13Ss0CrilfztDbIo9jT2BmLhg6C2Us2xlCUabNzW3s68y+piSq1XCP4B88VJpihnHXnoEMwWoThOLbSrGf65AjfopOdgg0xCQLFfjEfquJ0TE6xluzcEHEbpCp8bgQtmELkPyOWjln+eJKMrtITmWNPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NObITNLE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NObITNLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6392C2BCB3;
	Tue, 19 May 2026 17:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779212716;
	bh=By6wmNdWkSXZ2lU25eN5K4Fud2I3rTrNI+YdOHXdyRE=;
	h=Date:To:From:Subject:From;
	b=NObITNLE8MekYiBRDx5nocUrTBioivCJCn8VgvMaa7QGe+rhYO4GXAJqbSxEU5/kd
	 4GYcxbqlQXM0t6DmLmHurymvzWN/AOJX9/f7lGA8eCjyUgOOBIytzBGmu9TBjY2lRF
	 lXR0x9sXDg4B7769SZnW67+VtjYMAtVJsFAfX55E=
Date: Tue, 19 May 2026 10:45:15 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,michael.bommarito@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-reject-dinodes-whose-i_rdev-disagrees-with-the-file-type.patch added to mm-nonmm-unstable branch
Message-Id: <20260519174515.E6392C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: reject dinodes whose i_rdev disagrees with the file type
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-reject-dinodes-whose-i_rdev-disagrees-with-the-file-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-reject-dinodes-whose-i_rdev-disagrees-with-the-file-type.patch

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
From: Michael Bommarito <michael.bommarito@gmail.com>
Subject: ocfs2: reject dinodes whose i_rdev disagrees with the file type
Date: Tue, 19 May 2026 07:04:03 -0400

id1.dev1.i_rdev is the device-number arm of the ocfs2_dinode id1 union. 
It is only meaningful for character and block device inodes.  For any
other user-visible file type the on-disk value must be zero.

ocfs2_populate_inode() currently copies id1.dev1.i_rdev into inode->i_rdev
before the S_IFMT switch decides whether the inode is a special file.  A
non-device inode with a non-zero i_rdev can therefore publish stale or
attacker-controlled device state into the in-core inode.

System inodes legitimately use other arms of the same union, so keep the
cross-check restricted to non-system inodes.  Factor that predicate into a
helper and use it in both the normal validator and online filecheck path;
filecheck reports the malformed dinode through
OCFS2_FILECHECK_ERR_INVALIDINO instead of ocfs2_error().

Link: https://lore.kernel.org/20260519110404.1803902-3-michael.bommarito@gmail.com
Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   55 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-reject-dinodes-whose-i_rdev-disagrees-with-the-file-type
+++ a/fs/ocfs2/inode.c
@@ -72,6 +72,16 @@ static bool ocfs2_valid_inode_mode(umode
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
 }
 
+static bool ocfs2_dinode_has_unexpected_rdev(struct ocfs2_dinode *di)
+{
+	umode_t mode = le16_to_cpu(di->i_mode);
+
+	if (le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL)
+		return false;
+
+	return !S_ISCHR(mode) && !S_ISBLK(mode) && di->id1.dev1.i_rdev != 0;
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1518,6 +1528,41 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	/*
+	 * id1.dev1.i_rdev is the device-number arm of the id1 union and
+	 * is only meaningful for character and block device inodes.  For
+	 * any other regular user-visible file type the on-disk value
+	 * must be zero.  ocfs2_populate_inode() currently runs
+	 *
+	 *     inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
+	 *
+	 * unconditionally, before the S_IFMT switch decides whether the
+	 * inode is a special file.  As a result, an i_rdev value present
+	 * on a non-device inode is silently published into the in-core
+	 * inode; a subsequent forced re-read or in-core mode mutation
+	 * (cluster peer with raw write access to the shared LUN,
+	 * on-disk corruption, or a separately forged dinode) can then
+	 * expose the attacker-controlled device number to
+	 * init_special_inode() without ever showing an unusual i_mode
+	 * at validation time.
+	 *
+	 * System inodes (OCFS2_SYSTEM_FL) legitimately use the bitmap1
+	 * and journal1 arms of the same union (allocator i_used /
+	 * i_total counters and the journal ij_flags /
+	 * ij_recovery_generation pair); those bytes are not an i_rdev
+	 * and must not be checked here.  Restrict the cross-check to
+	 * non-system inodes, which is the full attacker-controllable
+	 * surface.
+	 */
+	if (ocfs2_dinode_has_unexpected_rdev(di)) {
+		rc = ocfs2_error(sb,
+				 "Invalid dinode #%llu: non-device mode 0%o with i_rdev %llu\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_mode),
+				 (unsigned long long)le64_to_cpu(di->id1.dev1.i_rdev));
+		goto bail;
+	}
+
 	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
@@ -1657,6 +1702,16 @@ static int ocfs2_filecheck_validate_inod
 		     (unsigned long long)bh->b_blocknr,
 		     le16_to_cpu(di->i_mode));
 		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_unexpected_rdev(di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: non-device mode 0%o with i_rdev %llu\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_mode),
+		     (unsigned long long)le64_to_cpu(di->id1.dev1.i_rdev));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
 	}
 
 bail:
_

Patches currently in -mm which might be from michael.bommarito@gmail.com are

ocfs2-reject-dinodes-with-non-canonical-i_mode-type.patch
ocfs2-reject-dinodes-whose-i_rdev-disagrees-with-the-file-type.patch
ocfs2-reject-non-inline-dinodes-with-i_size-and-zero-i_clusters.patch

