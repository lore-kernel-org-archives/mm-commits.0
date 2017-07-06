From: akpm@linux-foundation.org
Subject: [patch 100/108] mm/zswap.c: delete an error message for a
 failed memory allocation in zswap_dstmem_prepare()
Date: Thu, 06 Jul 2017 15:40:40 -0700
Message-ID: <20170706224040.PXF_c7GlI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37078 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752891AbdGFWkm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:40:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ddstreet@ieee.org, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, sjenning@redhat.com, torvalds@linux-foundation.org

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
