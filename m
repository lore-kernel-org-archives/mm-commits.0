Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CBF38B7D8
	for <mm-commits@vger.kernel.org>; Fri, 17 Jul 2026 19:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784316913; cv=none; b=aSjYD+cb6pJN0VQl8udSx8hSN/vfRksB/P0RdnacASfoUZatTLgRnnx1wN66bgmlAlQjO/ZEtrwOnIZpQ/64fTGi7SQzNQW4urHailO8x7O21xrSmFJdWt5ilPU0PHTnNVsnlxX5SBWHcYzH1LKTUNXAiH4LUrPDTep9bRns/Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784316913; c=relaxed/simple;
	bh=K5nd/C3rcv9xvTqueoALh2EWTzeyLs/WdloOMzYaG84=;
	h=Date:To:From:Subject:Message-Id; b=i9+cYNeAnj3HKyNBAZI/RnBIHdPRm9WvCrqTKtVztzb36vkeg3ZDFAmAVOfHmZgbOcd0ZiHa+ozkr3TzM0/IWK4rLTNsrjgHZNdI1Y+/0XIU5aBdC19I/pd4BLEowjBUyChxk07d04YFcHlD2fGZHrhDtPXzkab0FVTcLzHr4/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zw8OgcON; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zw8OgcON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2CB1F00A3A;
	Fri, 17 Jul 2026 19:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784316911;
	bh=ZUsbAO5/FCv3XdcQoj7pJ7tgh3Pt7+hoWaV8USS8gjc=;
	h=Date:To:From:Subject;
	b=zw8OgcONa+opwi4ED9xdCurkyoBv8FVI7bb7iLGib5nVlYv3hNYeybsjtdXwao3Yf
	 0F5q9lrDYXH5D+63O7CSTrD6iD4NKBKHGcOS+oQEif/TVBEj7HGAHAHpjtxRMwKUKz
	 63XuZ/WG7ZNJWTTIJqLZLDo8c2EhMy/wT3nSQGCM=
Date: Fri, 17 Jul 2026 12:35:10 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch removed from -mm tree
Message-Id: <20260717193511.1A2CB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mseal: limit scope of mseal address zero to address zero
has been removed from the -mm tree.  Its filename was
     mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/mseal: limit scope of mseal address zero to address zero
Date: Thu, 16 Jul 2026 14:43:10 +0100

Commit 44f65d900698 ("binfmt_elf: mseal address zero") unconditionally
provided do_mseal() to any internal kernel caller in order to address a
corner case slated for possible removal.

It also incorrectly attempts to mseal() without checking to see whether
the mapping even succeeded.

Restrict the scope to the corner case by providing mseal_mmap_page_zero()
which asserts the MMAP_PAGE_ZERO personality.

Avoid unnecessary checks in the start, end range by abstracting the actual
mseal()'ing to mseal() and have mseal_mmap_page_zero() call that instead.

Only try to seal the VMA if we mapped the VMA.

Link: https://lore.kernel.org/20260716-mseal-fixups-v1-2-3a9609bf041b@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c    |    7 +-----
 include/linux/mm.h |    8 +------
 mm/mseal.c         |   48 +++++++++++++++++++++++++++++++------------
 3 files changed, 39 insertions(+), 24 deletions(-)

--- a/fs/binfmt_elf.c~mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero
+++ a/fs/binfmt_elf.c
@@ -1353,11 +1353,8 @@ out_free_interp:
 		   emulate the SVr4 behavior. Sigh. */
 		error = vm_mmap(NULL, 0, PAGE_SIZE, PROT_READ | PROT_EXEC,
 				MAP_FIXED | MAP_PRIVATE, 0);
-
-		retval = do_mseal(0, PAGE_SIZE, 0);
-		if (retval)
-			pr_warn_ratelimited("pid=%d, couldn't seal address 0, ret=%d.\n",
-					    task_pid_nr(current), retval);
+		if (!error)
+			mseal_mmap_page_zero();
 	}
 
 	regs = current_pt_regs();
