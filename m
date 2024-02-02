Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5455813EFF3;
	Fri,  2 Feb 2024 12:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706875987; cv=none; b=DNT6svnAuyA8SKA98AJkFOnW4D2ea2nKlH0/a4mtzqCzfHV7yGGu9iOROAh2DwtsT5XA+uRlxeo+YOqVWkhbXqMrmKHAGX9zyHCtD2Q8mawTOhO2u08yvSIeiDXRuQcJcYHPhWehLh1ODCegwT/P6WSNgz6jU4xxhcIWn5riZyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706875987; c=relaxed/simple;
	bh=sfEUP45tPKEf4GRMpoyuVvNWZMPv1Waxj0bz+z2Il84=;
	h=Date:To:From:Subject:Message-Id; b=WfSlbebuaF7mfXFkV5sM/gWXH1jF69UpjKk1pNnWwEFWeT/Srr3n87EJjHbRQ3iaXGOY+0mEjJRpDIWmZDo4OTkqn6JzKbcXjLhfYxp0qil4B2dPvj7WussbMFpDL0l2RPkjmbNMsj0JovWr+S44aL2HLepkQUMX9bdtGo3mkA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vMPoIhKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vMPoIhKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEF4C433F1;
	Fri,  2 Feb 2024 12:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706875986;
	bh=sfEUP45tPKEf4GRMpoyuVvNWZMPv1Waxj0bz+z2Il84=;
	h=Date:To:From:Subject:From;
	b=vMPoIhKBkSCTlK7DppNSiAb61kNE+bhBweHhKo+T4tNmEI1MUBYnkPSLrLKanpyEC
	 nQY4h2CqJ+nb7El3OL2kIdX9Rj0N3yNGl2YcQdsWQ9Ya7qEBaxOSHDRjc3okm5iVlm
	 6Ty625r2VeMenr73/V455lJYdp3VztXFjMJZckjg=
Date: Fri, 02 Feb 2024 04:13:04 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-hang-in-nilfs_lookup_dirty_data_buffers.patch added to mm-hotfixes-unstable branch
Message-Id: <20240202121306.7CEF4C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix hang in nilfs_lookup_dirty_data_buffers()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-hang-in-nilfs_lookup_dirty_data_buffers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-hang-in-nilfs_lookup_dirty_data_buffers.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: nilfs2: fix hang in nilfs_lookup_dirty_data_buffers()
Date: Wed, 31 Jan 2024 23:56:57 +0900

Syzbot reported a hang issue in migrate_pages_batch() called by mbind()
and nilfs_lookup_dirty_data_buffers() called in the log writer of nilfs2.

While migrate_pages_batch() locks a folio and waits for the writeback to
complete, the log writer thread that should bring the writeback to
completion picks up the folio being written back in
nilfs_lookup_dirty_data_buffers() that it calls for subsequent log
creation and was trying to lock the folio.  Thus causing a deadlock.

In the first place, it is unexpected that folios/pages in the middle of
writeback will be updated and become dirty.  Nilfs2 adds a checksum to
verify the validity of the log being written and uses it for recovery at
mount, so data changes during writeback are suppressed.  Since this is
broken, an unclean shutdown could potentially cause recovery to fail.

Investigation revealed that the root cause is that the wait for writeback
completion in nilfs_page_mkwrite() is conditional, and if the backing
device does not require stable writes, data may be modified without
waiting.

Fix these issues by making nilfs_page_mkwrite() wait for writeback to
finish regardless of the stable write requirement of the backing device.

Link: https://lkml.kernel.org/r/20240131145657.4209-1-konishi.ryusuke@gmail.com
Fixes: 1d1d1a767206 ("mm: only enforce stable page writes if the backing device requires it")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+ee2ae68da3b22d04cd8d@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/00000000000047d819061004ad6c@google.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/file.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/file.c~nilfs2-fix-hang-in-nilfs_lookup_dirty_data_buffers
+++ a/fs/nilfs2/file.c
@@ -107,7 +107,13 @@ static vm_fault_t nilfs_page_mkwrite(str
 	nilfs_transaction_commit(inode->i_sb);
 
  mapped:
-	folio_wait_stable(folio);
+	/*
+	 * Since checksumming including data blocks is performed to determine
+	 * the validity of the log to be written and used for recovery, it is
+	 * necessary to wait for writeback to finish here, regardless of the
+	 * stable write requirement of the backing device.
+	 */
+	folio_wait_writeback(folio);
  out:
 	sb_end_pagefault(inode->i_sb);
 	return vmf_fs_error(ret);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-data-corruption-in-dsync-block-recovery-for-small-block-sizes.patch
nilfs2-fix-hang-in-nilfs_lookup_dirty_data_buffers.patch
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

