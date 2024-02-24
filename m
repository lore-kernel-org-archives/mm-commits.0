Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D471D53F
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739471; cv=none; b=lFTkFc04RQW4645jz05xGceVJIiIjjUfOmch+NhhDsvZnYXVhwDbDPTqtfwnqReFSPAXjqm5l3a1LQRW2S8NUjX/rtK9KUOC41+gRSGjW0Zu2nXN3VnVRuTmCv7Hy8yKNNZOhZeLiC67EaXlBh8VJlwTIEdjTI5ltJyfaB3qVGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739471; c=relaxed/simple;
	bh=eoCV8baoR1TOCJT6COSgoHwewkvLW19I3EjBhY16L+w=;
	h=Date:To:From:Subject:Message-Id; b=gic8Zj5x3kFazsh00joGcfuP7+4SBXX65qEfYDc34PGZNO6tAL/OUMm9Dpjm9pP5kyHBCheDJwY5kQP/jYxZWh6WLngI/vIoMLeXOAGYO8qqBef8FyrBKpoVpiUJHNGIfrQwrXoUndHJ0S3hbE0PZ0Jg3dvuH3phlkK5ddp/Ol8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fw6akYfa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fw6akYfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00742C433F1;
	Sat, 24 Feb 2024 01:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739471;
	bh=eoCV8baoR1TOCJT6COSgoHwewkvLW19I3EjBhY16L+w=;
	h=Date:To:From:Subject:From;
	b=Fw6akYfa6H7TJx4gNtb2F9NLc4YpMfHy0uXEN8OweEIzsAFUykTabY0m9lsARljVy
	 bxK9fTwbk+nJy2FZKY/6rKtvsmAmPWuuqImG5BT9fMJsBpda2rUzUsBArqznmWdkvd
	 dyCBJ3ByjEjGAOUYVnVAJg1RMTZzY6I8XZPIo9jY=
Date: Fri, 23 Feb 2024 17:51:10 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,hch@lst.de,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-remove-a-use-of-write_cache_pages-from-do_writepages.patch removed from -mm tree
Message-Id: <20240224015111.00742C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: remove a use of write_cache_pages() from do_writepages()
has been removed from the -mm tree.  Its filename was
     writeback-remove-a-use-of-write_cache_pages-from-do_writepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: writeback: remove a use of write_cache_pages() from do_writepages()
Date: Thu, 15 Feb 2024 07:36:49 +0100

Use the new writeback_iter() directly instead of indirecting through a
callback.

[hch@lst.de: ported to the while based iter style]
Link: https://lkml.kernel.org/r/20240215063649.2164017-15-hch@lst.de
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/mm/page-writeback.c~writeback-remove-a-use-of-write_cache_pages-from-do_writepages
+++ a/mm/page-writeback.c
@@ -2577,15 +2577,25 @@ int write_cache_pages(struct address_spa
 }
 EXPORT_SYMBOL(write_cache_pages);
 
-static int writepage_cb(struct folio *folio, struct writeback_control *wbc,
-		void *data)
+static int writeback_use_writepage(struct address_space *mapping,
+		struct writeback_control *wbc)
 {
-	struct address_space *mapping = data;
-	int ret = mapping->a_ops->writepage(&folio->page, wbc);
+	struct folio *folio = NULL;
+	struct blk_plug plug;
+	int err;
 
-	if (ret < 0)
-		mapping_set_error(mapping, ret);
-	return ret;
+	blk_start_plug(&plug);
+	while ((folio = writeback_iter(mapping, wbc, folio, &err))) {
+		err = mapping->a_ops->writepage(&folio->page, wbc);
+		if (err == AOP_WRITEPAGE_ACTIVATE) {
+			folio_unlock(folio);
+			err = 0;
+		}
+		mapping_set_error(mapping, err);
+	}
+	blk_finish_plug(&plug);
+
+	return err;
 }
 
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
@@ -2601,12 +2611,7 @@ int do_writepages(struct address_space *
 		if (mapping->a_ops->writepages) {
 			ret = mapping->a_ops->writepages(mapping, wbc);
 		} else if (mapping->a_ops->writepage) {
-			struct blk_plug plug;
-
-			blk_start_plug(&plug);
-			ret = write_cache_pages(mapping, wbc, writepage_cb,
-						mapping);
-			blk_finish_plug(&plug);
+			ret = writeback_use_writepage(mapping, wbc);
 		} else {
 			/* deal with chardevs and other special files */
 			ret = 0;
_

Patches currently in -mm which might be from willy@infradead.org are


