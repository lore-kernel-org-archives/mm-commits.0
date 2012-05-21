From: akpm@linux-foundation.org
Subject: [wrecked] ramoops-use-pstore-interface-fix.patch removed from -mm tree
Date: Mon, 21 May 2012 15:15:50 -0700
Message-ID: <20120521221551.04555A0363@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:61078 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab2EUWPw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 May 2012 18:15:52 -0400
Received: by ghbz15 with SMTP id z15so83140ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 21 May 2012 15:15:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, greg@kroah.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ramoops: fix printk format warnings
has been removed from the -mm tree.  Its filename was
     ramoops-use-pstore-interface-fix.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -243,7 +243,7 @@ static int __init ramoops_probe(struct p
 
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
 		pr_err("request mem region (0x%lx@0x%llx) failed\n",
-			cxt->size, cxt->phys_addr);
+			cxt->size, (unsigned long long)cxt->phys_addr);
 		err = -EINVAL;
 		goto fail_buf;
 	}
@@ -270,7 +270,8 @@ static int __init ramoops_probe(struct p
 	dump_oops = pdata->dump_oops;
 
 	pr_info("attached 0x%lx@0x%llx (%ux0x%zx)\n",
-		cxt->size, cxt->phys_addr, cxt->max_count, cxt->record_size);
+		cxt->size, (unsigned long long)cxt->phys_addr,
+		cxt->max_count, cxt->record_size);
 
 	return 0;
 
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
documentation-memcg-future-proof-hierarchical-statistics-documentation.patch
kmodc-fix-kernel-doc-warning.patch
kconfig-update-compression-algorithm-info.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

