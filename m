From: akpm@linux-foundation.org
Subject: [merged]
 drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch removed
 from -mm tree
Date: Mon, 05 Aug 2013 12:06:10 -0700
Message-ID: <51fff7a2.VdxAOSoS4EU6u9Ih%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab3HETGK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 15:06:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, james.hogan@imgtec.com, dwmw2@infradead.org, keescook@chromium.org

Subject: [merged] drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch removed from -mm tree
To: keescook@chromium.org,dwmw2@infradead.org,james.hogan@imgtec.com,rusty@rustcorp.com.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 12:06:10 -0700


The patch titled
     Subject: drivers/mtd/chips/gen_probe.c: refactor call to request_module()
has been removed from the -mm tree.  Its filename was
     drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: drivers/mtd/chips/gen_probe.c: refactor call to request_module()

This reduces the size of the stack frame when calling request_module().
Performing the sprintf before the call is not needed.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/gen_probe.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/mtd/chips/gen_probe.c~drivers-mtd-chips-gen_probec-refactor-call-to-request_module drivers/mtd/chips/gen_probe.c
--- a/drivers/mtd/chips/gen_probe.c~drivers-mtd-chips-gen_probec-refactor-call-to-request_module
+++ a/drivers/mtd/chips/gen_probe.c
@@ -211,9 +211,7 @@ static inline struct mtd_info *cfi_cmdse
 
 	probe_function = __symbol_get(probename);
 	if (!probe_function) {
-		char modname[sizeof("cfi_cmdset_%4.4X")];
-		sprintf(modname, "cfi_cmdset_%4.4X", type);
-		request_module(modname);
+		request_module("cfi_cmdset_%4.4X", type);
 		probe_function = __symbol_get(probename);
 	}
 
_

Patches currently in -mm which might be from keescook@chromium.org are

isdn-clean-up-debug-format-string-usage.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
panic-call-panic-handlers-before-kmsg_dump.patch
linux-next.patch

