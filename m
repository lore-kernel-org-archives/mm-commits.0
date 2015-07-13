From: akpm@linux-foundation.org
Subject: + mm-rip-put_page_unless_one-as-it-has-no-callers.patch added to
 -mm tree
Date: Mon, 13 Jul 2015 16:05:52 -0700
Message-ID: <55a44450.97lXMfzzgnuezaAC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbbGMXFx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jul 2015 19:05:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vineet.Gupta1@synopsys.com, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove put_page_unless_one()
has been added to the -mm tree.  Its filename is
     mm-rip-put_page_unless_one-as-it-has-no-callers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rip-put_page_unless_one-as-it-has-no-callers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rip-put_page_unless_one-as-it-has-no-callers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: mm: remove put_page_unless_one()

It has no callers.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN include/linux/mm.h~mm-rip-put_page_unless_one-as-it-has-no-callers include/linux/mm.h
--- a/include/linux/mm.h~mm-rip-put_page_unless_one-as-it-has-no-callers
+++ a/include/linux/mm.h
@@ -362,18 +362,6 @@ static inline int get_page_unless_zero(s
 	return atomic_inc_not_zero(&page->_count);
 }
 
-/*
- * Try to drop a ref unless the page has a refcount of one, return false if
- * that is the case.
- * This is to make sure that the refcount won't become zero after this drop.
- * This can be called when MMU is off so it must not access
- * any of the virtual mappings.
- */
-static inline int put_page_unless_one(struct page *page)
-{
-	return atomic_add_unless(&page->_count, -1, 1);
-}
