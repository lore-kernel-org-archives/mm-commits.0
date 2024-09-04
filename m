Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878F4BA37
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423413; cv=none; b=IQOZvqgQ6ckp32mreqQCu3JSXW4JZQwem4hn4botBY79MVw4mAmuY+s3W0trMn4Hk/GWs7+mVD7Yt+1y5FHm4hXfJi0fDcuIUGNe1im/8xfrOL09rsH9hs7uTutJ27tQ/BwWNYVyTwbisDInDIfKSeYRvqfdgY+cwB+RrCNycKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423413; c=relaxed/simple;
	bh=q+rtZGpC1KnO4V47rxvyvWg1X+YKrg1t/utwQHkPDsY=;
	h=Date:To:From:Subject:Message-Id; b=uUyMC3At1j8rqdtHuP/q3gjnG4ANqCbQuKaErmsmaD+z39Pt0tjRsauWVZO3EUaDswZK2vu2i7t2zUiel00ShLLThmllYaZ+R558QMQbfsOdggAs2qf/aetkD+GQb17tFXH1tzf3TZSkf5TxCNggYabjrAGKsrTVCiY1iK1Hq2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HVYVSbpg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HVYVSbpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F59C4CEC2;
	Wed,  4 Sep 2024 04:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423413;
	bh=q+rtZGpC1KnO4V47rxvyvWg1X+YKrg1t/utwQHkPDsY=;
	h=Date:To:From:Subject:From;
	b=HVYVSbpg+LdV9NCwejMOhSM3IQ9Bp4VTeGitizLZHs3Iq6mOvuie8gILqoq3JwYBL
	 YWQI0o/WCgjlYtRLh2Fx45dkVmKcZeBdkVTzC7IbC0pRfqJ4xVNTZsSg3uUeXA5/5K
	 Kloz3svs0shwq7OBoSEyUyHpS4ukyBr/Wm1sQbF4=
Date: Tue, 03 Sep 2024 21:16:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-kernel-numac-to-mm.patch removed from -mm tree
Message-Id: <20240904041653.53F59C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move kernel/numa.c to mm/
has been removed from the -mm tree.  Its filename was
     mm-move-kernel-numac-to-mm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm: move kernel/numa.c to mm/
Date: Wed, 7 Aug 2024 09:40:45 +0300

Patch series "mm: introduce numa_memblks", v4.

Following the discussion about handling of CXL fixed memory windows on
arm64 [1] I decided to bite the bullet and move numa_memblks from x86 to
the generic code so they will be available on arm64/riscv and maybe on
loongarch sometime later.

While it could be possible to use memblock to describe CXL memory windows,
it currently lacks notion of unpopulated memory ranges and numa_memblks
does implement this.

Another reason to make numa_memblks generic is that both arch_numa (arm64
and riscv) and loongarch use trimmed copy of x86 code although there is no
fundamental reason why the same code cannot be used on all these
platforms.  Having numa_memblks in mm/ will make it's interaction with
ACPI and FDT more consistent and I believe will reduce maintenance burden.

And with generic numa_memblks it is (almost) straightforward to enable
NUMA emulation on arm64 and riscv.

The first 9 commits in this series are cleanups that are not strictly
related to numa_memblks.
Commits 10-16 slightly reorder code in x86 to allow extracting numa_memblks
and NUMA emulation to the generic code.
Commits 17-19 actually move the code from arch/x86/ to mm/ and commits 20-22
does some aftermath cleanups.
Commit 23 updates of_numa_init() to return error of no NUMA nodes were
found in the device tree.
Commit 24 switches arch_numa to numa_memblks.
Commit 25 enables usage of phys_to_target_node() and
memory_add_physaddr_to_nid() with numa_memblks.
Commit 26 moves the description for numa=fake from x86 to admin-guide.

[1] https://lore.kernel.org/all/20240529171236.32002-1-Jonathan.Cameron@huawei.com/


This patch (of 26):

The stub functions in kernel/numa.c belong to mm/ rather than to kernel/

Link: https://lkml.kernel.org/r/20240807064110.1003856-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20240807064110.1003856-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Zi Yan <ziy@nvidia.com> # for x86_64 and arm64
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> [arm64 + CXL via QEMU]
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Rob Herring (Arm) <robh@kernel.org>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile |    1 -
 kernel/numa.c   |   26 --------------------------
 mm/Makefile     |    1 +
 mm/numa.c       |   26 ++++++++++++++++++++++++++
 4 files changed, 27 insertions(+), 27 deletions(-)

--- a/kernel/Makefile~mm-move-kernel-numac-to-mm
+++ a/kernel/Makefile
@@ -116,7 +116,6 @@ obj-$(CONFIG_SHADOW_CALL_STACK) += scs.o
 obj-$(CONFIG_HAVE_STATIC_CALL) += static_call.o
 obj-$(CONFIG_HAVE_STATIC_CALL_INLINE) += static_call_inline.o
 obj-$(CONFIG_CFI_CLANG) += cfi.o
-obj-$(CONFIG_NUMA) += numa.o
 
 obj-$(CONFIG_PERF_EVENTS) += events/
 
diff --git a/kernel/numa.c a/kernel/numa.c
deleted file mode 100644
--- a/kernel/numa.c
+++ /dev/null
@@ -1,26 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-
-#include <linux/printk.h>
-#include <linux/numa.h>
-
-/* Stub functions: */
-
-#ifndef memory_add_physaddr_to_nid
-int memory_add_physaddr_to_nid(u64 start)
-{
-	pr_info_once("Unknown online node for memory at 0x%llx, assuming node 0\n",
-			start);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
-#endif
-
-#ifndef phys_to_target_node
-int phys_to_target_node(u64 start)
-{
-	pr_info_once("Unknown target node for memory at 0x%llx, assuming node 0\n",
-			start);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(phys_to_target_node);
-#endif
--- a/mm/Makefile~mm-move-kernel-numac-to-mm
+++ a/mm/Makefile
@@ -117,6 +117,7 @@ obj-$(CONFIG_ZSMALLOC)	+= zsmalloc.o
 obj-$(CONFIG_Z3FOLD)	+= z3fold.o
 obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += early_ioremap.o
 obj-$(CONFIG_CMA)	+= cma.o
+obj-$(CONFIG_NUMA) += numa.o
 obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_PAGE_TABLE_CHECK) += page_table_check.o
diff --git a/mm/numa.c a/mm/numa.c
new file mode 100644
--- /dev/null
+++ a/mm/numa.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/printk.h>
+#include <linux/numa.h>
+
+/* Stub functions: */
+
+#ifndef memory_add_physaddr_to_nid
+int memory_add_physaddr_to_nid(u64 start)
+{
+	pr_info_once("Unknown online node for memory at 0x%llx, assuming node 0\n",
+			start);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
+#endif
+
+#ifndef phys_to_target_node
+int phys_to_target_node(u64 start)
+{
+	pr_info_once("Unknown target node for memory at 0x%llx, assuming node 0\n",
+			start);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(phys_to_target_node);
+#endif
_

Patches currently in -mm which might be from rppt@kernel.org are


