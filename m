From: akpm@linux-foundation.org
Subject: + mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch added
 to -mm tree
Date: Wed, 11 Jun 2014 14:28:43 -0700
Message-ID: <5398ca0b./sN3ODpgC6XmJHcD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbaFKV2o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 17:28:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjennings@variantweb.net, fabf@skynet.be

Subject: + mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch added to -mm tree
To: fabf@skynet.be,sjennings@variantweb.net
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 14:28:43 -0700


The patch titled
     Subject: mm/zswap.c: add __init to zswap_entry_cache_destroy()
has been added to the -mm tree.  Its filename is
     mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -207,7 +207,7 @@ static int zswap_entry_cache_create(void
 	return zswap_entry_cache == NULL;
 }
 
-static void zswap_entry_cache_destory(void)
+static void __init zswap_entry_cache_destroy(void)
 {
 	kmem_cache_destroy(zswap_entry_cache);
 }
@@ -926,7 +926,7 @@ static int __init init_zswap(void)
 pcpufail:
 	zswap_comp_exit();
 compfail:
-	zswap_entry_cache_destory();
+	zswap_entry_cache_destroy();
 cachefail:
 	zbud_destroy_pool(zswap_pool);
 error:
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
fs-isofs-logging-clean-up.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch

