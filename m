Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37E13C488
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708548683; cv=none; b=s8DuK1o6upXwm7B02kWqp4aabY906ieon6XS6HsmlqXFAEE4fXb2N9xt6J/NpRfQyqxWd4w2y15hC2Gqt4fsbhKJN9eqlCvKuHyU+mdYax4n/MTUOKNx7vG3jfx68/b8sEA9KAuYsp465+7sV57ZTS2newKwvh2G3CWbztfxrOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708548683; c=relaxed/simple;
	bh=3CtmQo5QVAeC3yx0uWMPaQmSmo8mR4AQ0X0JLBHeOKY=;
	h=Date:To:From:Subject:Message-Id; b=TFDYqrEFsaU9dOt2cMOTn9zz76w/TUXkWVsj97/QoWMvIN24lxG9Op8LFtStfpCql4bvQKuI3pinZqz+gJDBGzumUwJW3QU3d51XQHwEzSi35I2VRipMlB6aSH5y0nFxU0VygVJ9cp/N+PqLx9srlThK19eTJfT2hQcvLrvwTYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EJNuM5DB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EJNuM5DB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FD6C433C7;
	Wed, 21 Feb 2024 20:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708548683;
	bh=3CtmQo5QVAeC3yx0uWMPaQmSmo8mR4AQ0X0JLBHeOKY=;
	h=Date:To:From:Subject:From;
	b=EJNuM5DBmLdxYuPmycSz9g0btISXZl2diBKWfWndrO15yBK0ycWm/cBf3DKicBi16
	 XU7AMWjjTqCIqGqIz4RXvQqg/sx1BalVflQNkFGD9gOBh7byGoMf3kTMnpxAnYEwjP
	 XbKmXm9ntGcrM+OUvl1svje9EDJeb2AfnoZJY5E0=
Date: Wed, 21 Feb 2024 12:51:22 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-fix-done_index-when-hitting-the-wbc-nr_to_write.patch added to mm-unstable branch
Message-Id: <20240221205123.56FD6C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: fix done_index when hitting the wbc->nr_to_write
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-fix-done_index-when-hitting-the-wbc-nr_to_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-fix-done_index-when-hitting-the-wbc-nr_to_write.patch

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
Subject: writeback: fix done_index when hitting the wbc->nr_to_write
Date: Thu, 15 Feb 2024 07:36:38 +0100

When write_cache_pages finishes writing out a folio, it fails to update
done_index to account for the number of pages in the folio just written. 
That means when range_cyclic writeback is restarted, it will be restarted
at this folio instead of after it as it should.  Fix that by updating
done_index before breaking out of the loop.

Link: https://lkml.kernel.org/r/20240215063649.2164017-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page-writeback.c~writeback-fix-done_index-when-hitting-the-wbc-nr_to_write
+++ a/mm/page-writeback.c
@@ -2505,6 +2505,7 @@ continue_unlock:
 			 * keep going until we have written all the pages
 			 * we tagged for writeback prior to entering this loop.
 			 */
+			done_index = folio->index + nr;
 			wbc->nr_to_write -= nr;
 			if (wbc->nr_to_write <= 0 &&
 			    wbc->sync_mode == WB_SYNC_NONE) {
_

Patches currently in -mm which might be from hch@lst.de are

writeback-dont-call-mapping_set_error-on-aop_writepage_activate.patch
writeback-fix-done_index-when-hitting-the-wbc-nr_to_write.patch
writeback-also-update-wbc-nr_to_write-on-writeback-failure.patch
writeback-only-update-writeback_index-for-range_cyclic-writeback.patch
writeback-rework-the-loop-termination-condition-in-write_cache_pages.patch
writeback-add-a-writeback-iterator.patch

