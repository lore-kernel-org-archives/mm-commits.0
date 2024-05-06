Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A291D25757
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957096; cv=none; b=daM7dn9mzvcTBbnq2tHRUa88XPdosE06j/iIl23OIqbRRAVlK8E1msem3Q15p46Urje2sYep3KktAAKm9tIkcS9oDRwcLPg2uDna4SujGx1GVY9j2eMaWxlonP7SftRDB43KlLoxUzvrDNj8YaB6XLa/ckaPDbWXT2ER/uZJevU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957096; c=relaxed/simple;
	bh=hnrx4n/2AIzrBmVKqV9lw/btmP0NK8Qxo4lzLRW4Wus=;
	h=Date:To:From:Subject:Message-Id; b=D+gKBW8doRmcKjW3MdHDtAUrU/SqBEwRoF3bAG9NJ1tQeNPbOa/5hhqk1YBRrM7P+/mR+Y8H3m5PLCzB5PhCFPxXQh/DUxYepHSe+YzhqUja7SDT8UwNaMnHsPgsz/qitmbyDSdIyadKUkc8BWXJ1YZiQglb0Z6YttorjVAhOnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zuImYNAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zuImYNAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E08C116B1;
	Mon,  6 May 2024 00:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957096;
	bh=hnrx4n/2AIzrBmVKqV9lw/btmP0NK8Qxo4lzLRW4Wus=;
	h=Date:To:From:Subject:From;
	b=zuImYNAHpg9lRAIabTXMATJMyRtuEg4tq/1x5Y3wKpvfHoKLpVyYXH63llysKIVMb
	 YFPxv/FFzFW/HMAmbB2G5lclNe8ADjrsxScw4u7KS41Gdoy1X6QjRds6vtuBRf6mu6
	 OZ0JNg5ItuYiQP8hgkolGrjao0zpmoI/G/R6TGJo=
Date: Sun, 05 May 2024 17:58:15 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,ebiggers@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch removed from -mm tree
Message-Id: <20240506005816.70E08C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: f2fs: convert f2fs_clear_page_cache_dirty_tag to use a folio
has been removed from the -mm tree.  Its filename was
     f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: f2fs: convert f2fs_clear_page_cache_dirty_tag to use a folio
Date: Tue, 23 Apr 2024 23:55:33 +0100

Removes uses of page_mapping() and page_index().

Link: https://lkml.kernel.org/r/20240423225552.4113447-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/f2fs/data.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/f2fs/data.c~f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio
+++ a/fs/f2fs/data.c
@@ -4082,11 +4082,12 @@ const struct address_space_operations f2
 
 void f2fs_clear_page_cache_dirty_tag(struct page *page)
 {
-	struct address_space *mapping = page_mapping(page);
+	struct folio *folio = page_folio(page);
+	struct address_space *mapping = folio->mapping;
 	unsigned long flags;
 
 	xa_lock_irqsave(&mapping->i_pages, flags);
-	__xa_clear_mark(&mapping->i_pages, page_index(page),
+	__xa_clear_mark(&mapping->i_pages, folio->index,
 						PAGECACHE_TAG_DIRTY);
 	xa_unlock_irqrestore(&mapping->i_pages, flags);
 }
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

