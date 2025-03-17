Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A258254279;
	Mon, 17 Mar 2025 00:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742172077; cv=none; b=Ft3PSoKu78Bpv77g8NWaZ4gLc1Z0eewpmbztUakZUygMDhIbKbKwTKhODTB3U09+QV2uJJ6XVMC76Csb4IEwgDQ1bx20CUDt5s1s0RIF+gA5hEUQF1qSyK46aE4Ss8MW60xnfOtp3dkf0keK2IDA8HTHOKmdsXxRUQm6TkC6uBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742172077; c=relaxed/simple;
	bh=qtdQ8TG+11FeeYL/F3S0SzWuG+vC7Xmo2SLAICprxao=;
	h=Date:To:From:Subject:Message-Id; b=USjzyG4g3jRs26JqJuE4ea6Mu15w7hwfy7N8QPJ2m11GD/GztqFyFSPK0fyLgCTavAeps9+L15Up7+tppKHDGZ9mp7aOwDVzvxmZ5fAG1LiYzZcntCi+AhQqJz56b8Zkx2XDXRXjqdF7J1YLyVd5Y6nwXtsVngwDL2GBeebjocs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IxzuPUYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IxzuPUYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2211CC4CEDD;
	Mon, 17 Mar 2025 00:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742172077;
	bh=qtdQ8TG+11FeeYL/F3S0SzWuG+vC7Xmo2SLAICprxao=;
	h=Date:To:From:Subject:From;
	b=IxzuPUYUgwoNJK42sYjn/Ad/i8Rf1jWWO0TGWHLxj2ZrIiDd6Va96ubTZJXJY4gQn
	 kXi6tSOe2MwgB0e3jTIXSRS0g+6OGhf+ZMys6jS7CnMPh8Me3wbJq0S+aDOyKkFWXJ
	 1fedNawc70GtgRJsKL7LwliozK0EfCpYQL68nKZg=
Date: Sun, 16 Mar 2025 17:41:16 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,hch@lst.de,djwong@kernel.org,dchinner@redhat.com,raphaelsc@scylladb.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-error-handling-in-__filemap_get_folio-with-fgp_nowait.patch removed from -mm tree
Message-Id: <20250317004117.2211CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix error handling in __filemap_get_folio() with FGP_NOWAIT
has been removed from the -mm tree.  Its filename was
     mm-fix-error-handling-in-__filemap_get_folio-with-fgp_nowait.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Raphael S. Carvalho" <raphaelsc@scylladb.com>
Subject: mm: fix error handling in __filemap_get_folio() with FGP_NOWAIT
Date: Mon, 24 Feb 2025 11:37:00 -0300

original report:
https://lore.kernel.org/all/CAKhLTr1UL3ePTpYjXOx2AJfNk8Ku2EdcEfu+CH1sf3Asr=B-Dw@mail.gmail.com/T/

When doing buffered writes with FGP_NOWAIT, under memory pressure, the
system returned ENOMEM despite there being plenty of available memory, to
be reclaimed from page cache.  The user space used io_uring interface,
which in turn submits I/O with FGP_NOWAIT (the fast path).

retsnoop pointed to iomap_get_folio:

00:34:16.180612 -> 00:34:16.180651 TID/PID 253786/253721
(reactor-1/combined_tests):

                    entry_SYSCALL_64_after_hwframe+0x76
                    do_syscall_64+0x82
                    __do_sys_io_uring_enter+0x265
                    io_submit_sqes+0x209
                    io_issue_sqe+0x5b
                    io_write+0xdd
                    xfs_file_buffered_write+0x84
                    iomap_file_buffered_write+0x1a6
    32us [-ENOMEM]  iomap_write_begin+0x408
iter=&{.inode=0xffff8c67aa031138,.len=4096,.flags=33,.iomap={.addr=0xffffffffffffffff,.length=4096,.type=1,.flags=3,.bdev=0x…
pos=0 len=4096 foliop=0xffffb32c296b7b80
!    4us [-ENOMEM]  iomap_get_folio
iter=&{.inode=0xffff8c67aa031138,.len=4096,.flags=33,.iomap={.addr=0xffffffffffffffff,.length=4096,.type=1,.flags=3,.bdev=0x…
pos=0 len=4096

This is likely a regression caused by 66dabbb65d67 ("mm: return an ERR_PTR
from __filemap_get_folio"), which moved error handling from
io_map_get_folio() to __filemap_get_folio(), but broke FGP_NOWAIT
handling, so ENOMEM is being escaped to user space.  Had it correctly
returned -EAGAIN with NOWAIT, either io_uring or user space itself would
be able to retry the request.

It's not enough to patch io_uring since the iomap interface is the one
responsible for it, and pwritev2(RWF_NOWAIT) and AIO interfaces must
return the proper error too.

The patch was tested with scylladb test suite (its original reproducer),
and the tests all pass now when memory is pressured.

Link: https://lkml.kernel.org/r/20250224143700.23035-1-raphaelsc@scylladb.com
Fixes: 66dabbb65d67 ("mm: return an ERR_PTR from __filemap_get_folio")
Signed-off-by: Raphael S. Carvalho <raphaelsc@scylladb.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/mm/filemap.c~mm-fix-error-handling-in-__filemap_get_folio-with-fgp_nowait
+++ a/mm/filemap.c
@@ -1986,8 +1986,19 @@ no_page:
 
 		if (err == -EEXIST)
 			goto repeat;
-		if (err)
+		if (err) {
+			/*
+			 * When NOWAIT I/O fails to allocate folios this could
+			 * be due to a nonblocking memory allocation and not
+			 * because the system actually is out of memory.
+			 * Return -EAGAIN so that there caller retries in a
+			 * blocking fashion instead of propagating -ENOMEM
+			 * to the application.
+			 */
+			if ((fgp_flags & FGP_NOWAIT) && err == -ENOMEM)
+				err = -EAGAIN;
 			return ERR_PTR(err);
+		}
 		/*
 		 * filemap_add_folio locks the page, and for mmap
 		 * we expect an unlocked page.
_

Patches currently in -mm which might be from raphaelsc@scylladb.com are


