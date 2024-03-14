Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F1673516;
	Thu, 14 Mar 2024 16:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710433075; cv=none; b=n/BEJChzaa9QinJDNTABEIIIRkM3MmQlyLEowuJQ+GGYXSEASsBGxolw0gdz8wqwVkCNiJlbESlxwc5WKXYMNlUPYh3v/7f31wiu1ItgqMhiRw9BMIggk9AHKrVFWJXgl+Z0jVa6zbMuwvTiAAKIjwCZBgVnXTQ6+uiDk/RBxGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710433075; c=relaxed/simple;
	bh=xl3j/E5P1ibC/2vacBUU+w48FOghGVjd8R4+cBgJD3w=;
	h=Date:To:From:Subject:Message-Id; b=rv3ewETO2U3Qy4JTZz/hricsut6T2+3blMmAa8s1SNT8Q0GCgIm4GSu+a04DBnh4DevAP+pkIDsCsFjZjLtJJcTjpg8aJ30zc0HV+KfR0Xp3ME4rYeEyR8AYP7RLpQ8R651UDmJKB53k9jfyzV2q+THlrhTbccm3WYcG+FvfllI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fVgpp3TL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fVgpp3TL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFDEC433F1;
	Thu, 14 Mar 2024 16:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710433074;
	bh=xl3j/E5P1ibC/2vacBUU+w48FOghGVjd8R4+cBgJD3w=;
	h=Date:To:From:Subject:From;
	b=fVgpp3TLnkbjsJLjSOReSA57lTaOFCygqHzABPp5RPE6fzs/v5k+cIsznTQ+ibJmT
	 Q7UMAdp/7yqT8RJhDonNgtz5F+oHG/BdLMw13LBw4m6PMlotq61bnOtfI4xv4MibnS
	 QyWmVR+TfnFyzlwOgulldoRcZO6Evx+xfae/itNk=
Date: Thu, 14 Mar 2024 09:17:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-prevent-kernel-bug-at-submit_bh_wbc.patch removed from -mm tree
Message-Id: <20240314161754.8EFDEC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: prevent kernel bug at submit_bh_wbc()
has been removed from the -mm tree.  Its filename was
     nilfs2-prevent-kernel-bug-at-submit_bh_wbc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


