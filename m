From: akpm@linux-foundation.org
Subject: +
 page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-2.patch
 added to -mm tree
Date: Mon, 21 Sep 2015 15:35:17 -0700
Message-ID: <56008625.MCfxwxovAWD04GY2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938AbbIUWfS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Sep 2015 18:35:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, kirill.shutemov@linux.intel.com, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: rectify forward declaration
has been added to the -mm tree.  Its filename is
     page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-2.patch

