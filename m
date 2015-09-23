From: akpm@linux-foundation.org
Subject: + rcu-force-alignment-on-struct-callback_head-rcu_head.patch
 added to -mm tree
Date: Wed, 23 Sep 2015 13:07:00 -0700
Message-ID: <56030664.LKPm6SflpepXJI71%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbbIWUHB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Sep 2015 16:07:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, jesper.nilsson@axis.com, linux@roeck-us.net, paulmck@linux.vnet.ibm.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rcu: force alignment on struct callback_head/rcu_head
has been added to the -mm tree.  Its filename is
     rcu-force-alignment-on-struct-callback_head-rcu_head.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rcu-force-alignment-on-struct-callback_head-rcu_head.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rcu-force-alignment-on-struct-callback_head-rcu_head.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
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

mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified.patch
rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch

