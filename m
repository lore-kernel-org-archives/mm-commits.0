From: akpm@linux-foundation.org
Subject: +
 zswap-improve-a-size-determination-in-zswap_frontswap_init.patch added to
 -mm tree
Date: Thu, 25 May 2017 16:29:35 -0700
Message-ID: <592768df.0Uc7NDbKM85asXU9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48282 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965050AbdEYX3g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 19:29:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, ddstreet@ieee.org, sjenning@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap.c: improve a size determination in zswap_frontswap_init()
has been added to the -mm tree.  Its filename is
     zswap-improve-a-size-determination-in-zswap_frontswap_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zswap-improve-a-size-determination-in-zswap_frontswap_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zswap-improve-a-size-determination-in-zswap_frontswap_init.patch

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
Subject: mm/zswap.c: improve a size determination in zswap_frontswap_init()

Replace the specification of a data structure by a pointer dereference as
the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Link: http://lkml.kernel.org/r/19f9da22-092b-f867-bdf6-f4dbad7ccf1f@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zswap.c~zswap-improve-a-size-determination-in-zswap_frontswap_init mm/zswap.c
--- a/mm/zswap.c~zswap-improve-a-size-determination-in-zswap_frontswap_init
+++ a/mm/zswap.c
@@ -1156,7 +1156,7 @@ static void zswap_frontswap_init(unsigne
 {
 	struct zswap_tree *tree;
 
-	tree = kzalloc(sizeof(struct zswap_tree), GFP_KERNEL);
+	tree = kzalloc(sizeof(*tree), GFP_KERNEL);
 	if (!tree) {
 		pr_err("alloc failed, zswap disabled for swap type %d\n", type);
 		return;
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

sh-intc-delete-an-error-message-for-a-failed-memory-allocation-in-add_virq_to_pirq.patch
zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_pool_create.patch
zswap-improve-a-size-determination-in-zswap_frontswap_init.patch
zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_dstmem_prepare.patch

