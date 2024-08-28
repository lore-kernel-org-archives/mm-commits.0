Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198363FEC
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 00:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724803798; cv=none; b=srDHM+kEYkmcjBNNoZSvWgjtOP3axSxghb6tIaAOYQsfW50liiSi91MQHVOtqapITq2wTcqa+V7vSx/NJXSyH+ie7Zd9+gZHnOCa/p2f9sXGFq/VbDw/vMLlsZCnV5w7LcqZ/now5ursC4JBX4TVKfKgUk7NdMWA6At0+f/ktz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724803798; c=relaxed/simple;
	bh=Cer0JrXHMVTL3tqpmI1hDX5sqkv8iivcY5fCJf9N64Q=;
	h=Date:To:From:Subject:Message-Id; b=HywcfNL6gB7ngIt48LO9nZg+e1uNoLP5w+9zV1dKlnK2Q3DHNFqCqbOho+BDcbOOCC7a3Me1dR8jSOjQJ8cw06wEHw8plnciUX5sp1IPsACHjhGlwmCGMOUfgcKw1ykrUonxXIGagkdlTn5vE8JQf8Abw60EwWXTUtLt0HRFwKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=leBAqrfA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="leBAqrfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1D2C4AF51;
	Wed, 28 Aug 2024 00:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724803797;
	bh=Cer0JrXHMVTL3tqpmI1hDX5sqkv8iivcY5fCJf9N64Q=;
	h=Date:To:From:Subject:From;
	b=leBAqrfAU0dK8w3ndEZO3gHaP6Ar5t+Kp7hLg6MBOlxYQ3y1sV+sMM9veua5s0hLP
	 CPK3LNOxL2HqB+LjhJcc2fTezm2PrETAAUtZPTMkT2p1ReXNdYdE7rqVv7eiFpxKTs
	 RjdpyJC/yTAOdCH4YaOmm3FRPWebeT8gEDnT0crA=
Date: Tue, 27 Aug 2024 17:09:57 -0700
To: mm-commits@vger.kernel.org,huangxiaojia2@huawei.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-use-the-bits_per_long-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240828000957.8F1D2C4AF51@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: use the BITS_PER_LONG macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-use-the-bits_per_long-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-use-the-bits_per_long-macro.patch

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
Subject: nilfs2: use the BITS_PER_LONG macro
Date: Tue, 27 Aug 2024 02:41:10 +0900

The macros NILFS_BMAP_KEY_BIT and NILFS_BMAP_NEW_PTR_INIT calculate,
within their definitions, the number of bits in an unsigned long variable.
Use the BITS_PER_LONG macro to make them simpler.

Link: https://lkml.kernel.org/r/20240826174116.5008-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Huang Xiaojia <huangxiaojia2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/bmap.h~nilfs2-use-the-bits_per_long-macro
+++ a/fs/nilfs2/bmap.h
@@ -87,9 +87,8 @@ struct nilfs_bmap_operations {
 
 
 #define NILFS_BMAP_SIZE		(NILFS_INODE_BMAP_SIZE * sizeof(__le64))
-#define NILFS_BMAP_KEY_BIT	(sizeof(unsigned long) * 8 /* CHAR_BIT */)
-#define NILFS_BMAP_NEW_PTR_INIT	\
-	(1UL << (sizeof(unsigned long) * 8 /* CHAR_BIT */ - 1))
+#define NILFS_BMAP_KEY_BIT	BITS_PER_LONG
+#define NILFS_BMAP_NEW_PTR_INIT	(1UL << (BITS_PER_LONG - 1))
 
 static inline int nilfs_bmap_is_new_ptr(unsigned long ptr)
 {
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
nilfs2-use-the-bits_per_long-macro.patch
nilfs2-separate-inode-type-information-from-i_state-field.patch
nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation.patch
nilfs2-do-not-repair-reserved-inode-bitmap-in-nilfs_new_inode.patch
nilfs2-remove-sc_timer_task.patch
nilfs2-use-kthread_create-and-kthread_stop-for-the-log-writer-thread.patch
nilfs2-refactor-nilfs_segctor_thread.patch

