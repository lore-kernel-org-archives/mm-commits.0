From: akpm@linux-foundation.org
Subject: + mm-add-nr_zsmalloc-to-vmstat-fix.patch added to -mm tree
Date: Fri, 03 Jun 2016 15:14:52 -0700
Message-ID: <5752015c.KBLz0j35g1Sj0x0I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbcFCWOy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2016 18:14:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chan.jeong@lge.com, chanho.min@lge.com, minchan@kernel.org, sangseok.lee@lge.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-nr_zsmalloc-to-vmstat-fix
has been added to the -mm tree.  Its filename is
     mm-add-nr_zsmalloc-to-vmstat-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-nr_zsmalloc-to-vmstat-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-nr_zsmalloc-to-vmstat-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-nr_zsmalloc-to-vmstat-fix

fix build with CONFIG_ZSMALLOC=m

Cc: Chan Gyun Jeong <chan.jeong@lge.com>
Cc: Chanho Min <chanho.min@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sangseok Lee <sangseok.lee@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/vmstat.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~mm-add-nr_zsmalloc-to-vmstat-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-add-nr_zsmalloc-to-vmstat-fix
+++ a/include/linux/mmzone.h
@@ -140,7 +140,7 @@ enum zone_stat_item {
 	NR_DIRTIED,		/* page dirtyings since bootup */
 	NR_WRITTEN,		/* page writings since bootup */
 	NR_PAGES_SCANNED,	/* pages scanned since last reclaim */
-#ifdef CONFIG_ZSMALLOC
+#if IS_ENABLED(CONFIG_ZSMALLOC)
 	NR_ZSMALLOC,
 #endif
 #ifdef CONFIG_NUMA
diff -puN mm/vmstat.c~mm-add-nr_zsmalloc-to-vmstat-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-add-nr_zsmalloc-to-vmstat-fix
+++ a/mm/vmstat.c
@@ -718,7 +718,7 @@ const char * const vmstat_text[] = {
 	"nr_dirtied",
 	"nr_written",
 	"nr_pages_scanned",
-#ifdef CONFIG_ZSMALLOC
+#if IS_ENABLED(CONFIG_ZSMALLOC)
 	"nr_zsmalloc",
 #endif
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

