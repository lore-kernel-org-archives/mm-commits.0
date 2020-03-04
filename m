From: akpm@linux-foundation.org
Subject: + mm-ksmc-update-get_user_pages-in-comment.patch added to
 -mm tree
Date: Tue, 03 Mar 2020 16:16:43 -0800
Message-ID: <20200304001643.M1rqpOoIN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727854AbgCDAQo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Mar 2020 19:16:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenli@uniontech.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm.c: update get_user_pages() argument in comment
has been added to the -mm tree.  Its filename is
     mm-ksmc-update-get_user_pages-in-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-ksmc-update-get_user_pages-in-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-ksmc-update-get_user_pages-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: chenli <chenli@uniontech.com>
Subject: mm/ksm.c: update get_user_pages() argument in comment

This updates get_user_pages()'s argument in ksm_test_exit()'s comment

Link: http://lkml.kernel.org/r/30ac2417-f1c7-f337-0beb-df561295298c@uniontech.com
Signed-off-by: Li Chen <chenli@uniontech.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/ksm.c~mm-ksmc-update-get_user_pages-in-comment
+++ a/mm/ksm.c
@@ -455,7 +455,7 @@ static inline bool ksm_test_exit(struct
 /*
  * We use break_ksm to break COW on a ksm page: it's a stripped down
  *
- *	if (get_user_pages(addr, 1, 1, 1, &page, NULL) == 1)
+ *	if (get_user_pages(addr, 1, FOLL_WRITE, &page, NULL) == 1)
  *		put_page(page);
  *
  * but taking great care only to touch a ksm page, in a VM_MERGEABLE vma,
_

Patches currently in -mm which might be from chenli@uniontech.com are

mm-ksmc-update-get_user_pages-in-comment.patch
