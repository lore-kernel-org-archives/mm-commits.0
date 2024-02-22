Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB5D137935
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645189; cv=none; b=Xo63CpA7RH+oPNHG1WwLSz/9ypYKW03HJkgNNzicFrsNm7+fJkisDn98VgTNoZnHpJ7fIl/eMEzxkVSgQ3LeYBWr949pFl81Rq66qMG9H8bIQmR6odXJClNzXp9SKyFYIaElFn4/1NGybqrR5GFi/jShpbThtny6rJWDFH6OgwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645189; c=relaxed/simple;
	bh=lkEQxjaADmHA17WGBnlLvLAKyIZgzCP3sGsamMLkdhw=;
	h=Date:To:From:Subject:Message-Id; b=GkkybmyTzhHjVAlTmBDzuY7DqVL29e1KxaRjj70voia/KWYTIo57ScmQl+GtaNqQlK7tko0pSPTW3xGNaSwSWvxZIpHwiR3TOQIXrgCBiddtt7Fpt+HTT+47RuiPsQd+Ja2c2lnueQjtPosmHgHOkbokWNCG0J68lg22x3GR5oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i7GtaHe+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i7GtaHe+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1506C43390;
	Thu, 22 Feb 2024 23:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645189;
	bh=lkEQxjaADmHA17WGBnlLvLAKyIZgzCP3sGsamMLkdhw=;
	h=Date:To:From:Subject:From;
	b=i7GtaHe+0wGutOnn3hPbDd5v9RoYoKUnkP1Ef2Cdd9/AqgqcisnVyN/UefiQnBRJG
	 03KQ1cGrj7kWt0+2lUOeKO+EaWsxPTbVMzxICLTgBupIPDMbHbOoVxyZmrcNrS/gjp
	 oF+l/ImAtOZRN4pWVMbiUiED3vwB4uQYljhxNmDY=
Date: Thu, 22 Feb 2024 15:39:49 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-convert-metadata-file-common-code-to-use-kmap_local.patch removed from -mm tree
Message-Id: <20240222233949.B1506C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert metadata file common code to use kmap_local
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-metadata-file-common-code-to-use-kmap_local.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


