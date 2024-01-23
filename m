Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C54B5DF15
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970555; cv=none; b=ZcnpdwE4OLSi+n/ORGpXHraF3qRKhMEQYjTlfHZ+4htRxu+Zm9kLU+5wCibmqjhxdBKFEHcPg3zFkVf/35StyyoB/+kSEmqW0xzrzSmMrdiuWctQ9q6RzvqPW6HCRPlkJaw0rWxxpBtaV4hsSpBzqbOc+ac/sgpReIpbMa57qds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970555; c=relaxed/simple;
	bh=dvPpm75C6l5OD6PqYC2F6piDoF1hxCjW7hEBsA+NvWg=;
	h=Date:To:From:Subject:Message-Id; b=HgY18fHDUMzwFgAIz76qZ2mL6euYsoqXPvkWGt38qqKXw6fxFpeoAUxiylNBDN21tKG5ilzqKhfj4nZshzDkX2Gd40MfVWAsN2bmp1hTYzzDT/AECw/VdPxfhk4Du5yL0b+AhRkIEL4tAxypbSu3WNiaSjD/bRRjpNbkKF9SpeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XRGJ5OEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XRGJ5OEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E230C43394;
	Tue, 23 Jan 2024 00:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970554;
	bh=dvPpm75C6l5OD6PqYC2F6piDoF1hxCjW7hEBsA+NvWg=;
	h=Date:To:From:Subject:From;
	b=XRGJ5OEjF9QmqYYMYmzOR1r1wrloIiMcLSZqmdLwCWQuIeDNYXKybZjxZc+N6tzXA
	 PMfC/4k6/PWXHvgWxtaz+ia6/XHHW7Dwo88ZRdu1wJKZfSSiJ54DmidS7Z2Y1zNOZj
	 Pd1B9UoLE7y1ZnOZOVJCPMYhqvuDSw6GgW3cneOc=
Date: Mon, 22 Jan 2024 16:42:31 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-recovery-logic-to-use-kmap_local.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004234.0E230C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: convert recovery logic to use kmap_local
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-recovery-logic-to-use-kmap_local.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-recovery-logic-to-use-kmap_local.patch

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
Subject: nilfs2: convert recovery logic to use kmap_local
Date: Mon, 22 Jan 2024 23:01:48 +0900

Patch series "nilfs2: eliminate kmap and kmap_atomic calls".

This series converts remaining kmap and kmap_atomic calls to use
kmap_local, mainly in metadata files, and eliminates calls to these
deprecated kmap functions from nilfs2.

This series does not include converting metadata files to use folios, but
it is a step in that direction.

Most conversions are straightforward, but some are not: the checkpoint
file, the inode file, and the persistent object allocator.  These have
been adjusted or rewritten to avoid multiple kmap_local calls or nest them
if necessary, and to eliminate long waits like block I/O within the
highmem mapping sections.

This series has been tested in both 32-bit and 64-bit environments with
varying block sizes.


This patch (of 15):

In the recovery function when mounting, nilfs_recovery_copy_block() uses
the deprecated kmap_atomic(), so convert it to use kmap_local.

Link: https://lkml.kernel.org/r/20240122140202.6950-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20240122140202.6950-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/recovery.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/recovery.c~nilfs2-convert-recovery-logic-to-use-kmap_local
+++ a/fs/nilfs2/recovery.c
@@ -481,9 +481,9 @@ static int nilfs_recovery_copy_block(str
 	if (unlikely(!bh_org))
 		return -EIO;
 
-	kaddr = kmap_atomic(page);
+	kaddr = kmap_local_page(page);
 	memcpy(kaddr + bh_offset(bh_org), bh_org->b_data, bh_org->b_size);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 	brelse(bh_org);
 	return 0;
 }
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

