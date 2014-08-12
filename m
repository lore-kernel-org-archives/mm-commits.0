From: akpm@linux-foundation.org
Subject: [merged] mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:38:10 -0700
Message-ID: <53ea6d22.9o35ZzQGPCean04+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:42841 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbaHLTiL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:11 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so1919337oah.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap.c: add __init to zswap_entry_cache_destroy()
has been removed from the -mm tree.  Its filename was
     mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: mm/zswap.c: add __init to zswap_entry_cache_destroy()

zswap_entry_cache_destroy() is only called by __init init_zswap().

This patch also fixes function name zswap_entry_cache_ s/destory/destroy

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/zswap.c~mm-zswapc-add-__init-to-zswap_entry_cache_destroy mm/zswap.c
--- a/mm/zswap.c~mm-zswapc-add-__init-to-zswap_entry_cache_destroy
+++ a/mm/zswap.c
@@ -212,7 +212,7 @@ static int zswap_entry_cache_create(void
 	return zswap_entry_cache == NULL;
 }
 
-static void zswap_entry_cache_destory(void)
+static void __init zswap_entry_cache_destroy(void)
 {
 	kmem_cache_destroy(zswap_entry_cache);
 }
@@ -941,7 +941,7 @@ static int __init init_zswap(void)
 pcpufail:
 	zswap_comp_exit();
 compfail:
-	zswap_entry_cache_destory();
+	zswap_entry_cache_destroy();
 cachefail:
 	zpool_destroy_pool(zswap_pool);
 error:
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

