From: akpm@linux-foundation.org
Subject: - lib-sortc-optimization.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:55:59 -0700
Message-ID: <200710180655.l9I6tx5F030660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44014 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761041AbXJRHQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kvsnaidu@sapnaidu.net, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     lib/sort.c optimization
has been removed from the -mm tree.  Its filename was
     lib-sortc-optimization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lib/sort.c optimization
From: "Subbaiah Venkata" <kvsnaidu@sapnaidu.net>

Hello, I fixed and tested a small bug in lib/sort.c file, heap sort
function.

The fix avoids unnecessary swap of contents when i is 0 (saves few loads
and stores), which happens every time sort function is called.  I felt the
fix is worth bringing it to your attention given the importance and
frequent use of the sort function.

Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

origin.patch
