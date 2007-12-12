From: akpm@linux-foundation.org
Subject: + drivers-dma-iop-admac-use-list_head-instead-of-list_head_init.patch added to -mm tree
Date: Wed, 12 Dec 2007 00:41:37 -0800
Message-ID: <200712120841.lBC8fb1O001435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754907AbXLLIll (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 03:41:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com, dan.j.williams@intel.com, shannon.nelson@intel.com


The patch titled
     drivers/dma/iop-adma.c: use LIST_HEAD instead of LIST_HEAD_INIT
has been added to the -mm tree.  Its filename is
     drivers-dma-iop-admac-use-list_head-instead-of-list_head_init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/dma/iop-adma.c: use LIST_HEAD instead of LIST_HEAD_INIT
From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/iop-adma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dma/iop-adma.c~drivers-dma-iop-admac-use-list_head-instead-of-list_head_init drivers/dma/iop-adma.c
--- a/drivers/dma/iop-adma.c~drivers-dma-iop-admac-use-list_head-instead-of-list_head_init
+++ a/drivers/dma/iop-adma.c
@@ -284,7 +284,7 @@ iop_adma_alloc_slots(struct iop_adma_cha
 			int slots_per_op)
 {
 	struct iop_adma_desc_slot *iter, *_iter, *alloc_start = NULL;
-	struct list_head chain = LIST_HEAD_INIT(chain);
+	LIST_HEAD(chain);
 	int slots_found, retry = 0;
 
 	/* start search from the last allocated descrtiptor
_

Patches currently in -mm which might be from crquan@gmail.com are

git-net.patch
git-s390.patch
3w-raid-drivers-memset-not-needed-in-probe.patch
git-cryptodev.patch
drivers-char-use-list_head-instead-of-list_head_init.patch
drivers-char-ipmi-ipmi_msghandlerc-use-list_head-instead-of-list_head_init.patch
drivers-dma-iop-admac-use-list_head-instead-of-list_head_init.patch
