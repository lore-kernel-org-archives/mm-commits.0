Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AC02BE034
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917758; cv=none; b=nWcn1QsIhzlLO+wZ2wzYjwgCm49IBkTMEmelynVLOM6HZPMNeK+EZvPWU6/4TiqFiUIrlAEn15aeqOxI1Ip1irZWJBsYD0rUNXNVECXzBtgyNsL0UTeyV2ptnsdWGfrlndSOsicN+aedOa0BTAgguirJr0Mx3zHenXSfnGC4cn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917758; c=relaxed/simple;
	bh=xpbMIFLXF7S8e4o231l6P0q9GVQmajCzw4oEh9fJ7nI=;
	h=Date:To:From:Subject:Message-Id; b=KsLujlcCrX3YA1w0FSTP7WAYESZXrcA3eIsUguSpiDv7bQHrtvaP8o6hO9+JZK5ypwyoyJoMd+LUHr5JyeTk2UOV1wvPPZrN3oy6I8pzCUvOiRNgffrsMBTtZ7zP8GaBuwvi3NoDfZ1S3AOX3IrQKtSPPNc0NZZtwWfvoAqKZtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gz6RcY1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gz6RcY1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E293C4CEF7;
	Tue, 31 Mar 2026 00:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917758;
	bh=xpbMIFLXF7S8e4o231l6P0q9GVQmajCzw4oEh9fJ7nI=;
	h=Date:To:From:Subject:From;
	b=gz6RcY1bgBbB/z+3VFD2lfLkxu3EN9TUzf2Fnl1kDA8fOEpXTrQ9RNLuzOFqEjjYt
	 5uls5un9sWcoBk+BNRWeSQoAZtzH7o90siC8qcl5aDro0xFgs3K2XDvj3DKmE1oNdb
	 +s7DQ5Zuyn1Y6S55WuETMkNnStIZAjvEV8ozFmrU=
Date: Mon, 30 Mar 2026 17:42:37 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,will@kernel.org,viro@zeniv.linux.org.uk,vgupta@kernel.org,vbabka@kernel.org,tsbogend@alpha.franken.de,svens@linux.ibm.com,surenb@google.com,stephen.smalley.work@gmail.com,rppt@kernel.org,richard@nod.at,pfalcato@suse.de,paul@paul-moore.com,palmer@dabbelt.com,omosnace@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,linux@armlinux.org.uk,liam.howlett@oracle.com,kernel@xen0n.name,kees@kernel.org,johannes@sipsolutions.net,jannh@google.com,jack@suse.cz,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,dinguyen@kernel.org,david@kernel.org,chenhuacai@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,anton.ivanov@cambridgegreys.com,alex@ghiti.fr,agordeev@linux.ibm.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-vma_flags_count-and-vma_test_single_mask.patch removed from -mm tree
Message-Id: <20260331004238.0E293C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce vma_flags_count() and vma[_flags]_test_single_mask()
has been removed from the -mm tree.  Its filename was
     mm-introduce-vma_flags_count-and-vma_test_single_mask.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm: introduce vma_flags_count() and vma[_flags]_test_single_mask()
Date: Fri, 20 Mar 2026 19:38:32 +0000

vma_flags_count() determines how many bits are set in VMA flags, using
bitmap_weight().

vma_flags_test_single_mask() determines if a vma_flags_t set of flags
contains a single flag specified as another vma_flags_t value, or if the
sought flag mask is empty, it is defined to return false.

This is useful when we want to declare a VMA flag as optionally a single
flag in a mask or empty depending on kernel configuration.

This allows us to have VM_NONE-like semantics when checking whether the
flag is set.

In a subsequent patch, we introduce the use of VMA_DROPPABLE of type
vma_flags_t using precisely these semantics.

It would be actively confusing to use vma_flags_test_any_single_mask() for
this (and vma_flags_test_all_mask() is not correct to use here, as it
trivially returns true when tested against an empty vma flags mask).

We introduce vma_flags_count() to be able to assert that the compared flag
mask is singular or empty, checked when CONFIG_DEBUG_VM is enabled.

Also update the VMA tests as part of this change.

Link: https://lkml.kernel.org/r/cd778dd02b9f2a01eb54d25a49dea8ec2ddf7753.1774034900.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h                 |   46 +++++++++++++++++++++++++++
 tools/testing/vma/include/custom.h |    6 ---
 tools/testing/vma/include/dup.h    |   21 ++++++++++++
 tools/testing/vma/vma_internal.h   |    6 +++
 4 files changed, 73 insertions(+), 6 deletions(-)

--- a/include/linux/mm.h~mm-introduce-vma_flags_count-and-vma_test_single_mask
+++ a/include/linux/mm.h
@@ -1078,6 +1078,14 @@ static __always_inline vma_flags_t __mk_
 #define append_vma_flags(flags, ...) __mk_vma_flags(flags,			\
 		COUNT_ARGS(__VA_ARGS__), (const vma_flag_t []){__VA_ARGS__})
 
