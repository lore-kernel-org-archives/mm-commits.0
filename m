From: akpm@linux-foundation.org
Subject: [merged] mmu_notifier-add-mmu_notifier_invalidate_range.patch
 removed from -mm tree
Date: Fri, 21 Nov 2014 12:33:18 -0800
Message-ID: <546fa18e.XmS9y0nuzHVPU+p/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaKUUdU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Nov 2014 15:33:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jroedel@suse.de, Jay.Cornwall@amd.com, Oded.Gabbay@amd.com, Suravee.Suthikulpanit@amd.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, dwmw2@infradead.org, hughd@google.com, jbarnes@virtuousgeek.org, jglisse@redhat.com, jweiner@redhat.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmu_notifier: add mmu_notifier_invalidate_range()
has been removed from the -mm tree.  Its filename was
     mmu_notifier-add-mmu_notifier_invalidate_range.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Joerg Roedel <jroedel@suse.de>
Subject: mmu_notifier: add mmu_notifier_invalidate_range()

This notifier closes an important gap in the current mmu_notifier
implementation, the existing callbacks are called too early or too late=
 to
reliably manage a non-CPU TLB.  Specifically, invalidate_range_start() =
is
called when all pages are still mapped and invalidate_range_end() when =
all
pages are unmapped and potentially freed.

This is fine when the users of the mmu_notifiers manage their own SoftT=
LB,
like KVM does.  When the TLB is managed in software it is easy to wipe =
out
entries for a given range and prevent new entries to be established unt=
il
invalidate_range_end is called.

But when the user of mmu_notifiers has to manage a hardware TLB it can
still wipe out TLB entries in invalidate_range_start, but it can't make
sure that no new TLB entries in the given range are established between
invalidate_range_start and invalidate_range_end.

To avoid silent data corruption the entries in the non-CPU TLB need to =
be
flushed when the pages are unmapped (at this point in time no _new_ TLB
entries can be established in the non-CPU TLB) but not yet freed (as th=
e
non-CPU TLB may still have _existing_ entries pointing to the pages abo=
ut
to be freed).

To fix this problem we need to catch the moment when the Linux VMM flus=
hes
remote TLBs (as a non-CPU TLB is not very CPU TLB), as this is the poin=
t
in time when the pages are unmapped but _not_ yet freed.

The mmu_notifier_invalidate_range() function aims to catch that moment.

IOMMU code will be one user of the notifier-callback.  Currently this i=
s
only the AMD IOMMUv2 driver, but its code is about to be more generaliz=
ed
and converted to a generic IOMMU-API extension to fit the needs of simi=
lar
functionality in other IOMMUs as well.

The current attempt in the AMD IOMMUv2 driver to work around the
invalidate_range_start/end() shortcoming is to assign an empty page tab=
le
to the non-CPU TLB between any invalidata_range_start/end calls.  With =
the
empty page-table assigned, every page-table walk to re-fill the non-CPU
TLB will cause a page-fault reported to the IOMMU driver via an interru=
pt,
possibly causing interrupt storms.

The page-fault handler in the AMD IOMMUv2 driver doesn't handle the fau=
lt
if an invalidate_range_start/end pair is active, it just reports back
SUCCESS to the device and let it refault the page.  But existing hardwa=
re
(newer Radeon GPUs) that makes use of this feature don't re-fault
indefinitly, after a certain number of faults for the same address the
device enters a failure state and needs to be resetted.

To avoid the GPUs entering a failure state we need to get rid of the
empty-page-table workaround and use the mmu_notifier_invalidate_range()
function introduced with this patch.

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

 include/linux/mmu_notifier.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN include/linux/mmu_notifier.h~mmu_notifier-add-mmu_notifier_in=
validate_range include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mmu_notifier-add-mmu_notifier_invali=
date_range
+++ a/include/linux/mmu_notifier.h
@@ -242,6 +242,11 @@ static inline void mmu_notifier_invalida
 		__mmu_notifier_invalidate_range_end(mm, start, end);
 }
=20
+static inline void mmu_notifier_invalidate_range(struct mm_struct *mm,
+				  unsigned long start, unsigned long end)
+{
+}
+
 static inline void mmu_notifier_mm_init(struct mm_struct *mm)
 {
 	mm->mmu_notifier_mm =3D NULL;
@@ -341,6 +346,11 @@ static inline void mmu_notifier_invalida
 				  unsigned long start, unsigned long end)
 {
 }
+
+static inline void mmu_notifier_invalidate_range(struct mm_struct *mm,
+				  unsigned long start, unsigned long end)
+{
+}
=20
 static inline void mmu_notifier_mm_init(struct mm_struct *mm)
 {
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
