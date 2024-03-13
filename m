Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9594A818;
	Wed, 13 Mar 2024 18:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710354641; cv=none; b=ILKN8qkvjXY5y2l4Zn/7u0gIwcm9ZAQsU5iX0x0Kc/MBDz70VCfKLXYgI+t9BielZ4sUm8bXuC/JMSUv3QkTqlJvNAWLY52IbVla4BytkPy9boT3+lYD/zTmvhDNBUPW5tHG/HiI0dePAC3E9MFRDNdZgykSKE/wtlA5VQF5H6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710354641; c=relaxed/simple;
	bh=/vaAKpFzWoxnjAHS0sGqyYvi6MEkIKEPDMKRahpe4nM=;
	h=Date:To:From:Subject:Message-Id; b=ov8LLJXYdp8corses+DNv8SAPeNEWuS6hnuDxKtin9I9HkOltT9nj0QQvQ0GeJkaZM9xj9URMmJsbkfPIpr1vMnsISP3eaAvWW8dPkDvWBAZXMELqdvL5hj6i9tE5YrYF69YIyBCcz+FLyEqzvpFCLPUZWfbfuoe387hOzwNfwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GisqNEiB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GisqNEiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8F9C433F1;
	Wed, 13 Mar 2024 18:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710354641;
	bh=/vaAKpFzWoxnjAHS0sGqyYvi6MEkIKEPDMKRahpe4nM=;
	h=Date:To:From:Subject:From;
	b=GisqNEiB6kVqkfI1bt8V7mBGZMB1SI47LfmZiw56vVGFe7Y+ZYnV6D8W4gbxoCRt5
	 Ix1J8N/4EcRTU7eWwmt8woCeWoda9dIUGxl+ytAHUMPlBTD/nqwmo1RBLVd6Z2iy/G
	 QsfkS7NCipQ9Og2tl0SMDoceQRPOuupi/SsOYQ8g=
Date: Wed, 13 Mar 2024 11:30:39 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-prevent-kernel-bug-at-submit_bh_wbc.patch added to mm-nonmm-unstable branch
Message-Id: <20240313183041.0D8F9C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: prevent kernel bug at submit_bh_wbc()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-prevent-kernel-bug-at-submit_bh_wbc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-prevent-kernel-bug-at-submit_bh_wbc.patch

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
Subject: nilfs2: prevent kernel bug at submit_bh_wbc()
Date: Wed, 13 Mar 2024 19:58:27 +0900

Fix a bug where nilfs_get_block() returns a successful status when
searching and inserting the specified block both fail inconsistently.  If
this inconsistent behavior is not due to a previously fixed bug, then an
unexpected race is occurring, so return a temporary error -EAGAIN instead.

This prevents callers such as __block_write_begin_int() from requesting a
read into a buffer that is not mapped, which would cause the BUG_ON check
for the BH_Mapped flag in submit_bh_wbc() to fail.

Link: https://lkml.kernel.org/r/20240313105827.5296-3-konishi.ryusuke@gmail.com
Fixes: 1f5abe7e7dbc ("nilfs2: replace BUG_ON and BUG calls triggerable from ioctl")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/inode.c~nilfs2-prevent-kernel-bug-at-submit_bh_wbc
+++ a/fs/nilfs2/inode.c
@@ -112,7 +112,7 @@ int nilfs_get_block(struct inode *inode,
 					   "%s (ino=%lu): a race condition while inserting a data block at offset=%llu",
 					   __func__, inode->i_ino,
 					   (unsigned long long)blkoff);
-				err = 0;
+				err = -EAGAIN;
 			}
 			nilfs_transaction_abort(inode->i_sb);
 			goto out;
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-failure-to-detect-dat-corruption-in-btree-and-direct-mappings.patch
nilfs2-prevent-kernel-bug-at-submit_bh_wbc.patch

