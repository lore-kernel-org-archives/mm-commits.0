Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0043223C519
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343266; cv=none; b=bTTwTEFCS3IlqtiRMr77ZQ6oMg1Xjfn2TBcvchVyVAtzNSW3Ck2eJzA99GvYEtE44frW6bN3oyfyZswK6ODQiie57L5TrVU8f7cv/yH2CrAcDq36H5F6VRfosWk9kqaaU5Wj7K7x7iKaT+4jCFQnCasaU3PPsU+US+hZTJ43CLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343266; c=relaxed/simple;
	bh=+3eUawWWkF01hkJI35cFVJ0RsGSsqp4lulo8Qjk1bQc=;
	h=Date:To:From:Subject:Message-Id; b=XKZ8rAsVXwJKf5vyfkhXw5p6KJVOd44f2qq4rlHr9aiMGUiKR8xMXUjeAS0XdZooeqiPI1P6gOkvdoCI7mIP2YPEkDKEN/GLzwOSkwav6KNRj/Gbgnpu6MbHMMvdQPe0lIKiuifbEG2H+IeNiAVDkGVdJDWqYdxWoKlocw2kY5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IjKl/3YW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IjKl/3YW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A75C4AF0C;
	Mon, 17 Nov 2025 01:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343265;
	bh=+3eUawWWkF01hkJI35cFVJ0RsGSsqp4lulo8Qjk1bQc=;
	h=Date:To:From:Subject:From;
	b=IjKl/3YWRo6Ip4NlsWtu3Y/ploKkdqJyfQZCEz5gSrWw+40v4NIQ0je9db5DL22We
	 TFWargC2kmuUTHZEF5JP/TjqDb3fpwTLiMxYRRJKXMvADBJzdkqsSgjA6wGSFz/psq
	 Do18RNbvvTDkGcjUXHE5Ayn2gHAI0nGvVTPf20lw=
Date: Sun, 16 Nov 2025 17:34:25 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,harry.yoo@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] treewide-include-linux-pgalloch-instead-of-asm-pgalloch.patch removed from -mm tree
Message-Id: <20251117013425.B9A75C4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: treewide: include linux/pgalloc.h instead of asm/pgalloc.h
has been removed from the -mm tree.  Its filename was
     treewide-include-linux-pgalloch-instead-of-asm-pgalloch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Harry Yoo <harry.yoo@oracle.com>
Subject: treewide: include linux/pgalloc.h instead of asm/pgalloc.h
Date: Fri, 24 Oct 2025 20:30:47 +0900

For now, including <asm/pgalloc.h> instead of <linux/pgalloc.h> is
technically fine unless the .c file calls p*d_populate_kernel() helper
functions.

But it is a better practice to always include <linux/pgalloc.h>.  Include
<linux/pgalloc.h> instead of <asm/pgalloc.h> outside arch/.

Link: https://lkml.kernel.org/r/20251024113047.119058-3-harry.yoo@oracle.com
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/efi/arm-runtime.c   |    4 ++--
 drivers/firmware/efi/riscv-runtime.c |    4 ++--
 drivers/s390/char/sclp_sd.c          |    3 +--
 fs/dax.c                             |    2 +-
 kernel/fork.c                        |    4 ++--
 mm/debug_vm_pgtable.c                |    2 +-
 mm/filemap.c                         |    3 ++-
 mm/huge_memory.c                     |    2 +-
 mm/hugetlb.c                         |    2 +-
 mm/hugetlb_vmemmap.c                 |    3 ++-
 mm/khugepaged.c                      |    2 +-
 mm/memory.c                          |    4 ++--
 mm/mmu_gather.c                      |    2 +-
 mm/mremap.c                          |    2 +-
 mm/pgtable-generic.c                 |    3 ++-
 mm/pt_reclaim.c                      |    3 ++-
 16 files changed, 24 insertions(+), 21 deletions(-)

--- a/drivers/firmware/efi/arm-runtime.c~treewide-include-linux-pgalloch-instead-of-asm-pgalloch
+++ a/drivers/firmware/efi/arm-runtime.c
@@ -12,18 +12,18 @@
 #include <linux/io.h>
 #include <linux/memblock.h>
 #include <linux/mm_types.h>
+#include <linux/pgalloc.h>
+#include <linux/pgtable.h>
 #include <linux/preempt.h>
 #include <linux/rbtree.h>
 #include <linux/rwsem.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/pgtable.h>
 
 #include <asm/cacheflush.h>
 #include <asm/efi.h>
 #include <asm/mmu.h>
-#include <asm/pgalloc.h>
 
 #if defined(CONFIG_PTDUMP_DEBUGFS) || defined(CONFIG_ARM_PTDUMP_DEBUGFS)
 #include <asm/ptdump.h>
--- a/drivers/firmware/efi/riscv-runtime.c~treewide-include-linux-pgalloch-instead-of-asm-pgalloch
+++ a/drivers/firmware/efi/riscv-runtime.c
@@ -14,18 +14,18 @@
 #include <linux/io.h>
 #include <linux/memblock.h>
 #include <linux/mm_types.h>
+#include <linux/pgalloc.h>
+#include <linux/pgtable.h>
 #include <linux/preempt.h>
 #include <linux/rbtree.h>
 #include <linux/rwsem.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/pgtable.h>
 
 #include <asm/cacheflush.h>
 #include <asm/efi.h>
 #include <asm/mmu.h>
