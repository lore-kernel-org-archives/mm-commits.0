From: akpm@linux-foundation.org
Subject: + mm-includecheck-fix-for-mm-nommuc.patch added to -mm tree
Date: Mon, 10 Aug 2009 23:48:16 -0700
Message-ID: <200908110648.n7B6mGWe026394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703AbZHKLyl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, dhowells@redhat.com, gerg@snapgear.com, jaswinderrajput@gmail.com


The patch titled
     mm: includecheck fix for mm/nommu.c
has been added to the -mm tree.  Its filename is
     mm-includecheck-fix-for-mm-nommuc.patch

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
Subject: mm: includecheck fix for mm/nommu.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Fix the following 'make includecheck' warning:

  mm/nommu.c: internal.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/nommu.c~mm-includecheck-fix-for-mm-nommuc mm/nommu.c
--- a/mm/nommu.c~mm-includecheck-fix-for-mm-nommuc
+++ a/mm/nommu.c
@@ -56,8 +56,6 @@ void no_printk(const char *fmt, ...)
 	no_printk(KERN_DEBUG FMT"\n", ##__VA_ARGS__)
 #endif
 
-#include "internal.h"
