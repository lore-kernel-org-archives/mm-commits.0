From: akpm@linux-foundation.org
Subject: + mm-fix-commmets-if-sparsemem-pgdata-doesnt-have-page_ext.patch
 added to -mm tree
Date: Wed, 27 Apr 2016 14:17:46 -0700
Message-ID: <57212c7a.6uYGIwtIgwG+aJoq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbcD0VRr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 17:17:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm fix commmets: If SPARSEMEM, pgdata doesn't have page_ext
has been added to the -mm tree.  Its filename is
     mm-fix-commmets-if-sparsemem-pgdata-doesnt-have-page_ext.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-commmets-if-sparsemem-pgdata-doesnt-have-page_ext.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-commmets-if-sparsemem-pgdata-doesnt-have-page_ext.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm fix commmets: If SPARSEMEM, pgdata doesn't have page_ext

If SPARSEMEM, use page_ext in mem_section
if !SPARSEMEM, use page_ext in pgdata

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~mm-fix-commmets-if-sparsemem-pgdata-doesnt-have-page_ext include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-fix-commmets-if-sparsemem-pgdata-doesnt-have-page_ext
+++ a/include/linux/mmzone.h
@@ -1063,7 +1063,7 @@ struct mem_section {
 	unsigned long *pageblock_flags;
 #ifdef CONFIG_PAGE_EXTENSION
 	/*
-	 * If !SPARSEMEM, pgdat doesn't have page_ext pointer. We use
+	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
 	 * section. (see page_ext.h about this.)
 	 */
 	struct page_ext *page_ext;
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

mm-fix-commmets-if-sparsemem-pgdata-doesnt-have-page_ext.patch