--- a/include/linux/mm.h~mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero
+++ a/include/linux/mm.h
@@ -5291,13 +5291,9 @@ int reserve_mem_find_by_name(const char
 int reserve_mem_release_by_name(const char *name);
 
 #ifdef CONFIG_64BIT
-int do_mseal(unsigned long start, size_t len_in, unsigned long flags);
+void mseal_mmap_page_zero(void);
 #else
-static inline int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
-{
-	/* noop on 32 bit */
-	return 0;
-}
+static inline void mseal_mmap_page_zero(void) {}
 #endif
 
 /*
--- a/mm/mseal.c~mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero
+++ a/mm/mseal.c
@@ -32,7 +32,7 @@ static bool range_contains_unmapped(unsi
 	return prev_end < end;
 }
 
-static int mseal_apply(unsigned long start, unsigned long end)
+static int __mseal(unsigned long start, unsigned long end)
 {
 	struct vm_area_struct *vma, *prev;
 	VMA_ITERATOR(vmi, current->mm, start);
@@ -66,6 +66,38 @@ static int mseal_apply(unsigned long sta
 	return 0;
 }
 
+static int mseal(unsigned long start, unsigned long end)
+{
+	int err;
+
+	err = mmap_write_lock_killable(current->mm);
+	if (err)
+		return err;
+	if (range_contains_unmapped(start, end))
+		err = -ENOMEM;
+	else
+		err = __mseal(start, end);
+	mmap_write_unlock(current->mm);
+	return err;
+}
+
+/**
+ * mseal_mmap_page_zero() - If the MMAP_PAGE_ZERO personality is set, mseal()
+ * the page mapped at address zero.
+ */
+void mseal_mmap_page_zero(void)
+{
+	int err;
+
+	if (WARN_ON_ONCE(!(current->personality & MMAP_PAGE_ZERO)))
+		return;
+
+	err = mseal(0, PAGE_SIZE);
+	if (err)
+		pr_warn_ratelimited("pid=%d, couldn't seal address 0, ret=%d.\n",
+				    task_pid_nr(current), err);
+}
+
 /*
  * mseal(2) seals the VM's meta data from
  * selected syscalls.
@@ -118,10 +150,9 @@ static int mseal_apply(unsigned long sta
  *
  *  unseal() is not supported.
  */
-int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
+static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 {
 	size_t len;
-	int ret = 0;
 	unsigned long end;
 
 	/* Verify flags not set. */
@@ -144,16 +175,7 @@ int do_mseal(unsigned long start, size_t
 	if (end == start)
 		return 0;
 
-	if (mmap_write_lock_killable(current->mm))
-		return -EINTR;
-
-	if (range_contains_unmapped(start, end))
-		ret = -ENOMEM;
-	else
-		ret = mseal_apply(start, end);
-
-	mmap_write_unlock(current->mm);
-	return ret;
+	return mseal(start, end);
 }
 
 SYSCALL_DEFINE3(mseal, unsigned long, start, size_t, len, unsigned long,
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-move-alloc-tag-to-mm.patch
mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch
mm-add-kdoc-comments-for-vma_start-last_pgoff.patch
tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch
mm-introduce-and-use-vma_end_pgoff.patch
mm-rmap-update-mm-interval_treec-comments.patch
mm-rmap-parameterise-vma_interval_tree_-by-address_space.patch
mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch
mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch
mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch
mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch
mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch
maintainers-move-mm-interval_treec-to-rmap-section.patch
mm-vma-introduce-and-use-vmg_pages-vmg__pgoff.patch
mm-vma-clean-up-anon_vma_compatible.patch
mm-vma-refactor-vmg_adjust_set_range-for-clarity.patch
mm-vma-minor-cleanup-of-expand_.patch
mm-introduce-and-use-linear_page_delta.patch
mm-vma-use-vma_start_pgoff-linear_page_index-in-mm-code.patch
mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch
mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch
mm-use-linear_page_-consistently.patch
mm-vma-introduce-vma_assert_can_modify.patch
mm-vma-add-and-use-vma__pgoff.patch
mm-vma-move-__install_special_mapping-to-vmac.patch
mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch
mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch
mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch
mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch
mm-vma-introduce-and-use-vma_set_pgoff.patch
mm-vma-correct-incorrect-vmah-inclusion.patch
mm-vma-use-guard-clauses-in-can_vma_merge_.patch
tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch
tools-testing-vma-output-compared-expression-on-assert_.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch

