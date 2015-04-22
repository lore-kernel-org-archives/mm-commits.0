From: akpm@linux-foundation.org
Subject: + zsmalloc-remove-obsolete-zsmalloc_debug.patch added to -mm tree
Date: Wed, 22 Apr 2015 13:38:45 -0700
Message-ID: <553806d5.Kc2u90vNvIfZmbzD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbbDVUiq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 16:38:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.jabrzyk@samsung.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: remove obsolete ZSMALLOC_DEBUG
has been added to the -mm tree.  Its filename is
     zsmalloc-remove-obsolete-zsmalloc_debug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-remove-obsolete-zsmalloc_debug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-remove-obsolete-zsmalloc_debug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marcin Jabrzyk <m.jabrzyk@samsung.com>
Subject: zsmalloc: remove obsolete ZSMALLOC_DEBUG

The DEBUG define in zsmalloc is useless, there is no usage of it at all.

Signed-off-by: Marcin Jabrzyk <m.jabrzyk@samsung.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-remove-obsolete-zsmalloc_debug mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-remove-obsolete-zsmalloc_debug
+++ a/mm/zsmalloc.c
@@ -45,10 +45,6 @@
  *
  */
 
-#ifdef CONFIG_ZSMALLOC_DEBUG
-#define DEBUG
-#endif
