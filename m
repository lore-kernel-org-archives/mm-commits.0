Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E99521771C
	for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2025 20:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753389441; cv=none; b=kTxyPZF3Nu5OWCLCOu+4rtNktXILcU9DHZnArU5q2AhjmB4biqtpXNRfnvO8JXtTHhhiAafITAOZzTooBkm+bOPc4HT8idiMWzwlchiGEwfXCGJ8V4Nihioa6fylEi2fZLgHA9IWRWKkQyouubSII8auVfmhKWPjL9jco+eqohk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753389441; c=relaxed/simple;
	bh=ZaMUWbDXuYjgMJkC/7676yMeTuBkM5326IGFQBXTtVQ=;
	h=Date:To:From:Subject:Message-Id; b=Yl+ZgCBS9Q/S7SKsWXbggHpNTxQ/Q87g2bsX6yXwSMSeHIopOhcLqAcT/3FQKzWABszxdKQ+m/bee2n9IlqXxz2Bd5/F9Rdm9wFDLFLZRpUgWitr64bZnhGcapGVx75EpqmsBRydNkP/YQBR0fGztGKzP+jI4KTtfe/IZIxksZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0fCHQmHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0fCHQmHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72178C4CEED;
	Thu, 24 Jul 2025 20:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753389440;
	bh=ZaMUWbDXuYjgMJkC/7676yMeTuBkM5326IGFQBXTtVQ=;
	h=Date:To:From:Subject:From;
	b=0fCHQmHZWwiyOdY3IR9j7y2DczmylgcKflb04DFEBUWn0twBEjs4gAYvhv4CMf1/D
	 NS7SwmAf9G7I3TCW6x/rkBW0h0Y2+qFzH6ASngdW5YLQbL6U/euhjEQX/12muZXFbT
	 gcTSSIblO1FlWFzhV0G6NEYuJR+xjfUI0wIu2UqU=
Date: Thu, 24 Jul 2025 13:37:19 -0700
To: mm-commits@vger.kernel.org,sj1557.seo@samsung.com,linkinjeon@kernel.org,hirofumi@mail.parknet.co.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-fix-too-many-log-in-fat_chain_add.patch added to mm-nonmm-unstable branch
Message-Id: <20250724203720.72178C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fat: fix too many log in fat_chain_add()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-fix-too-many-log-in-fat_chain_add.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-fix-too-many-log-in-fat_chain_add.patch

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
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: fix too many log in fat_chain_add()
Date: Thu, 24 Jul 2025 16:42:10 +0900

This log was excessive for a serial console.  So use the ratelimited
version instead.

Link: https://lkml.kernel.org/r/87qzy611d9.fsf@mail.parknet.co.jp
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reported-by: syzbot+fa7ef54f66c189c04b73@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fa7ef54f66c189c04b73
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/misc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/fat/misc.c~fat-fix-too-many-log-in-fat_chain_add
+++ a/fs/fat/misc.c
@@ -158,9 +158,9 @@ int fat_chain_add(struct inode *inode, i
 			mark_inode_dirty(inode);
 	}
 	if (new_fclus != (inode->i_blocks >> (sbi->cluster_bits - 9))) {
-		fat_fs_error(sb, "clusters badly computed (%d != %llu)",
-			     new_fclus,
-			     (llu)(inode->i_blocks >> (sbi->cluster_bits - 9)));
+		fat_fs_error_ratelimit(
+			sb, "clusters badly computed (%d != %llu)", new_fclus,
+			(llu)(inode->i_blocks >> (sbi->cluster_bits - 9)));
 		fat_cache_inval_inode(inode);
 	}
 	inode->i_blocks += nr_cluster << (sbi->cluster_bits - 9);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fat-fix-too-many-log-in-fat_chain_add.patch

