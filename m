From: akpm@linux-foundation.org
Subject: +
 mm-zsmalloc-avoid-unnecessary-iteration-in-get_pages_per_zspage.patch added to -mm tree
Date: Thu, 05 May 2016 14:46:30 -0700
Message-ID: <572bbf36.gzoKp3GKaoD+eEDt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092AbcEEVqb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2016 17:46:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: avoid unnecessary iteration in get_pages_per_zspage()
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-avoid-unnecessary-iteration-in-get_pages_per_zspage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-avoid-unnecessary-iteration-in-get_pages_per_zspage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-avoid-unnecessary-iteration-in-get_pages_per_zspage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: mm/zsmalloc: avoid unnecessary iteration in get_pages_per_zspage()

If we find a zspage with usage == 100%, there is no need to try other
zspages.

Link: http://lkml.kernel.org/r/1462425447-13385-1-git-send-email-opensource.ganesh@gmail.com
Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/zsmalloc.c~mm-zsmalloc-avoid-unnecessary-iteration-in-get_pages_per_zspage mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-avoid-unnecessary-iteration-in-get_pages_per_zspage
+++ a/mm/zsmalloc.c
@@ -770,6 +770,9 @@ static int get_pages_per_zspage(int clas
 		if (usedpc > max_usedpc) {
 			max_usedpc = usedpc;
 			max_usedpc_order = i;
+
+			if (max_usedpc == 100)
+				break;
 		}
 	}
 
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

mm-zsmalloc-avoid-unnecessary-iteration-in-get_pages_per_zspage.patch

