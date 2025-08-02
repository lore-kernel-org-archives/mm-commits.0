Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E0E1E5B72
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 19:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754161350; cv=none; b=ZDd7Yi0Ngh0km9A+z5hIbAwMsiyGguPvlsNSCK3DnhTTLsLkoSOZ0nU5xkXXnmxA1+pKZEojOb4guoIB6UnJ21/G/N0V91A1zzR0CBsalx0EXmwmDesWI7txovuTaoH6WCbyPZWeMtPZadKWhFUmqmD3RtEOIMxLoPxvyQvp6No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754161350; c=relaxed/simple;
	bh=CTPrBhK8dho2QHQ0pU7EOJBEHffGGJZOZl0tXkJB4XM=;
	h=Date:To:From:Subject:Message-Id; b=qgVYWjkU617xnPyRs4PblcnybiYChRrrGDuTo7jtPm8BccScLbWeoGgQRutHXJcwGPjIN8i468awuL1rWYHBAC7DH1tlFRz0EcDQLW1syOiXKrCc0w/Fmvpdv05CoxJBkgKqtdNu6QLJodGiHQXaEuEUoSifLjGIJ27o6K/CM+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZlVCxnjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZlVCxnjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35115C4CEEF;
	Sat,  2 Aug 2025 19:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754161350;
	bh=CTPrBhK8dho2QHQ0pU7EOJBEHffGGJZOZl0tXkJB4XM=;
	h=Date:To:From:Subject:From;
	b=ZlVCxnjvTe+09/zt/APiA7SNyLdC0SUYla5o+8CVMI6rBFI/Nl452oKqgysbC6mlD
	 qcsZKgWavaI0YLhcERHcLct3sliB9IGSVyHXoiCzDBrwcZBlE1p1XuIcVoAEq1gHFj
	 A1M8n6LGLLX+WVJTCnv2Eau1oKkBGjiU1uxEAXzs=
Date: Sat, 02 Aug 2025 12:02:29 -0700
To: mm-commits@vger.kernel.org,sj1557.seo@samsung.com,linkinjeon@kernel.org,hirofumi@mail.parknet.co.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-fix-too-many-log-in-fat_chain_add.patch removed from -mm tree
Message-Id: <20250802190230.35115C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fat: fix too many log in fat_chain_add()
has been removed from the -mm tree.  Its filename was
     fat-fix-too-many-log-in-fat_chain_add.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


