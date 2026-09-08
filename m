Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFBB4A5C49
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 23:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788910433; cv=none; b=GhPc/GGOPi4gtXcLVrLhoDbfxca9SXihKqySy/ioAgXnagq00TIdtO+zPvI8Uv6f/H46ZlyEQz1HQs4TYJKAPHrQSi6Wl8bHS4yT6snVeJj5Mfk5vlAJ9Euz/P3k1T1X64CzibbE74Zc/YypJ9+nGEbeb64P/N6WEqbsDNuUGwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788910433; c=relaxed/simple;
	bh=hymrOUxsUL4S7w/I6E6GTfSfWi5HKXcrojYklaK4KQ0=;
	h=Date:To:From:Subject:Message-Id; b=eLg8mja+m67G9qAgpAaVpbOfA6uvVXiNkWRbMj3GY/4JVa85HM7k/4USkFZXYOnUOxDAIAqIiB4KR22c9IVuol5pVmW6RnwjHLQ9K4OGm337RdJBzXIXK/1IPO5lrf4AdyGiU+9OuxeZTzsJc0lH+pGgaQHZE0lGU0OarE5O5tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qdVvLDe1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qdVvLDe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8122B1F00A3D;
	Tue,  8 Sep 2026 23:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788910431;
	bh=DhgumfFg4w5ZSXiQmx1e+28YbdV2sBrm9ll3PDtkjeo=;
	h=Date:To:From:Subject;
	b=qdVvLDe1/Kqf5cA1tVmkbciC1G5muO9oe07pG+Yz0D+8Hg9wso9gd+ulzLY1GJprv
	 qm8SPB+jK7vW3jK/o8DUBuX3eegJBU5gNKZtBO16w6u2pvIw0raLMIr3FvfZYhl8Go
	 7eEyQrbOVRQ+I75TYD0XqEZ+dPB8KGb3yY76EDJI=
Date: Tue, 08 Sep 2026 16:33:51 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch removed from -mm tree
Message-Id: <20260908233351.8122B1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: implement file_is_dev_zero() to uniquely identify /dev/zero
has been removed from the -mm tree.  Its filename was
     mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: implement file_is_dev_zero() to uniquely identify /dev/zero
Date: Wed, 02 Sep 2026 19:00:19 +0100

To lay the foundation for a future change that converts
MAP_PRIVATE-/dev/zero mappings to be truly anonymous, add the ability to
uniquely identify these mappings.

With the memory character device now part of mm/ this is trivially
achievable through a file_is_dev_zero() predicate that simply tests that
the file operation hooks are zero_fops.

Also update userland VMA tests to expose file_is_dev_zero() and provide a
stub zero_fops for testing.

Link: https://lore.kernel.org/20260902-map-private-dev-zero-v1-2-a578c730cec7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/char-mem.c                   |   13 +++++++++++++
 mm/internal.h                   |    3 +++
 tools/testing/vma/include/dup.h |    7 +++++++
 tools/testing/vma/shared.c      |    9 +++++++++
 4 files changed, 32 insertions(+)

--- a/mm/char-mem.c~mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero
+++ a/mm/char-mem.c
@@ -31,6 +31,8 @@
 #include <linux/uaccess.h>
 #include <linux/security.h>
 
+#include "internal.h"
+
 #define DEVMEM_MINOR	1
 #define DEVPORT_MINOR	4
 
@@ -707,6 +709,17 @@ static const struct memdev {
 #endif
 };
 
+/**
+ * file_is_dev_zero() - is the specified @file associated with the /dev/zero
+ * driver?
+ * @file: File to test.
+ * Returns: true if it is, false otherwise.
+ */
+bool file_is_dev_zero(const struct file *file)
+{
+	return file && file->f_op == &zero_fops;
+}
+
 static int memory_open(struct inode *inode, struct file *filp)
 {
 	int minor;
--- a/mm/internal.h~mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero
+++ a/mm/internal.h
@@ -1638,4 +1638,7 @@ static inline bool can_spin_trylock(void
 	return true;
 }
 
+/* char-mem.c */
+bool file_is_dev_zero(const struct file *file);
+
 #endif	/* __MM_INTERNAL_H */
--- a/tools/testing/vma/include/dup.h~mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero
+++ a/tools/testing/vma/include/dup.h
@@ -1641,3 +1641,10 @@ static inline pgoff_t linear_anon_page_i
 
 	return pgoff;
 }
+
+extern const struct file_operations zero_fops;
+
+static inline bool file_is_dev_zero(const struct file *file)
+{
+	return file && file->f_op == &zero_fops;
+}
--- a/tools/testing/vma/shared.c~mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero
+++ a/tools/testing/vma/shared.c
@@ -12,6 +12,15 @@ const struct vm_operations_struct vma_du
 struct anon_vma dummy_anon_vma;
 struct task_struct __current;
 
+static int mmap_zero_prepare(struct vm_area_desc *desc)
+{
+	return 0;
+}
+
+const struct file_operations zero_fops = {
+	.mmap_prepare = mmap_zero_prepare,
+};
+
 struct vm_area_struct *alloc_vma(struct mm_struct *mm,
 		unsigned long start, unsigned long end,
 		pgoff_t pgoff, vma_flags_t vma_flags)
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-correctly-unaccount-on-mmap_prepare-failure.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch
mm-huge_memory-zap-deposited-page-tables-after-an-rcu-grace-period.patch
mm-enable-mmu_gather_rcu_table_free-for-most-2-level-architectures.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-riscv.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-arm.patch
mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc64.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire.patch
mm-enable-mmu_gather_rcu_table_free-for-sh-x2.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch
mm-make-userland-page-table-freeing-rcu-safe.patch
mm-change-the-contract-for-free_pgtables-update-docs.patch

