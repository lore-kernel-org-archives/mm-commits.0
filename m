Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249725DF15
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970562; cv=none; b=qNIGuh1+zOt4KmiM1VD1smMywyCzxEb4+LdgSM1DAaeOw9qdLMgOZI3BNQ7XFw03lZJrJgUEZYKX94vpY8Ibo4T7UkbmAV//ZHYU4Tp38KYauAg0TiWU7lc4DNxW1YIIiWyOS7QJzWG/fJMJybpkdQQPZArJu+NAT7shQCG96SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970562; c=relaxed/simple;
	bh=S2jOg0JnZIJYwOL1X7htZislNwScTiM0gJNoiz/NDGU=;
	h=Date:To:From:Subject:Message-Id; b=RoW6QawAVSl4vo7GAv2rPBzhjuYO4SXHkXRL9eqMjLm6kIcUkmuUBr2lQOuvjLVA4T3NJZhJdeswqPzX6raVo5pdWglEO0MZa7Kdtwqt7bN/DWVX2uaVsE7tGVNf2qNMoYyymPT+rls5HekTTo6Z4QJ0W7BGfnqfgqaHWl9QxUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qLmJSQ3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qLmJSQ3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C22CC433C7;
	Tue, 23 Jan 2024 00:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970562;
	bh=S2jOg0JnZIJYwOL1X7htZislNwScTiM0gJNoiz/NDGU=;
	h=Date:To:From:Subject:From;
	b=qLmJSQ3YK7iwQsGIBstS8eK008HhL2Xw4m0exeeln4mh6f2ftP6I6an8vclFa8wzp
	 l2P8ZhXeo0DOab0DnsvRrSyiVgftGp5y/A5Ah6AqoxwjXMe3b9jdrCDEDEiAbpwKbC
	 z8RdwTkgPcx4metV5SpBZlWpCCd394SCnQYD7s8Y=
Date: Mon, 22 Jan 2024 16:42:38 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-nilfs_copy_buffer-to-use-kmap_local.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004241.6C22CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: convert nilfs_copy_buffer() to use kmap_local
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-nilfs_copy_buffer-to-use-kmap_local.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-nilfs_copy_buffer-to-use-kmap_local.patch

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
Subject: nilfs2: convert nilfs_copy_buffer() to use kmap_local
Date: Mon, 22 Jan 2024 23:01:50 +0900

The routine nilfs_copy_buffer() that copies a block buffer still uses the
deprecated kmap_atomic(), so convert it to use kmap_local.

Link: https://lkml.kernel.org/r/20240122140202.6950-4-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/page.c~nilfs2-convert-nilfs_copy_buffer-to-use-kmap_local
+++ a/fs/nilfs2/page.c
@@ -103,11 +103,11 @@ void nilfs_copy_buffer(struct buffer_hea
 	struct page *spage = sbh->b_page, *dpage = dbh->b_page;
 	struct buffer_head *bh;
 
-	kaddr0 = kmap_atomic(spage);
-	kaddr1 = kmap_atomic(dpage);
+	kaddr0 = kmap_local_page(spage);
+	kaddr1 = kmap_local_page(dpage);
 	memcpy(kaddr1 + bh_offset(dbh), kaddr0 + bh_offset(sbh), sbh->b_size);
-	kunmap_atomic(kaddr1);
-	kunmap_atomic(kaddr0);
+	kunmap_local(kaddr1);
+	kunmap_local(kaddr0);
 
 	dbh->b_state = sbh->b_state & NILFS_BUFFER_INHERENT_BITS;
 	dbh->b_blocknr = sbh->b_blocknr;
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

