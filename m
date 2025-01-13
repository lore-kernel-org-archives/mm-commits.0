Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D572E170A0B
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742268; cv=none; b=WwGfVUAdrWatyoXHD7kxOiK2FINeM6H/c2BLrUCvTeE8rBdt6tdfWJ8F0crauXOAdSBWRSV9vWJb89X0p2iNGHQ1MenmGry3Gulcs81NwhvfQV6Pe7XMCEbOoFMYLZgN6UF5tC/XyEIMVA1pkt3QWnJ4GCsPU9rPSxPQ8rGGOkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742268; c=relaxed/simple;
	bh=VIM5pKw8Qk1Jj3xOqtr0+KX0Ac94po5M/OJUiqcEFfU=;
	h=Date:To:From:Subject:Message-Id; b=IGmyr6Q0HfN2E6hZjShIWxwEbgSyJEw1NrhtmHvqmNh6oueKVf19RHubIx+EUZHmimg8z4vnmI576kTX6P3STzV13VpLgwaITNoDYLbxwR3MKeh1mS2j46eauf1AZUTBG0L3Jae+KWbjNHx2TmR+yh0vdT+sonYlfY3EH9GmtwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TEw/KF80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TEw/KF80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEE1C4CED6;
	Mon, 13 Jan 2025 04:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742268;
	bh=VIM5pKw8Qk1Jj3xOqtr0+KX0Ac94po5M/OJUiqcEFfU=;
	h=Date:To:From:Subject:From;
	b=TEw/KF80BVA/hkpF8PBFm4Fnm3yXBYFJLJzelbq2YMjx6/+GkdoI1Kfvxx3zSNOXK
	 2Oj5rZPgduLfMCF3kMa11J+xZj9wssyciikqrDZs6U6pVv99Y8GaMx69hFlvW1Lc7w
	 gpAeSEt6cJ4UQywM0mfySeFQ6ryXAJK6pvTmQyfs=
Date: Sun, 12 Jan 2025 20:24:28 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-protect-access-to-buffers-with-no-active-references.patch removed from -mm tree
Message-Id: <20250113042428.AAEE1C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: protect access to buffers with no active references
has been removed from the -mm tree.  Its filename was
     nilfs2-protect-access-to-buffers-with-no-active-references.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: protect access to buffers with no active references
Date: Wed, 8 Jan 2025 05:00:47 +0900

nilfs_lookup_dirty_data_buffers(), which iterates through the buffers
attached to dirty data folios/pages, accesses the attached buffers without
locking the folios/pages.

For data cache, nilfs_clear_folio_dirty() may be called asynchronously
when the file system degenerates to read only, so
nilfs_lookup_dirty_data_buffers() still has the potential to cause use
after free issues when buffers lose the protection of their dirty state
midway due to this asynchronous clearing and are unintentionally freed by
try_to_free_buffers().

Eliminate this race issue by adjusting the lock section in this function.

Link: https://lkml.kernel.org/r/20250107200202.6432-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/segment.c~nilfs2-protect-access-to-buffers-with-no-active-references
+++ a/fs/nilfs2/segment.c
@@ -734,7 +734,6 @@ static size_t nilfs_lookup_dirty_data_bu
 		if (!head)
 			head = create_empty_buffers(folio,
 					i_blocksize(inode), 0);
-		folio_unlock(folio);
 
 		bh = head;
 		do {
@@ -744,11 +743,14 @@ static size_t nilfs_lookup_dirty_data_bu
 			list_add_tail(&bh->b_assoc_buffers, listp);
 			ndirties++;
 			if (unlikely(ndirties >= nlimit)) {
+				folio_unlock(folio);
 				folio_batch_release(&fbatch);
 				cond_resched();
 				return ndirties;
 			}
 		} while (bh = bh->b_this_page, bh != head);
+
+		folio_unlock(folio);
 	}
 	folio_batch_release(&fbatch);
 	cond_resched();
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


