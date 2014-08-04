From: akpm@linux-foundation.org
Subject: + mm-change-confusing-ifdef-use-in-__access_remote_vm.patch added to -mm tree
Date: Mon, 04 Aug 2014 14:02:48 -0700
Message-ID: <53dff4f8.cbopaIA9V4VRQPMw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:52612 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaHDVCt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2014 17:02:49 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so1546qaq.1
        for <mm-commits@vger.kernel.org>; Mon, 04 Aug 2014 14:02:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, dcb314@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change confusing #ifdef use in __access_remote_vm
has been added to the -mm tree.  Its filename is
     mm-change-confusing-ifdef-use-in-__access_remote_vm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-change-confusing-ifdef-use-in-__access_remote_vm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-change-confusing-ifdef-use-in-__access_remote_vm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm: change confusing #ifdef use in __access_remote_vm

This patch changes confusing #ifdef use in __access_remote_vm
into merely ugly #ifdef use.

Addresses bug https://bugzilla.kernel.org/show_bug.cgi?id=81651

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-change-confusing-ifdef-use-in-__access_remote_vm mm/memory.c
--- a/mm/memory.c~mm-change-confusing-ifdef-use-in-__access_remote_vm
+++ a/mm/memory.c
@@ -3618,11 +3618,13 @@ static int __access_remote_vm(struct tas
 		ret = get_user_pages(tsk, mm, addr, 1,
 				write, 1, &page, &vma);
 		if (ret <= 0) {
+#ifndef CONFIG_HAVE_IOREMAP_PROT
+			break;
+#else
 			/*
 			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
 			 * we can access using slightly different code.
 			 */
-#ifdef CONFIG_HAVE_IOREMAP_PROT
 			vma = find_vma(mm, addr);
 			if (!vma || vma->vm_start > addr)
 				break;
@@ -3630,9 +3632,9 @@ static int __access_remote_vm(struct tas
 				ret = vma->vm_ops->access(vma, addr, buf,
 							  len, write);
 			if (ret <= 0)
-#endif
 				break;
 			bytes = ret;
+#endif
 		} else {
 			bytes = len;
 			offset = addr & (PAGE_SIZE-1);
_

Patches currently in -mm which might be from riel@redhat.com are

x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
mm-internalh-use-nth_page.patch
mm-thp-move-invariant-bug-check-out-of-loop-in-__split_huge_page_map.patch
mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim-fix.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-remove-all_unreclaimable-fix.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
mm-vmscan-clean-up-struct-scan_control-v2.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-update-the-description-for-vm_total_pages.patch
mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode.patch
mm-writeback-prevent-race-when-calculating-dirty-limits.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
mm-oom-remove-unnecessary-check-for-null-zonelist.patch
mm-oom-rename-zonelist-locking-functions.patch
mm-thp-restructure-thp-avoidance-of-light-synchronous-migration.patch
mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio.patch
memcg-vmscan-fix-forced-scan-of-anonymous-pages.patch
memcg-vmscan-fix-forced-scan-of-anonymous-pages-fix-cleanups.patch
mm-change-confusing-ifdef-use-in-__access_remote_vm.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

