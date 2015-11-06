From: akpm@linux-foundation.org
Subject: [merged]
 rcu-force-alignment-on-struct-callback_head-rcu_head.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:05:59 -0800
Message-ID: <563d0827.Ys1uwOriOpV3ujfY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033600AbbKFUGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, jesper.nilsson@axis.com, linux@roeck-us.net, paulmck@linux.vnet.ibm.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rcu: force alignment on struct callback_head/rcu_head
has been removed from the -mm tree.  Its filename was
     rcu-force-alignment-on-struct-callback_head-rcu_head.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: rcu: force alignment on struct callback_head/rcu_head

Make struct callback_head aligned to size of pointer.  On most
architectures it happens naturally due ABI requirements, but some
architectures (like CRIS) have weird ABI and we need to ask it explicitly.

The alignment is required to guarantee that bits 0 and 1 of @next will be
clear under normal conditions -- as long as we use call_rcu(),
call_rcu_bh(), call_rcu_sched(), or call_srcu() to queue callback.

This guarantee is important for few reasons:
 - future call_rcu_lazy() will make use of lower bits in the pointer;
 - the structure shares storage spacer in struct page with @compound_head,
   which encode PageTail() in bit 0. The guarantee is needed to avoid
   false-positive PageTail().

False postive PageTail() caused crash on crisv32[1].  It happend due
misaligned task_struct->rcu, which was byte-aligned.

[1] http://lkml.kernel.org/r/55FAEA67.9000102@roeck-us.net

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/types.h |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN include/linux/types.h~rcu-force-alignment-on-struct-callback_head-rcu_head include/linux/types.h
--- a/include/linux/types.h~rcu-force-alignment-on-struct-callback_head-rcu_head
+++ a/include/linux/types.h
@@ -205,11 +205,25 @@ struct ustat {
  * struct callback_head - callback structure for use with RCU and task_work
  * @next: next update requests in a list
  * @func: actual update function to call after the grace period.
+ *
+ * The struct is aligned to size of pointer. On most architectures it happens
+ * naturally due ABI requirements, but some architectures (like CRIS) have
+ * weird ABI and we need to ask it explicitly.
+ *
+ * The alignment is required to guarantee that bits 0 and 1 of @next will be
+ * clear under normal conditions -- as long as we use call_rcu(),
+ * call_rcu_bh(), call_rcu_sched(), or call_srcu() to queue callback.
+ *
+ * This guarantee is important for few reasons:
+ *  - future call_rcu_lazy() will make use of lower bits in the pointer;
+ *  - the structure shares storage spacer in struct page with @compound_head,
+ *    which encode PageTail() in bit 0. The guarantee is needed to avoid
+ *    false-positive PageTail().
  */
 struct callback_head {
 	struct callback_head *next;
 	void (*func)(struct callback_head *head);
-};
+} __attribute__((aligned(sizeof(void *))));
 #define rcu_head callback_head
 
 typedef void (*rcu_callback_t)(struct rcu_head *head);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-make-compound_head-robust-fix.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-proc-adjust-pss-calculation.patch
rmap-add-argument-to-charge-compound-page.patch
memcg-adjust-to-support-new-thp-refcounting.patch
mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault.patch
mm-adjust-foll_split-for-new-refcounting.patch
mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton.patch
thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch
khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes.patch
thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-vmstats-new-thp-splitting-event.patch
mm-temporally-mark-thp-broken.patch
thp-drop-all-split_huge_page-related-code.patch
mm-drop-tail-page-refcounting.patch
futex-thp-remove-special-case-for-thp-in-get_futex_key.patch
ksm-prepare-to-new-thp-semantics.patch
mm-thp-remove-compound_lock.patch
arm64-thp-remove-infrastructure-for-handling-splitting-pmds.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch
powerpc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch
sparc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
tile-thp-remove-infrastructure-for-handling-splitting-pmds.patch
x86-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-2.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-3.patch
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
thp-reintroduce-split_huge_page-fix-3.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch

