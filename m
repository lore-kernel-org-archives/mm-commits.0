Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9A97604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103979; cv=none; b=W7gewNTugywbBq7id3COKVHoFtJKvDg9+iVow0ObWe1h/9DlJII7XWf/D+75PQZIKF4n9VIC6uoc196uajOWhY4NmTJOeWxDzGguvvlyy3ZYpQiz6PpNnF3KTXnP2FS4ylp/IM+yKCl6Exrike0DKEXQNahBiXFAkENb3Py8LcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103979; c=relaxed/simple;
	bh=digTinJWPsRZc64U7GbZAsVJXkWG60QdSG9Z+fW7cCQ=;
	h=Date:To:From:Subject:Message-Id; b=DDZG4kelvVpyJfNjN+Aywgi08+/zPZIClV5ZLKGdPnZ0xkFlFXru2DKiBUo4QtL44PNcrfgff83GEc75DRrc0S51rulrVF9zJm/tXZagvItnhjshEBDFS6jq/sM9av4wxQBCWs5HytoYOcRg7sESnI/fGC7AGx9XRCh3FC4ijGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nPQaj+ZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nPQaj+ZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1996C113CD;
	Fri, 26 Apr 2024 03:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103979;
	bh=digTinJWPsRZc64U7GbZAsVJXkWG60QdSG9Z+fW7cCQ=;
	h=Date:To:From:Subject:From;
	b=nPQaj+ZE6egCsQ767eOT869VxMGYCrxyM+Bgta9+zO39EFCiQHzJioVtgMPLWFEN3
	 m9ulw7HBBr8YsLGEQ4z5ftDwSnbhJyCZt4WMx6uGYOkjnmeY5ZoMcg9ETZlxrTNZmw
	 KTBKrTIdS70nEQf0KEPJUcVvHGnwI8334FEhZFi8=
Date: Thu, 25 Apr 2024 20:59:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@ZenIV.linux.org.uk,tujinjiang@huawei.com,jack@suse.cz,brauner@kernel.org,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags.patch removed from -mm tree
Message-Id: <20240426035939.B1996C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: don't decrease mmap_miss when folio has workingset flag
has been removed from the -mm tree.  Its filename was
     mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/filemap: don't decrease mmap_miss when folio has workingset flag
Date: Fri, 22 Mar 2024 17:35:55 +0800

If there are too many folios that are recently evicted in a file, then
they will probably continue to be evicted.  In such situation, there is no
positive effect to read-ahead this file since it is only a waste of IO.

The mmap_miss is increased in do_sync_mmap_readahead() and decreased in
both do_async_mmap_readahead() and filemap_map_pages().  In order to skip
read-ahead in above scenario, the mmap_miss have to increased exceed
MMAP_LOTSAMISS.  This can be done by stop decreased mmap_miss when folio
has workingset flag.  The async path is not to care because in above
scenario, it's hard to run into the async path.

[liushixin2@huawei.com: add comments]
  Link: https://lkml.kernel.org/r/20240326065026.1910584-1-liushixin2@huawei.com
Link: https://lkml.kernel.org/r/20240322093555.226789-3-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags
+++ a/mm/filemap.c
@@ -3492,7 +3492,15 @@ static vm_fault_t filemap_map_folio_rang
 		if (PageHWPoison(page + count))
 			goto skip;
 
-		(*mmap_miss)++;
+		/*
+		 * If there are too many folios that are recently evicted
+		 * in a file, they will probably continue to be evicted.
+		 * In such situation, read-ahead is only a waste of IO.
+		 * Don't decrease mmap_miss in this scenario to make sure
+		 * we can stop read-ahead.
+		 */
+		if (!folio_test_workingset(folio))
+			(*mmap_miss)++;
 
 		/*
 		 * NOTE: If there're PTE markers, we'll leave them to be
@@ -3541,7 +3549,9 @@ static vm_fault_t filemap_map_order0_fol
 	if (PageHWPoison(page))
 		return ret;
 
-	(*mmap_miss)++;
+	/* See comment of filemap_map_folio_range() */
+	if (!folio_test_workingset(folio))
+		(*mmap_miss)++;
 
 	/*
 	 * NOTE: If there're PTE markers, we'll leave them to be
_

Patches currently in -mm which might be from liushixin2@huawei.com are


