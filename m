From: akpm@linux-foundation.org
Subject: + kernel-kfifoc-add-handling-of-chained-scatterlists.patch added to -mm tree
Date: Wed, 11 Aug 2010 13:37:14 -0700
Message-ID: <201008112037.o7BKbEEq013281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757210Ab0HKUhp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Aug 2010 16:37:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net


The patch titled
     kernel/kfifo.c: add handling of chained scatterlists
has been added to the -mm tree.  Its filename is
     kernel-kfifoc-add-handling-of-chained-scatterlists.patch

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
Subject: kernel/kfifo.c: add handling of chained scatterlists
From: Stefani Seibold <stefani@seibold.net>

The current kfifo scatterlist implementation will not work with chained
scatterlists.  It assumes that struct scatterlist arrays are allocated
contiguously, which is not the case when chained scatterlists (struct
sg_table) are in use.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kfifo.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN kernel/kfifo.c~kernel-kfifoc-add-handling-of-chained-scatterlists kernel/kfifo.c
--- a/kernel/kfifo.c~kernel-kfifoc-add-handling-of-chained-scatterlists
+++ a/kernel/kfifo.c
@@ -10,7 +10,7 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
@@ -333,17 +333,16 @@ static int setup_sgl_buf(struct scatterl
 		buf += PAGE_SIZE;
 		npage = virt_to_page(buf);
 		if (page_to_phys(page) != page_to_phys(npage) - l) {
-			sgl->page_link = 0;
-			sg_set_page(sgl++, page, l - off, off);
-			if (++n == nents)
+			sg_set_page(sgl, page, l - off, off);
+			sgl = sg_next(sgl);
+			if (++n == nents || sgl == NULL)
 				return n;
 			page = npage;
 			len -= l - off;
 			l = off = 0;
 		}
 	}
-	sgl->page_link = 0;
-	sg_set_page(sgl++, page, len, off);
+	sg_set_page(sgl, page, len, off);
 	return n + 1;
 }
 
@@ -363,7 +362,7 @@ static unsigned int setup_sgl(struct __k
 	}
 	l = min(len, size - off);
 
-	n  = setup_sgl_buf(sgl, fifo->data + off, nents, l);
+	n = setup_sgl_buf(sgl, fifo->data + off, nents, l);
 	n += setup_sgl_buf(sgl + n, fifo->data, nents - n, len - l);
 
 	if (n)
_

Patches currently in -mm which might be from stefani@seibold.net are

origin.patch
kernel-kfifoc-add-handling-of-chained-scatterlists.patch

