From: akpm@linux-foundation.org
Subject: [merged]
 mmu_notifier-add-the-call-back-for-mmu_notifier_invalidate_range.patch
 removed from -mm tree
Date: Fri, 21 Nov 2014 12:33:24 -0800
Message-ID: <546fa194.Eb+bHPNYOqmMxV3p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaKUUdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Nov 2014 15:33:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jroedel@suse.de, Jay.Cornwall@amd.com, Oded.Gabbay@amd.com, Suravee.Suthikulpanit@amd.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, dwmw2@infradead.org, hughd@google.com, jbarnes@virtuousgeek.org, jglisse@redhat.com, jweiner@redhat.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmu_notifier: add the callback for mmu_notifier_invalidat=
e_range()
has been removed from the -mm tree.  Its filename was
     mmu_notifier-add-the-call-back-for-mmu_notifier_invalidate_range.p=
atch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Joerg Roedel <jroedel@suse.de>
Subject: mmu_notifier: add the callback for mmu_notifier_invalidate_ran=
ge()

Now that the mmu_notifier_invalidate_range() calls are in place, add th=
e
callback to allow subsystems to register against it.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: J=E9r=F4me Glisse <jglisse@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Jay Cornwall <Jay.Cornwall@amd.com>
Cc: Oded Gabbay <Oded.Gabbay@amd.com>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   37 ++++++++++++++++++++++++++++-----
 mm/mmu_notifier.c            |   25 ++++++++++++++++++++++
 2 files changed, 57 insertions(+), 5 deletions(-)

diff -puN include/linux/mmu_notifier.h~mmu_notifier-add-the-call-back-f=
or-mmu_notifier_invalidate_range include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mmu_notifier-add-the-call-back-for-m=
mu_notifier_invalidate_range
+++ a/include/linux/mmu_notifier.h
@@ -98,11 +98,11 @@ struct mmu_notifier_ops {
 	/*
 	 * invalidate_range_start() and invalidate_range_end() must be
 	 * paired and are called only when the mmap_sem and/or the
-	 * locks protecting the reverse maps are held. The subsystem
-	 * must guarantee that no additional references are taken to
-	 * the pages in the range established between the call to
-	 * invalidate_range_start() and the matching call to
-	 * invalidate_range_end().
+	 * locks protecting the reverse maps are held. If the subsystem
+	 * can't guarantee that no additional references are taken to
+	 * the pages in the range, it has to implement the
+	 * invalidate_range() notifier to remove any references taken
+	 * after invalidate_range_start().
 	 *
 	 * Invalidation of multiple concurrent ranges may be
 	 * optionally permitted by the driver. Either way the
@@ -144,6 +144,29 @@ struct mmu_notifier_ops {
 	void (*invalidate_range_end)(struct mmu_notifier *mn,
 				     struct mm_struct *mm,
 				     unsigned long start, unsigned long end);
+
+	/*
+	 * invalidate_range() is either called between
+	 * invalidate_range_start() and invalidate_range_end() when the
+	 * VM has to free pages that where unmapped, but before the
+	 * pages are actually freed, or outside of _start()/_end() when
+	 * a (remote) TLB is necessary.
+	 *
+	 * If invalidate_range() is used to manage a non-CPU TLB with
+	 * shared page-tables, it not necessary to implement the
+	 * invalidate_range_start()/end() notifiers, as
+	 * invalidate_range() alread catches the points in time when an
+	 * external TLB range needs to be flushed.
+	 *
+	 * The invalidate_range() function is called under the ptl
+	 * spin-lock and not allowed to sleep.
+	 *
+	 * Note that this function might be called with just a sub-range
+	 * of what was passed to invalidate_range_start()/end(), if
+	 * called between those functions.
+	 */
+	void (*invalidate_range)(struct mmu_notifier *mn, struct mm_struct *m=
m,
+				 unsigned long start, unsigned long end);
 };
=20
 /*
@@ -190,6 +213,8 @@ extern void __mmu_notifier_invalidate_ra
 				  unsigned long start, unsigned long end);
 extern void __mmu_notifier_invalidate_range_end(struct mm_struct *mm,
 				  unsigned long start, unsigned long end);
+extern void __mmu_notifier_invalidate_range(struct mm_struct *mm,
+				  unsigned long start, unsigned long end);
=20
 static inline void mmu_notifier_release(struct mm_struct *mm)
 {
@@ -245,6 +270,8 @@ static inline void mmu_notifier_invalida
 static inline void mmu_notifier_invalidate_range(struct mm_struct *mm,
 				  unsigned long start, unsigned long end)
 {
+	if (mm_has_notifiers(mm))
+		__mmu_notifier_invalidate_range(mm, start, end);
 }
=20
 static inline void mmu_notifier_mm_init(struct mm_struct *mm)
diff -puN mm/mmu_notifier.c~mmu_notifier-add-the-call-back-for-mmu_noti=
fier_invalidate_range mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mmu_notifier-add-the-call-back-for-mmu_notifier=
_invalidate_range
+++ a/mm/mmu_notifier.c
@@ -193,6 +193,16 @@ void __mmu_notifier_invalidate_range_end
=20
 	id =3D srcu_read_lock(&srcu);
 	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
+		/*
+		 * Call invalidate_range here too to avoid the need for the
+		 * subsystem of having to register an invalidate_range_end
+		 * call-back when there is invalidate_range already. Usually a
+		 * subsystem registers either invalidate_range_start()/end() or
+		 * invalidate_range(), so this will be no additional overhead
+		 * (besides the pointer check).
+		 */
+		if (mn->ops->invalidate_range)
+			mn->ops->invalidate_range(mn, mm, start, end);
 		if (mn->ops->invalidate_range_end)
 			mn->ops->invalidate_range_end(mn, mm, start, end);
 	}
@@ -200,6 +210,21 @@ void __mmu_notifier_invalidate_range_end
 }
 EXPORT_SYMBOL_GPL(__mmu_notifier_invalidate_range_end);
=20
+void __mmu_notifier_invalidate_range(struct mm_struct *mm,
+				  unsigned long start, unsigned long end)
+{
+	struct mmu_notifier *mn;
+	int id;
+
+	id =3D srcu_read_lock(&srcu);
+	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
+		if (mn->ops->invalidate_range)
+			mn->ops->invalidate_range(mn, mm, start, end);
+	}
+	srcu_read_unlock(&srcu, id);
+}
+EXPORT_SYMBOL_GPL(__mmu_notifier_invalidate_range);
+
 static int do_mmu_notifier_register(struct mmu_notifier *mn,
 				    struct mm_struct *mm,
 				    int take_mmap_sem)
_

Patches currently in -mm which might be from jroedel@suse.de are

mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use.patch
iommu-amd-use-handle_mm_fault-directly-v2.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
