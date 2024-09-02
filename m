Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E23414E2D6
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248825; cv=none; b=nKee90GpbiFMB3xlcgbjYVyc8WgZDopsBn9Gnxdq7XoMoZ4oR2zfeJT0oSvlTt0xYWyD8h5hp+hIQ9J6rBObw669LflltASyCYZB74FZtGEg1zr942WlCLf0Ov1szcpdC+SwPkx3nZ3HmAImuJgTisYNQHJYOPv6w80ZZdp4C90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248825; c=relaxed/simple;
	bh=8tVIMiVbB5gvQJ0JsS3OUNmZJp3iNW3Vz1n31FF/Ot0=;
	h=Date:To:From:Subject:Message-Id; b=uEiV0Ad6oezX3pCtK3y5c6bI8lI+3C8hZIZBpcJ2fBjIXeFDfji5A0j7It5DfPdKtlUB8juFeCDY/zoWxOXPqCDzA9n8ZHIRNf8PlYjG2J3Qo4A+D/B3yfXYrz3TdA7rjILbJ9kBbasAL6r02bxZjFBn3jdAC2aZI/PuDbAb3xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IgCSYKda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IgCSYKda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65451C4CEC2;
	Mon,  2 Sep 2024 03:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248825;
	bh=8tVIMiVbB5gvQJ0JsS3OUNmZJp3iNW3Vz1n31FF/Ot0=;
	h=Date:To:From:Subject:From;
	b=IgCSYKdaqToH20dNYeGVhEbCfPTyFYzzcE9fBMStouyeBOKVrhJWPgqLKnuOp0YL6
	 US5eMiQdKfye0tq2uvGKwQdxbdPHkRtADQhMw4pjJ2ePdP9vKOdzr2F0TtnYFuiP1c
	 xT/ghWC3lg23960tqRz0Ctyvx70Nenbu0n+Ky0vw=
Date: Sun, 01 Sep 2024 20:47:04 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-describe-the-members-of-nilfs_bmap_operations-structure.patch removed from -mm tree
Message-Id: <20240902034705.65451C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: describe the members of nilfs_bmap_operations structure
has been removed from the -mm tree.  Its filename was
     nilfs2-describe-the-members-of-nilfs_bmap_operations-structure.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: describe the members of nilfs_bmap_operations structure
Date: Fri, 16 Aug 2024 16:43:17 +0900

Add missing member variable descriptions in the kernel-doc comments for
the nilfs_bmap_operations structure, hiding the internal operations with
the "private:" tag.  This eliminates the following warnings output by the
kernel-doc script:

 fs/nilfs2/bmap.h:74: warning: Function parameter or struct member
  'bop_lookup' not described in 'nilfs_bmap_operations'
 fs/nilfs2/bmap.h:74: warning: Function parameter or struct member
  'bop_lookup_contig' not described in 'nilfs_bmap_operations'
 ...
 fs/nilfs2/bmap.h:74: warning: Function parameter or struct member
  'bop_gather_data' not described in 'nilfs_bmap_operations'

Link: https://lkml.kernel.org/r/20240816074319.3253-7-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.h |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/bmap.h~nilfs2-describe-the-members-of-nilfs_bmap_operations-structure
+++ a/fs/nilfs2/bmap.h
@@ -44,6 +44,19 @@ struct nilfs_bmap_stats {
 
 /**
  * struct nilfs_bmap_operations - bmap operation table
+ * @bop_lookup:               single block search operation
+ * @bop_lookup_contig:        consecutive block search operation
+ * @bop_insert:               block insertion operation
+ * @bop_delete:               block delete operation
+ * @bop_clear:                block mapping resource release operation
+ * @bop_propagate:            operation to propagate dirty state towards the
+ *                            mapping root
+ * @bop_lookup_dirty_buffers: operation to collect dirty block buffers
+ * @bop_assign:               disk block address assignment operation
+ * @bop_mark:                 operation to mark in-use blocks as dirty for
+ *                            relocation by GC
+ * @bop_seek_key:             find valid block key operation
+ * @bop_last_key:             find last valid block key operation
  */
 struct nilfs_bmap_operations {
 	int (*bop_lookup)(const struct nilfs_bmap *, __u64, int, __u64 *);
@@ -66,7 +79,7 @@ struct nilfs_bmap_operations {
 	int (*bop_seek_key)(const struct nilfs_bmap *, __u64, __u64 *);
 	int (*bop_last_key)(const struct nilfs_bmap *, __u64 *);
 
-	/* The following functions are internal use only. */
+	/* private: internal use only */
 	int (*bop_check_insert)(const struct nilfs_bmap *, __u64);
 	int (*bop_check_delete)(struct nilfs_bmap *, __u64);
 	int (*bop_gather_data)(struct nilfs_bmap *, __u64 *, __u64 *, int);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


