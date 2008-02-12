From: akpm@linux-foundation.org
Subject: + xtensa-warn-about-including-asm-rwsemh-directly.patch added to -mm tree
Date: Tue, 12 Feb 2008 14:42:54 -0800
Message-ID: <200802122242.m1CMgshn026272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33314 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754413AbYBLWnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 17:43:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, chris@zankel.net


The patch titled
     XTENSA: warn about including <asm/rwsem.h> directly.
has been added to the -mm tree.  Its filename is
     xtensa-warn-about-including-asm-rwsemh-directly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: XTENSA: warn about including <asm/rwsem.h> directly.
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

For consistency with other architectures, warn about including
<asm-xtensa/rwsem.h> directly.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-xtensa/rwsem.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/asm-xtensa/rwsem.h~xtensa-warn-about-including-asm-rwsemh-directly include/asm-xtensa/rwsem.h
--- a/include/asm-xtensa/rwsem.h~xtensa-warn-about-including-asm-rwsemh-directly
+++ a/include/asm-xtensa/rwsem.h
@@ -13,6 +13,10 @@
 #ifndef _XTENSA_RWSEM_H
 #define _XTENSA_RWSEM_H
 
+#ifndef _LINUX_RWSEM_H
+#error "Please don't include <asm/rwsem.h> directly, use <linux/rwsem.h> instead."
+#endif
+
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <asm/atomic.h>
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-xfs.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
