Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEF115E80E
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 16:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714668438; cv=none; b=m16yyu2Sa0ARBeQSfSoT9oo4riFRunPBA8CsUqav+9sYutlewA/2goMtfGAEUk/eKiXWMAW484Z13KxhSN2PSS+4LShN62Jw0Njvp1gDGuoUB0KBYu5UukEODheTuqZJ0uUJZlAigpZPj2eCnmfwwOBPoP+pL/nIl+3mSpuKJqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714668438; c=relaxed/simple;
	bh=/Pm870PYAgGTPWl+grNF1QoSC0Yg+LML1KLJHu6ijFQ=;
	h=Date:To:From:Subject:Message-Id; b=tOAhhCYj658n1fNlljPoXXtkbhRQl5vCeZzl7YQf2xRwo7bXq7sujnedFlMW5/sY4AcI+j1odXsHs12UgkdEbRtCV8upRqhzzgu+JMdRFzdxR1US/jY8xisYmVEHuCoUUVYXRxBVyp6RBPOeW6LKz00fHUKF2Lf5fl8AgY5hZSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DL9k/pJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DL9k/pJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B180BC113CC;
	Thu,  2 May 2024 16:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714668437;
	bh=/Pm870PYAgGTPWl+grNF1QoSC0Yg+LML1KLJHu6ijFQ=;
	h=Date:To:From:Subject:From;
	b=DL9k/pJqP4WkkFPh3geN8uYaqoEyBHzDpvZxD2+LcRfi1d423LZ/Qn2Gc6ebeRAbI
	 FVp1V9s3b1HkgiJ4y6V3PApzJn9TqYFEsuhe8NxozZkT5Dj8+jYvc5bFWXkJ68Nkmk
	 f+7JzHvZmjvar9I7OH2lBpNpKSCtEWUd7LcIC5C8=
Date: Thu, 02 May 2024 09:47:16 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,bvanassche@acm.org,axboe@kernel.dk,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-make-superblock-data-array-index-computation-sparse-friendly.patch added to mm-nonmm-unstable branch
Message-Id: <20240502164717.B180BC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: make superblock data array index computation sparse friendly
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-make-superblock-data-array-index-computation-sparse-friendly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-make-superblock-data-array-index-computation-sparse-friendly.patch

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
Subject: nilfs2: make superblock data array index computation sparse friendly
Date: Tue, 30 Apr 2024 17:00:19 +0900

Upon running sparse, "warning: dubious: x & !y" is output at an array
index calculation within nilfs_load_super_block().

The calculation is not wrong, but to eliminate the sparse warning, replace
it with an equivalent calculation.

Also, add a comment to make it easier to understand what the unintuitive
array index calculation is doing and whether it's correct.

Link: https://lkml.kernel.org/r/20240430080019.4242-3-konishi.ryusuke@gmail.com
Fixes: e339ad31f599 ("nilfs2: introduce secondary super block")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/the_nilfs.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/the_nilfs.c~nilfs2-make-superblock-data-array-index-computation-sparse-friendly
+++ a/fs/nilfs2/the_nilfs.c
@@ -592,7 +592,7 @@ static int nilfs_load_super_block(struct
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 	struct buffer_head **sbh = nilfs->ns_sbh;
 	u64 sb2off, devsize = bdev_nr_bytes(nilfs->ns_bdev);
-	int valid[2], swp = 0;
+	int valid[2], swp = 0, older;
 
 	if (devsize < NILFS_SEG_MIN_BLOCKS * NILFS_MIN_BLOCK_SIZE + 4096) {
 		nilfs_err(sb, "device size too small");
@@ -648,9 +648,25 @@ static int nilfs_load_super_block(struct
 	if (swp)
 		nilfs_swap_super_block(nilfs);
 
+	/*
+	 * Calculate the array index of the older superblock data.
+	 * If one has been dropped, set index 0 pointing to the remaining one,
+	 * otherwise set index 1 pointing to the old one (including if both
+	 * are the same).
+	 *
+	 *  Divided case             valid[0]  valid[1]  swp  ->  older
+	 *  -------------------------------------------------------------
+	 *  Both SBs are invalid        0         0       N/A (Error)
+	 *  SB1 is invalid              0         1       1         0
+	 *  SB2 is invalid              1         0       0         0
+	 *  SB2 is newer                1         1       1         0
+	 *  SB2 is older or the same    1         1       0         1
+	 */
+	older = valid[1] ^ swp;
+
 	nilfs->ns_sbwcount = 0;
 	nilfs->ns_sbwtime = le64_to_cpu(sbp[0]->s_wtime);
-	nilfs->ns_prot_seq = le64_to_cpu(sbp[valid[1] & !swp]->s_last_seq);
+	nilfs->ns_prot_seq = le64_to_cpu(sbp[older]->s_last_seq);
 	*sbpp = sbp[0];
 	return 0;
 }
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-use-integer-type-instead-of-enum-req_op-for-event-tracing-header.patch
nilfs2-make-superblock-data-array-index-computation-sparse-friendly.patch

