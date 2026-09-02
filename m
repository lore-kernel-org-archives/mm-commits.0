Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBF9390601
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 19:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788376913; cv=none; b=V8o6WOoKOtKgioZQWxXmBI+OcqMDjGh7Aakp9n2h2fBYP4Ec4ZNAoXu6WOPIIZ0vPQ67jIFi0P54wAMG/GtAwrRdzVaOeYWzCBZWVHBWumYlm6V79t27+KTmCy2FpD1QP/EQgSeSp/qSuBbgV1U6E7j32PHPvYdTgoceNtT4piA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788376913; c=relaxed/simple;
	bh=nGbP6jhFagtvgxGG6GtQo73fmxG/OFuXBwQHnO1p5YI=;
	h=Date:To:From:Subject:Message-Id; b=mdUF4nrq6pzoTulT6q+mo/nUFJHa817eLxbfUOoBsaSKzbk6EtEYc2sH99yIlAdUbl75tW1h+JO9PaYClqE/D6MObXnkcAE/igb+ELa5Ucy3GQwfR/r+CGAKi7JgmzL95mFbX5ooMeBBQIPtVKlpkvoJQw1fs94UmLEgvR47nHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CaxG+Bkd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CaxG+Bkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176E61F000E9;
	Wed,  2 Sep 2026 19:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788376911;
	bh=1jS9AsdbIO1Y1IER11YJShX+Cjv/69XSVUiQXnaypkQ=;
	h=Date:To:From:Subject;
	b=CaxG+BkdXhg8h5gunzxIQme8z5kGnYXAa5Rd0CHBuE+EGVlGDh79eQEc/TEGE3XlZ
	 VecSH0mZpR8oz0owJpT3fPV5zvZQHKRQg9qUI8udi00e51+NxyjItZ1apccx/ScOMp
	 oWBJjV3MTbkF3LoGRaUOB24HVPNvNNNPTuUj7Cog=
Date: Wed, 02 Sep 2026 12:21:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam@infradead.org,jannh@google.com,jack@suse.cz,hughd@google.com,gregkh@linuxfoundation.org,david@kernel.org,baolin.wang@linux.alibaba.com,arnd@arndb.de,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch added to mm-new branch
Message-Id: <20260902192151.176E61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: implement file_is_dev_zero() to uniquely identify /dev/zero
has been added to the -mm mm-new branch.  Its filename is
     mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-mremap-reset-unfaulted-vma-page-offset-for-mremap_dontunmap.patch
mm-secretmem-properly-account-locked-pages.patch
mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings.patch
mm-mremap-account-mm-locked_vm-correctly-for-mremap_dontunmap.patch
mm-vma-correctly-unaccount-on-mmap_prepare-failure.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch

