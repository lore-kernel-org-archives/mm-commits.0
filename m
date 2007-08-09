From: akpm@linux-foundation.org
Subject: + lib-sortc-optimization.patch added to -mm tree
Date: Thu, 09 Aug 2007 13:33:37 -0700
Message-ID: <200708092033.l79KXbGD018149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52452 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765449AbXHIUe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:34:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kvsnaidu@sapnaidu.net, mpm@selenic.com


The patch titled
     lib/sort.c optimization
has been added to the -mm tree.  Its filename is
     lib-sortc-optimization.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lib/sort.c optimization
From: "Subbaiah Venkata" <kvsnaidu@sapnaidu.net>

Hello, I fixed and tested a small bug in lib/sort.c file, heap sort
function.

The fix avoids unnecessary swap of contents when i is 0 (saves few loads
and stores), which happens every time sort function is called.  I felt the
fix is worth bringing it to your attention given the importance and
frequent use of the sort function.

Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/sort.c~lib-sortc-optimization lib/sort.c
--- a/lib/sort.c~lib-sortc-optimization
+++ a/lib/sort.c
@@ -67,7 +67,7 @@ void sort(void *base, size_t num, size_t
 	}
 
 	/* sort */
-	for (i = n - size; i >= 0; i -= size) {
+	for (i = n - size; i > 0; i -= size) {
 		swap(base, base + i, size);
 		for (r = 0; r * 2 + size < i; r = c) {
 			c = r * 2 + size;
_

Patches currently in -mm which might be from kvsnaidu@sapnaidu.net are

lib-sortc-optimization.patch
