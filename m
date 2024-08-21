Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28143139CFE
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 21:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724275444; cv=none; b=kvazcTYz/fwxeLi/8jTiUkfQ3IeX5eBCWrdApTg+DGWhSAmB2V8eeET/BvQHCCPJrP2EZLXMYPaNF1PHun13VrhMXyceaasKAnGledlZHUyNXmS2h5zw6s3yWE/1EOtEz6JCZA1RAvfuc5qz9R4WkQ9EDLc7GCoRIKtTAbJ1asY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724275444; c=relaxed/simple;
	bh=ckr//UUfbEWhhoyBx05eQG3Gb53Xc5IiI94B4rB5pAk=;
	h=Date:To:From:Subject:Message-Id; b=eiS1rYPOFe88AoGX2SEvkSbOppYvWkg9lzupySxESetbBbSP2XI7u4KQe0LhOquU4JIVD9mbmu0Y4gKF316eIXlXJ4fur6sycEkX/OmURwGPRiaM+z9VDIv2DUtTS2XhvwT3SvkohiqMO6JROWIBEg0bc8020JucUSMKfe6JMaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q63oKZte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q63oKZte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7771AC4AF09;
	Wed, 21 Aug 2024 21:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724275443;
	bh=ckr//UUfbEWhhoyBx05eQG3Gb53Xc5IiI94B4rB5pAk=;
	h=Date:To:From:Subject:From;
	b=Q63oKZteZnpTDS6dCFw2jEadkOoWKiVGNTVlyYkqLHwTVUMxPZhf+1jyyG1s8EIkc
	 +DI3eEcRYaBPU3dRjd7sfxw/w3tQYZqPk8DLBZk0ZUwM8F096WrBpdIBkBKoxv91f3
	 iIda0uA2dJySmhcfWJ8iJQJioIbbatgap/7JbRzs=
Date: Wed, 21 Aug 2024 14:24:02 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-do-not-propagate-enoent-error-from-sufile-during-gc.patch added to mm-nonmm-unstable branch
Message-Id: <20240821212403.7771AC4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: do not propagate ENOENT error from sufile during GC
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-do-not-propagate-enoent-error-from-sufile-during-gc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-do-not-propagate-enoent-error-from-sufile-during-gc.patch

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
Subject: nilfs2: do not propagate ENOENT error from sufile during GC
Date: Thu, 22 Aug 2024 00:46:26 +0900

nilfs_sufile_freev(), which is used to free segments in GC, aborts with
-ENOENT if the target segment usage is on a hole block.

This error only occurs if one of the segment numbers to be freed passed by
the GC ioctl is invalid, so return -EINVAL instead.

To avoid impairing readability, introduce a wrapper function that
encapsulates error handling including the error code conversion (and error
message output).

Link: https://lkml.kernel.org/r/20240821154627.11848-5-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |   64 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 56 insertions(+), 8 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-do-not-propagate-enoent-error-from-sufile-during-gc
+++ a/fs/nilfs2/segment.c
@@ -1102,12 +1102,64 @@ static int nilfs_segctor_scan_file_dsync
 	return err;
 }
 
+/**
+ * nilfs_free_segments - free the segments given by an array of segment numbers
+ * @nilfs:   nilfs object
+ * @segnumv: array of segment numbers to be freed
+ * @nsegs:   number of segments to be freed in @segnumv
+ *
+ * nilfs_free_segments() wraps nilfs_sufile_freev() and
+ * nilfs_sufile_cancel_freev(), and edits the segment usage metadata file
+ * (sufile) to free all segments given by @segnumv and @nsegs at once.  If
+ * it fails midway, it cancels the changes so that none of the segments are
+ * freed.  If @nsegs is 0, this function does nothing.
+ *
+ * The freeing of segments is not finalized until the writing of a log with
+ * a super root block containing this sufile change is complete, and it can
+ * be canceled with nilfs_sufile_cancel_freev() until then.
+ *
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EINVAL	- Invalid segment number.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
+ */
+static int nilfs_free_segments(struct the_nilfs *nilfs, __u64 *segnumv,
+			       size_t nsegs)
+{
+	size_t ndone;
+	int ret;
+
+	if (!nsegs)
+		return 0;
+
+	ret = nilfs_sufile_freev(nilfs->ns_sufile, segnumv, nsegs, &ndone);
+	if (unlikely(ret)) {
+		nilfs_sufile_cancel_freev(nilfs->ns_sufile, segnumv, ndone,
+					  NULL);
+		/*
+		 * If a segment usage of the segments to be freed is in a
+		 * hole block, nilfs_sufile_freev() will return -ENOENT.
+		 * In this case, -EINVAL should be returned to the caller
+		 * since there is something wrong with the given segment
+		 * number array.  This error can only occur during GC, so
+		 * there is no need to worry about it propagating to other
+		 * callers (such as fsync).
+		 */
+		if (ret == -ENOENT) {
+			nilfs_err(nilfs->ns_sb,
+				  "The segment usage entry %llu to be freed is invalid (in a hole)",
+				  (unsigned long long)segnumv[ndone]);
+			ret = -EINVAL;
+		}
+	}
+	return ret;
+}
+
 static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 {
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	struct list_head *head;
 	struct nilfs_inode_info *ii;
-	size_t ndone;
 	int err = 0;
 
 	switch (nilfs_sc_cstage_get(sci)) {
@@ -1201,14 +1253,10 @@ static int nilfs_segctor_collect_blocks(
 		nilfs_sc_cstage_inc(sci);
 		fallthrough;
 	case NILFS_ST_SUFILE:
-		err = nilfs_sufile_freev(nilfs->ns_sufile, sci->sc_freesegs,
-					 sci->sc_nfreesegs, &ndone);
-		if (unlikely(err)) {
-			nilfs_sufile_cancel_freev(nilfs->ns_sufile,
-						  sci->sc_freesegs, ndone,
-						  NULL);
+		err = nilfs_free_segments(nilfs, sci->sc_freesegs,
+					  sci->sc_nfreesegs);
+		if (unlikely(err))
 			break;
-		}
 		sci->sc_stage.flags |= NILFS_CF_SUFREED;
 
 		err = nilfs_segctor_scan_file(sci, nilfs->ns_sufile,
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

