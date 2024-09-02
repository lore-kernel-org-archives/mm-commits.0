Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873F214F132
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248838; cv=none; b=fTAjMRNwyUvwOM8Lp40hNNoqNLIKw9GOgVAfm9wOh/grpCnyCdNIga4a84WkuqR8gwr0+PF7WJL+o88JYPZHqv3utDemS+4+IBPauua7X4+QNL31v2qxuPPl2eXMdOzp1IatboduNdVNyNQFr7RM7dSvLaW8Flvpw8PUsPeH0L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248838; c=relaxed/simple;
	bh=BykZJ34EMUnpdpguh79A6fvHboledeIBVWlV3uiQSKs=;
	h=Date:To:From:Subject:Message-Id; b=PCaCyL3r+1edGn/kR5ebn4DnJyC8kZBz1FvsCsN5WyuZuGd6Twsv1ERPuocTq5D4UOwuey7nFlQNQeXXQE4lkc+c3bcexVnheJ1OWuJ96D30uS38/1M3RRhXwDLYccFTts/wasgZ8yOx1RsvdT95dl1lKiqE+ki8FDBwpvWdOr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r0plBpaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r0plBpaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5678BC4CEC2;
	Mon,  2 Sep 2024 03:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248838;
	bh=BykZJ34EMUnpdpguh79A6fvHboledeIBVWlV3uiQSKs=;
	h=Date:To:From:Subject:From;
	b=r0plBpaz8F4X9DNI9L1FI6ciikyaCoa45PtiyYsbZ2p8Fjpu0j5di68ciNBNjVnOU
	 XamP/oLl/nbROMxUcOf9HRuVPTerWbzPkyCQvlP3j/MX742LncQa4D/s+siLCGTBer
	 eywvEbtcgPfsQLAEByrP5VXLTwF4msR2T7J3K10o=
Date: Sun, 01 Sep 2024 20:47:17 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-do-not-propagate-enoent-error-from-sufile-during-recovery.patch removed from -mm tree
Message-Id: <20240902034718.5678BC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: do not propagate ENOENT error from sufile during recovery
has been removed from the -mm tree.  Its filename was
     nilfs2-do-not-propagate-enoent-error-from-sufile-during-recovery.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


