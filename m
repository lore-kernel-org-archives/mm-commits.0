From: akpm@linux-foundation.org
Subject: + readahead-partial-sendfile-fix.patch added to -mm tree
Date: Fri, 09 Feb 2007 20:18:28 -0800
Message-ID: <200702100418.l1A4ISIB003353@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35456 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbXBJESm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 23:18:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@gmail.com, wfg@mail.ustc.edu.cn


The patch titled
     readahead: partial sendfile fix
has been added to the -mm tree.  Its filename is
     readahead-partial-sendfile-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: partial sendfile fix
From: Fengguang Wu <fengguang.wu@gmail.com>

Enable readahead to handle partially done read requests, e.g.

        sendfile(188, 1921, [1478592], 19553028) = 37440
        sendfile(188, 1921, [1516032], 19515588) = 28800
        sendfile(188, 1921, [1544832], 19486788) = 37440
        sendfile(188, 1921, [1582272], 19449348) = 14400
        sendfile(188, 1921, [1596672], 19434948) = 37440
        sendfile(188, 1921, [1634112], 19397508) = 37440

In the above strace log,
        - some lighttpd is doing _sequential_ reading
        - every sendfile() returns with only _partial_ work done

page_cache_readahead() expects that if it returns @next_index, it will be
called exactly at @next_index next time. That's not true here. So the pattern
will be falsely recognized as a random read trace.

Also documented in "Linux AIO Performance and Robustness for Enterprise
Workloads" section 3.5:

	  sendfile(fd, 0, 2GB, fd2) = 8192,
	    tells readahead about up to 128KB of the read
	  sendfile(fd, 8192, 2GB - 8192, fd2) = 8192,
	    tells readahead about 8KB - 132KB of the read
	  sendfile(fd, 16384, 2GB - 16384, fd2) = 8192,
	    tells readahead about 16KB-140KB of the read
	       ...
	This confuses the readahead logic about the I/O pattern which appears
	to be 0-128K, 8K-132K, 16K-140K instead of clear sequentiality from
	0-2GB that is really appropriate.

Retry based AIO shares the same read pattern and readahead problem.
In this case, simply disabling readahead on restarted aio is not a good option:
we still need to call into readahead in the rare case of (req_size > ra_max).

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c   |    3 ---
 mm/readahead.c |    9 +++++++++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -puN mm/filemap.c~readahead-partial-sendfile-fix mm/filemap.c
--- a/mm/filemap.c~readahead-partial-sendfile-fix
+++ a/mm/filemap.c
@@ -885,9 +885,6 @@ void do_generic_mapping_read(struct addr
 	if (!isize)
 		goto out;
 
-	if (unlikely(aio_restarted()))
-		next_index = last_index; /* Avoid repeat readahead */
-
 	end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
 	for (;;) {
 		struct page *page;
diff -puN mm/readahead.c~readahead-partial-sendfile-fix mm/readahead.c
--- a/mm/readahead.c~readahead-partial-sendfile-fix
+++ a/mm/readahead.c
@@ -581,6 +581,15 @@ page_cache_readahead(struct address_spac
 	int sequential;
 
 	/*
+	 * A previous read request is partially completed,
+	 * causing the retried/continued read calls into us prematurely.
+	 */
+	if (ra->start < offset &&
+			offset < ra->prev_page &&
+				 ra->prev_page < ra->ahead_start + ra->ahead_size)
+		goto out;
+
+	/*
 	 * We avoid doing extra work and bogusly perturbing the readahead
 	 * window expansion logic.
 	 */
_

Patches currently in -mm which might be from fengguang.wu@gmail.com are

readahead-partial-sendfile-fix.patch
