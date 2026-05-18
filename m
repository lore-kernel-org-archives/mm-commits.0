Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED51F285CA4;
	Mon, 18 May 2026 21:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779140467; cv=none; b=a1gaJPA+kmDpFwHRDC82yXeStBnsI5EWwlU82tr3uNZW84kSoqs6r8VVjVvdVn+N1obK3wAAJMDXfiLprHiq6lh88vTYdTsOenVQc6C//tdR9E+iLVI5Zh7Jv2EqQorWgZq7U/4acKL/BsHoa1zT+JK5xj3rtg7EMn7EWN+TVPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779140467; c=relaxed/simple;
	bh=Q1snxrkBhET8Q8x4xLWPbvI0BiCwxsKrZMqQlPrDeTw=;
	h=Date:To:From:Subject:Message-Id; b=Ef+oliNiT0xNxAtg7zAbyq/TTr6lM/i3jhcxHzUOJeXF/WwLWkVZcgAX6SWoHVjuMsCwdEfXELwbL07thEmSayJ9Zz5iVD9e2+0urssz7/wdYkzgBU1qoe0LMgZu+JR9ge7uR6Pvb0YfpSueLsszl8Rt1Vl3xsz1IIsbW7Eurvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EpkqXiYi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EpkqXiYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81280C2BCB7;
	Mon, 18 May 2026 21:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779140466;
	bh=Q1snxrkBhET8Q8x4xLWPbvI0BiCwxsKrZMqQlPrDeTw=;
	h=Date:To:From:Subject:From;
	b=EpkqXiYioXfY4/sm3zMAROUYUVv/b9z/0UkXYvG0M4H6m9Df6LpEqeuE26R8ltW15
	 JGOOkZyH7DAYCySdl10lE0mDF1mqMkqt4nRhd0gnQIBtcKiDrQgQuY4mRR6v0mehKo
	 v3GovhD74j5PmmJzOh0cMDCjuindp9B/9VNw9pDI=
Date: Mon, 18 May 2026 14:41:05 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,michael.bommarito@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-reject-dinodes-whose-i_rdev-disagrees-with-the-file-type.patch added to mm-nonmm-unstable branch
Message-Id: <20260518214106.81280C2BCB7@smtp.kernel.org>
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
Date: Sun, 17 May 2026 07:10:13 -0400

id1.dev1.i_rdev is the device-number arm of the ocfs2_dinode id1 union and
is only meaningful for character and block device inodes.  For any other
user-visible file type the on-disk value must be zero.

ocfs2_populate_inode() currently runs

    inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));

unconditionally, before the S_IFMT switch decides whether the inode is a
special file.  As a result, an i_rdev value present on a non-device inode
is silently published into the in-core inode.  A subsequent forced re-read
or in-core mode mutation (cluster peer with raw write access to the shared
LUN, on-disk corruption, or a separately forged dinode) can then expose
the attacker- controlled device number to init_special_inode() without
ever showing an unusual i_mode at validation time.

System inodes (OCFS2_SYSTEM_FL) legitimately use the bitmap1 and journal1
arms of the same union: allocator inodes encode i_used / i_total in the
bitmap1 arm and the journal encodes ij_flags / ij_recovery_generation in
the journal1 arm.  Those byte sequences are not an i_rdev and a non-zero
pattern there is the on-disk norm, not an integrity violation.  Restrict
the cross- check to non-system inodes; that is the full surface where
i_rdev semantics apply and is also the full surface an unprivileged
consumer of the volume can see.

Following the i_mode canonicalisation in patch 1, S_ISCHR / S_ISBLK covers
the whole device-inode space; this check operates correctly on its own,
but the canonicalised i_mode makes the predicate exhaustive.

Link: https://lore.kernel.org/20260517111015.3187935-3-michael.bommarito@gmail.com
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

 fs/ocfs2/inode.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-reject-dinodes-whose-i_rdev-disagrees-with-the-file-type
+++ a/fs/ocfs2/inode.c
@@ -1533,6 +1533,44 @@ int ocfs2_validate_inode_block(struct su
 		}
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
+	if (!(le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL) &&
+	    !S_ISCHR(le16_to_cpu(di->i_mode)) &&
+	    !S_ISBLK(le16_to_cpu(di->i_mode)) &&
+	    di->id1.dev1.i_rdev != 0) {
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
 
_

Patches currently in -mm which might be from michael.bommarito@gmail.com are

ocfs2-reject-dinodes-with-non-canonical-i_mode-type-or-stray-bits.patch
ocfs2-reject-dinodes-whose-i_rdev-disagrees-with-the-file-type.patch
ocfs2-reject-regular-files-with-non-zero-i_size-and-zero-i_clusters.patch

