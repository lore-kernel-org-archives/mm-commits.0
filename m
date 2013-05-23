From: akpm@linux-foundation.org
Subject: +
 drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch added to -mm tree
Date: Thu, 23 May 2013 15:52:00 -0700
Message-ID: <519e9d90.dDjKzEOeTRkpKSu2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759758Ab3EWWwB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 18:52:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, james.hogan@imgtec.com, dwmw2@infradead.org, keescook@chromium.org

Subject: + drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch added to -mm tree
To: keescook@chromium.org,dwmw2@infradead.org,james.hogan@imgtec.com,rusty@rustcorp.com.au
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 15:52:00 -0700


The patch titled
     Subject: drivers/mtd/chips/gen_probe.c: refactor call to request_module()
has been added to the -mm tree.  Its filename is
     drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

