Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8716AC15B
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739456; cv=none; b=E5qhkehpeDKNzVebH15fXbS4TQSenDcRg2RCOAX2nSjJiRYtBcs3Vwcm71/1LrydB4doq9gwDm/ucJnSRLQkajOLuseiLO7to5uvSzXK5vp2vWa1Fy9Gxyu5aWSD6yLG7DsovT6EbFMItB/o9FoL9FG4oLKJtEnOdxGifRv9Ad4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739456; c=relaxed/simple;
	bh=8b3Kl0SkzL+UkgNA9Ud7remYdyYUwTI0TQ0kU6RGeSU=;
	h=Date:To:From:Subject:Message-Id; b=RjpEFTZjFBLILTAKfkVpT7vIY4S+LAgG7WuxLd4am+U+ADKoxDL7AAfjOrDxhrmEMkX+NvOKMEguOSGvIH+7twOoovX2n6mT///N/s9bmrWn25S9XZrGf2S19Ohz8SgzwslyCfl1tRKUMiMk3jfCdAjKG4Cke4Or98/AJL2Zw40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kZT6ziPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kZT6ziPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8CDC433C7;
	Sat, 24 Feb 2024 01:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739456;
	bh=8b3Kl0SkzL+UkgNA9Ud7remYdyYUwTI0TQ0kU6RGeSU=;
	h=Date:To:From:Subject:From;
	b=kZT6ziPHlEvNxJlsSOlJeYXl1NiFRxx/42Y4w4IGhPg2OJeOFPsa4pWf8PBbe60w+
	 GwZrJ9JptsdSU+ldovpzinGiMV3zJClgjkyJ/7rARa/qpFLr7q4nRXaOwNLxNktHxq
	 Z3C1KrL5G4pA6bNICNzXswsC2bEsUEjCoI8KKZ7k=
Date: Fri, 23 Feb 2024 17:50:55 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-dont-call-mapping_set_error-on-aop_writepage_activate.patch removed from -mm tree
Message-Id: <20240224015056.5D8CDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: don't call mapping_set_error on AOP_WRITEPAGE_ACTIVATE
has been removed from the -mm tree.  Its filename was
     writeback-dont-call-mapping_set_error-on-aop_writepage_activate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: writeback: don't call mapping_set_error on AOP_WRITEPAGE_ACTIVATE
Date: Thu, 15 Feb 2024 07:36:36 +0100

Patch series "convert write_cache_pages() to an iterator", v8.

This is an evolution of the series Matthew Wilcox originally sent in June
2023, which has changed quite a bit since and now has a while based
iterator.


This patch (of 14):

mapping_set_error should only be called on 0 returns (which it ignores) or
a negative error code.

writepage_cb ends up being able to call writepage_cb on the magic
AOP_WRITEPAGE_ACTIVATE return value from ->writepage which means success
but the caller needs to unlock the page.  Ignore that and just call
mapping_set_error on negative errors.

(no fixes tag as this goes back more than 20 years over various renames
and refactors so I've given up chasing down the original introduction)

Link: https://lkml.kernel.org/r/20240215063649.2164017-1-hch@lst.de
Link: https://lkml.kernel.org/r/20240215063649.2164017-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page-writeback.c~writeback-dont-call-mapping_set_error-on-aop_writepage_activate
+++ a/mm/page-writeback.c
@@ -2535,7 +2535,9 @@ static int writepage_cb(struct folio *fo
 {
 	struct address_space *mapping = data;
 	int ret = mapping->a_ops->writepage(&folio->page, wbc);
-	mapping_set_error(mapping, ret);
+
+	if (ret < 0)
+		mapping_set_error(mapping, ret);
 	return ret;
 }
 
_

Patches currently in -mm which might be from hch@lst.de are


