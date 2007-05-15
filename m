From: akpm@linux-foundation.org
Subject: - update-mtd-use-of-symbol_getput.patch removed from -mm tree
Date: Tue, 15 May 2007 01:49:23 -0700
Message-ID: <200705150849.l4F8nMrK005529@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758387AbXEOItk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 04:49:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xyzzy@speakeasy.org, dwmw2@infradead.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Update mtd use of symbol_(get|put)
has been removed from the -mm tree.  Its filename was
     update-mtd-use-of-symbol_getput.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Update mtd use of symbol_(get|put)
From: Trent Piepho <xyzzy@speakeasy.org>

Make the mtd sub-system work with changes to __symbol_get().  mtd calls
__symbol_get() directly, rather than through the symbol_get() macro because it
uses a string it created with sprintf to specify the symbol to attach to.  It
needs to be updated to supply THIS_MODULE as the user parameter added to
__symbol_get().

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/gen_probe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/chips/gen_probe.c~update-mtd-use-of-symbol_getput drivers/mtd/chips/gen_probe.c
--- a/drivers/mtd/chips/gen_probe.c~update-mtd-use-of-symbol_getput
+++ a/drivers/mtd/chips/gen_probe.c
@@ -211,10 +211,10 @@ static inline struct mtd_info *cfi_cmdse
 
 	sprintf(probename, MODULE_SYMBOL_PREFIX "cfi_cmdset_%4.4X", type);
 
-	probe_function = __symbol_get(probename);
+	probe_function = __symbol_get(probename, THIS_MODULE);
 	if (!probe_function) {
 		request_module(probename + sizeof(MODULE_SYMBOL_PREFIX) - 1);
-		probe_function = __symbol_get(probename);
+		probe_function = __symbol_get(probename, THIS_MODULE);
 	}
 
 	if (probe_function) {
_

Patches currently in -mm which might be from xyzzy@speakeasy.org are

git-dvb.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
