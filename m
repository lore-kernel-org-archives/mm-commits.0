Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66551448E0
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 22:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723846750; cv=none; b=XJf+oQ+leVe2+2y6h6reZfsMTVJR2bWLyCICizSRlacuBLtbC3wKaWUxp9IjaObKMesqd2TCh8Va+y8KIPH2zg2uotr5c3sWSvTe6l5vjpP4tB8b7DE7kcncD1hdDaLk77hY+BhciLOTo/hwBimJGHDcMQcnNSvAW0TTHxHXhbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723846750; c=relaxed/simple;
	bh=SeApVOF4yVxL94bvDUWbohrEn2+iK2Pn7NmKCa3wU+Y=;
	h=Date:To:From:Subject:Message-Id; b=cccOg9vE/LYAjZPZmXtHBG7bSG/qHhViKcyW5NGbXfecJA1Zd3vs83+cPCiEyk79bgtbtqJLmCZaJsIXt7o9Asx6PXwQ5egoNyLnH54OoVbY4vqGb3WGPB/bevzfp3SbWPQBA0FFrL3uu/y65UUF9Q06TypwFk6Pm1AVAUGDnFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SwXdp9Qj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SwXdp9Qj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFD1C32782;
	Fri, 16 Aug 2024 22:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723846749;
	bh=SeApVOF4yVxL94bvDUWbohrEn2+iK2Pn7NmKCa3wU+Y=;
	h=Date:To:From:Subject:From;
	b=SwXdp9QjZgoe+9e6xGAwf0ztC8FhYVP6p1cWSODvKGR48iCuwCbC2WsR3VOHXcFc0
	 tWWOfX1Tu3XM4kqmKi3dFVsG+/FOq9XjRnvAcwQej2m+WsxN+cOYDXliTYnMUgHwSb
	 n/VzFgKz3GWa/a1lqJFJz8rw7brN2bIPPicmXVso=
Date: Fri, 16 Aug 2024 15:19:09 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-inconsistencies-in-kernel-doc-comments-in-segmenth.patch added to mm-nonmm-unstable branch
Message-Id: <20240816221909.BBFD1C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix inconsistencies in kernel-doc comments in segment.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-fix-inconsistencies-in-kernel-doc-comments-in-segmenth.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-inconsistencies-in-kernel-doc-comments-in-segmenth.patch

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
Subject: nilfs2: fix inconsistencies in kernel-doc comments in segment.h
Date: Fri, 16 Aug 2024 16:43:18 +0900

Fix incorrect or missing variable names in the member variable
descriptions in the nilfs_recovery_info and nilfs_sc_info structures,
thereby eliminating the following warnings output by the kernel-doc
script:

 fs/nilfs2/segment.h:49: warning: Function parameter or struct member
  'ri_cno' not described in 'nilfs_recovery_info'
 fs/nilfs2/segment.h:49: warning: Function parameter or struct member
  'ri_lsegs_start_seq' not described in 'nilfs_recovery_info'
 fs/nilfs2/segment.h:49: warning: Excess struct member 'ri_ri_cno'
  description in 'nilfs_recovery_info'
 fs/nilfs2/segment.h:49: warning: Excess struct member 'ri_lseg_start_seq'
  description in 'nilfs_recovery_info'
 fs/nilfs2/segment.h:177: warning: Function parameter or struct member
  'sc_seq_accepted' not described in 'nilfs_sc_info'
 fs/nilfs2/segment.h:177: warning: Function parameter or struct member
  'sc_timer_task' not described in 'nilfs_sc_info'
 fs/nilfs2/segment.h:177: warning: Excess struct member 'sc_seq_accept'
  description in 'nilfs_sc_info'

Link: https://lkml.kernel.org/r/20240816074319.3253-8-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/segment.h~nilfs2-fix-inconsistencies-in-kernel-doc-comments-in-segmenth
+++ a/fs/nilfs2/segment.h
@@ -22,10 +22,10 @@ struct nilfs_root;
  * struct nilfs_recovery_info - Recovery information
  * @ri_need_recovery: Recovery status
  * @ri_super_root: Block number of the last super root
- * @ri_ri_cno: Number of the last checkpoint
+ * @ri_cno: Number of the last checkpoint
  * @ri_lsegs_start: Region for roll-forwarding (start block number)
  * @ri_lsegs_end: Region for roll-forwarding (end block number)
- * @ri_lseg_start_seq: Sequence value of the segment at ri_lsegs_start
+ * @ri_lsegs_start_seq: Sequence value of the segment at ri_lsegs_start
  * @ri_used_segments: List of segments to be mark active
  * @ri_pseg_start: Block number of the last partial segment
  * @ri_seq: Sequence number on the last partial segment
@@ -107,7 +107,7 @@ struct nilfs_segsum_pointer {
  * @sc_wait_daemon: Daemon wait queue
  * @sc_wait_task: Start/end wait queue to control segctord task
  * @sc_seq_request: Request counter
- * @sc_seq_accept: Accepted request count
+ * @sc_seq_accepted: Accepted request count
  * @sc_seq_done: Completion counter
  * @sc_sync: Request of explicit sync operation
  * @sc_interval: Timeout value of background construction
@@ -115,6 +115,7 @@ struct nilfs_segsum_pointer {
  * @sc_lseg_stime: Start time of the latest logical segment
  * @sc_watermark: Watermark for the number of dirty buffers
  * @sc_timer: Timer for segctord
+ * @sc_timer_task: Thread woken up by @sc_timer
  * @sc_task: current thread of segctord
  */
 struct nilfs_sc_info {
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

