From: akpm@linux-foundation.org
Subject: [merged]
 kvm-mm-account-kvm-related-kmem-slabs-to-kmemcg.patch removed from -mm tree
Date: Tue, 17 Oct 2017 14:41:09 -0700
Message-ID: <20171017214109.iOmNokmD6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50378 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934796AbdJQVlL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 17:41:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, christoffer.dall@linaro.org, dgibson@redhat.com, gthelen@google.com, hpa@zytor.com, james.hogan@imgtec.com, khandual@linux.vnet.ibm.com, mhocko@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@ozlabs.org, pbonzini@redhat.com, rkrcmar@redhat.com, shakeelb@google.com, tglx@linutronix.de, vdavydov.dev@gmail.com


The patch titled
     Subject: kvm, mm: account kvm related kmem slabs to kmemcg
has been removed from the -mm tree.  Its filename was
     kvm-mm-account-kvm-related-kmem-slabs-to-kmemcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: kvm, mm: account kvm related kmem slabs to kmemcg

The kvm slabs can consume a significant amount of system memory and indeed
in our production environment we have observed that a lot of machines are
spending significant amount of memory that can not be left as system
memory overhead.  Also the allocations from these slabs can be triggered
directly by user space applications which has access to kvm and thus a
buggy application can leak such memory.  So, these caches should be
accounted to kmemcg.

Link: http://lkml.kernel.org/r/20171006010724.186563-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: David Gibson <dgibson@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/mmu.c  |    4 ++--
 virt/kvm/kvm_main.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/kvm/mmu.c~kvm-mm-account-kvm-related-kmem-slabs-to-kmemcg arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~kvm-mm-account-kvm-related-kmem-slabs-to-kmemcg
+++ a/arch/x86/kvm/mmu.c
@@ -5476,13 +5476,13 @@ int kvm_mmu_module_init(void)
 
 	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
 					    sizeof(struct pte_list_desc),
-					    0, 0, NULL);
+					    0, SLAB_ACCOUNT, NULL);
 	if (!pte_list_desc_cache)
 		goto nomem;
 
 	mmu_page_header_cache = kmem_cache_create("kvm_mmu_page_header",
 						  sizeof(struct kvm_mmu_page),
-						  0, 0, NULL);
+						  0, SLAB_ACCOUNT, NULL);
 	if (!mmu_page_header_cache)
 		goto nomem;
 
diff -puN virt/kvm/kvm_main.c~kvm-mm-account-kvm-related-kmem-slabs-to-kmemcg virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~kvm-mm-account-kvm-related-kmem-slabs-to-kmemcg
+++ a/virt/kvm/kvm_main.c
@@ -4010,7 +4010,7 @@ int kvm_init(void *opaque, unsigned vcpu
 	if (!vcpu_align)
 		vcpu_align = __alignof__(struct kvm_vcpu);
 	kvm_vcpu_cache = kmem_cache_create("kvm_vcpu", vcpu_size, vcpu_align,
-					   0, NULL);
+					   SLAB_ACCOUNT, NULL);
 	if (!kvm_vcpu_cache) {
 		r = -ENOMEM;
 		goto out_free_3;
_

Patches currently in -mm which might be from shakeelb@google.com are

fs-mm-account-filp-cache-to-kmemcg.patch
epoll-account-epitem-and-eppoll_entry-to-kmemcg.patch

