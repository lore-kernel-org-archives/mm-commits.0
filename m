From: akpm@linux-foundation.org
Subject: + frontswap-fix-the-condition-in-bug_on.patch added to -mm tree
Date: Tue, 04 Nov 2014 12:59:13 -0800
Message-ID: <54593e21.821cnL8dORYNkdXI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47679 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaKDU7M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 15:59:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: omycle@gmail.com, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/frontswap.c: fix the condition in BUG_ON
has been added to the -mm tree.  Its filename is
     frontswap-fix-the-condition-in-bug_on.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/frontswap-fix-the-condition-in-bug_on.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/frontswap-fix-the-condition-in-bug_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Haifeng <omycle@gmail.com>
Subject: mm/frontswap.c: fix the condition in BUG_ON

The largest index of swap device is MAX_SWAPFILES-1.  So the type should
be less than MAX_SWAPFILES.

Signed-off-by: Haifeng Li <omycle@gmail.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frontswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/frontswap.c~frontswap-fix-the-condition-in-bug_on mm/frontswap.c
--- a/mm/frontswap.c~frontswap-fix-the-condition-in-bug_on
+++ a/mm/frontswap.c
@@ -182,7 +182,7 @@ void __frontswap_init(unsigned type, uns
 	if (frontswap_ops)
 		frontswap_ops->init(type);
 	else {
-		BUG_ON(type > MAX_SWAPFILES);
+               BUG_ON(type >= MAX_SWAPFILES);
 		set_bit(type, need_init);
 	}
 }
_

Patches currently in -mm which might be from omycle@gmail.com are

frontswap-fix-the-condition-in-bug_on.patch

