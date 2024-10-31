Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581D212C491
	for <mm-commits@vger.kernel.org>; Thu, 31 Oct 2024 03:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730344512; cv=none; b=CXAX5d7jjwN2n+Cxpjy9nMhNoHFLNJ0vwtP1QOxaDbEVwAklY0Mozhx37TF71uUUCxRAjWLaVrFFt+Sb9jqyO9yBD2r8e5nebzINeujBtY9GBpA6CkTPGKLgmvE9eKV3udS8D7F61GIRvVu19cT6O42NZLzzEH9rK/AHZAkNqqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730344512; c=relaxed/simple;
	bh=79HuR79gKkubZuBgPeTdUQNmPAGhy85G6B/DNUCKKrM=;
	h=Date:To:From:Subject:Message-Id; b=kpZirEf9+vA8RpnBM3/XMhoqyC71qIEZK5w5u/QHz3gXiZCgJ+iRBwbJ4vZZ0Q2c5Z8QpTcQN81hrfewxLS49NBVgXxBBWARmedkYY6VbLFa6Tnima7eLBkhq7ur+LDqyDGikWZk7He4oP8mAfwK2NS/mKj0lPIMjkeWtcdzi2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uNv7vSBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uNv7vSBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21790C4CECF;
	Thu, 31 Oct 2024 03:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730344512;
	bh=79HuR79gKkubZuBgPeTdUQNmPAGhy85G6B/DNUCKKrM=;
	h=Date:To:From:Subject:From;
	b=uNv7vSBcPK7bndzhhwTdDy5IEF2p18foHiOwOS1ODecLQ6I2BYsV1nw8uvalAEA/u
	 1dVDn4GnLczA5/G55b7M3Visz7JzpMwjgyAgkYT0I+M5dWM2NeSLijo4HmOT70EL5q
	 5o3VeenhJMzu90ld4+qOh8sv2iQN63u6MzyT8RCA=
Date: Wed, 30 Oct 2024 20:15:11 -0700
To: mm-commits@vger.kernel.org,yi1.lai@linux.intel.com,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] squashfs-fix-variable-overflow-in-squashfs_readpage_block.patch removed from -mm tree
Message-Id: <20241031031512.21790C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Squashfs: fix variable overflow in squashfs_readpage_block
has been removed from the -mm tree.  Its filename was
     squashfs-fix-variable-overflow-in-squashfs_readpage_block.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: fix variable overflow in squashfs_readpage_block
Date: Mon, 21 Oct 2024 00:22:00 +0100

Syzbot reports a slab out of bounds access in squashfs_readpage_block().

This is caused by an attempt to read page index 0x2000000000.  This value
(start_index) is stored in an integer loop variable which overflows
producing a value of 0.  This causes a loop which iterates over pages
start_index -> end_index to iterate over 0 -> end_index, which ultimately
causes an out of bounds page array access.

Fix by changing variable to a loff_t, and rename to index to make it
clearer it is a page index, and not a loop count.

Link: https://lkml.kernel.org/r/20241020232200.837231-1-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
Closes: https://lore.kernel.org/all/ZwzcnCAosIPqQ9Ie@ly-workstation/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file_direct.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/squashfs/file_direct.c~squashfs-fix-variable-overflow-in-squashfs_readpage_block
+++ a/fs/squashfs/file_direct.c
@@ -30,7 +30,8 @@ int squashfs_readpage_block(struct page
 	int mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
 	loff_t start_index = folio->index & ~mask;
 	loff_t end_index = start_index | mask;
-	int i, n, pages, bytes, res = -ENOMEM;
+	loff_t index;
+	int i, pages, bytes, res = -ENOMEM;
 	struct page **page, *last_page;
 	struct squashfs_page_actor *actor;
 	void *pageaddr;
@@ -45,9 +46,9 @@ int squashfs_readpage_block(struct page
 		return res;
 
 	/* Try to grab all the pages covered by the Squashfs block */
-	for (i = 0, n = start_index; n <= end_index; n++) {
-		page[i] = (n == folio->index) ? target_page :
-			grab_cache_page_nowait(target_page->mapping, n);
+	for (i = 0, index = start_index; index <= end_index; index++) {
+		page[i] = (index == folio->index) ? target_page :
+			grab_cache_page_nowait(target_page->mapping, index);
 
 		if (page[i] == NULL)
 			continue;
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are


