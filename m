From: akpm@linux-foundation.org
Subject: [merged]
 mm-do-not-discard-partial-pages-with-posix_fadv_dontneed.patch removed from -mm tree
Date: Fri, 10 Jun 2016 12:12:22 -0700
Message-ID: <575b1116.ftC78X/1LwSuLdYq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbcFJTMX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jun 2016 15:12:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: green@linuxhacker.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/fadvise.c: do not discard partial pages with POSIX_FADV_DONTNEED
has been removed from the -mm tree.  Its filename was
     mm-do-not-discard-partial-pages-with-posix_fadv_dontneed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Drokin <green@linuxhacker.ru>
Subject: mm/fadvise.c: do not discard partial pages with POSIX_FADV_DONTNEED

I noticed that the logic in the fadvise64_64 syscall is incorrect for
partial pages.  While first page of the region is correctly skipped if it
is partial, the last page of the region is mistakenly discarded.  This
leads to problems for applications that read data in non-page-aligned
chunks discarding already processed data between the reads.

A somewhat misguided application that does something like write(XX bytes
(non-page-alligned)); drop the data it just wrote; repeat gets a
significant penalty in performance as a result.

Link: http://lkml.kernel.org/r/1464917140-1506698-1-git-send-email-green@linuxhacker.ru
Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/fadvise.c~mm-do-not-discard-partial-pages-with-posix_fadv_dontneed mm/fadvise.c
--- a/mm/fadvise.c~mm-do-not-discard-partial-pages-with-posix_fadv_dontneed
+++ a/mm/fadvise.c
@@ -126,6 +126,17 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, l
 		 */
 		start_index = (offset+(PAGE_SIZE-1)) >> PAGE_SHIFT;
 		end_index = (endbyte >> PAGE_SHIFT);
+		if ((endbyte & ~PAGE_MASK) != ~PAGE_MASK) {
+			/* First page is tricky as 0 - 1 = -1, but pgoff_t
+			 * is unsigned, so the end_index >= start_index
+			 * check below would be true and we'll discard the whole
+			 * file cache which is not what was asked.
+			 */
+			if (end_index == 0)
+				break;
+
+			end_index--;
+		}
 
 		if (end_index >= start_index) {
 			unsigned long count = invalidate_mapping_pages(mapping,
_

Patches currently in -mm which might be from green@linuxhacker.ru are


