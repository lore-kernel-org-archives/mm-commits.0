Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9697C757F8
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423507; cv=none; b=dqWtF/ijwS5TLX3dO3LYp+OnXXssX0UIxWjtHDb0nytT9xhkIhJ1P3Qb+8NFwNywtuJnkmPbLWkFfyb7vrVK8BRfUm3ZdzdLJimZNhjAQuE/85wXksFo+VcBS6uGNB1qt+Q7aYm6dtfsPR3ww3EMnhz4q93eqaF2PpP57ZIZuJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423507; c=relaxed/simple;
	bh=9rKYW+46WkCXARHnbpwAMEbBPTstg79u2xmG+ktL1aw=;
	h=Date:To:From:Subject:Message-Id; b=eGjsCiFxS4DXqmFPbIK9XEI8tpScw1UbLScrnbCs659SfxRmsNBThk3bK59tUpHTmHF6EpQJGl/IJYEZN6LNvbkWgOh8KjBW6gS93SM+/j62P+xQcz/ewheS8gd16WFnvpcc7rCV0UrzMIluhLhU7NZNxng9kwpfqJakhiHykP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zf5jNRsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zf5jNRsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5F2C4CEC2;
	Wed,  4 Sep 2024 04:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423507;
	bh=9rKYW+46WkCXARHnbpwAMEbBPTstg79u2xmG+ktL1aw=;
	h=Date:To:From:Subject:From;
	b=Zf5jNRsb1UjB8HMt1l8aW4TJvDolwuhb/MU4uwmCnpBN1kQgTpcFhcOfp5GTiFAtJ
	 k2ljvXeitnOfr1MrcIhLVKnjhaoNhWop4cc+YHJVxJsz/8ua2uJ7amugVV7gmYp9DG
	 8REOTu9ru6EF6bcFRT/Qxde72Khebd37/l4JYygY=
Date: Tue, 03 Sep 2024 21:18:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,david@fromorbit.com,brauner@kernel.org,axboe@kernel.dk,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-allow-read-ahead-with-iocb_nowait-set.patch removed from -mm tree
Message-Id: <20240904041827.6C5F2C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: allow read-ahead with IOCB_NOWAIT set
has been removed from the -mm tree.  Its filename was
     mm-allow-read-ahead-with-iocb_nowait-set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm: allow read-ahead with IOCB_NOWAIT set
Date: Tue, 20 Aug 2024 10:26:39 +0800

Readahead support for IOCB_NOWAIT was introduced in commit 2e85abf053b9
("mm: allow read-ahead with IOCB_NOWAIT set").  However, this
implementation broke the semantics of IOCB_NOWAIT by potentially causing
it to wait on I/O during memory reclamation.  This behavior was later
modified in commit efa8480a8316 ("fs: RWF_NOWAIT should imply IOCB_NOIO").

To resolve the blocking issue during memory reclamation, we can use
memalloc_noio_{save,restore} to ensure non-blocking behavior.  This change
restores the original functionality, allowing preadv2(IOCB_NOWAIT) to
trigger readahead if the file content is not present in the page cache.

While this process may trigger direct memory reclamation, the
__GFP_NORETRY flag is set in the readahead GFP flags, ensuring it won't
block.

A use case for this change is when we want to trigger readahead in the
preadv2(2) syscall if the file cache is absent, but without waiting for
certain filesystem locks, like xfs_ilock.  A simple example is as follows:

retry:
    if (preadv2(fd, iovec, cnt, offset, RWF_NOWAIT) < 0) {
        do_other_work();
        goto retry;
    }

Link: https://lore.gnuweeb.org/io-uring/20200624164127.GP21350@casper.infradead.org/
Link: https://lkml.kernel.org/r/20240820022639.89562-1-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    1 -
 mm/filemap.c       |    6 ++++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/fs.h~mm-allow-read-ahead-with-iocb_nowait-set
+++ a/include/linux/fs.h
@@ -3461,7 +3461,6 @@ static inline int kiocb_set_rw_flags(str
 	if (flags & RWF_NOWAIT) {
 		if (!(ki->ki_filp->f_mode & FMODE_NOWAIT))
 			return -EOPNOTSUPP;
-		kiocb_flags |= IOCB_NOIO;
 	}
 	if (flags & RWF_ATOMIC) {
 		if (rw_type != WRITE)
--- a/mm/filemap.c~mm-allow-read-ahead-with-iocb_nowait-set
+++ a/mm/filemap.c
@@ -46,6 +46,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/splice.h>
 #include <linux/rcupdate_wait.h>
+#include <linux/sched/mm.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include "internal.h"
@@ -2519,6 +2520,7 @@ static int filemap_get_pages(struct kioc
 	pgoff_t index = iocb->ki_pos >> PAGE_SHIFT;
 	pgoff_t last_index;
 	struct folio *folio;
+	unsigned int flags;
 	int err = 0;
 
 	/* "last_index" is the index of the page beyond the end of the read */
@@ -2531,8 +2533,12 @@ retry:
 	if (!folio_batch_count(fbatch)) {
 		if (iocb->ki_flags & IOCB_NOIO)
 			return -EAGAIN;
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			flags = memalloc_noio_save();
 		page_cache_sync_readahead(mapping, ra, filp, index,
 				last_index - index);
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			memalloc_noio_restore(flags);
 		filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
 	}
 	if (!folio_batch_count(fbatch)) {
_

Patches currently in -mm which might be from laoar.shao@gmail.com are


