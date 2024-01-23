Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7240F5EE75
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970553; cv=none; b=exbB4EEiRaibS1VJ/tAYBP0ry4N7VxUUm04v6Id1E+eFW4x1MB66qa8knvye9fneZBcecaR3aHFg0mSmnBJ+URUploqi+sWv2bneQWDfBuAYEB4gjM5ZboDupEhcOolvWEpjnudDdiXUlD65jG20MA+QUjCsOnkQrgvFov27KeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970553; c=relaxed/simple;
	bh=bciMCmXA9c2LX2jUnWBbgm8rF9Mb/qoFdF6kKP2halY=;
	h=Date:To:From:Subject:Message-Id; b=QcwkvYqjmkZxCjHiNDF1uege2MVPW559g5d6y1uS66dgQqN5EcNPuYNAcmWh6z46y5R04pSY1iQNCiD4nLhUmKaVTpXaf8jXc3PeIiBFuVMZJEWvc0+q4htsO6u7mE7SoAgxWCk4dB83NixkSylKJ+buPM8YRzeOlBsYDnMBJDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IFMSXQjm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IFMSXQjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FD9C43390;
	Tue, 23 Jan 2024 00:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970550;
	bh=bciMCmXA9c2LX2jUnWBbgm8rF9Mb/qoFdF6kKP2halY=;
	h=Date:To:From:Subject:From;
	b=IFMSXQjmv1QOmeCuQNfnQEBYmbOrWkcG3U1xoRXHWT1EP79TnSq3Yd4x8UzvgoHeA
	 +UFNLatXgvF6KdzGeub4H22zsDHoVyi3mU+zVyHCS7GNGU+pP/bj2UUFcdz4WGvHzF
	 co/vowZm+87u8dsppm9vH0RmE9AW/zJDuw3VWhgI=
Date: Mon, 22 Jan 2024 16:42:27 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-segment-buffer-to-use-kmap_local.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004230.70FD9C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: convert segment buffer to use kmap_local
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-segment-buffer-to-use-kmap_local.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-segment-buffer-to-use-kmap_local.patch

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
Subject: nilfs2: convert segment buffer to use kmap_local
Date: Mon, 22 Jan 2024 23:01:49 +0900

In the segment buffer code used for log writing, a CRC calculation routine
uses the deprecated kmap_atomic(), so convert it to use kmap_local.

Link: https://lkml.kernel.org/r/20240122140202.6950-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segbuf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/segbuf.c~nilfs2-convert-segment-buffer-to-use-kmap_local
+++ a/fs/nilfs2/segbuf.c
@@ -220,9 +220,9 @@ static void nilfs_segbuf_fill_in_data_cr
 		crc = crc32_le(crc, bh->b_data, bh->b_size);
 	}
 	list_for_each_entry(bh, &segbuf->sb_payload_buffers, b_assoc_buffers) {
-		kaddr = kmap_atomic(bh->b_page);
+		kaddr = kmap_local_page(bh->b_page);
 		crc = crc32_le(crc, kaddr + bh_offset(bh), bh->b_size);
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 	}
 	raw_sum->ss_datasum = cpu_to_le32(crc);
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

