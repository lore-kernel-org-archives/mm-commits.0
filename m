Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91971A01B4;
	Mon, 24 Jun 2024 23:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719270187; cv=none; b=cNssKVsvGwydHmcQYz2hIf3VuoTY9vfvuAmjiHtRJToViDJi8dY62ETmhPfd/fvLW7vP347dr0df6FQxIVcyLNOMaJLZXlVtTZpHm0P7ZQYShnMdiExiT6f/V/4gsMQrfL5cXGozbAOUO2e9/44C3vj2Cq+/N5MFcof2oaFPpSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719270187; c=relaxed/simple;
	bh=yTL4sscG5UzRy7Fzkoua+4LtRBFmTDyAx6Czvbqc40I=;
	h=Date:To:From:Subject:Message-Id; b=iLEs7hVoRnD6gOGbEpuWUyOfKh/I02tDvoS2wvzh0Yn+WZhJ0/EZICeSye+n6Bhvt/9755Xi2UxSnGrFTGAx+dQAKAxbMX9iKhv2nv/0nDpSv9ax7U9uhNtskxK00TVvWSb22y9LHHcW/q/zdyHhwG9o1fwrTsxzzK6k6S9BSRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H8RvMADw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H8RvMADw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23ED9C32789;
	Mon, 24 Jun 2024 23:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719270187;
	bh=yTL4sscG5UzRy7Fzkoua+4LtRBFmTDyAx6Czvbqc40I=;
	h=Date:To:From:Subject:From;
	b=H8RvMADwiAMLcXaPGjEDP1E1ytQnTbzFQCMwYBZYxA2fq3joLwq81WH04ewTiQFHR
	 JETpTROWVkbPxAU82mBqrI6abHt15PLgQStTMJZfAJICr3B1M2jTW9qokz2TOf4ukZ
	 mVgUK++UT8wLKnONloyfeZow3UURqRiWfPsjedh8=
Date: Mon, 24 Jun 2024 16:03:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,jack@suse.cz,hdanton@sina.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-inode-number-range-checks.patch added to mm-hotfixes-unstable branch
Message-Id: <20240624230307.23ED9C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix inode number range checks
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-inode-number-range-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-inode-number-range-checks.patch

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
Subject: nilfs2: fix inode number range checks
Date: Sun, 23 Jun 2024 14:11:33 +0900

Patch series "nilfs2: fix potential issues related to reserved inodes".

This series fixes one use-after-free issue reported by syzbot, caused by
nilfs2's internal inode being exposed in the namespace on a corrupted
filesystem, and a couple of flaws that cause problems if the starting
number of non-reserved inodes written in the on-disk super block is
intentionally (or corruptly) changed from its default value.  


This patch (of 3):

In the current implementation of nilfs2, "nilfs->ns_first_ino", which
gives the first non-reserved inode number, is read from the superblock,
but its lower limit is not checked.

As a result, if a number that overlaps with the inode number range of
reserved inodes such as the root directory or metadata files is set in the
super block parameter, the inode number test macros (NILFS_MDT_INODE and
NILFS_VALID_INODE) will not function properly.

In addition, these test macros use left bit-shift calculations using with
the inode number as the shift count via the BIT macro, but the result of a
shift calculation that exceeds the bit width of an integer is undefined in
the C specification, so if "ns_first_ino" is set to a large value other
than the default value NILFS_USER_INO (=11), the macros may potentially
malfunction depending on the environment.

Fix these issues by checking the lower bound of "nilfs->ns_first_ino" and
by preventing bit shifts equal to or greater than the NILFS_USER_INO
constant in the inode number test macros.

Also, change the type of "ns_first_ino" from signed integer to unsigned
integer to avoid the need for type casting in comparisons such as the
lower bound check introduced this time.

Link: https://lkml.kernel.org/r/20240623051135.4180-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20240623051135.4180-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/nilfs.h     |    5 +++--
 fs/nilfs2/the_nilfs.c |    6 ++++++
 fs/nilfs2/the_nilfs.h |    2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/nilfs.h~nilfs2-fix-inode-number-range-checks
+++ a/fs/nilfs2/nilfs.h
@@ -116,9 +116,10 @@ enum {
 #define NILFS_FIRST_INO(sb) (((struct the_nilfs *)sb->s_fs_info)->ns_first_ino)
 
 #define NILFS_MDT_INODE(sb, ino) \
-	((ino) < NILFS_FIRST_INO(sb) && (NILFS_MDT_INO_BITS & BIT(ino)))
+	((ino) < NILFS_USER_INO && (NILFS_MDT_INO_BITS & BIT(ino)))
 #define NILFS_VALID_INODE(sb, ino) \
-	((ino) >= NILFS_FIRST_INO(sb) || (NILFS_SYS_INO_BITS & BIT(ino)))
+	((ino) >= NILFS_FIRST_INO(sb) ||				\
+	 ((ino) < NILFS_USER_INO && (NILFS_SYS_INO_BITS & BIT(ino))))
 
 /**
  * struct nilfs_transaction_info: context information for synchronization
--- a/fs/nilfs2/the_nilfs.c~nilfs2-fix-inode-number-range-checks
+++ a/fs/nilfs2/the_nilfs.c
@@ -452,6 +452,12 @@ static int nilfs_store_disk_layout(struc
 	}
 
 	nilfs->ns_first_ino = le32_to_cpu(sbp->s_first_ino);
+	if (nilfs->ns_first_ino < NILFS_USER_INO) {
+		nilfs_err(nilfs->ns_sb,
+			  "too small lower limit for non-reserved inode numbers: %u",
+			  nilfs->ns_first_ino);
+		return -EINVAL;
+	}
 
 	nilfs->ns_blocks_per_segment = le32_to_cpu(sbp->s_blocks_per_segment);
 	if (nilfs->ns_blocks_per_segment < NILFS_SEG_MIN_BLOCKS) {
--- a/fs/nilfs2/the_nilfs.h~nilfs2-fix-inode-number-range-checks
+++ a/fs/nilfs2/the_nilfs.h
@@ -182,7 +182,7 @@ struct the_nilfs {
 	unsigned long		ns_nrsvsegs;
 	unsigned long		ns_first_data_block;
 	int			ns_inode_size;
-	int			ns_first_ino;
+	unsigned int		ns_first_ino;
 	u32			ns_crc_seed;
 
 	/* /sys/fs/<nilfs>/<device> */
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-inode-number-range-checks.patch
nilfs2-add-missing-check-for-inode-numbers-on-directory-entries.patch
nilfs2-fix-incorrect-inode-allocation-from-reserved-inodes.patch
nilfs2-prepare-backing-device-folios-for-writing-after-adding-checksums.patch
nilfs2-do-not-call-inode_attach_wb-directly.patch

