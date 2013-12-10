From: akpm@linux-foundation.org
Subject: + mm-memblock-add-memblock-memory-allocation-apis-fix.patch added to -mm tree
Date: Mon, 09 Dec 2013 16:29:13 -0800
Message-ID: <52a66059.mNgRGafyUPtXqCrt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3LJA3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 19:29:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, santosh.shilimkar@ti.com, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, grygorii.strashko@ti.com, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, akpm@linux-foundation.org

Subject: + mm-memblock-add-memblock-memory-allocation-apis-fix.patch added to -mm tree
To: akpm@linux-foundation.org,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,grygorii.strashko@ti.com,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,santosh.shilimkar@ti.com,tj@kernel.org,tony@atomide.com,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 16:29:13 -0800


The patch titled
     Subject: mm-memblock-add-memblock-memory-allocation-apis-fix
has been added to the -mm tree.  Its filename is
     mm-memblock-add-memblock-memory-allocation-apis-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-add-memblock-memory-allocation-apis-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-add-memblock-memory-allocation-apis-fix.patch

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
Subject: mm-memblock-add-memblock-memory-allocation-apis-fix

s/depricated/deprecated/

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memblock.c~mm-memblock-add-memblock-memory-allocation-apis-fix mm/memblock.c
--- a/mm/memblock.c~mm-memblock-add-memblock-memory-allocation-apis-fix
+++ a/mm/memblock.c
@@ -788,7 +788,7 @@ void __init_memblock __next_free_mem_ran
 	bool check_node = (nid != NUMA_NO_NODE) && (nid != MAX_NUMNODES);
 
 	if (nid == MAX_NUMNODES)
-		pr_warn_once("%s: Usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE instead\n",
+		pr_warn_once("%s: Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n",
 			     __func__);
 
 	for ( ; mi < mem->cnt; mi++) {
@@ -861,7 +861,7 @@ void __init_memblock __next_free_mem_ran
 	bool check_node = (nid != NUMA_NO_NODE) && (nid != MAX_NUMNODES);
 
 	if (nid == MAX_NUMNODES)
-		pr_warn_once("%s: Usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE instead\n",
+		pr_warn_once("%s: Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n",
 			     __func__);
 
 	if (*idx == (u64)ULLONG_MAX) {
@@ -1068,7 +1068,7 @@ static void * __init memblock_virt_alloc
 	void *ptr;
 
 	if (nid == MAX_NUMNODES)
-		pr_warn("%s: usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE\n",
+		pr_warn("%s: usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE\n",
 			__func__);
 
 	if (WARN_ON_ONCE(slab_is_available()))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

