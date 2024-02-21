Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285393C488
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708548685; cv=none; b=R2Nl46LKvJ/52fWrkOg4eP17qksvM+CjEkTqMS6sZK7+v2YtraXU8Qp8MOdYLkxftfhVpZbUua5Uhntrrr3HAKT7MJGTdHIY/m0TWpfe70hpFo1lUx+kXJHuTr7HL2HlwWk/ONfy5gtIZFfKLgZ0MlJy1wkueyF8YXb/hlGu9Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708548685; c=relaxed/simple;
	bh=+R4haXcv6gAzltD+U3JJOFo0jRLLQ9TQq/w1cEjF16g=;
	h=Date:To:From:Subject:Message-Id; b=qWasHk2qKJUhosvrzqkTFLjDxNHKHTIBFVM8MVWrm7OD18/6EMI8DVSJtcGdaA6qsMLZZ0sf52n6V99IoQfTiFoO9lcMwrMDebkAX+KCkM82bk+OJsfzyLFBvazC8AgSTeZaed+6no0YJo7Yt4Q99hfhVdVLUkQ8XEZ2t+jwAmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bMYpX1wd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bMYpX1wd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822D0C433C7;
	Wed, 21 Feb 2024 20:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708548684;
	bh=+R4haXcv6gAzltD+U3JJOFo0jRLLQ9TQq/w1cEjF16g=;
	h=Date:To:From:Subject:From;
	b=bMYpX1wdyDPdhvmEnTkKeZntU7RTvDNPwGkEEX2IdVgeLvzM+7V5dDykVA/Y6T04l
	 E9bEcCxrqdPZi2dfw3GfNzwjlmMLRcPenR3S4QqHEH2wHsvawdtlIMfUlAgCBwn+Yf
	 7x4eL443RA0FI//NccJsAezstSBnECMCV56bfw8k=
Date: Wed, 21 Feb 2024 12:51:23 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-also-update-wbc-nr_to_write-on-writeback-failure.patch added to mm-unstable branch
Message-Id: <20240221205124.822D0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: also update wbc->nr_to_write on writeback failure
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-also-update-wbc-nr_to_write-on-writeback-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-also-update-wbc-nr_to_write-on-writeback-failure.patch

This patch will later appear in the mm-unstable branch at
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

writeback-dont-call-mapping_set_error-on-aop_writepage_activate.patch
writeback-fix-done_index-when-hitting-the-wbc-nr_to_write.patch
writeback-also-update-wbc-nr_to_write-on-writeback-failure.patch
writeback-only-update-writeback_index-for-range_cyclic-writeback.patch
writeback-rework-the-loop-termination-condition-in-write_cache_pages.patch
writeback-add-a-writeback-iterator.patch

