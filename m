From: akpm@linux-foundation.org
Subject: + fs-affs-filec-remove-obsolete-pagesize-check.patch added to -mm tree
Date: Mon, 17 Nov 2014 14:05:25 -0800
Message-ID: <546a7125.L/cnswNU/VUxRckF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaKQWF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Nov 2014 17:05:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/file.c: remove obsolete pagesize check
has been added to the -mm tree.  Its filename is
     fs-affs-filec-remove-obsolete-pagesize-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-filec-remove-obsolete-pagesize-check.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-filec-remove-obsolete-pagesize-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/file.c: remove obsolete pagesize check

linux kernel doesn't manage page sizes below 4kb.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/affs/file.c~fs-affs-filec-remove-obsolete-pagesize-check fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-filec-remove-obsolete-pagesize-check
+++ a/fs/affs/file.c
@@ -15,10 +15,6 @@
 #include <linux/aio.h>
 #include "affs.h"
 
-#if PAGE_SIZE < 4096
-#error PAGE_SIZE must be at least 4096
-#endif
