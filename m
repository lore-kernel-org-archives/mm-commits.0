Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794626178;
	b=K0gxTUjKXMSNiOQw4N3ZfPkPE6yLQqEGUrfDsDDGvmjZ1EaLFqygPSww+MqS5xCKUVMe
	 cQ0HHEkU5+G0ITBu6A58MFFDQDybkaGce0WC2OOeC+2YUzmP9vQyWXU0mS3yWi6ATOOmf
	 kcUVKeXlTF+MHYRFwwhBOmxZbbqd0E6dxFUrEG0cfBhNLnDbK8AQtFp203B92rAgbaxXs
	 Py1zxBte7psqyrhQ4iPATyxB0x4chS5wrsw97l/3uZEXZAyeg0TOnnP9ZPvLK2VEWa2bg
	 T4L4HgWjmWrYxbLMRhUFUGr8VjjB/HzOvGRvkaJQf6lMNebtzKvtDAfkEJsmughnrRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794626178;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=zoNHeT1XJtmR3/ddpeTwS615sy6YTRsR7eenA2Oqxbs=;
	b=oAXp3sq8pDSgTC1knMOCyvLi0KE3sUdl37bjoWK9WkR7jCi7uJmGSdUArDJcPAmA4ngt
	 kzKF1d25vCcxhFaMhTxqfrFRMfwSzlcoVLfLaNWcctEO4jR68tzHcX5YG+D3zX74QdloP
	 wm8L7VBbHFC4zW58VJPTihcupIJDq7PkyrTSk5aKaxugX3zMeOwZjV1i+IWR8yqGEhry9
	 ommATcwWT4AmccpRH3SNTGtH/kF+fg7p8MaGaxGwRtRz1SER+pJZtlHGtdbU3sFpU96XX
	 yKtnaxbXoSHyi0YiFmEaj/n7V3mxEEyfohD3kX76ekPtB/g0yayevptVbyfBGfaU+Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dLJ4+ksO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC36606A8A4
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 03:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dLJ4+ksO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EBC1F000C5;
	Sat, 14 Nov 2026 03:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794626177;
	bh=zoNHeT1XJtmR3/ddpeTwS615sy6YTRsR7eenA2Oqxbs=;
	h=Date:To:From:Subject;
	b=dLJ4+ksOFotqv1EXCgd7lPEdkjagUecH67HIDmNd8y/sGjVm5iQhw8gwMzGiXlqG7
	 KjD1mWGV1QjIki2BEZL+JNqe6Upppgz5s+qNCZbByD2Rygfxgy250uFxTgUiuVZGMi
	 A2e62XJiXJ12VbGEcT5nmMAU3y2RWxODWPfqzCN8=
Date: Fri, 13 Nov 2026 19:16:17 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,p.raghav@samsung.com,
	jack@suse.cz,gopalmalaviya53@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-dont-skip-the-fallback-after-aligning-index-down.patch added to mm-new branch
Message-Id: <20261114031617.B1EBC1F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/readahead: don't skip the fallback after aligning index down
has been added to the -mm mm-new branch.  Its filename is
     mm-readahead-dont-skip-the-fallback-after-aligning-index-down.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-dont-skip-the-fallback-after-aligning-index-down.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Gopal Malaviya <gopalmalaviya53@gmail.com>
Subject: mm/readahead: don't skip the fallback after aligning index down
Date: Fri, 13 Nov 2026 07:27:11 +0000

page_cache_ra_order() rounds the start of the readahead window down to the
minimum folio size of the mapping, so on a file system with blocks larger
than the page size, index can end up below start.  If adding the first
folio then fails, for example with -EEXIST because that folio is already
cached, the loop stops with index still below start, and the check before
the fallback

	if (ra->size > index - start)

wraps around, so do_page_cache_ra() is not called and nothing of the
window is read.

For example, with read_ahead_kb 128 and 16 KiB blocks, the mmap
read-around window for a fault on page 1042 starts at page 1026, index
becomes 1024, and if pages 1024-1027 are cached, pages 1028-1057 are not
read ahead.

Compare with the end of the window instead.  Where index is not below
start, this is the same check and the same number of pages as before.

Tested in a KVM guest (x86_64, 2 vCPUs, 3 GiB) on mm-hotfixes-unstable,
with XFS with 16 KiB blocks and with ext4 on virtio-blk, read_ahead_kb
128.  A test caches page 1026 of a file with pread() on a
POSIX_FADV_RANDOM descriptor, then faults page 1042 through a mapping, and
counts the cached pages of the window [1026, 1058) with mincore():

                                       before   after
  XFS, 16 KiB blocks                      6       32
  XFS, 16 KiB blocks, nothing cached     32       32
  ext4                                   32       32

Tracing shows the fallback now running after the -EEXIST, as
page_cache_ra_unbounded with index=1024 and nr_to_read=34.

Touching 1% of the pages of a cold 20 GiB file on XFS with 16 KiB blocks,
at random, at a stride of 2053 pages, or as random runs of 2 or 4 adjacent
pages, reads the same amount before and after, within 5% over two runs
each, at read_ahead_kb 128 and 8192.

The problem was pointed out by the Sashiko AI review of an unrelated patch
[1].  An AI assistant (Claude) helped with the analysis and the test, and
drafted this changelog.  I reviewed, implemented, built and tested the
change.

Link: https://lore.kernel.org/20261113072711.235264-1-gopalmalaviya53@gmail.com
Link: https://sashiko.dev/#/bug/linux-da6e8836-f808-4b39-9f04-de52995a0162 [1]
Fixes: d5ea5e5e50df ("readahead: properly shorten readahead when falling back to do_page_cache_ra()")
Signed-off-by: Gopal Malaviya <gopalmalaviya53@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>

 mm/readahead.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/readahead.c~mm-readahead-dont-skip-the-fallback-after-aligning-index-down
+++ a/mm/readahead.c
@@ -552,10 +552,12 @@ void page_cache_ra_order(struct readahea
 fallback:
 	/*
 	 * ->readahead() may have updated readahead window size so we have to
-	 * check there's still something to read.
+	 * check there's still something to read. Compare with the end of the
+	 * window, as index may have been rounded down below start to the
+	 * minimum folio size.
 	 */
-	if (ra->size > index - start)
-		do_page_cache_ra(ractl, ra->size - (index - start),
+	if (index < start + ra->size)
+		do_page_cache_ra(ractl, start + ra->size - index,
 				 ra->async_size);
 }
 
_

Patches currently in -mm which might be from gopalmalaviya53@gmail.com are

mm-readahead-dont-skip-the-fallback-after-aligning-index-down.patch