-#include <asm/pgalloc.h>
 
 static bool __init efi_virtmap_init(void)
 {
--- a/drivers/s390/char/sclp_sd.c~treewide-include-linux-pgalloch-instead-of-asm-pgalloch
+++ a/drivers/s390/char/sclp_sd.c
@@ -17,8 +17,7 @@
 #include <linux/vmalloc.h>
 #include <linux/async.h>
 #include <linux/mutex.h>
-
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
 
 #include "sclp.h"
 
--- a/fs/dax.c~treewide-include-linux-pgalloch-instead-of-asm-pgalloch
+++ a/fs/dax.c
@@ -24,7 +24,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/iomap.h>
 #include <linux/rmap.h>
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/fs_dax.h>
--- a/kernel/fork.c~treewide-include-linux-pgalloch-instead-of-asm-pgalloch
+++ a/kernel/fork.c
@@ -106,9 +106,9 @@
 #include <linux/pidfs.h>
 #include <linux/tick.h>
 #include <linux/unwind_deferred.h>
-
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
 #include <linux/uaccess.h>
+
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
--- a/mm/debug_vm_pgtable.c~treewide-include-linux-pgalloch-instead-of-asm-pgalloch
+++ a/mm/debug_vm_pgtable.c
@@ -30,9 +30,9 @@
 #include <linux/sched/mm.h>
 #include <linux/io.h>
 #include <linux/vmalloc.h>
+#include <linux/pgalloc.h>
 
 #include <asm/cacheflush.h>
-#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
 /*
--- a/mm/filemap.c~treewide-include-linux-pgalloch-instead-of-asm-pgalloch
+++ a/mm/filemap.c
@@ -48,7 +48,8 @@
 #include <linux/rcupdate_wait.h>
 #include <linux/sched/mm.h>
 #include <linux/sysctl.h>
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
+
 #include <asm/tlbflush.h>
 #include "internal.h"
 
--- a/mm/huge_memory.c~treewide-include-linux-pgalloch-instead-of-asm-pgalloch
+++ a/mm/huge_memory.c
@@ -37,11 +37,11 @@
 #include <linux/sched/sysctl.h>
 #include <linux/memory-tiers.h>
 #include <linux/compat.h>
+#include <linux/pgalloc.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
 
 #include <asm/tlb.h>
-#include <asm/pgalloc.h>
 #include "internal.h"
 #include "swap.h"
 
--- a/mm/hugetlb.c~treewide-include-linux-pgalloch-instead-of-asm-pgalloch
+++ a/mm/hugetlb.c
@@ -39,9 +39,9 @@
 #include <linux/memory.h>
 #include <linux/mm_inline.h>
 #include <linux/padata.h>
+#include <linux/pgalloc.h>
 
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/tlb.h>
 #include <asm/setup.h>
 
--- a/mm/hugetlb_vmemmap.c~treewide-include-linux-pgalloch-instead-of-asm-pgalloch
+++ a/mm/hugetlb_vmemmap.c
@@ -15,7 +15,8 @@
 #include <linux/bootmem_info.h>
 #include <linux/mmdebug.h>
 #include <linux/pagewalk.h>
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
+
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
 
--- a/mm/khugepaged.c~treewide-include-linux-pgalloch-instead-of-asm-pgalloch
+++ a/mm/khugepaged.c
@@ -21,9 +21,9 @@
 #include <linux/shmem_fs.h>
 #include <linux/dax.h>
 #include <linux/ksm.h>
+#include <linux/pgalloc.h>
 
 #include <asm/tlb.h>
-#include <asm/pgalloc.h>
 #include "internal.h"
 #include "mm_slot.h"
 
--- a/mm/memory.c~treewide-include-linux-pgalloch-instead-of-asm-pgalloch
+++ a/mm/memory.c
@@ -76,13 +76,13 @@
 #include <linux/ptrace.h>
 #include <linux/vmalloc.h>
 #include <linux/sched/sysctl.h>
+#include <linux/pgalloc.h>
+#include <linux/uaccess.h>
 
 #include <trace/events/kmem.h>
 
 #include <asm/io.h>
 #include <asm/mmu_context.h>
-#include <asm/pgalloc.h>
-#include <linux/uaccess.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
--- a/mm/mmu_gather.c~treewide-include-linux-pgalloch-instead-of-asm-pgalloch
+++ a/mm/mmu_gather.c
@@ -9,8 +9,8 @@
 #include <linux/smp.h>
 #include <linux/swap.h>
 #include <linux/rmap.h>
+#include <linux/pgalloc.h>
 
-#include <asm/pgalloc.h>
 #include <asm/tlb.h>
 
 #ifndef CONFIG_MMU_GATHER_NO_GATHER
--- a/mm/mremap.c~treewide-include-linux-pgalloch-instead-of-asm-pgalloch
+++ a/mm/mremap.c
@@ -25,10 +25,10 @@
 #include <linux/uaccess.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/mempolicy.h>
+#include <linux/pgalloc.h>
 
 #include <asm/cacheflush.h>
 #include <asm/tlb.h>
-#include <asm/pgalloc.h>
 
 #include "internal.h"
 
--- a/mm/pgtable-generic.c~treewide-include-linux-pgalloch-instead-of-asm-pgalloch
+++ a/mm/pgtable-generic.c
@@ -14,7 +14,8 @@
 #include <linux/swapops.h>
 #include <linux/mm_inline.h>
 #include <linux/iommu.h>
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
+
 #include <asm/tlb.h>
 
 /*
--- a/mm/pt_reclaim.c~treewide-include-linux-pgalloch-instead-of-asm-pgalloch
+++ a/mm/pt_reclaim.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/hugetlb.h>
+#include <linux/pgalloc.h>
+
 #include <asm-generic/tlb.h>
-#include <asm/pgalloc.h>
 
 #include "internal.h"
 
_

Patches currently in -mm which might be from harry.yoo@oracle.com are


