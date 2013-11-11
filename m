From: akpm@linux-foundation.org
Subject: + list-introduce-list_next_entry-and-list_prev_entry.patch added
 to -mm tree
Date: Mon, 11 Nov 2013 15:18:52 -0800
Message-ID: <528165dc.77KKtgWWp3/mZuN1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3KKXSx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Nov 2013 18:18:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gregkh@linuxfoundation.org, eilong@broadcom.com, a.p.zijlstra@chello.nl, oleg@redhat.com

Subject: + list-introduce-list_next_entry-and-list_prev_entry.patch added to -mm tree
To: oleg@redhat.com,a.p.zijlstra@chello.nl,eilong@broadcom.com,gregkh@linuxfoundation.org
From: akpm@linux-foundation.org
Date: Mon, 11 Nov 2013 15:18:52 -0800


The patch titled
     Subject: list: introduce list_next_entry() and list_prev_entry()
has been added to the -mm tree.  Its filename is
     list-introduce-list_next_entry-and-list_prev_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/list-introduce-list_next_entry-and-list_prev_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/list-introduce-list_next_entry-and-list_prev_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: list: introduce list_next_entry() and list_prev_entry()

Add 2 trivial helpers list_next_entry() and list_prev_entry(), they can
have a lot of users including list.h itself.  In fact the 1st one is
already defined in events/core.c and bnx2x_sp.c, so the patch simply moves
the definition to list.h.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eilon Greenstein <eilong@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c |    3 --
 include/linux/list.h                           |   16 +++++++++++++++
 kernel/events/core.c                           |    3 --
 3 files changed, 16 insertions(+), 6 deletions(-)

diff -puN drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c~list-introduce-list_next_entry-and-list_prev_entry drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c~list-introduce-list_next_entry-and-list_prev_entry
+++ a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
@@ -1217,9 +1217,6 @@ static void bnx2x_set_one_vlan_mac_e1h(s
 				     ETH_VLAN_FILTER_CLASSIFY, config);
 }
 
-#define list_next_entry(pos, member) \
-	list_entry((pos)->member.next, typeof(*(pos)), member)
-
 /**
  * bnx2x_vlan_mac_restore - reconfigure next MAC/VLAN/VLAN-MAC element
  *
diff -puN include/linux/list.h~list-introduce-list_next_entry-and-list_prev_entry include/linux/list.h
--- a/include/linux/list.h~list-introduce-list_next_entry-and-list_prev_entry
+++ a/include/linux/list.h
@@ -373,6 +373,22 @@ static inline void list_splice_tail_init
 	(!list_empty(ptr) ? list_first_entry(ptr, type, member) : NULL)
 
 /**
+ * list_next_entry - get the next element in list
+ * @pos:	the type * to cursor
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_next_entry(pos, member) \
+	list_entry((pos)->member.next, typeof(*(pos)), member)
+
+/**
+ * list_prev_entry - get the prev element in list
+ * @pos:	the type * to cursor
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_prev_entry(pos, member) \
+	list_entry((pos)->member.prev, typeof(*(pos)), member)
+
+/**
  * list_for_each	-	iterate over a list
  * @pos:	the &struct list_head to use as a loop cursor.
  * @head:	the head for your list.
diff -puN kernel/events/core.c~list-introduce-list_next_entry-and-list_prev_entry kernel/events/core.c
--- a/kernel/events/core.c~list-introduce-list_next_entry-and-list_prev_entry
+++ a/kernel/events/core.c
@@ -2210,9 +2210,6 @@ static void __perf_event_sync_stat(struc
 	perf_event_update_userpage(next_event);
 }
 
-#define list_next_entry(pos, member) \
-	list_entry(pos->member.next, typeof(*pos), member)
-
 static void perf_event_sync_stat(struct perf_event_context *ctx,
 				   struct perf_event_context *next_ctx)
 {
_

Patches currently in -mm which might be from oleg@redhat.com are

kthread-make-kthread_create-killable.patch
list-introduce-list_next_entry-and-list_prev_entry.patch
list-change-list_for_each_entry-to-use-list__entry.patch
list-introduce-list_last_entry-use-list_firstlast_entry.patch
debugfs-use-list_next_entry-in-debugfs_remove_recursive.patch
exec-ptrace-fix-get_dumpable-incorrect-tests.patch
linux-next.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch

