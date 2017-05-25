From: akpm@linux-foundation.org
Subject: +
 zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_dstmem_prepare.patch added to -mm tree
Date: Thu, 25 May 2017 16:29:37 -0700
Message-ID: <592768e1.q9RTXtif6CU689Ux%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48290 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965050AbdEYX3i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 19:29:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, ddstreet@ieee.org, sjenning@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap.c: delete an error message for a failed memory allocation in zswap_dstmem_prepare()
has been added to the -mm tree.  Its filename is
     zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_dstmem_prepare.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_dstmem_prepare.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_dstmem_prepare.patch

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
Subject: mm/zswap.c: delete an error message for a failed memory allocation in zswap_dstmem_prepare()

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Link: http://lkml.kernel.org/r/bae25b04-2ce2-7137-a71c-50d7b4f06431@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/zswap.c~zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_dstmem_prepare mm/zswap.c
--- a/mm/zswap.c~zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_dstmem_prepare
+++ a/mm/zswap.c
@@ -371,10 +371,9 @@ static int zswap_dstmem_prepare(unsigned
 	u8 *dst;
 
 	dst = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
-	if (!dst) {
-		pr_err("can't allocate compressor buffer\n");
+	if (!dst)
 		return -ENOMEM;
-	}
+
 	per_cpu(zswap_dstmem, cpu) = dst;
 	return 0;
 }
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

sh-intc-delete-an-error-message-for-a-failed-memory-allocation-in-add_virq_to_pirq.patch
zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_pool_create.patch
zswap-improve-a-size-determination-in-zswap_frontswap_init.patch
zswap-delete-an-error-message-for-a-failed-memory-allocation-in-zswap_dstmem_prepare.patch

