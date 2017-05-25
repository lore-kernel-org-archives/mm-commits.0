From: akpm@linux-foundation.org
Subject: +
 zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_pool_create.patch added to -mm tree
Date: Thu, 25 May 2017 16:29:33 -0700
Message-ID: <592768dd.Z9Cg+cI9HSB93eqs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48270 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965050AbdEYX3e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 19:29:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, ddstreet@ieee.org, sjenning@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap.c: delete an error message for a failed memory allocation in zswap_pool_create()
has been added to the -mm tree.  Its filename is
     zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_pool_create.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_pool_create.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_pool_create.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: mm/zswap.c: delete an error message for a failed memory allocation in zswap_pool_create()

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Link: http://lkml.kernel.org/r/2345aabc-ae98-1d31-afba-40a02c5baf3d@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/zswap.c~zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_pool_create mm/zswap.c
--- a/mm/zswap.c~zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_pool_create
+++ a/mm/zswap.c
@@ -515,10 +515,8 @@ static struct zswap_pool *zswap_pool_cre
 	}
 
 	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
-	if (!pool) {
-		pr_err("pool alloc failed\n");
+	if (!pool)
 		return NULL;
-	}
 
 	/* unique name for each pool specifically required by zsmalloc */
 	snprintf(name, 38, "zswap%x", atomic_inc_return(&zswap_pools_count));
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

sh-intc-delete-an-error-message-for-a-failed-memory-allocation-in-add_virq_to_pirq.patch
zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_pool_create.patch
zswap-improve-a-size-determination-in-zswap_frontswap_init.patch
zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_dstmem_prepare.patch

