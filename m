From: akpm@linux-foundation.org
Subject: - readahead-partial-sendfile-fix.patch removed from -mm tree
Date: Tue, 08 May 2007 01:16:05 -0700
Message-ID: <200705080816.l488G5EL019086@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934652AbXEHIRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:17:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@gmail.com, wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: partial sendfile fix
has been removed from the -mm tree.  Its filename was
     readahead-partial-sendfile-fix.patch

This patch was dropped because an updated version will be merged

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

 mm/readahead.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN mm/readahead.c~readahead-partial-sendfile-fix mm/readahead.c
--- a/mm/readahead.c~readahead-partial-sendfile-fix
+++ a/mm/readahead.c
@@ -579,6 +579,15 @@ page_cache_readahead(struct address_spac
 	int sequential;
 
 	/*
+	 * A previous read request is partially completed,
+	 * causing the retried/continued read calls into us prematurely.
+	 */
+	if (ra->start < offset &&
+			offset < ra->prev_index &&
+				 ra->prev_index < ra->ahead_start + ra->ahead_size)
+		goto out;
+
+	/*
 	 * We avoid doing extra work and bogusly perturbing the readahead
 	 * window expansion logic.
 	 */
_

Patches currently in -mm which might be from fengguang.wu@gmail.com are

splice-and-readahead-interaction.patch
readahead-partial-sendfile-fix.patch
