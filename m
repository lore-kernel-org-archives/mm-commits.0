From: akpm@linux-foundation.org
Subject: [folded-merged]
 page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-2.patch
 removed from -mm tree
Date: Wed, 30 Sep 2015 14:54:56 -0700
Message-ID: <560c5a30.0go9qLqokKEzeXcw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbbI3Vy5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:54:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, kirill.shutemov@linux.intel.com, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: rectify forward declaration
has been removed from the -mm tree.  Its filename was
     page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-2.patch

This patch was dropped because it was folded into page-flags-introduce-page-flags-policies-wrt-compound-pages.patch

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: page-flags: rectify forward declaration

compound_head is defined as inline in page-flags.h but in the forward
declaration of compound_head in the same file missed "inline".  As a
result we got plenty of build warnings while building for some
architecture like avr32.  The warning showed as: warning: 'compound_head'
declared inline after being called.  warning: previous declaration of
'compound_head' was here

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-2 include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-2
+++ a/include/linux/page-flags.h
@@ -227,7 +227,7 @@ static inline int __TestClearPage##uname
 struct page;
 static inline int PageCompound(struct page *page);
 static inline int PageTail(struct page *page);
-static struct page *compound_head(struct page *page);
+static inline struct page *compound_head(struct page *page);
 
 TESTPAGEFLAG(Locked, locked, ANY)
 PAGEFLAG(Error, error, ANY) TESTCLEARFLAG(Error, error, ANY)
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

page-flags-introduce-page-flags-policies-wrt-compound-pages.patch

