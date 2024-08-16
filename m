Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD6714037F
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 22:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723846748; cv=none; b=tEYtk+3syjF12YaZfegvqY6BKduyh+7Z2lrxCLZNrCUDoMCOpnGzgxxQDhlvRbmg3tG6PnANmV8sYEv30ItqjRD48ETEAUFxmDbtHZsRfiBbTr4kkk8+Dg0hl1CE0ivNvqAJoZGkPAcF9MP9liizjCe0zMISONs8fExH0Q4WZ5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723846748; c=relaxed/simple;
	bh=S/g/r/mevyGgipBpLcpvRIH+OAxGbWBGhJU28b9X4mI=;
	h=Date:To:From:Subject:Message-Id; b=S5z0O2Mq4Bqwus5zFOdvK9QTuFwVKcxD1NhXx58yoX4hG4eVuN3a0PYw/XpW4Ylq4ZAFHqOmk1qp8d6Bo0/MJgL9Bslu1rFWpnqv46OOWYRN89xZhOzmgngRQ4odTNzGzXzWtMzoQhU45YBhauMSoCeQA5zf0zi8MrjvuCbcHT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nm7mAPGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nm7mAPGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80C8C32782;
	Fri, 16 Aug 2024 22:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723846748;
	bh=S/g/r/mevyGgipBpLcpvRIH+OAxGbWBGhJU28b9X4mI=;
	h=Date:To:From:Subject:From;
	b=Nm7mAPGhzm2fGlUDgnfHE7xAZV4c4gSMuBFoVuKm2prOrzPMU5wkTBgqND8upaacq
	 v/A0uQVkrcuLI394EtPAP0pk+yxkmrbwDbgn4h80+Rr5lplKUeJR9KKsGy2wWyBgbq
	 2mUYcVvsFH0QWEiIpjo2Jr1HxyHEf2K2B1Fuu0Sw=
Date: Fri, 16 Aug 2024 15:19:07 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-describe-the-members-of-nilfs_bmap_operations-structure.patch added to mm-nonmm-unstable branch
Message-Id: <20240816221907.E80C8C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: describe the members of nilfs_bmap_operations structure
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-describe-the-members-of-nilfs_bmap_operations-structure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-describe-the-members-of-nilfs_bmap_operations-structure.patch

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

