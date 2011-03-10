From: akpm@linux-foundation.org
Subject: + drivers-misc-atmel_tclibc-fix-a-memory-leak.patch added to -mm tree
Date: Thu, 10 Mar 2011 14:16:52 -0800
Message-ID: <201103102216.p2AMGqlx031791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002Ab1CJWQz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Mar 2011 17:16:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com


The patch titled
     drivers/misc/atmel_tclib.c: fix a memory leak
has been added to the -mm tree.  Its filename is
     drivers-misc-atmel_tclibc-fix-a-memory-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/atmel_tclib.c: fix a memory leak
From: Axel Lin <axel.lin@gmail.com>

request_mem_region() will call kzalloc to allocate memory for struct
resource.  release_resource() unregisters the resource but does not free
the allocated memory, thus use release_mem_region() instead to fix the
memory leak.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/atmel_tclib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/atmel_tclib.c~drivers-misc-atmel_tclibc-fix-a-memory-leak drivers/misc/atmel_tclib.c
--- a/drivers/misc/atmel_tclib.c~drivers-misc-atmel_tclibc-fix-a-memory-leak
+++ a/drivers/misc/atmel_tclib.c
@@ -75,7 +75,7 @@ out:
 	return tc;
 
 fail_ioremap:
-	release_resource(r);
+	release_mem_region(r->start, ATMEL_TC_IOMEM_SIZE);
 fail:
 	tc = NULL;
 	goto out;
@@ -95,7 +95,7 @@ void atmel_tc_free(struct atmel_tc *tc)
 	spin_lock(&tc_list_lock);
 	if (tc->regs) {
 		iounmap(tc->regs);
-		release_resource(tc->iomem);
+		release_mem_region(tc->iomem->start, ATMEL_TC_IOMEM_SIZE);
 		tc->regs = NULL;
 		tc->iomem = NULL;
 	}
_

Patches currently in -mm which might be from axel.lin@gmail.com are

gpio-add-module_device_table.patch
linux-next.patch
drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix.patch
drivers-misc-atmel_tclibc-fix-a-memory-leak.patch
gpio-use-__devexit-at-necessary-places.patch

