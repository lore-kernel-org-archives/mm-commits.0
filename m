Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AF8139CFE
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 21:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724275442; cv=none; b=iCXBdYQ8ad3xagsODHUbEvV1nAB2KD9b3lHO+0ER/PniN9IWDDeVzMxREA7hrdSasflVkD1PaGdF43kmXMvSchnfThFerlkv3yFtI+ntzTUz5N4CGTGXxGohRI1OAkxTGRs3UwA3Qn2/zp4psCrnMqEamtv/zAeSv6Wwi0E1dr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724275442; c=relaxed/simple;
	bh=n6xRThMzpzfKsUdVQo4l/RuKY7LwN/p9wUdFKirKzgM=;
	h=Date:To:From:Subject:Message-Id; b=LGQmLcLV1yfRjFCn62+aTaJ00dhWtWA/hS0BVGxizQwh2yfQPbVuNUOu2gEeKySIHm3wzVcg1igk5YfL0x44816RqmoA6XTg0ChcFh+ZTDhdeMTORhCPP+P1LoETwRX4N3NCQUlPp8fGZV9srfJs0yQsvG7CwGlV3Dcr0Sq+er8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RQ+rRYxk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RQ+rRYxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D2FC4AF09;
	Wed, 21 Aug 2024 21:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724275441;
	bh=n6xRThMzpzfKsUdVQo4l/RuKY7LwN/p9wUdFKirKzgM=;
	h=Date:To:From:Subject:From;
	b=RQ+rRYxk4Ocl9oXiYB8xt5x+KmyP0mgrzoiUNhLdfTkWarVc4C/sE2Dk6OR3q0wdN
	 XKdk6JgIh3TM2NTzcR/AzzGO5ociWKT+/mdHV8tgexxi2dIE89Jqn4EMRisPyouKYL
	 JJNbLyB20rPTkubU3vx4GWV/LszJR9wZKN7Zh4Tk=
Date: Wed, 21 Aug 2024 14:24:00 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-do-not-propagate-enoent-error-from-sufile-during-recovery.patch added to mm-nonmm-unstable branch
Message-Id: <20240821212401.93D2FC4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: do not propagate ENOENT error from sufile during recovery
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-do-not-propagate-enoent-error-from-sufile-during-recovery.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-do-not-propagate-enoent-error-from-sufile-during-recovery.patch

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: do not propagate ENOENT error from sufile during recovery
Date: Thu, 22 Aug 2024 00:46:25 +0900

nilfs_sufile_free() returns the error code -ENOENT when the block where
the segment usage should be placed does not exist (hole block case), but
this error should not be propagated upwards to the mount system call.

In nilfs_prepare_segment_for_recovery(), one of the recovery steps during
mount, nilfs_sufile_free() is used and may return -ENOENT as is, so in
that case return -EINVAL instead.

Link: https://lkml.kernel.org/r/20240821154627.11848-4-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/recovery.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/recovery.c~nilfs2-do-not-propagate-enoent-error-from-sufile-during-recovery
+++ a/fs/nilfs2/recovery.c
@@ -433,8 +433,17 @@ static int nilfs_prepare_segment_for_rec
 	 * The next segment is invalidated by this recovery.
 	 */
 	err = nilfs_sufile_free(sufile, segnum[1]);
-	if (unlikely(err))
+	if (unlikely(err)) {
+		if (err == -ENOENT) {
+			nilfs_err(sb,
+				  "checkpoint log inconsistency at block %llu (segment %llu): next segment %llu is unallocated",
+				  (unsigned long long)nilfs->ns_last_pseg,
+				  (unsigned long long)nilfs->ns_segnum,
+				  (unsigned long long)segnum[1]);
+			err = -EINVAL;
+		}
 		goto failed;
+	}
 
 	for (i = 1; i < 4; i++) {
 		err = nilfs_segment_list_add(head, segnum[i]);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch
nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch
nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch
nilfs2-add-support-for-fs_ioc_getuuid.patch
nilfs2-add-support-for-fs_ioc_getfssysfspath.patch
nilfs2-add-support-for-fs_ioc_getfslabel.patch
nilfs2-add-support-for-fs_ioc_setfslabel.patch
nilfs2-do-not-output-warnings-when-clearing-dirty-buffers.patch
nilfs2-add-missing-argument-description-for-__nilfs_error.patch
nilfs2-add-missing-argument-descriptions-for-ioctl-related-helpers.patch
nilfs2-improve-kernel-doc-comments-for-b-tree-node-helpers.patch
nilfs2-fix-incorrect-kernel-doc-declaration-of-nilfs_palloc_req-structure.patch
nilfs2-add-missing-description-of-nilfs_btree_path-structure.patch
nilfs2-describe-the-members-of-nilfs_bmap_operations-structure.patch
nilfs2-fix-inconsistencies-in-kernel-doc-comments-in-segmenth.patch
nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments.patch
nilfs2-treat-missing-sufile-header-block-as-metadata-corruption.patch
nilfs2-treat-missing-cpfile-header-block-as-metadata-corruption.patch
nilfs2-do-not-propagate-enoent-error-from-sufile-during-recovery.patch
nilfs2-do-not-propagate-enoent-error-from-sufile-during-gc.patch
nilfs2-do-not-propagate-enoent-error-from-nilfs_sufile_mark_dirty.patch

