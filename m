From: akpm@linux-foundation.org
Subject: [patch 034/162] mm fix commmets: if SPARSEMEM, pgdata doesn't
 have page_ext
Date: Fri, 20 May 2016 16:58:04 -0700
Message-ID: <573fa48c.elwszc2K31KLdg2E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbcETX6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:58:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, weijie.yang@samsung.com

From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm fix commmets: if SPARSEMEM, pgdata doesn't have page_ext

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
