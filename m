Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B9A154BF0
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248826; cv=none; b=AYmPeewfWbiCcP08f0oDUOjJ7CtWH6dR1fClskxkOSl/kjY6FEfVT/TtPnzIBOMzmXhWf1iKiq+z+MtZfqIEIH1ilsEqNn8stHlr+B+aFX/DQH2ZAEeoMpmlF2DvzSucf6+uKxcs20QwGbbP1wogw8ldw9dnKcR3U4hoT7hhe0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248826; c=relaxed/simple;
	bh=ZiktLVoMTacsvN34vvSQyipUhg/d5wFJIjbnfVVwbsA=;
	h=Date:To:From:Subject:Message-Id; b=T68VaNlNfq+4PPPWPN/IJaa3ufLf9k7p/IDfPIaporrl8qmUCTjrblQhOUudD/sfr72nQh7sZoJtqjhTMUKrVxL5F/kH0FDYOexxROwBDKQNjIfdViDo9OkxY1UutVvIArye88qSzj5bgCer8yT1xLBHpb7nLfi04ATY+9Ug/fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fcfrp1fP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fcfrp1fP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7FFC4CEC2;
	Mon,  2 Sep 2024 03:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248826;
	bh=ZiktLVoMTacsvN34vvSQyipUhg/d5wFJIjbnfVVwbsA=;
	h=Date:To:From:Subject:From;
	b=fcfrp1fP8macTgYzlBPuG1pRJUvlu4v8LyLXVDX25iC7AYJCwU2LD4MovMJEMazEs
	 BVznYERMzLbjgyvC4u1vqrbUBy2tL5HV1g6JB+tVnIOFNuAaB8jifcqaAFPs4fnBRR
	 Tx2ATUmJhuV1EeD3RFxS3+BrFUw+KzXOxnNR3UAY=
Date: Sun, 01 Sep 2024 20:47:05 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-fix-inconsistencies-in-kernel-doc-comments-in-segmenth.patch removed from -mm tree
Message-Id: <20240902034706.6C7FFC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix inconsistencies in kernel-doc comments in segment.h
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-inconsistencies-in-kernel-doc-comments-in-segmenth.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


