Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8533C13A268
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248839; cv=none; b=KLQz2ThCmCVY/ixy8paPdN8N1qPBAC52IWYt9keXrngdQdVkMJnX+zkuCdMTzypvP4lVHNc5D+vGWa3NXR91TBs3XiIFhEHoSjjBm/uFJqLNYsegesfy0uiULAuO28ZhZHmNFj5pEj/f+eymlImzapAssv/UulfUEHHEZg8aZZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248839; c=relaxed/simple;
	bh=VAMgivTGInPhmcrA/2wqEH//Vr1kpnYGKe0rJTSTPkY=;
	h=Date:To:From:Subject:Message-Id; b=I8djN6LgUi7aWRhBYE0dJm+n+SneyMeFjwRpIOkhw/ymCu5L4IvonOyT6kMlSPrzVzNEOI30jbyZPpp7qVrw7mK2tMjG6hNAit8BG/EJtwkstS+CJWXwomWBUT6kxDJma9vAtIaEwjdBMQCmOfWp+4f/AIn8zIkrTYAbk+fCPaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fe2DIQhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fe2DIQhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B482C4CEC2;
	Mon,  2 Sep 2024 03:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248839;
	bh=VAMgivTGInPhmcrA/2wqEH//Vr1kpnYGKe0rJTSTPkY=;
	h=Date:To:From:Subject:From;
	b=fe2DIQhzbE4ouX495rUGrwjkDwKTLALtUrHuz2HFqvgnAfKizJMH1VUPRZYeQq42j
	 FzFvRZe34mPVNQ3iMvgdEGmVBwjBqYxr2CCZkQz0vnd9V8cwKGu35rsfWksAymEjO5
	 sPi3pR0aYu+c/QU8vyOjrOh9wCUwjPuPrDUGeXFU=
Date: Sun, 01 Sep 2024 20:47:18 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-do-not-propagate-enoent-error-from-sufile-during-gc.patch removed from -mm tree
Message-Id: <20240902034719.5B482C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: do not propagate ENOENT error from sufile during GC
has been removed from the -mm tree.  Its filename was
     nilfs2-do-not-propagate-enoent-error-from-sufile-during-gc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


