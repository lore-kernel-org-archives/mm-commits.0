Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17734175D51
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 21:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724275439; cv=none; b=Tmxey6RxFgk1TbNAopdyOHAFPZKYpJhIgU9dHbi8ZWoV7pxavIDANSJC7vz48L1dsCdIeEx0xSEpn0qlvPYlWhp1jf1ISeqapxG9gh9NRYUadCP8mA3EtXyuWlEb6sMs27iJWrGOC6uRaSfTnyOZE5HYYc8eaks+adUzlMqKXfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724275439; c=relaxed/simple;
	bh=HVr3DHFQBpZXdgxCSEXU/r6wM+0K0ZUe9GpklkZteuw=;
	h=Date:To:From:Subject:Message-Id; b=Kao7hb+xAMRxZzDUWkefW+KreBXpkyb8Bvt8NhtjFk1ar0YahRDBuyXZa9icKBeWoBs8EygD5x+/NV9X4MYjOaL0Ry4WiGATYvwIBpwLPuXwzV8Brp3mTs4my5uEVoulX4IkKw/wTxMLCrhqAQcvvqR/qYQfI7LTpkOT4ZrU9pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wIDNuBAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wIDNuBAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3B3C4AF09;
	Wed, 21 Aug 2024 21:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724275438;
	bh=HVr3DHFQBpZXdgxCSEXU/r6wM+0K0ZUe9GpklkZteuw=;
	h=Date:To:From:Subject:From;
	b=wIDNuBAhgnEEv85e+fbW6BuvLSOfahkaexYc+CpJd+0V5vpqn6AuLSFZqbnKgz+YD
	 0mSSynfMe7ZRub5WK1FB6eI4XJpKizfi4Ea1czKaghDwmwp0E2fK8G8+cswdaYeRXj
	 LumTXQ+OBYwROksmf/sFsNFbLGhde8ET1TYSMdS0=
Date: Wed, 21 Aug 2024 14:23:57 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-treat-missing-sufile-header-block-as-metadata-corruption.patch added to mm-nonmm-unstable branch
Message-Id: <20240821212358.7A3B3C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: treat missing sufile header block as metadata corruption
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-treat-missing-sufile-header-block-as-metadata-corruption.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-treat-missing-sufile-header-block-as-metadata-corruption.patch

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
Subject: nilfs2: treat missing sufile header block as metadata corruption
Date: Thu, 22 Aug 2024 00:46:23 +0900

Patch series "nilfs2: prevent unexpected ENOENT propagation".

This series fixes potential issues where the result code -ENOENT, which is
returned internally when a metadata file operation encouters a hole block,
is exposed to user space without being properly handled.

Several issues with the same cause leading to hangs or WARN_ON check
failures have been reported by syzbot and fixed each time in the past. 
This collectively fixes the missing -ENOENT conversions that do not cause
stability issues and are not covered by syzbot.


This patch (of 5):

The sufile, a metadata file that holds metadata for segment management,
has statistical information in its first block, but if reading this block
fails, it receives the internal code -ENOENT and returns it unchanged to
the callers.

To prevent this -ENOENT from being propagated to system calls, if reading
the header block fails, return -EIO (or -EINVAL depending on the context)
instead.

Link: https://lkml.kernel.org/r/20240821154627.11848-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20240821154627.11848-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/fs/nilfs2/sufile.c~nilfs2-treat-missing-sufile-header-block-as-metadata-corruption
+++ a/fs/nilfs2/sufile.c
@@ -79,10 +79,17 @@ nilfs_sufile_block_get_segment_usage(con
 		NILFS_MDT(sufile)->mi_entry_size;
 }
 
-static inline int nilfs_sufile_get_header_block(struct inode *sufile,
-						struct buffer_head **bhp)
+static int nilfs_sufile_get_header_block(struct inode *sufile,
+					 struct buffer_head **bhp)
 {
-	return nilfs_mdt_get_block(sufile, 0, 0, NULL, bhp);
+	int err = nilfs_mdt_get_block(sufile, 0, 0, NULL, bhp);
+
+	if (unlikely(err == -ENOENT)) {
+		nilfs_error(sufile->i_sb,
+			    "missing header block in segment usage metadata");
+		err = -EIO;
+	}
+	return err;
 }
 
 static inline int
@@ -1237,9 +1244,15 @@ int nilfs_sufile_read(struct super_block
 	if (err)
 		goto failed;
 
-	err = nilfs_sufile_get_header_block(sufile, &header_bh);
-	if (err)
+	err = nilfs_mdt_get_block(sufile, 0, 0, NULL, &header_bh);
+	if (unlikely(err)) {
+		if (err == -ENOENT) {
+			nilfs_err(sb,
+				  "missing header block in segment usage metadata");
+			err = -EINVAL;
+		}
 		goto failed;
+	}
 
 	sui = NILFS_SUI(sufile);
 	kaddr = kmap_local_page(header_bh->b_page);
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

