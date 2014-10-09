From: akpm@linux-foundation.org
Subject: [folded-merged] introduce-dump_vma-fix.patch removed from -mm
 tree
Date: Thu, 09 Oct 2014 13:39:08 -0700
Message-ID: <5436f26c.OidEB9s+oHoN/6xW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaJIUjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:39:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, khlebnikov@openvz.org, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: introduce-dump_vma-fix
has been removed from the -mm tree.  Its filename was
     introduce-dump_vma-fix.patch

This patch was dropped because it was folded into introduce-dump_vma.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: introduce-dump_vma-fix

make dump_vma() require CONFIG_DEBUG_VM

Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Michel Lespinasse <walken@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~introduce-dump_vma-fix mm/page_alloc.c
--- a/mm/page_alloc.c~introduce-dump_vma-fix
+++ a/mm/page_alloc.c
@@ -6681,6 +6681,8 @@ void dump_page(struct page *page, const
 }
 EXPORT_SYMBOL(dump_page);
 
+#ifdef CONFIG_DEBUG_VM
+
 static const struct trace_print_flags vmaflags_names[] = {
 	{VM_READ,			"read"		},
 	{VM_WRITE,			"write"		},
@@ -6738,3 +6740,5 @@ void dump_vma(const struct vm_area_struc
 	dump_flags(vma->vm_flags, vmaflags_names, ARRAY_SIZE(vmaflags_names));
 }
 EXPORT_SYMBOL(dump_vma);
+
+#endif		/* CONFIG_DEBUG_VM */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch
mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
memory-hotplug-add-sysfs-zones_online_to-attribute.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
include-linux-migrateh-remove-migratepage-define.patch
introduce-dump_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch
mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix.patch
mm-debugc-use-pr_emerg.patch
mm-ksm-use-pr_err-instead-of-printk-fix.patch
mm-introduce-a-general-rcu-get_user_pages_fast-fix.patch
arm64-mm-enable-rcu-fast_gup-checkpatch-fixes.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
acct-eliminate-compile-warning-fix.patch

