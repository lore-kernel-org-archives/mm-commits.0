From: akpm@linux-foundation.org
Subject: + ramoops-use-pstore-interface-fix.patch added to -mm tree
Date: Wed, 01 Feb 2012 14:53:05 -0800
Message-ID: <20120201225305.969AEA0110@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56930 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab2BAWxH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 17:53:07 -0500
Received: by eekb15 with SMTP id b15so52831eek.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 14:53:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, greg@kroah.com, keescook@chromium.org


The patch titled
     Subject: ramoops: fix printk format warnings
has been added to the -mm tree.  Its filename is
     ramoops-use-pstore-interface-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: ramoops: fix printk format warnings

Fix printk format warnings for phys_addr_t type variables:

drivers/char/ramoops.c:246:3: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'phys_addr_t'
drivers/char/ramoops.c:273:2: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'phys_addr_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ramoops.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/char/ramoops.c~ramoops-use-pstore-interface-fix drivers/char/ramoops.c
--- a/drivers/char/ramoops.c~ramoops-use-pstore-interface-fix
+++ a/drivers/char/ramoops.c
@@ -244,7 +244,7 @@ static int __init ramoops_probe(struct p
 
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
 		pr_err("request mem region (0x%lx@0x%llx) failed\n",
-			cxt->size, cxt->phys_addr);
+			cxt->size, (unsigned long long)cxt->phys_addr);
 		err = -EINVAL;
 		goto fail_buf;
 	}
@@ -271,7 +271,8 @@ static int __init ramoops_probe(struct p
 	dump_oops = pdata->dump_oops;
 
 	pr_info("attached 0x%lx@0x%llx (%ux0x%zx)\n",
-		cxt->size, cxt->phys_addr, cxt->max_count, cxt->record_size);
+		cxt->size, (unsigned long long)cxt->phys_addr,
+		cxt->max_count, cxt->record_size);
 
 	return 0;
 
_
Subject: Subject: ramoops: fix printk format warnings

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
crc32-bolt-on-crc32c-dont-reference-unnecessary-crc32-tables-in-single-bit-mode.patch
ramoops-use-pstore-interface.patch
ramoops-use-pstore-interface-fix.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

