From: akpm@linux-foundation.org
Subject: + kvm-plumb-return-of-hva-when-resolving-page-fault.patch added
 to -mm tree
Date: Tue, 05 Apr 2016 16:16:09 -0700
Message-ID: <57044739.x4MpFH4aCqw/2RT0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbcDEXQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 19:16:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreslc@google.com, aarcange@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kvm: plumb return of hva when resolving page fault.
has been added to the -mm tree.  Its filename is
     kvm-plumb-return-of-hva-when-resolving-page-fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kvm-plumb-return-of-hva-when-resolving-page-fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kvm-plumb-return-of-hva-when-resolving-page-fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andres Lagar-Cavilla <andreslc@google.com>
Subject: kvm: plumb return of hva when resolving page fault.

So we don't have to redo this work later.  Note the hva is not racy, it is
simple arithmetic based on the memslot.

This will be used in the huge tmpfs commits.

Signed-off-by: Andres Lagar-Cavilla <andreslc@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/mmu.c         |   20 ++++++++++++++------
 arch/x86/kvm/paging_tmpl.h |    3 ++-
 include/linux/kvm_host.h   |    2 +-
 virt/kvm/kvm_main.c        |   14 ++++++++------
 4 files changed, 25 insertions(+), 14 deletions(-)

diff -puN arch/x86/kvm/mmu.c~kvm-plumb-return-of-hva-when-resolving-page-fault arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~kvm-plumb-return-of-hva-when-resolving-page-fault
+++ a/arch/x86/kvm/mmu.c
@@ -2992,7 +2992,8 @@ exit:
 }
 
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
-			 gva_t gva, kvm_pfn_t *pfn, bool write, bool *writable);
+			 gva_t gva, kvm_pfn_t *pfn, bool write, bool *writable,
+			 unsigned long *hva);
 static void make_mmu_pages_available(struct kvm_vcpu *vcpu);
 
 static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
@@ -3003,6 +3004,7 @@ static int nonpaging_map(struct kvm_vcpu
 	bool force_pt_level = false;
 	kvm_pfn_t pfn;
 	unsigned long mmu_seq;
+	unsigned long hva;
 	bool map_writable, write = error_code & PFERR_WRITE_MASK;
 
 	level = mapping_level(vcpu, gfn, &force_pt_level);
@@ -3024,7 +3026,8 @@ static int nonpaging_map(struct kvm_vcpu
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, gfn, v, &pfn, write, &map_writable))
+	if (try_async_pf(vcpu, prefault, gfn, v, &pfn, write,
+			 &map_writable, &hva))
 		return 0;
 
 	if (handle_abnormal_pfn(vcpu, v, gfn, pfn, ACC_ALL, &r))
@@ -3487,14 +3490,16 @@ static bool can_do_async_pf(struct kvm_v
 }
 
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
-			 gva_t gva, kvm_pfn_t *pfn, bool write, bool *writable)
+			 gva_t gva, kvm_pfn_t *pfn, bool write, bool *writable,
+			 unsigned long *hva)
 {
 	struct kvm_memory_slot *slot;
 	bool async;
 
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	async = false;
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async, write, writable);
+	*pfn = __gfn_to_pfn_memslot(slot, gfn,
+				    false, &async, write, writable, hva);
 	if (!async)
 		return false; /* *pfn has correct page already */
 
@@ -3508,7 +3513,8 @@ static bool try_async_pf(struct kvm_vcpu
 			return true;
 	}
 
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL, write, writable);
+	*pfn = __gfn_to_pfn_memslot(slot, gfn,
+				    false, NULL, write, writable, hva);
 	return false;
 }
 
@@ -3531,6 +3537,7 @@ static int tdp_page_fault(struct kvm_vcp
 	bool force_pt_level;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	unsigned long mmu_seq;
+	unsigned long hva;
 	int write = error_code & PFERR_WRITE_MASK;
 	bool map_writable;
 
@@ -3559,7 +3566,8 @@ static int tdp_page_fault(struct kvm_vcp
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
+	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write,
+			 &map_writable, &hva))
 		return 0;
 
 	if (handle_abnormal_pfn(vcpu, 0, gfn, pfn, ACC_ALL, &r))
diff -puN arch/x86/kvm/paging_tmpl.h~kvm-plumb-return-of-hva-when-resolving-page-fault arch/x86/kvm/paging_tmpl.h
--- a/arch/x86/kvm/paging_tmpl.h~kvm-plumb-return-of-hva-when-resolving-page-fault
+++ a/arch/x86/kvm/paging_tmpl.h
@@ -712,6 +712,7 @@ static int FNAME(page_fault)(struct kvm_
 	int level = PT_PAGE_TABLE_LEVEL;
 	bool force_pt_level = false;
 	unsigned long mmu_seq;
+	unsigned long hva;
 	bool map_writable, is_self_change_mapping;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
@@ -765,7 +766,7 @@ static int FNAME(page_fault)(struct kvm_
 	smp_rmb();
 
 	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, write_fault,
-			 &map_writable))
+			 &map_writable, &hva))
 		return 0;
 
 	if (handle_abnormal_pfn(vcpu, mmu_is_nested(vcpu) ? 0 : addr,
diff -puN include/linux/kvm_host.h~kvm-plumb-return-of-hva-when-resolving-page-fault include/linux/kvm_host.h
--- a/include/linux/kvm_host.h~kvm-plumb-return-of-hva-when-resolving-page-fault
+++ a/include/linux/kvm_host.h
@@ -600,7 +600,7 @@ kvm_pfn_t gfn_to_pfn_memslot(struct kvm_
 kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
-			       bool *writable);
+			       bool *writable, unsigned long *hva);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_set_pfn_dirty(kvm_pfn_t pfn);
diff -puN virt/kvm/kvm_main.c~kvm-plumb-return-of-hva-when-resolving-page-fault virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~kvm-plumb-return-of-hva-when-resolving-page-fault
+++ a/virt/kvm/kvm_main.c
@@ -1444,7 +1444,7 @@ exit:
 
 kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
-			       bool *writable)
+			       bool *writable, unsigned long *hva)
 {
 	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
 
@@ -1466,8 +1466,10 @@ kvm_pfn_t __gfn_to_pfn_memslot(struct kv
 		writable = NULL;
 	}
 
-	return hva_to_pfn(addr, atomic, async, write_fault,
-			  writable);
+	if (hva)
+		*hva = addr;
+
+	return hva_to_pfn(addr, atomic, async, write_fault, writable);
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
 
@@ -1475,19 +1477,19 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kv
 		      bool *writable)
 {
 	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, NULL,
-				    write_fault, writable);
+				    write_fault, writable, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
 kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
_

Patches currently in -mm which might be from andreslc@google.com are

tmpfs-mem_cgroup-charge-fault-to-vm_mm-not-current-mm.patch
kvm-plumb-return-of-hva-when-resolving-page-fault.patch
kvm-teach-kvm-to-map-page-teams-as-huge-pages.patch
huge-tmpfs-mem_cgroup-shmem_pmdmapped-accounting.patch
huge-tmpfs-mem_cgroup-shmem_hugepages-accounting.patch
huge-tmpfs-show-page-team-flag-in-pageflags.patch
huge-tmpfs-no-kswapd-by-default-on-sync-allocations.patch

