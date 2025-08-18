Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8885F4F1
	for <mm-commits@vger.kernel.org>; Mon, 18 Aug 2025 02:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755484137; cv=none; b=GHnoE4w2OSWMTOIKK6QMAwpwquS9Kniqkf+wJeapQsmhKcfUC5gS7wXy3Z3SZ88HKcfPROFPx9+VJRkJ8Hu3478iZcCFFif7VqYzuFagdy5iAxBjSKDhmVm+/IYEAiBlbeJ+iiLxcFBSqRxKlYVBbDHnPYdTbYAWV2xJ6C2RJOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755484137; c=relaxed/simple;
	bh=IlsXOP2QamDlkNXdWHwZckIW39f6uNyD0AI3PYB+H1Q=;
	h=Date:To:From:Subject:Message-Id; b=MmlMe68L6qtiu0OnRHkDh6ViIG15bf+kdcCp9rsR7Lk3b3W/irmV6fJ618mNumS+annMZCPF5DNEinVMQ19epUv5H29dQ863YxE6iPAm42kbd84xjFIWDX0wreiEoMNgwJ7I0F+aN77ce9bZej/GoabWFoQdx86IDY7HWIKeiXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TPe13gFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TPe13gFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3870EC4CEEB;
	Mon, 18 Aug 2025 02:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755484137;
	bh=IlsXOP2QamDlkNXdWHwZckIW39f6uNyD0AI3PYB+H1Q=;
	h=Date:To:From:Subject:From;
	b=TPe13gFLZynib+iiGifm12EKPh5OsoPmHDSCcPox7CORglkndSn6YPwBwvLWh1tRG
	 Lpe3gqsWIerGjuz+BIBDZOW3qyjDzpyINqz6PWvWWJdJHSDWyEdDu30IPWV0LTEBkC
	 y4itVg0fghUA5pckDa0txYdjKAYi2Cd2rIgE99N8=
Date: Sun, 17 Aug 2025 19:28:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,hch@infradead.org,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-skip-non-uptodate-folio-if-there-are-available-folios.patch added to mm-new branch
Message-Id: <20250818022857.3870EC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: Skip non-uptodate folio if there are available folios
has been added to the -mm mm-new branch.  Its filename is
     mm-filemap-skip-non-uptodate-folio-if-there-are-available-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-skip-non-uptodate-folio-if-there-are-available-folios.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Chi Zhiling <chizhiling@kylinos.cn>
Subject: mm/filemap: Skip non-uptodate folio if there are available folios
Date: Mon, 28 Jul 2025 16:39:52 +0800

When reading data exceeding the maximum IO size, the operation is split
into multiple IO requests, but the data isn't immediately copied to
userspace after each IO completion.

For example, when reading 2560k data from a device with 1280k maximum IO
size, the following sequence occurs:

1. read 1280k
2. copy 41 pages and issue read ahead for next 1280k
3. copy 31 pages to user buffer
4. wait the next 1280k
5. copy 8 pages to user buffer
6. copy 20 folios(64k) to user buffer

The 8 pages in step 5 are copied after the second 1280k completes(step 4)
due to waiting for a non-uptodate folio in filemap_update_page.  We can
copy the 8 pages before the second 1280k completes(step 4) to reduce the
latency of this read operation.

After applying the patch, these 8 pages will be copied before the next IO
completes:

1. read 1280k
2. copy 41 pages and issue read ahead for next 1280k
3. copy 31 pages to user buffer
4. copy 8 pages to user buffer
5. wait the next 1280k
6. copy 20 folios(64k) to user buffer

This patch drops a setting of IOCB_NOWAIT for AIO, which is fine because
filemap_read will set it again for AIO.

The final solution provided by Matthew Wilcox:
Link: https://lore.kernel.org/linux-fsdevel/aIDy076Sxt544qja@casper.infradead.org/

Link: https://lkml.kernel.org/r/20250728083952.75518-3-chizhiling@163.com
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/filemap.c~mm-filemap-skip-non-uptodate-folio-if-there-are-available-folios
+++ a/mm/filemap.c
@@ -2623,9 +2623,10 @@ retry:
 			goto err;
 	}
 	if (!folio_test_uptodate(folio)) {
-		if ((iocb->ki_flags & IOCB_WAITQ) &&
-		    folio_batch_count(fbatch) > 1)
-			iocb->ki_flags |= IOCB_NOWAIT;
+		if (folio_batch_count(fbatch) > 1) {
+			err = -EAGAIN;
+			goto err;
+		}
 		err = filemap_update_page(iocb, mapping, count, folio,
 					  need_uptodate);
 		if (err)
_

Patches currently in -mm which might be from chizhiling@kylinos.cn are

mm-filemap-do-not-use-is_partially_uptodate-for-entire-folio.patch
mm-filemap-skip-non-uptodate-folio-if-there-are-available-folios.patch

