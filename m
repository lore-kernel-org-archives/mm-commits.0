From: akpm@linux-foundation.org
Subject: [merged] drivers-video-add-kmalloc-null-tests.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:02:46 -0700
Message-ID: <200909232002.n8NK2kVe017877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999AbZIWUDQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:03:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, tom.leiming@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/video: add kmalloc NULL tests
has been removed from the -mm tree.  Its filename was
     drivers-video-add-kmalloc-null-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video: add kmalloc NULL tests
From: Julia Lawall <julia@diku.dk>

Check that the result of kmalloc is not NULL before passing it to other
functions.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression *x;
identifier f;
constant char *C;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
... when != x == NULL
    when != x != NULL
    when != (x || ...)
(
kfree(x)
|
f(...,C,...,x,...)
|
*f(...,x,...)
|
*x->f
)
// </smpl>

[akpm@linux-foundation.org: convert to kstrdup() as well]
Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/au1100fb.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/video/au1100fb.c~drivers-video-add-kmalloc-null-tests drivers/video/au1100fb.c
--- a/drivers/video/au1100fb.c~drivers-video-add-kmalloc-null-tests
+++ a/drivers/video/au1100fb.c
@@ -715,8 +715,11 @@ int au1100fb_setup(char *options)
 			}
 			/* Mode option (only option that start with digit) */
 			else if (isdigit(this_opt[0])) {
-				mode = kmalloc(strlen(this_opt) + 1, GFP_KERNEL);
-				strncpy(mode, this_opt, strlen(this_opt) + 1);
+				mode = kstrdup(this_opt, GFP_KERNEL);
+				if (!mode) {
+					print_err("memory allocation failed");
+					return -ENOMEM;
+				}
 			}
 			/* Unsupported option */
 			else {
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-md-introduce-missing-kfree.patch
edac-fix-resource-size-calculation.patch
fs-romfs-correct-error-handling-code.patch
drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error.patch