+/* Calculates the number of set bits in the specified VMA flags. */
+static __always_inline int vma_flags_count(const vma_flags_t *flags)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+
+	return bitmap_weight(bitmap, NUM_VMA_FLAG_BITS);
+}
+
 /*
  * Test whether a specific VMA flag is set, e.g.:
  *
@@ -1153,6 +1161,26 @@ static __always_inline bool vma_flags_te
 #define vma_flags_test_all(flags, ...) \
 	vma_flags_test_all_mask(flags, mk_vma_flags(__VA_ARGS__))
 
+/*
+ * Helper to test that a flag mask of type vma_flags_t has a SINGLE flag set
+ * (returning false if flagmask has no flags set).
+ *
+ * This is defined to make the semantics clearer when testing an optionally
+ * defined VMA flags mask, e.g.:
+ *
+ * if (vma_flags_test_single_mask(&flags, VMA_DROPPABLE)) { ... }
+ *
+ * When VMA_DROPPABLE is defined if available, or set to EMPTY_VMA_FLAGS
+ * otherwise.
+ */
+static __always_inline bool vma_flags_test_single_mask(const vma_flags_t *flags,
+		vma_flags_t flagmask)
+{
+	VM_WARN_ON_ONCE(vma_flags_count(&flagmask) > 1);
+
+	return vma_flags_test_any_mask(flags, flagmask);
+}
+
 /* Set each of the to_set flags in flags, non-atomically. */
 static __always_inline void vma_flags_set_mask(vma_flags_t *flags,
 		vma_flags_t to_set)
@@ -1282,6 +1310,24 @@ static __always_inline bool vma_test_all
 	vma_test_all_mask(vma, mk_vma_flags(__VA_ARGS__))
 
 /*
+ * Helper to test that a flag mask of type vma_flags_t has a SINGLE flag set
+ * (returning false if flagmask has no flags set).
+ *
+ * This is useful when a flag needs to be either defined or not depending upon
+ * kernel configuration, e.g.:
+ *
+ * if (vma_test_single_mask(vma, VMA_DROPPABLE)) { ... }
+ *
+ * When VMA_DROPPABLE is defined if available, or set to EMPTY_VMA_FLAGS
+ * otherwise.
+ */
+static __always_inline bool
+vma_test_single_mask(const struct vm_area_struct *vma, vma_flags_t flagmask)
+{
+	return vma_flags_test_single_mask(&vma->flags, flagmask);
+}
+
+/*
  * Helper to set all VMA flags in a VMA.
  *
  * Note: appropriate locks must be held, this function does not acquire them for
--- a/tools/testing/vma/include/custom.h~mm-introduce-vma_flags_count-and-vma_test_single_mask
+++ a/tools/testing/vma/include/custom.h
@@ -15,12 +15,6 @@ extern unsigned long dac_mmap_min_addr;
 #define dac_mmap_min_addr	0UL
 #endif
 
-#define VM_WARN_ON(_expr) (WARN_ON(_expr))
-#define VM_WARN_ON_ONCE(_expr) (WARN_ON_ONCE(_expr))
-#define VM_WARN_ON_VMG(_expr, _vmg) (WARN_ON(_expr))
-#define VM_BUG_ON(_expr) (BUG_ON(_expr))
-#define VM_BUG_ON_VMA(_expr, _vma) (BUG_ON(_expr))
-
 #define TASK_SIZE ((1ul << 47)-PAGE_SIZE)
 
 /*
--- a/tools/testing/vma/include/dup.h~mm-introduce-vma_flags_count-and-vma_test_single_mask
+++ a/tools/testing/vma/include/dup.h
@@ -905,6 +905,13 @@ static __always_inline vma_flags_t __mk_
 #define append_vma_flags(flags, ...) __mk_vma_flags(flags,			\
 		COUNT_ARGS(__VA_ARGS__), (const vma_flag_t []){__VA_ARGS__})
 
+static __always_inline int vma_flags_count(const vma_flags_t *flags)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+
+	return bitmap_weight(bitmap, NUM_VMA_FLAG_BITS);
+}
+
 static __always_inline bool vma_flags_test(const vma_flags_t *flags,
 		vma_flag_t bit)
 {
@@ -952,6 +959,14 @@ static __always_inline bool vma_flags_te
 #define vma_flags_test_all(flags, ...) \
 	vma_flags_test_all_mask(flags, mk_vma_flags(__VA_ARGS__))
 
+static __always_inline bool vma_flags_test_single_mask(const vma_flags_t *flags,
+						vma_flags_t flagmask)
+{
+	VM_WARN_ON_ONCE(vma_flags_count(&flagmask) > 1);
+
+	return vma_flags_test_any_mask(flags, flagmask);
+}
+
 static __always_inline void vma_flags_set_mask(vma_flags_t *flags, vma_flags_t to_set)
 {
 	unsigned long *bitmap = flags->__vma_flags;
@@ -1031,6 +1046,12 @@ static __always_inline bool vma_test_all
 #define vma_test_all(vma, ...) \
 	vma_test_all_mask(vma, mk_vma_flags(__VA_ARGS__))
 
+static __always_inline bool
+vma_test_single_mask(const struct vm_area_struct *vma, vma_flags_t flagmask)
+{
+	return vma_flags_test_single_mask(&vma->flags, flagmask);
+}
+
 static __always_inline void vma_set_flags_mask(struct vm_area_struct *vma,
 		vma_flags_t flags)
 {
--- a/tools/testing/vma/vma_internal.h~mm-introduce-vma_flags_count-and-vma_test_single_mask
+++ a/tools/testing/vma/vma_internal.h
@@ -51,6 +51,12 @@ typedef unsigned long	pgprotval_t;
 typedef struct pgprot { pgprotval_t pgprot; } pgprot_t;
 typedef __bitwise unsigned int vm_fault_t;
 
+#define VM_WARN_ON(_expr) (WARN_ON(_expr))
+#define VM_WARN_ON_ONCE(_expr) (WARN_ON_ONCE(_expr))
+#define VM_WARN_ON_VMG(_expr, _vmg) (WARN_ON(_expr))
+#define VM_BUG_ON(_expr) (BUG_ON(_expr))
+#define VM_BUG_ON_VMA(_expr, _vma) (BUG_ON(_expr))
+
 #include "include/stubs.h"
 #include "include/dup.h"
 #include "include/custom.h"
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

