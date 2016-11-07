From: akpm@linux-foundation.org
Subject: + mm-filemap-dont-allow-partially-uptodate-page-for-pipes.patch
 added to -mm tree
Date: Mon, 07 Nov 2016 11:16:49 -0800
Message-ID: <5820d321.yEgwI+VIRtHDjJRX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32892 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933244AbcKGTQ6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2016 14:16:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guaneryu@gmail.com, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: don't allow partially uptodate page for pipes
has been added to the -mm tree.  Its filename is
     mm-filemap-dont-allow-partially-uptodate-page-for-pipes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-dont-allow-partially-uptodate-page-for-pipes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-dont-allow-partially-uptodate-page-for-pipes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eryu Guan <guaneryu@gmail.com>
Subject: mm/filemap: don't allow partially uptodate page for pipes

Starting from 4.9-rc1 kernel, I started noticing some test failures of
sendfile(2) and splice(2) (sendfile0N and splice01 from LTP) when testing
on sub-page block size filesystems (tested both XFS and ext4), these
syscalls start to return EIO in the tests.  e.g.

sendfile02    1  TFAIL  :  sendfile02.c:133: sendfile(2) failed to return expected value, expected: 26, got: -1
sendfile02    2  TFAIL  :  sendfile02.c:133: sendfile(2) failed to return expected value, expected: 24, got: -1
sendfile02    3  TFAIL  :  sendfile02.c:133: sendfile(2) failed to return expected value, expected: 22, got: -1
sendfile02    4  TFAIL  :  sendfile02.c:133: sendfile(2) failed to return expected value, expected: 20, got: -1

This is because that in sub-page block size cases, we don't need the whole
page to be uptodate, only the part we care about is uptodate is OK (if fs
has ->is_partially_uptodate defined).  But page_cache_pipe_buf_confirm()
doesn't have the ability to check the partially-uptodate case, it needs
the whole page to be uptodate.  So it returns EIO in this case.

This is a regression introduced by commit 82c156f85384 ("switch
generic_file_splice_read() to use of ->read_iter()").  Prior to the
change, generic_file_splice_read() doesn't allow partially-uptodate page
either, so it worked fine.

Fix it by skipping the partially-uptodate check if we're working on a pipe
in do_generic_file_read(), so we read the whole page from disk as long as
the page is not uptodate.

I think the other way to fix it is to add the ability to check & allow
partially-uptodate page to page_cache_pipe_buf_confirm(), but that is much
harder to do and seems gain little.

Link: http://lkml.kernel.org/r/1477986187-12717-1-git-send-email-guaneryu@gmail.com
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/filemap.c~mm-filemap-dont-allow-partially-uptodate-page-for-pipes mm/filemap.c
--- a/mm/filemap.c~mm-filemap-dont-allow-partially-uptodate-page-for-pipes
+++ a/mm/filemap.c
@@ -1732,6 +1732,9 @@ find_page:
 			if (inode->i_blkbits == PAGE_SHIFT ||
 					!mapping->a_ops->is_partially_uptodate)
 				goto page_not_up_to_date;
+			/* pipes can't handle partially uptodate pages */
+			if (unlikely(iter->type & ITER_PIPE))
+				goto page_not_up_to_date;
 			if (!trylock_page(page))
 				goto page_not_up_to_date;
 			/* Did it get truncated before we got the lock? */
_

Patches currently in -mm which might be from guaneryu@gmail.com are

mm-filemap-dont-allow-partially-uptodate-page-for-pipes.patch

