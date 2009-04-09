From: akpm@linux-foundation.org
Subject: + include-linux-fiemaph-include-typesh-now-that-its-exported.patch added to -mm tree
Date: Thu, 09 Apr 2009 14:17:30 -0700
Message-ID: <200904092117.n39LHUiS030744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755171AbZDIVUE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 17:20:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, sam@ravnborg.org


The patch titled
     include/linux/fiemap.h: include types.h now that it's exported
has been added to the -mm tree.  Its filename is
     include-linux-fiemaph-include-typesh-now-that-its-exported.patch

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
Subject: include/linux/fiemap.h: include types.h now that it's exported
From: Eric Sandeen <sandeen@redhat.com>

Include <linux/types.h> in fiemap.h.  Sam Ravnborg pointed out that this
was missing in this newly-exported header which uses the __u32 and __u64
types.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fiemap.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/fiemap.h~include-linux-fiemaph-include-typesh-now-that-its-exported include/linux/fiemap.h
--- a/include/linux/fiemap.h~include-linux-fiemaph-include-typesh-now-that-its-exported
+++ a/include/linux/fiemap.h
@@ -11,6 +11,8 @@
 #ifndef _LINUX_FIEMAP_H
 #define _LINUX_FIEMAP_H
 
+#include <linux/types.h>
+
 struct fiemap_extent {
 	__u64 fe_logical;  /* logical offset in bytes for the start of
 			    * the extent from the beginning of the file */
_

Patches currently in -mm which might be from sandeen@redhat.com are

include-linux-fiemaph-include-typesh-now-that-its-exported.patch

