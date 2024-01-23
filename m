Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39675DF15
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970558; cv=none; b=pKZM1MlupQdPOMCTOszRm4VYvnG2RNVakL+sV/fhVdT/hJ28poBZ+jgFtK6ep4LeLTOda2M+uT1lLLoVpcAT7F4+AJ1CpNYCGF2zj8oNvmxL8xU85F+DYLAe9tl+e/dvxQQByuhevjxQohVNDdXq/mMz1Z9nUwAxvdXAXO9xCFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970558; c=relaxed/simple;
	bh=l8nNgp6lD1oO9M1kydNDEySL3MzeWVGuymdkcy40b78=;
	h=Date:To:From:Subject:Message-Id; b=aotMFiCSdzn2R55VIlSpdO/LpVyEllwbbW/u6hatWFwe0qUq7l7gFR80m8q0BCY5i3MVja0j43Lz1wjnGe0IgqnX8s5vr1Cs0Lci5zgWWEAKXk6okScviAEWuBRJNYwShoXOL9Yh9mE7R6pUrZJDqHZzRZGIn8Cdww+F6q+oAXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r3zPHrFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r3zPHrFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFE7C43394;
	Tue, 23 Jan 2024 00:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970558;
	bh=l8nNgp6lD1oO9M1kydNDEySL3MzeWVGuymdkcy40b78=;
	h=Date:To:From:Subject:From;
	b=r3zPHrFrl3+5NwlR4T+ntlDgP/77fGz1gX8uzIJBVaB8iFXLLGMaruk9hu7n1OZ3k
	 6CsCPxtIoNtPFgCf/NDSzEy/VGiS5++5EdMCNkceYJrpFmduytkfUwuz0Uh3HuRtdR
	 hzefu9ELWs6AvUrCaIGXxfLWallCiaJqqpUKwKbw=
Date: Mon, 22 Jan 2024 16:42:35 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-metadata-file-common-code-to-use-kmap_local.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004237.DEFE7C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: convert metadata file common code to use kmap_local
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-metadata-file-common-code-to-use-kmap_local.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-metadata-file-common-code-to-use-kmap_local.patch

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
Subject: nilfs2: convert metadata file common code to use kmap_local
Date: Mon, 22 Jan 2024 23:01:51 +0900

In the common code of metadata files, the new block creation routine
nilfs_mdt_insert_new_block() still uses the deprecated kmap_atomic(), so
convert it to use kmap_local.

Link: https://lkml.kernel.org/r/20240122140202.6950-5-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/mdt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/mdt.c~nilfs2-convert-metadata-file-common-code-to-use-kmap_local
+++ a/fs/nilfs2/mdt.c
@@ -47,12 +47,12 @@ nilfs_mdt_insert_new_block(struct inode
 
 	set_buffer_mapped(bh);
 
-	kaddr = kmap_atomic(bh->b_page);
+	kaddr = kmap_local_page(bh->b_page);
 	memset(kaddr + bh_offset(bh), 0, i_blocksize(inode));
 	if (init_block)
 		init_block(inode, bh, kaddr);
 	flush_dcache_page(bh->b_page);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	set_buffer_uptodate(bh);
 	mark_buffer_dirty(bh);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-convert-recovery-logic-to-use-kmap_local.patch
nilfs2-convert-segment-buffer-to-use-kmap_local.patch
nilfs2-convert-nilfs_copy_buffer-to-use-kmap_local.patch
nilfs2-convert-metadata-file-common-code-to-use-kmap_local.patch
nilfs2-convert-sufile-to-use-kmap_local.patch
nilfs2-convert-persistent-object-allocator-to-use-kmap_local.patch
nilfs2-convert-dat-to-use-kmap_local.patch
nilfs2-move-nilfs_bmap_write-call-out-of-nilfs_write_inode_common.patch
nilfs2-do-not-acquire-rwsem-in-nilfs_bmap_write.patch
nilfs2-convert-ifile-to-use-kmap_local.patch
nilfs2-localize-highmem-mapping-for-checkpoint-creation-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-finalization-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile.patch
nilfs2-remove-nilfs_cpfile_getput_checkpoint.patch
nilfs2-convert-cpfile-to-use-kmap_local.patch

