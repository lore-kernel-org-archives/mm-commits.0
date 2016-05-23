From: akpm@linux-foundation.org
Subject: [patch 43/84] s390/kexec: consolidate
 crash_map/unmap_reserved_pages() and
 arch_kexec_protect(unprotect)_crashkres()
Date: Mon, 23 May 2016 16:24:22 -0700
Message-ID: <57439126.1SY26xUMM3ixdALP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbcEWXYY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:24:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, xlpang@redhat.com, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, heiko.carstens@de.ibm.com, holzheu@linux.vnet.ibm.com, mhuang@redhat.com, vgoyal@redhat.com

From: Xunlei Pang <xlpang@redhat.com>
Subject: s390/kexec: consolidate crash_map/unmap_reserved_pages() and arch_kexec_protect(unprotect)_crashkres()

Commit 3f625002581b ("kexec: introduce a protection mechanism for the
crashkernel reserved memory") is a similar mechanism for protecting the
crash kernel reserved memory to previous crash_map/unmap_reserved_pages()
implementation, the new one is more generic in name and cleaner in code
(besides, some arch may not be allowed to unmap the pgtable).

Therefore, this patch consolidates them, and uses the new
arch_kexec_protect(unprotect)_crashkres() to replace former
crash_map/unmap_reserved_pages() which by now has been only used by S390.

The consolidation work needs the crash memory to be mapped initially, this
is done in machine_kdump_pm_init() which is after reserve_crashkernel(). 
Once kdump kernel is loaded, the new arch_kexec_protect_crashkres()
implemented for S390 will actually unmap the pgtable like before.

Signed-off-by: Xunlei Pang <xlpang@redhat.com>
Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Acked-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Minfei Huang <mhuang@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/machine_kexec.c |   28 ++++++++++++++++++----------
 include/linux/kexec.h            |    2 --
 kernel/kexec.c                   |   12 ------------
 kernel/kexec_core.c              |   11 ++---------
 4 files changed, 20 insertions(+), 33 deletions(-)

diff -puN arch/s390/kernel/machine_kexec.c~s390-kexec-consolidate-crash_map-unmap_reserved_pages-and-arch_kexec_protectunprotect_crashkres arch/s390/kernel/machine_kexec.c
--- a/arch/s390/kernel/machine_kexec.c~s390-kexec-consolidate-crash_map-unmap_reserved_pages-and-arch_kexec_protectunprotect_crashkres
+++ a/arch/s390/kernel/machine_kexec.c
@@ -43,13 +43,13 @@ static int machine_kdump_pm_cb(struct no
 	switch (action) {
 	case PM_SUSPEND_PREPARE:
 	case PM_HIBERNATION_PREPARE:
-		if (crashk_res.start)
-			crash_map_reserved_pages();
+		if (kexec_crash_image)
+			arch_kexec_unprotect_crashkres();
 		break;
 	case PM_POST_SUSPEND:
 	case PM_POST_HIBERNATION:
-		if (crashk_res.start)
-			crash_unmap_reserved_pages();
+		if (kexec_crash_image)
+			arch_kexec_protect_crashkres();
 		break;
 	default:
 		return NOTIFY_DONE;
@@ -60,6 +60,8 @@ static int machine_kdump_pm_cb(struct no
 static int __init machine_kdump_pm_init(void)
 {
 	pm_notifier(machine_kdump_pm_cb, 0);
+	/* Create initial mapping for crashkernel memory */
+	arch_kexec_unprotect_crashkres();
 	return 0;
 }
 arch_initcall(machine_kdump_pm_init);
@@ -146,6 +148,8 @@ static int kdump_csum_valid(struct kimag
 #endif
 }
 
+#ifdef CONFIG_CRASH_DUMP
+
 /*
  * Map or unmap crashkernel memory
  */
@@ -167,21 +171,25 @@ static void crash_map_pages(int enable)
 }
 
 /*
- * Map crashkernel memory
+ * Unmap crashkernel memory
  */
-void crash_map_reserved_pages(void)
+void arch_kexec_protect_crashkres(void)
 {
-	crash_map_pages(1);
+	if (crashk_res.end)
+		crash_map_pages(0);
 }
 
 /*
- * Unmap crashkernel memory
+ * Map crashkernel memory
  */
-void crash_unmap_reserved_pages(void)
+void arch_kexec_unprotect_crashkres(void)
 {
-	crash_map_pages(0);
+	if (crashk_res.end)
+		crash_map_pages(1);
 }
 
+#endif
+
 /*
  * Give back memory to hypervisor before new kdump is loaded
  */
diff -puN include/linux/kexec.h~s390-kexec-consolidate-crash_map-unmap_reserved_pages-and-arch_kexec_protectunprotect_crashkres include/linux/kexec.h
--- a/include/linux/kexec.h~s390-kexec-consolidate-crash_map-unmap_reserved_pages-and-arch_kexec_protectunprotect_crashkres
+++ a/include/linux/kexec.h
@@ -230,8 +230,6 @@ extern void crash_kexec(struct pt_regs *
 int kexec_should_crash(struct task_struct *);
 void crash_save_cpu(struct pt_regs *regs, int cpu);
 void crash_save_vmcoreinfo(void);
-void crash_map_reserved_pages(void);
-void crash_unmap_reserved_pages(void);
 void arch_crash_save_vmcoreinfo(void);
 __printf(1, 2)
 void vmcoreinfo_append_str(const char *fmt, ...);
diff -puN kernel/kexec.c~s390-kexec-consolidate-crash_map-unmap_reserved_pages-and-arch_kexec_protectunprotect_crashkres kernel/kexec.c
--- a/kernel/kexec.c~s390-kexec-consolidate-crash_map-unmap_reserved_pages-and-arch_kexec_protectunprotect_crashkres
+++ a/kernel/kexec.c
@@ -136,9 +136,6 @@ static int do_kexec_load(unsigned long e
 	if (ret)
 		return ret;
 
-	if (flags & KEXEC_ON_CRASH)
-		crash_map_reserved_pages();
-
 	if (flags & KEXEC_PRESERVE_CONTEXT)
 		image->preserve_context = 1;
 
@@ -161,12 +158,6 @@ out:
 	if ((flags & KEXEC_ON_CRASH) && kexec_crash_image)
 		arch_kexec_protect_crashkres();
 
-	/*
-	 * Once the reserved memory is mapped, we should unmap this memory
-	 * before returning
-	 */
-	if (flags & KEXEC_ON_CRASH)
-		crash_unmap_reserved_pages();
 	kimage_free(image);
 	return ret;
 }
@@ -232,9 +223,6 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
 
 	result = do_kexec_load(entry, nr_segments, segments, flags);
 
-	if ((flags & KEXEC_ON_CRASH) && kexec_crash_image)
-		arch_kexec_protect_crashkres();
-
 	mutex_unlock(&kexec_mutex);
 
 	return result;
diff -puN kernel/kexec_core.c~s390-kexec-consolidate-crash_map-unmap_reserved_pages-and-arch_kexec_protectunprotect_crashkres kernel/kexec_core.c
--- a/kernel/kexec_core.c~s390-kexec-consolidate-crash_map-unmap_reserved_pages-and-arch_kexec_protectunprotect_crashkres
+++ a/kernel/kexec_core.c
@@ -954,7 +954,6 @@ int crash_shrink_memory(unsigned long ne
 	start = roundup(start, KEXEC_CRASH_MEM_ALIGN);
 	end = roundup(start + new_size, KEXEC_CRASH_MEM_ALIGN);
 
-	crash_map_reserved_pages();
 	crash_free_reserved_phys_range(end, crashk_res.end);
 
 	if ((start == end) && (crashk_res.parent != NULL))
@@ -968,7 +967,6 @@ int crash_shrink_memory(unsigned long ne
 	crashk_res.end = end - 1;
 
 	insert_resource(&iomem_resource, ram_res);
-	crash_unmap_reserved_pages();
 
 unlock:
 	mutex_unlock(&kexec_mutex);
@@ -1553,17 +1551,12 @@ int kernel_kexec(void)
 }
 
 /*
- * Add and remove page tables for crashkernel memory
+ * Protection mechanism for crashkernel reserved memory after
+ * the kdump kernel is loaded.
  *
  * Provide an empty default implementation here -- architecture
  * code may override this
  */
-void __weak crash_map_reserved_pages(void)
-{}
-
-void __weak crash_unmap_reserved_pages(void)
-{}
