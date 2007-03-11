From: akpm@linux-foundation.org
Subject: + update-mtd-use-of-symbol_getput.patch added to -mm tree
Date: Sun, 11 Mar 2007 00:09:57 -0800
Message-ID: <200703110809.l2B89vXg007536@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39478 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbXCKIKK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 04:10:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xyzzy@speakeasy.org, dwmw2@infradead.org, rusty@rustcorp.com.au


The patch titled
     Update mtd use of symbol_(get|put)
has been added to the -mm tree.  Its filename is
     update-mtd-use-of-symbol_getput.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fix-constant-folding-and-poor-optimization-in-byte-swapping.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-tidy.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
