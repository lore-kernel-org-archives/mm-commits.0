Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E0D21A1C;
	Fri,  4 Oct 2024 02:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728008778; cv=none; b=uC6VmhJbmxvKgVSlb9n0+A75SdCuyqoQTBRvDVc0CT0Cs0W+BacM/93x15EVJSKsXIJlGv9sOn+EoMfNZr9tyQEOiG74WS+wg6oY7InhZldYEknf0+1tDlcTePF381bUwDmxgmJ4pfaQA9UEdcjhUQGes2DEuwyy4ZwoQSQPjYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728008778; c=relaxed/simple;
	bh=g02fdDsNR33eWNgHvfG1kZf5xmlE+HGU4pUmMwVneV0=;
	h=Date:To:From:Subject:Message-Id; b=acbFr1pHuJso0sjiKtoievUwuDKZfcWvk+MewMlsDIlTVMBwF1OOYwU0NDZXUE1ruRqI0XXJdZi/+mxGp425llkYWbUGfRlmhHxLINfi9t/FLdZcVOcBnZsHdsXwLrnWapZnYnLzUwgebVBKRl9ijw1xfAsU0aKI1eJq0pgXC/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Eri9gN7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Eri9gN7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CFBC4CEC5;
	Fri,  4 Oct 2024 02:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728008777;
	bh=g02fdDsNR33eWNgHvfG1kZf5xmlE+HGU4pUmMwVneV0=;
	h=Date:To:From:Subject:From;
	b=Eri9gN7gk+UUSdvPa8Uj0ojxf2KmyA7mKr3o+mUl9Ss7HHvmtm1hjxtlQ4AC1P+qI
	 rSe3c/BPgHs9rPpxeFE1dK4iSFcSa58qVZ6Tcw9kyBSG4x34g75ZXPmkpmizqor31M
	 BpoxY6uU9DtCuJK41PGY6uu2DoIYMiW/6LEoYcms=
Date: Thu, 03 Oct 2024 19:26:17 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hca@linux.ibm.com,gor@linux.ibm.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-proc-kcorec-allow-translation-of-physical-memory-addresses.patch removed from -mm tree
Message-Id: <20241004022617.A4CFBC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/kcore.c: allow translation of physical memory addresses
has been removed from the -mm tree.  Its filename was
     fs-proc-kcorec-allow-translation-of-physical-memory-addresses.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: fs/proc/kcore.c: allow translation of physical memory addresses
Date: Mon, 30 Sep 2024 14:21:19 +0200

When /proc/kcore is read an attempt to read the first two pages results in
HW-specific page swap on s390 and another (so called prefix) pages are
accessed instead.  That leads to a wrong read.

Allow architecture-specific translation of memory addresses using
kc_xlate_dev_mem_ptr() and kc_unxlate_dev_mem_ptr() callbacks similarily
to /dev/mem xlate_dev_mem_ptr() and unxlate_dev_mem_ptr() callbacks.  That
way an architecture can deal with specific physical memory ranges.

Re-use the existing /dev/mem callback implementation on s390, which
handles the described prefix pages swapping correctly.

For other architectures the default callback is basically NOP.  It is
expected the condition (vaddr == __va(__pa(vaddr))) always holds true for
KCORE_RAM memory type.

Link: https://lkml.kernel.org/r/20240930122119.1651546-1-agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/io.h |    2 +
 fs/proc/kcore.c            |   36 +++++++++++++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 2 deletions(-)

--- a/arch/s390/include/asm/io.h~fs-proc-kcorec-allow-translation-of-physical-memory-addresses
+++ a/arch/s390/include/asm/io.h
@@ -16,8 +16,10 @@
 #include <asm/pci_io.h>
 
 #define xlate_dev_mem_ptr xlate_dev_mem_ptr
+#define kc_xlate_dev_mem_ptr xlate_dev_mem_ptr
 void *xlate_dev_mem_ptr(phys_addr_t phys);
 #define unxlate_dev_mem_ptr unxlate_dev_mem_ptr
+#define kc_unxlate_dev_mem_ptr unxlate_dev_mem_ptr
 void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr);
 
 #define IO_SPACE_LIMIT 0
--- a/fs/proc/kcore.c~fs-proc-kcorec-allow-translation-of-physical-memory-addresses
+++ a/fs/proc/kcore.c
@@ -50,6 +50,20 @@ static struct proc_dir_entry *proc_root_
 #define	kc_offset_to_vaddr(o) ((o) + PAGE_OFFSET)
 #endif
 
+#ifndef kc_xlate_dev_mem_ptr
+#define kc_xlate_dev_mem_ptr kc_xlate_dev_mem_ptr
+static inline void *kc_xlate_dev_mem_ptr(phys_addr_t phys)
+{
+	return __va(phys);
+}
+#endif
+#ifndef kc_unxlate_dev_mem_ptr
+#define kc_unxlate_dev_mem_ptr kc_unxlate_dev_mem_ptr
+static inline void kc_unxlate_dev_mem_ptr(phys_addr_t phys, void *virt)
+{
+}
+#endif
+
 static LIST_HEAD(kclist_head);
 static DECLARE_RWSEM(kclist_lock);
 static int kcore_need_update = 1;
@@ -471,6 +485,8 @@ static ssize_t read_kcore_iter(struct ki
 	while (buflen) {
 		struct page *page;
 		unsigned long pfn;
+		phys_addr_t phys;
+		void *__start;
 
 		/*
 		 * If this is the first iteration or the address is not within
@@ -537,7 +553,8 @@ static ssize_t read_kcore_iter(struct ki
 			}
 			break;
 		case KCORE_RAM:
-			pfn = __pa(start) >> PAGE_SHIFT;
+			phys = __pa(start);
+			pfn =  phys >> PAGE_SHIFT;
 			page = pfn_to_online_page(pfn);
 
 			/*
@@ -557,13 +574,28 @@ static ssize_t read_kcore_iter(struct ki
 			fallthrough;
 		case KCORE_VMEMMAP:
 		case KCORE_TEXT:
+			if (m->type == KCORE_RAM) {
+				__start = kc_xlate_dev_mem_ptr(phys);
+				if (!__start) {
+					ret = -ENOMEM;
+					if (iov_iter_zero(tsz, iter) != tsz)
+						ret = -EFAULT;
+					goto out;
+				}
+			} else {
+				__start = (void *)start;
+			}
+
 			/*
 			 * Sadly we must use a bounce buffer here to be able to
 			 * make use of copy_from_kernel_nofault(), as these
 			 * memory regions might not always be mapped on all
 			 * architectures.
 			 */
-			if (copy_from_kernel_nofault(buf, (void *)start, tsz)) {
+			ret = copy_from_kernel_nofault(buf, __start, tsz);
+			if (m->type == KCORE_RAM)
+				kc_unxlate_dev_mem_ptr(phys, __start);
+			if (ret) {
 				if (iov_iter_zero(tsz, iter) != tsz) {
 					ret = -EFAULT;
 					goto out;
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are


