From: akpm@linux-foundation.org
Subject: +
 rapidio-delete-an-unnecessary-variable-initialisation-in-three-functions.patch added to -mm tree
Date: Tue, 19 Dec 2017 16:05:56 -0800
Message-ID: <5a39a964.cYiCDXFhPADfYQKB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40342 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753724AbdLTAF5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Dec 2017 19:05:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, alexandre.bounine@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: delete an unnecessary variable initialisation in three functions
has been added to the -mm tree.  Its filename is
     rapidio-delete-an-unnecessary-variable-initialisation-in-three-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-delete-an-unnecessary-variable-initialisation-in-three-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-delete-an-unnecessary-variable-initialisation-in-three-functions.patch

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
Subject: rapidio: delete an unnecessary variable initialisation in three functions

The local variable "rc" will be set to an appropriate value a bit later. 
Thus omit the explicit initialisation at the beginning.

Link: http://lkml.kernel.org/r/ed729e8c-815c-8b56-a48f-1be579d0cc2b@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-delete-an-unnecessary-variable-initialisation-in-three-functions drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-delete-an-unnecessary-variable-initialisation-in-three-functions
+++ a/drivers/rapidio/rio.c
@@ -441,7 +441,7 @@ int rio_request_inb_dbell(struct rio_mpo
 			  void (*dinb) (struct rio_mport * mport, void *dev_id, u16 src,
 					u16 dst, u16 info))
 {
-	int rc = 0;
+	int rc;
 	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
 
 	if (res) {
@@ -693,7 +693,7 @@ EXPORT_SYMBOL_GPL(rio_pw_enable);
 int rio_map_inb_region(struct rio_mport *mport, dma_addr_t local,
 			u64 rbase, u32 size, u32 rflags)
 {
-	int rc = 0;
+	int rc;
 	unsigned long flags;
 
 	if (!mport->ops->map_inb)
@@ -737,7 +737,7 @@ EXPORT_SYMBOL_GPL(rio_unmap_inb_region);
 int rio_map_outb_region(struct rio_mport *mport, u16 destid, u64 rbase,
 			u32 size, u32 rflags, dma_addr_t *local)
 {
-	int rc = 0;
+	int rc;
 	unsigned long flags;
 
 	if (!mport->ops->map_outb)
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

rapidio-delete-an-error-message-for-a-failed-memory-allocation-in-rio_init_mports.patch
rapidio-adjust-12-checks-for-null-pointers.patch
rapidio-adjust-five-function-calls-together-with-a-variable-assignment.patch
rapidio-improve-a-size-determination-in-five-functions.patch
rapidio-delete-an-unnecessary-variable-initialisation-in-three-functions.patch
rapidio-return-an-error-code-only-as-a-constant-in-two-functions.patch
rapidio-move-12-export_symbol_gpl-calls-to-function-implementations.patch

