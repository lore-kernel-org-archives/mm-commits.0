From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch removed from
 -mm tree
Date: Tue, 15 Mar 2016 14:38:29 -0700
Message-ID: <56e880d5.YsZAGQrUpeZ/loTR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbcCOVia (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 17:38:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, dave.hansen@intel.com, izumi.taku@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, matt@codeblueprint.co.uk, mel@csn.ul.ie, qiuxishi@huawei.com, steve.capper@linaro.org, sudeep.holla@arm.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_allocc-introduce-kernelcore=mirror-option-fix
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch

This patch was dropped because it was folded into mm-page_allocc-introduce-kernelcore=mirror-option.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_allocc-introduce-kernelcore=mirror-option-fix

fix build with CONFIG_HAVE_MEMBLOCK_NODE_MAP=n

Reported-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_allocc-introduce-kernelcore=mirror-option-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-introduce-kernelcore=mirror-option-fix
+++ a/mm/page_alloc.c
@@ -4521,6 +4521,7 @@ void __meminit memmap_init_zone(unsigned
 						&nr_initialised))
 				break;
 
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 			/*
 			 * if not mirrored_kernelcore and ZONE_MOVABLE exists,
 			 * range from zone_movable_pfn[nid] to end of each node
@@ -4531,7 +4532,6 @@ void __meminit memmap_init_zone(unsigned
 				    pfn >= zone_movable_pfn[nid])
 					continue;
 
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 			/*
 			 * check given memblock attribute by firmware which
 			 * can affect kernel memory layout.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch

