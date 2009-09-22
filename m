From: akpm@linux-foundation.org
Subject: [merged] mm-includecheck-fix-for-mm-nommuc.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:41:30 -0700
Message-ID: <200909222041.n8MKfUSQ007670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752915AbZIVUmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, dhowells@redhat.com, gerg@snapgear.com, jaswinderrajput@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: includecheck fix for mm/nommu.c
has been removed from the -mm tree.  Its filename was
     mm-includecheck-fix-for-mm-nommuc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: includecheck fix for mm/nommu.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Fix the following 'make includecheck' warning:

  mm/nommu.c: internal.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Acked-by: Greg Ungerer <gerg@snapgear.com>
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
