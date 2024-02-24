Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0A210958
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739459; cv=none; b=QkXbLAHmRVvN1B23JoWZ5ae6dtANk90ZGch505CrWWc2rZNazKwSLpqRXca5WWElphK9eJH0lXcQDvyMeUEdxdjecKYo8tykUaJEsym7XgAP7vXUGmyIlWGaN7IC5eHntURB+5urGW/T/M62sMAH0o2RH8difmLYfh+6GrfWqf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739459; c=relaxed/simple;
	bh=ox00fLJL6YDbBK3iTSt9EYe6kEndyqR/zYOAeqCXwSk=;
	h=Date:To:From:Subject:Message-Id; b=X9Wwa6KoFwwDRXWrPNq4QWacbIKMt54nX7LQg2uo21v8f/rXQNbp51tZFXUQ1xNj88OtF7MtrgG+JDNZNgv/15Sh51X9hJ4YYo5VK5tGfKuicopVUXhztHathI66eHs6YnQVRGNJYAUXZZAlPtGWmycAFbPmcnm0yLWbPZ3ps74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1pVAAlzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1pVAAlzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91483C43390;
	Sat, 24 Feb 2024 01:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739459;
	bh=ox00fLJL6YDbBK3iTSt9EYe6kEndyqR/zYOAeqCXwSk=;
	h=Date:To:From:Subject:From;
	b=1pVAAlzvy4dSXhfNCLc1R/IbaRIVdXiFV5E06wyi5HXEFH9K1QNOCvXoAed9Ha7Ut
	 Mx4NDiIq2I2GZ2iS4q1b/3Veyq5965XordSDPc9VooUV/bs7HGDrmDd6Qk2xHKDwnN
	 v1aRs2RDwXb4Ie50obHCcrDwDbxt7t1VEHnGNATw=
Date: Fri, 23 Feb 2024 17:50:59 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-also-update-wbc-nr_to_write-on-writeback-failure.patch removed from -mm tree
Message-Id: <20240224015059.91483C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: also update wbc->nr_to_write on writeback failure
has been removed from the -mm tree.  Its filename was
     writeback-also-update-wbc-nr_to_write-on-writeback-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: writeback: also update wbc->nr_to_write on writeback failure
Date: Thu, 15 Feb 2024 07:36:39 +0100

When exiting write_cache_pages early due to a non-integrity write failure,
wbc->nr_to_write currently doesn't account for the folio we just failed to
write.  This doesn't matter because the callers always ingore the value on
a failure, but moving the update to common code will allow to simplify the
code, so do it.

Link: https://lkml.kernel.org/r/20240215063649.2164017-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~writeback-also-update-wbc-nr_to_write-on-writeback-failure
+++ a/mm/page-writeback.c
@@ -2473,6 +2473,7 @@ continue_unlock:
 			trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
 			error = writepage(folio, wbc, data);
 			nr = folio_nr_pages(folio);
+			wbc->nr_to_write -= nr;
 			if (unlikely(error)) {
 				/*
 				 * Handle errors according to the type of
@@ -2506,7 +2507,6 @@ continue_unlock:
 			 * we tagged for writeback prior to entering this loop.
 			 */
 			done_index = folio->index + nr;
-			wbc->nr_to_write -= nr;
 			if (wbc->nr_to_write <= 0 &&
 			    wbc->sync_mode == WB_SYNC_NONE) {
 				done = 1;
_

Patches currently in -mm which might be from hch@lst.de are


