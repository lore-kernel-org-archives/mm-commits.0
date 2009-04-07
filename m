From: akpm@linux-foundation.org
Subject: + befs-fix-build-on-parisc.patch added to -mm tree
Date: Tue, 07 Apr 2009 00:08:02 -0700
Message-ID: <200904070708.n37782Ss004105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919AbZDGHJr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 03:09:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com


The patch titled
     befs: fix build on parisc
has been added to the -mm tree.  Its filename is
     befs-fix-build-on-parisc.patch

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
Subject: befs: fix build on parisc
From: Alexander Beregalov <a.beregalov@gmail.com>

fs/befs/super.c:85: error: 'PAGE_SIZE' undeclared

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/super.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/befs/super.c~befs-fix-build-on-parisc fs/befs/super.c
--- a/fs/befs/super.c~befs-fix-build-on-parisc
+++ a/fs/befs/super.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/fs.h>
+#include <asm/page.h> /* for PAGE_SIZE */
 
 #include "befs.h"
 #include "super.h"
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

origin.patch
befs-fix-build-on-parisc.patch
linux-next.patch

