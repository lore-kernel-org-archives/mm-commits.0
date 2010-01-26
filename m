From: akpm@linux-foundation.org
Subject: + mm-flush-dcache-before-writing-into-page-to-avoid-alias.patch added to -mm tree
Date: Tue, 26 Jan 2010 14:42:30 -0800
Message-ID: <201001262242.o0QMgUwJ026093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932142Ab0AZWnl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 17:43:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anfei.zhou@gmail.com, linux-arch@vger.kernel.org, miklos@szeredi.hu, nickpiggin@yahoo.com.au, rmk@arm.linux.org.uk, stable@kernel.org, torvalds@linux-foundation.org


The patch titled
     mm: flush dcache before writing into page to avoid alias
has been added to the -mm tree.  Its filename is
     mm-flush-dcache-before-writing-into-page-to-avoid-alias.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: flush dcache before writing into page to avoid alias
From: anfei zhou <anfei.zhou@gmail.com>

The cache alias problem will happen if the changes of user shared mapping
is not flushed before copying, then user and kernel mapping may be mapped
into two different cache line, it is impossible to guarantee the coherence
after iov_iter_copy_from_user_atomic.  So the right steps should be:

	flush_dcache_page(page);
	kmap_atomic(page);
	write to page;
	kunmap_atomic(page);
	flush_dcache_page(page);

More precisely, we might create two new APIs flush_dcache_user_page and
flush_dcache_kern_page to replace the two flush_dcache_page accordingly.

Here is a snippet tested on omap2430 with VIPT cache, and I think it is
not ARM-specific:

	int val = 0x11111111;
	fd = open("abc", O_RDWR);
	addr = mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	*(addr+0) = 0x44444444;
	tmp = *(addr+0);
	*(addr+1) = 0x77777777;
	write(fd, &val, sizeof(int));
	close(fd);

The results are not always 0x11111111 0x77777777 at the beginning as expected.  Sometimes we see 0x44444444 0x77777777.

Signed-off-by: Anfei <anfei.zhou@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-arch@vger.kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |    3 +++
 mm/filemap.c   |    3 +++
 2 files changed, 6 insertions(+)

diff -puN fs/fuse/file.c~mm-flush-dcache-before-writing-into-page-to-avoid-alias fs/fuse/file.c
--- a/fs/fuse/file.c~mm-flush-dcache-before-writing-into-page-to-avoid-alias
+++ a/fs/fuse/file.c
@@ -828,6 +828,9 @@ static ssize_t fuse_fill_write_pages(str
 		if (!page)
 			break;
 
+		if (mapping_writably_mapped(mapping))
+			flush_dcache_page(page);
+
 		pagefault_disable();
 		tmp = iov_iter_copy_from_user_atomic(page, ii, offset, bytes);
 		pagefault_enable();
diff -puN mm/filemap.c~mm-flush-dcache-before-writing-into-page-to-avoid-alias mm/filemap.c
--- a/mm/filemap.c~mm-flush-dcache-before-writing-into-page-to-avoid-alias
+++ a/mm/filemap.c
@@ -2196,6 +2196,9 @@ again:
 		if (unlikely(status))
 			break;
 
+		if (mapping_writably_mapped(mapping))
+			flush_dcache_page(page);
+
 		pagefault_disable();
 		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
 		pagefault_enable();
_

Patches currently in -mm which might be from anfei.zhou@gmail.com are

mm-flush-dcache-before-writing-into-page-to-avoid-alias.patch

